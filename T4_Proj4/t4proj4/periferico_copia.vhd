library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.p_MIPS_S.all; -- Pacote para usar 'wires32'

entity periferico_copia is
    port (
        clock       : in std_logic;
        reset       : in std_logic;
        
        -- Controle de Barramento
        suspend     : out std_logic;
        suspend_ack : in std_logic;
        
        -- Interface com Memória Principal (Destino)
        d_address_out : out wires32; 
        data_out      : out wires32; 
        we_out        : out std_logic;
        ce_out        : out std_logic;
        
        -- Controle de Execução
        start_copia   : in std_logic;
        led_done      : out std_logic
    );
end periferico_copia;

architecture behavioral of periferico_copia is

    type state_type is (S_IDLE, S_REQ, S_READ_ADDR, S_WAIT_RAM, S_WRITE, S_CHECK, S_DONE);
    signal state : state_type;
    
    -- Contadores
    signal src_addr : std_logic_vector(12 downto 0) := (others => '0');
    signal dst_addr : wires32; 
    
    -- Dados internos
    signal int_data : std_logic_vector(31 downto 0);
    signal byte_lido : std_logic_vector(7 downto 0);

begin

    -- Instância Direta da Memória Fonte (mod1 - Texto)
    MEM_FONTE: entity work.data_mem_mod1 
        port map (
            clock       => clock,
            ce          => '1', 
            we          => '0', 
            bw          => '0', -- Apenas leitura
            address     => src_addr(12 downto 2),
            byte_choice => src_addr(1 downto 0),
            data_in     => (others => '0'),
            data_out    => int_data
        );

    -- =======================================================================
    -- MUX INVERTIDO (TESTE DE CORREÇÃO DE ENDIANNESS)
    -- =======================================================================
    -- Se antes ele lia 00 e parava, agora tentamos ler do byte mais alto primeiro.
    -- Se o texto aparecer "embaralhado" (ex: eomoR em vez de Romeo), sabemos que 
    -- o problema era só a ordem, mas pelo menos ele não vai parar!
    byte_lido <= int_data(31 downto 24) when src_addr(1 downto 0) = "00" else
                 int_data(23 downto 16) when src_addr(1 downto 0) = "01" else
                 int_data(15 downto 8)  when src_addr(1 downto 0) = "10" else
                 int_data(7 downto 0);

    -- Máquina de Estados
    process(clock, reset)
    begin
        if reset = '1' then
            state <= S_IDLE;
            src_addr <= (others => '0');
            dst_addr <= x"10010020"; 
            suspend <= '0';
            we_out <= '0'; 
            ce_out <= '0';
            led_done <= '0';
            d_address_out <= (others => '0');
            data_out <= (others => '0');
            
        elsif rising_edge(clock) then
            case state is
                
                -- 1. Aguarda comando de Start
                when S_IDLE =>
                    if start_copia = '1' then
                        state <= S_REQ;
                    end if;
                    
                -- 2. Solicita Pausa ao Processador
                when S_REQ =>
                    suspend <= '1';
                    if suspend_ack = '1' then
                        state <= S_READ_ADDR;
                    end if;
                    
                -- 3. Coloca o endereço na memória
                when S_READ_ADDR =>
                    -- O endereço 'src_addr' já está ligado à memória combinacionalmente
                    state <= S_WAIT_RAM;

                -- [NOVO] 3.5. Espera a memória responder (Sincronismo)
                when S_WAIT_RAM =>
                    -- BRAM precisa de clock para jogar o dado para fora.
                    -- Gastamos um ciclo aqui para garantir estabilidade.
                    state <= S_WRITE;
                    
                -- 4. Escreve dado na memória externa
                when S_WRITE =>
                    d_address_out <= dst_addr;
                    data_out <= byte_lido & byte_lido & byte_lido & byte_lido;
                    ce_out <= '1';
                    we_out <= '1'; -- Pulso de escrita
                    state <= S_CHECK;
                    
                -- 5. Verifica fim da string (NULL) ou incrementa
                when S_CHECK =>
                    we_out <= '0'; 
                    ce_out <= '0';
                    
                    if byte_lido = x"00" then -- Se for zero, terminou
                        state <= S_DONE;
                    else
                        src_addr <= src_addr + 1;
                        dst_addr <= dst_addr + 1;
                        state <= S_READ_ADDR; -- Volta para ler o próximo
                    end if;
                    
                -- 6. Finaliza e acende LED
                when S_DONE =>
                    suspend <= '0'; -- Libera o processador
                    led_done <= '1'; -- Acende LED de sucesso
                    
            end case;
        end if;
    end process;

end behavioral;