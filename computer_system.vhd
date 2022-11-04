LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY computer_system IS
  PORT (
	--clock
    clk        : IN std_logic; --high freq. clock (~ 50 MHz)
	
	--inputs and outputs 
    dig0, dig1,dig2, dig3, dig4, dig5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- show key pressed on display
	reset      : IN std_logic; --
	debug 		: IN std_logic_vector(2 downto 0);
	app_input : IN std_logic_vector (9 downto 0)
   );
END computer_system;

architecture bhv of computer_system is 
	signal int_rw_mem_off : std_logic_vector (1 downto 0);
	signal int_datawritetomem : std_logic_vector (7 downto 0);
	signal int_mem_address : std_logic_vector (18 downto 0);
	signal int_datareadfrommem : std_logic_vector (7 downto 0);
	
begin

	mm: entity work.main_memory PORT MAP (
	    reset => reset,
		clk => clk,
		rw_mem_off => int_rw_mem_off,
		din => int_datawritetomem,
		address => int_mem_address,
		app_input => app_input,
		dig4 => dig4,
		dig5 => dig5,
		dout => int_datareadfrommem
	);
	

	pr: entity work.proccesor port map (
		clk => clk,
		reset => reset,
		writetomem => int_datawritetomem,
		addressmem => int_mem_address,
		readfrommem => int_datareadfrommem,
		writeorread => int_rw_mem_off,
		debug => debug,
		dig0 => dig0, 
		dig1 => dig1, 
		dig2 => dig2, 
		dig3 => dig3,
		app_input => app_input
	);	
END;	