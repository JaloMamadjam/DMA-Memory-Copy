--------------------------------------------------------------------------------
-- Entity:      Top_System_Root
-- File:        Top_System_Root.vhd
-- Description: Top-level hierarchy connecting MIPS Core and DMA Controller.
--              Implements glue logic for bus arbitration.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_System_Root is
    Port ( 
        sys_clk     : in  STD_LOGIC; -- Main Oscillator (50MHz)
        sys_rst     : in  STD_LOGIC; -- User Reset Input
        
        -- System Status Output
        status_led  : out STD_LOGIC
    );
end Top_System_Root;

architecture Structural of Top_System_Root is

    -- Interconnect Signals (System Bus)
    signal sys_suspend     : std_logic;
    signal sys_suspend_ack : std_logic;
    
    signal sys_addr        : std_logic_vector(31 downto 0);
    signal sys_data        : std_logic_vector(31 downto 0);
    
    signal sys_we          : std_logic;
    signal sys_ce          : std_logic;
    signal sys_be          : std_logic;
    
    -- Control Logic Adaptation Signal
    signal mips_rw_ctrl    : std_logic;

begin

    -- Signal Inversion Logic:
    -- DMA drives Active-High Write Enable (WE)
    -- MIPS expects Read/Write control (RW: 1=Read, 0=Write)
    mips_rw_ctrl <= not sys_we;

    -- =========================================================================
    -- INSTANCE: MIPS PROCESSOR CORE
    -- =========================================================================
    CORE_MIPS: entity work.MIPS_S_withBRAMs 
    generic map (
        LAST_I_ADDRESS => x"004007FF",
        LAST_D_ADDRESS => x"10011FFF"
    )
    port map ( 
        clock           => sys_clk,
        reset           => sys_rst,
        sel_CPU         => '0',
        reset_CPU       => open,
        
        -- Peripheral Bus Interface
        suspend         => sys_suspend,
        suspend_ack     => sys_suspend_ack,
        
        d_address_Per   => sys_addr,
        data_out_Per    => sys_data,
        ce_Per          => sys_ce,
        bw_Per          => sys_be,
        rw_Per          => mips_rw_ctrl, -- Inverted logic applied
        
        -- Unconnected Core Outputs
        ce_CPU          => open,
        rw_CPU          => open,
        bw_CPU          => open,
        d_address_CPU   => open,
        data_out_CPU    => open,
        data_out_RAM    => open
    );

    -- =========================================================================
    -- INSTANCE: DMA COPY UNIT (PERIPHERAL)
    -- =========================================================================
    DMA_UNIT: entity work.Periferico_Copy 
    port map ( 
        clock           => sys_clk,
        reset           => sys_rst,
        
        -- Bus Arbitration
        suspend         => sys_suspend,
        suspend_ack     => sys_suspend_ack,
        
        -- Bus Master Interface
        mem_address     => sys_addr,
        mem_data_out    => sys_data,
        mem_we          => sys_we,
        mem_ce          => sys_ce,
        mem_bw          => sys_be,
        
        -- User Interface
        led_done        => status_led
    );

end Structural;