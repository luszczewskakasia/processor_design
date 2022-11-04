LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY processor IS
  PORT (
    clk        : IN std_logic; --high freq. clock (~ 50 MHz)
    reset      : IN std_logic; --
	
	--connections to/from mem
	writetomem : OUT std_logic_vector (7 downto 0);
	addressmem: OUT std_logic_vector (18 downto 0);
	readfrommem: IN std_logic_vector (7 downto 0);
	writeorread: OUT std_logic_vector (1 downto 0);
	
	--connections for control
	debug 		: IN std_logic_vector(2 downto 0);
	dig2, dig3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --output value of registers
	
	--inputs and outputs of register
    	dig0, dig1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- show key pressed on display
	app_input : IN std_logic_vector (9 downto 0)
   );
END processor;

ARCHITECTURE bhv OF processor IS
	SIGNAL int_alu_instr : std_logic_vector(2 DOWNTO 0);
	signal int_demux_mem : std_logic;
	signal int_demux_A : std_logic;
	signal int_demux_B : std_logic_vector (1 downto 0);
	signal int_mux_reg : std_logic_vector (1 downto 0);
	signal int_address_add : std_logic_vector (1 downto 0);
	signal int_enable_instr :std_logic;
	signal int_enable_status_bit : std_logic;
	signal int_rw_reg_off : std_logic_vector (1 downto 0);
	signal int_status_bit : std_logic;
	signal int_address_A_reg : std_logic_vector (3 downto 0);
	signal int_address_B_reg : std_logic_vector (3 downto 0);
	signal int_enable_reg : std_logic;
	signal int_instr_reg : std_logic_vector (7 downto 0);
	signal int_register_A : std_logic_vector (18 downto 0);
	signal int_register_B : std_logic_vector (18 downto 0);
	signal int_register_C : std_logic_vector (18 downto 0);
	signal int_register_load :std_logic_vector (18 downto 0);
	signal int_mux_mem : std_logic_vector (1 downto 0);

	
BEGIN 
cu: ENTITY work.control_unit PORT MAP (
    instr_reg => int_instr_reg,
    debug => debug,
    status_bit_reg => int_status_bit,
    clk => clk,
    reset => reset,
    register_A => int_register_A,
    register_B => int_register_B,
    register_C => int_register_C,
    register_LOAD => int_register_LOAD,
    dig2 => dig2,
    dig3 => dig3,
    demux_mem => int_demux_mem,
    demux_A => int_demux_A,
    demux_B => int_demux_B,
    mux_mem => int_mux_mem,
    mux_reg => int_mux_reg,
    address_add => int_address_add,
    enable_instr => int_enable_instr,				
    enable_status_bit => int_enable_status_bit,
    alu_instr => int_alu_instr,
    rw_mem_off => writeorread,
    rw_reg_off => int_rw_reg_off,
    address_A_reg	=> int_address_A_reg,
    address_B_reg => int_address_B_reg,
    enable_reg => int_enable_reg
    );


dp: ENTITY work.data_path PORT MAP (
		clk => clk,
		reset => reset,
		alu_instr => int_alu_instr,	
		demux_mem => int_demux_mem,
		demux_A	=> int_demux_A,
		demux_B	=> int_demux_B,
		mux_mem	=> int_mux_mem,
		mux_reg	=> int_mux_reg, 			
		address_add	=> int_address_add,		
		enable_instr => int_enable_instr,		
		enable_status_bit => int_enable_status_bit,	
		rw_reg_off => int_rw_reg_off,
		status_bit => int_status_bit,
		address_A_reg => int_address_A_reg,
		address_B_reg => int_address_B_reg,		
		enable_reg => int_enable_reg,
		memory_data_in => readfrommem, -- from memory to signextend
		app_input => app_input,
		dig0 => dig0,			
		dig1 => dig1,		 			
		address_mem => addressmem,
		memory_data_out	=> writetomem,
		instruction_data_out => int_instr_reg,
		reg_A => int_register_A,
		reg_B => int_register_B,
		reg_C => int_register_C,
		reg_load => int_register_LOAD
    );
	
END;