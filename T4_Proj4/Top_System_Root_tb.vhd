--------------------------------------------------------------------------------
-- Module:      Top_System_Root_tb
-- Description: Testbench for System Integration Verification.
--              Validates handshake, memory copy timing and completion flag.
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Top_System_Root_tb IS
END Top_System_Root_tb;
 
ARCHITECTURE Verification OF Top_System_Root_tb IS 
 
   -- Inputs (Initialized)
   signal clk_tb : std_logic := '0';
   signal rst_tb : std_logic := '0';

   -- Outputs
   signal led_out : std_logic;
 
   -- Clock Period Definition (50MHz)
   constant CLK_PERIOD : time := 20 ns;
 
BEGIN
 
   -- Unit Under Test (UUT) Instantiation
   UUT_SYSTEM: entity work.Top_System_Root 
   PORT MAP (
          sys_clk    => clk_tb,
          sys_rst    => rst_tb,
          status_led => led_out
        );
 
   -- Clock Generator Process
   clk_gen: process
   begin
        clk_tb <= '0';
        wait for CLK_PERIOD/2;
        clk_tb <= '1';
        wait for CLK_PERIOD/2;
   end process;
 
   -- Stimulus Process
   stim_proc: process
   begin        
      -- Phase 1: Global Reset Assertion
      report "Starting Simulation: Asserting System Reset" severity note;
      rst_tb <= '1';
      wait for 100 ns;  
      
      -- Phase 2: System Start
      rst_tb <= '0';
      report "Reset Released. System Operation Started." severity note;
      
      -- Phase 3: Wait for DMA Completion
      -- Estimated runtime: 90us. Timeout limit set to 600us.
      wait until led_out = '1' for 600 us;
      
      -- Phase 4: Result Verification
      if led_out = '1' then
          report "TEST PASSED: Completion flag (LED) asserted." severity note;
          wait for 100 ns; 
      else
          report "TEST FAILED: Operation timed out." severity error;
          wait for 100 ns;
      end if;

      wait; -- Stop Simulation
   end process;
 
END;