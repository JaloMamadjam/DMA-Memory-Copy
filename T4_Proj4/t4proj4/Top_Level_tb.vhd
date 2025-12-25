LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Top_Level_tb IS
END Top_Level_tb;
 
ARCHITECTURE behavior OF Top_Level_tb IS 
 
   -- Sinais de Entrada (Inicializados em '0')
   signal clock_board : std_logic := '0';
   signal reset_board : std_logic := '0';

   -- Sinais de Saída
   signal led_concluido : std_logic;
 
   -- Definição do Clock (50MHz = 20ns)
   constant clock_period : time := 20 ns;
 
BEGIN
 
   -- =========================================================================
   -- INSTÂNCIA DIRETA DO TOP LEVEL 
   -- =========================================================================
   uut: entity work.Top_Level 
   PORT MAP (
          clock_board => clock_board,
          reset_board => reset_board,
          led_concluido => led_concluido
        );
 
   -- =========================================================================
   -- PROCESSO DO CLOCK (Gera 50MHz)
   -- =========================================================================
   clock_process :process
   begin
		clock_board <= '0';
		wait for clock_period/2;
		clock_board <= '1';
		wait for clock_period/2;
   end process;
 
   -- =========================================================================
   -- PROCESSO DE ESTÍMULO (O Teste)
   -- =========================================================================
   stim_proc: process
   begin		
      -- 1. Reset Inicial (Segura o botão por 100ns)
      reset_board <= '1';
      wait for 100 ns;	
      
      -- 2. Solta o Reset (Hardware começa a rodar)
      reset_board <= '0';
      
      -- 3. Aguarda a cópia
      -- Calculamos ~90us. Vamos esperar 500us para garantir.
      wait until led_concluido = '1' for 500 us;
      
      -- 4. Verificação
      if led_concluido = '1' then
          -- Sucesso
          wait for 100 ns;
      else
          -- Falha (Timeout)
          wait for 100 ns;
      end if;

      wait; -- Para a simulação
   end process;
 
END;