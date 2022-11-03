LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

entity data_path is
	GENERIC (
		addr_w : natural := 8;
		reg_w : natural := 19
		);
		
	PORT (
		clk     	: IN std_logic;
		reset		: IN std_logic;
		-- from control to datapath
		alu_instru			: IN std_logic_vector (2 downto 0);
		demux_mem			: IN std_logic;
		demux_A				: IN std_logic;
		demux_B				: IN std_logic;
		mux_mem				: IN std_logic_vector (1 downto 0);
		mux_reg				: IN std_logic_vector (1 downto 0);
		address_add			: IN std_logic_vector (1 downto 0);
		enable_instru		: IN std_logic;
		enable_status_bit	: IN std_logic;
		rw_reg_off 			: IN std_logic_vector (1 downto 0);
		status_bit			: IN std_logic;
		address_A_reg		: IN std_logic_vector (3 DOWNTO 0);
		address_B_reg		: IN std_logic_vector (3 DOWNTO 0); -- a,b,c, load
		enable_reg 			: IN std_logic
		
		-- switch input (10 binary input)
		app_input			: IN std_logic_vector (8 downto 0);
		
		-- led display output
		dig0				: OUT std_logic_vector (6 downto 0);
		dig1				: OUT std_logic_vector (6 downto 0);	
		dig4 				: OUT std_logic_vector (6 downto 0);
		dig5 				: OUT std_logic_vector (6 downto 0);
		address_mem			: OUT std_logic_vector (reg_w-1  downto 0); -- address from adder to memory
		
		
	);
end data_path;

architecture of data_path is

	signal reg_din	: std_logic_vector(18 DOWNTO 0);	-- b -> reg_din (mux_register)
	signal a_out	: std_logic_vector(18 DOWNTO 0);	-- a_out -> Data_In (register_A)
	signal b_out	: std_logic_vector(18 DOWNTO 0);	-- b_out -> Data_In (register_B)
	signal reg_A_out: std_logic_vector(18 DOWNTO 0);	-- reg_A_out -> A_register (demux_A)
	signal reg_B_out: std_logic_vector(18 DOWNTO 0);	-- reg_B_out -> B_register (demux_B)
	signal Alu_A	: std_logic_vector(18 DOWNTO 0);	-- Alu_A -> A (ALU)
	signal Alu_B	: std_logic_vector(18 DOWNTO 0);	-- Alu_B -> B (ALU)
	signal A2MM		: std_logic_vector(18 DOWNTO 0);	-- A2MM -> a0_18 (mux_memory)


begin
	REG : entity work.reg port map (
		clk => clk,
		reset => reset,
		rw_reg_off => rw_reg_off,
		app_input => app_input,
		a_add => address_A_reg,
		b_add => address_B_reg,
		din => reg_din,
		a_out => a_out,
		b_out => b_out
		);
	
	reg_A : entity work.register_A port map (
		clk => clk,
		reset => reset,
		Data_In => a_out,
		ctrl => enable_reg,
		Data_Out =>reg_A_out,
		);
	reg_B : entity work.register_B port map (
		clk => clk,
		reset => reset,
		Data_In => a_out,
		ctrl => enable_reg,
		Data_Out =>reg_B_out,
		);
	demux_A: entity work.demux_A port map (
		A_register => reg_A_out,
		ctrl => demux_A,
		ALU_input_A => Alu_A,
		memory => A2MM		
		);
	

-- a,b,c, load should be output of datapath.