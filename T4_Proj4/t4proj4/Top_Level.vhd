library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Level is
    Port ( 
        clock_board : in  STD_LOGIC; -- Clock da FPGA
        reset_board : in  STD_LOGIC; -- Botão de Reset
        
        -- LED para indicar fim da cópia
        led_concluido : out STD_LOGIC
    );
end Top_Level;

architecture Behavioral of Top_Level is

    -- Sinais de interconexão (Fios entre os blocos)
    signal w_suspend       : std_logic;
    signal w_suspend_ack   : std_logic;
    
    signal w_mem_addr      : std_logic_vector(31 downto 0);
    signal w_mem_data      : std_logic_vector(31 downto 0);
    
    signal w_mem_we        : std_logic;
    signal w_mem_ce        : std_logic;
    signal w_mem_bw        : std_logic;
    
    -- Sinal para inverter a lógica de escrita (WE -> RW)
    signal w_rw_logic      : std_logic;

begin

    -- Adaptação de Lógica:
    -- O Periférico solta '1' para Escrever (WE)
    -- O MIPS espera '0' para Escrever (RW)
    w_rw_logic <= not w_mem_we;

    -- =========================================================================
    -- 1. INSTÂNCIA DO SISTEMA MIPS (Processador + RAM Principal)
    -- =========================================================================
    CPU_SYSTEM: entity work.MIPS_S_withBRAMs 
    generic map (
        LAST_I_ADDRESS => x"004007FF",
        LAST_D_ADDRESS => x"10011FFF"
    )
    port map ( 
        clock           => clock_board,
        reset           => reset_board,
        sel_CPU         => '0',         -- Operação normal
        reset_CPU       => open,        -- Saída não usada
        
        -- Entradas vindas do Periférico
        suspend         => w_suspend,
        d_address_Per   => w_mem_addr,
        data_out_Per    => w_mem_data,
        ce_Per          => w_mem_ce,
        bw_Per          => w_mem_bw,
        rw_Per          => w_rw_logic,  -- Conecta o sinal invertido
        
        -- Saídas para o Periférico
        suspend_ack     => w_suspend_ack,
        
        -- Saídas de monitoramento (não usadas no Top Level)
        ce_CPU          => open,
        rw_CPU          => open,
        bw_CPU          => open,
        d_address_CPU   => open,
        data_out_CPU    => open,
        data_out_RAM    => open
    );

    -- =========================================================================
    -- 2. INSTÂNCIA DO PERIFÉRICO (Controlador DMA + Texto Origem)
    -- =========================================================================
    DMA_UNIT: entity work.Periferico 
    port map ( 
        clock           => clock_board,
        reset           => reset_board,
        
        -- Controle de Suspensão
        suspend         => w_suspend,
        suspend_ack     => w_suspend_ack,
        
        -- Barramento de Memória (Escrita)
        mem_address     => w_mem_addr,
        mem_data_out    => w_mem_data,
        mem_we          => w_mem_we,
        mem_ce          => w_mem_ce,
        mem_bw          => w_mem_bw,
        
        -- Status
        led_done        => led_concluido
    );

end Behavioral;