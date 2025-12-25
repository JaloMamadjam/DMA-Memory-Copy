library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Periferico is
    Port ( 
        clock       : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        
        -- Interface com o MIPS
        suspend     : out STD_LOGIC;
        suspend_ack : in  STD_LOGIC;
        
        -- Barramento de Memória (Para escrever no Destino Externo)
        mem_address : out STD_LOGIC_VECTOR (31 downto 0);
        mem_data_out: out STD_LOGIC_VECTOR (31 downto 0);
        mem_we      : out STD_LOGIC; -- Write Enable
        mem_ce      : out STD_LOGIC; -- Chip Enable
        mem_bw      : out STD_LOGIC; -- Byte Write (1=Byte)
        
        -- LED de Conclusão
        led_done    : out STD_LOGIC
    );
end Periferico;

architecture Behavioral of Periferico is

    -- Sinais de Estados
    type estado_t is (S_RESET, S_REQ_SUSPEND, S_READ_WAIT, S_CHECK_WRITE, S_INC_ADDR, S_DONE);
    signal estado : estado_t := S_RESET;

    -- Ponteiros (Endereços)
    signal addr_origem : std_logic_vector(31 downto 0) := x"10012000";
    signal addr_destino: std_logic_vector(31 downto 0) := x"10010020";
    
    -- Sinais internos (Clock e Dados)
    signal IDMem_clock   : std_logic;
    signal mod1_data_out : std_logic_vector(31 downto 0); -- Palavra de 32 bits da memória
    signal byte_lido     : std_logic_vector(7 downto 0);  -- O byte selecionado

begin

    -- Gera o clock invertido para a memória (padrão do projeto)
    Mem_Clock: IDMem_clock <= not clock;

    -- =========================================================================
    -- INSTÂNCIA DIRETA DA MEMÓRIA INTERNA (ORIGEM DO TEXTO)
    -- =========================================================================
    -- Usamos 'entity work.data_mem_mod1' direto, sem component.
    -- IMPORTANTE: 'we' travado em '0' pois só queremos LER desta memória.
    
    MEM_ROMEO: entity work.data_mem_mod1 
    port map (
        clock       => IDMem_clock, 
        ce          => '1',            -- Sempre habilitada
        we          => '1',            -- LEITURA APENAS (Nunca escreve)
        bw          => '0',            -- Byte write desligado
        
        -- Conexão dos Endereços (Slicing)
        address     => addr_origem(12 downto 2), -- Seleciona a palavra
        byte_choice => addr_origem(1 downto 0),  -- Seleciona o byte
        
        data_in     => (others => '0'), -- Entrada aterrada
        data_out    => mod1_data_out    -- Saída do dado bruto
    );

    -- =========================================================================
    -- MULTIPLEXADOR (Seleciona o byte certo dentro da palavra)
    -- =========================================================================
    byte_lido <= mod1_data_out(7 downto 0)   when addr_origem(1 downto 0) = "00" else
                 mod1_data_out(15 downto 8)  when addr_origem(1 downto 0) = "01" else
                 mod1_data_out(23 downto 16) when addr_origem(1 downto 0) = "10" else
                 mod1_data_out(31 downto 24);

    -- =========================================================================
    -- MÁQUINA DE ESTADOS (FSM)
    -- =========================================================================
    process(clock, reset)
    begin
        if reset = '1' then
            estado <= S_RESET;
            suspend <= '0';
            mem_we <= '0'; mem_ce <= '0'; mem_bw <= '0';
            led_done <= '0';
            addr_origem <= x"10012000";
            addr_destino<= x"10010020";
            
        elsif rising_edge(clock) then
            case estado is
                
                -- 1. Início e Pedido de Suspensão
                when S_RESET =>
                    suspend <= '1';
                    if suspend_ack = '1' then
                        estado <= S_READ_WAIT;
                    else
                        estado <= S_RESET;
                    end if;

                -- 2. Espera Leitura (Latência da Memória)
                when S_READ_WAIT =>
                    mem_we <= '0';
                    mem_ce <= '0';
                    estado <= S_CHECK_WRITE;

                -- 3. Verifica o Byte e Escreve na RAM Principal
                when S_CHECK_WRITE =>
                    mem_address  <= addr_destino;
                    -- Replica o byte nos 32 bits (técnica segura para SB)
                    mem_data_out <= byte_lido & byte_lido & byte_lido & byte_lido;
                    
                    mem_ce <= '1'; 
                    mem_we <= '1'; 
                    mem_bw <= '1'; -- Avisa que é escrita de 1 Byte

                    if byte_lido = x"00" then
                        estado <= S_DONE; -- Fim da string
                    else
                        estado <= S_INC_ADDR; -- Continua copiando
                    end if;

                -- 4. Incrementa Ponteiros
                when S_INC_ADDR =>
                    mem_we <= '0';
                    mem_ce <= '0';
                    addr_origem  <= addr_origem + 1;
                    addr_destino <= addr_destino + 1;
                    estado <= S_READ_WAIT;

                -- 5. Fim (Trava e Acende LED)
                when S_DONE =>
                    mem_we <= '0';
                    mem_ce <= '0';
                    suspend <= '0';  -- Libera o processador
                    led_done <= '1'; -- Sucesso!
                    estado <= S_DONE;
                    
                when others =>
                    estado <= S_RESET;
            end case;
        end if;
    end process;

end Behavioral;