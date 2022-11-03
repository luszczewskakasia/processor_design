LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

entity data_path is
	GENERIC (
		addr_w : natural := 8;
		reg_w : natural := 19
		);
		
	PORT (
		clk     			: IN std_logic;
		reset				: IN std_logic;
		-- from control to datapath
		alu_instru			: IN std_logic_vector (2 downto 0);
		demux_mem			: IN std_logic;
		demux_A				: IN std_logic;
		demux_B				: IN std_logic_vector (1 downto 0);
		mux_mem				: IN std_logic_vector (1 downto 0);
		mux_reg				: IN std_logic_vector (1 downto 0);
		address_add			: IN std_logic_vector (1 downto 0);
		enable_instr		: IN std_logic;
		enable_status_bit	: IN std_logic;
		rw_reg_off 			: IN std_logic_vector (1 downto 0);
		address_A_reg		: IN std_logic_vector (3 DOWNTO 0);
		address_B_reg		: IN std_logic_vector (3 DOWNTO 0); -- a,b,c, load
		enable_reg 			: IN std_logic
		memory_data_in		: IN std_logic_vector (7 downto 0); -- from memory to signextend
		
		-- switch input (10 binary input)
		app_input			: IN std_logic_vector (8 downto 0);
		
		-- led display output
		dig0				: OUT std_logic_vector (6 downto 0);
		dig1				: OUT std_logic_vector (6 downto 0);	
		address_mem			: OUT std_logic_vector (reg_w-1  downto 0); -- address from adder to memory
		status_bit			: OUT std_logic;					-- status bit from datapath to control
		memory_data_out		: OUT std_logic_vector (7 downto 0) -- data from mux_memory to memory
		instruction_data_out: OUT std_logic_vector (7 downto 0) -- data from instruction to control
		reg_A				: OUT std_logic_vector(18 DOWNTO 0);
		reg_B				: OUT std_logic_vector(18 DOWNTO 0);
		reg_C				: OUT std_logic_vector(18 DOWNTO 0);
		reg_load			: OUT std_logic_vector(18 DOWNTO 0);
		
	);
end data_path;

architecture of data_path is

	signal reg_din			: std_logic_vector(18 DOWNTO 0);	-- b -> reg_din (mux_register)
	signal a_out			: std_logic_vector(18 DOWNTO 0);	-- a_out -> Data_In (register_A)
	signal b_out			: std_logic_vector(18 DOWNTO 0);	-- b_out -> Data_In (register_B)
	signal reg_A_out		: std_logic_vector(18 DOWNTO 0);	-- reg_A_out -> A_register (demux_A)
	signal reg_B_out		: std_logic_vector(18 DOWNTO 0);	-- reg_B_out -> B_register (demux_B)
	signal Alu_A			: std_logic_vector(18 DOWNTO 0);	-- Alu_A -> A (ALU)
	signal Alu_B			: std_logic_vector(18 DOWNTO 0);	-- Alu_B -> B (ALU)
	signal A2MM				: std_logic_vector(18 DOWNTO 0);	-- A2MM -> a0_18 (mux_memory)
	signal main_register	: std_logic_vector(18 DOWNTO 0);	-- between demux_B & mux_register
	signal to_adder			: std_logic_vector(18 DOWNTO 0);	-- input of address adder
	signal reg_C_in			: std_logic_vector(18 DOWNTO 0); 	-- reg_C_out -> Data_In (register_C)
	signal status_bit_ALU	: std_logic_vector(1 downto 0);		-- staus_bit_ALu -> ALU (status_bit)
	signal reg_C_out		: std_logic_vector(18 DOWNTO 0);	-- reg_C_out -> ALU (mux_register)
	signal load_register 	: std_logic_vector(18 DOWNTO 0); 	-- Data_Out -> load_register(load)
	signal signextend_reg	: std_logic_vector(18 DOWNTO 0); 	-- signextend_reg -> Data_In (sign_extend)
	signal se_reg			: std_logic_vector(18 DOWNTO 0);	-- load_register -> se_reg (demux_mem)
	signal instr_register	: std_logic_vector(7 DOWNTO 0);		-- instr_register -> Data_In (instruction_reg)
	
	
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
		
	demux_B: entity work.demux_b port map (
		B_register => reg_B_out,
		ctrl => demux_B,
		ALU_input_B => Alu_B,
		main_register => main_register,
		memory => to_adder
		);
		
	ALU: entity work.ALU port map(
		clk => clk,
		reset => reset,
		A => Alu_A,
		B => Alu_B,
		ALU_instr => alu_instru,
		C => reg_C_in,
		status_bit => status_bit_ALU
		);
		
	reg_C : entity work.register_C port map (
		clk => clk,
		reset => reset,
		Data_In => reg_C_in,
		ctrl => enable_reg,
		Data_Out => reg_C_out,
		);
	
	mux_reg: entity work.mux_register port map (
		ALU => reg_C_out,
		B_register => main_register,
		load_register => load_register
		ctrl => mux_reg,
		b => reg_din		
		);
		
	sts_bit: entity work.status_bit port map (
		clk => clk,
		reset => reset,
		ALU => status_bit_ALU,
		ctrl => enable_status_bit,
		control => status_bit	
		);
		
	load: entity work.load_register port map (
		Data_In => signextend_reg,
		clk => clk,
		reset => reset,
		ctrl => enable_reg,
		Data_Out => load_register		
		);
		
	SE:entity work.sign_extend port map(
		memory => se_reg,
		load_register => signextend_reg	
		);
		
	dux_mem:entity work.demux_memory port map(
		memory => memory_data_in,
		ctrl => demux_mem,
		instruction_register => instr_register,
		load_register => se_reg	
		);
		
	instr:entity work.instruction_register port map(
		Data_In => instr_register,
		clk => clk,
		reset => reset,
		ctrl => enable_instr,
		Data_Out => instruction_data_out	
		);
		
		
		
		
		

	reg_A <= reg_A_out
	reg_B <= reg_B_out
	reg_C <= reg_C_out
	reg_load <= load_register




-- a,b,c, load should be output of datapath.