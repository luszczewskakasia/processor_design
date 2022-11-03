--quick change
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY control_unit IS
  PORT (
    instr_reg   		: IN std_logic_vector(7 DOWNTO 0); --input instruction
    debug    			: IN std_logic_vector(2 DOWNTO 0); --buttons to debug the processor this is only used when debugging is turned on. when debug(2) is 1 then it runs normally. When debug(1) is pressed it will run for 1 clock cycle. debug(0) is used to display other values on the 4 7 segment displays.
    status_bit_reg		: IN std_logic; -- Input status bit
    clk     			: IN std_logic; --50 Mhz clock
    reset				: IN std_logic; --asynchronous reset
	
	register_A 			: IN std_logic_vector(18 downto 0);
	register_B			: IN std_logic_vector(18 downto 0);
	register_C			: IN std_logic_vector(18 downto 0);
	register_LOAD		: IN std_logic_vector(18 downto 0);

	dig2 				: OUT std_logic_vector(6 downto 0);
	dig3				: OUT std_logic_vector(6 downto 0);

    demux_mem 			: OUT std_logic; 
    demux_A				: OUT std_logic;
    demux_B				: OUT std_logic_vector (1 DOWNTO 0);

    mux_mem				: OUT std_logic_vector (1 DOWNTO 0);
    mux_reg				: OUT std_logic_vector (1 DOWNTO 0);

    address_add 		: OUT std_logic_vector (1 DOWNTO 0);
    enable_instr 		: OUT std_logic; 						
    enable_status_bit 	: OUT std_logic;

    alu_instr			: OUT std_logic_vector (2 DOWNTO 0);
    rw_mem_off			: OUT std_logic_vector (1 DOWNTO 0);

    rw_reg_off			: OUT std_logic_vector (1 DOWNTO 0);
    address_A_reg		: OUT std_logic_vector (3 DOWNTO 0);
    address_B_reg		: OUT std_logic_vector (3 DOWNTO 0);
	
	enable_reg 			: OUT std_logic --1 when it is in wait mode and 0 when it is in run mode
    
  );
END ENTITY control_unit;

architecture bhv of control_unit is
begin
  PROCESS(clk,reset)

	--function that takes the current clock cycle, the status bit and the intruction as input and outputs a 28 wide binary number that gives information for all the internal components of the datapath.
	--The function only works in the instruction state. The last bit tells us whether it is the last clock cycle of that specific instruction and therefore whether we should continue to the next state (prepare) ('1' last clock cycle, '0' not last clock cycle)
	function control_lines_instr (temp_instr_reg:  std_logic_vector (7 DOWNTO 0); temp_clock_cycle : integer; temp_status_bit : std_logic) return std_logic_vector is
	BEGIN
      		CASE temp_clock_cycle IS
        	WHEN 1 =>
			case temp_instr_reg (7 downto 4) is 
				when "0000" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "000" & temp_instr_reg(3) & '0' & temp_instr_reg(2 downto 0) & '0'; --load a and b from register
				when "0001" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "000" & temp_instr_reg(3) & '0' & temp_instr_reg(2 downto 0) & '0'; --load a and b from register
				when "0010" =>
					case temp_instr_reg (3) is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & '0' & temp_instr_reg(2 downto 0) & "0000" & '0'; --load data to output A
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & '0' & temp_instr_reg(2 downto 0) & "0000" & '0'; --load data to output A
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "0011" =>
					case temp_instr_reg (3) is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & '0' & temp_instr_reg(2 downto 0) & "0000" & '0'; --load data to output A
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & '0' & temp_instr_reg(2 downto 0) & "0000" & '0'; --load data to output A
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "0100" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "1000" & '0' & temp_instr_reg(2 downto 0) & '0'; --load PC at outpA and value at outpB of reg
				when "0101" => 
					case  temp_status_bit is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '1'; --not equal so end instruction
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "1000" & '0' & temp_instr_reg(2 downto 0) & '0'; --load PC at outpA 
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "0110" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "0000" & '0' & temp_instr_reg(2 downto 0) & '0'; --load value to output B
				when "1000" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "0000" & "000" & temp_instr_reg(3) & '0'; --load value to output regB
				when "1001" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "000" & temp_instr_reg(3) & '0' & temp_instr_reg(2 downto 0) & '0'; --load regA (value) and regB (address)
				when "1010" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "0000" & "000" & temp_instr_reg(0) & '0'; --load value to output B of reg
				WHEN OTHERS => RETURN "----------------------------";  
			end case;
         	WHEN 2 => 
			case temp_instr_reg (7 downto 4) is 
				when "0000" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --load register output into a and b
				when "0001" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --load register output into a and b
				when "0010" =>
					case temp_instr_reg (3) is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --load into regA 
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --load into regA 
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "0011" =>
					case temp_instr_reg (3) is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --load into regA 
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --load into regA 
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "0100" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --load into regA and regB and instruct ALU
				when "0101" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --load into regA and regB and instruct ALU
				when "0110" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --load output B into regB
				when "1000" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --load result reg into B
				when "1001" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "000" & temp_instr_reg(3) & '0' & temp_instr_reg(2 downto 0) & '0'; --load regA (value) and regB (address) and save output a and b reg in register a and B
				when "1010" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --load outputB of register into register B
				WHEN OTHERS => RETURN "----------------------------";  
			end case;
        	WHEN 3 => 
			case temp_instr_reg (7 downto 4) is 
				when "0000" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "001" & "00" & "00" & "0000" & "0000" & '0'; --instruct ALU
				when "0001" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --instruct ALU
				when "0010" =>
					case temp_instr_reg (3) is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "010" & "00" & "00" & "0000" & "0000" & '0'; --ALU instruct
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "011" & "00" & "00" & "0000" & "0000" & '0'; --ALU instruct
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "0011" =>
					case temp_instr_reg (3) is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "100" & "00" & "00" & "0000" & "0000" & '0'; --ALU instruct
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "101" & "00" & "00" & "0000" & "0000" & '0'; --ALU instruct
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "0100" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --load result ALU into C
				when "0101" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --load result ALU into C
				when "0110" => return '0' & '0' & "01" & "00" & "01" & "00" & '0' & '0' & "000" & "00" & "11" & "1000" & "0000" & '1'; --load B into register
				when "1000" => return '0' & '0' & "10" & "00" & "00" & "00" & '0' & '0' & "000" & "10" & "00" & "0000" & "0000"  & '0'; --ask mem for data
				when "1001" => return '0' & '1' & "10" & "00" & "00" & "00" & '0' & '0' & "000" & "11" & "10" & "000" & temp_instr_reg(3) & '0' & temp_instr_reg(2 downto 0) & '0'; --load regA (value) and regB (address) and save output a and b reg in register a and B and store value in mem
				when "1010" => return '0' & '0' & "01" & "00" & "01" & "00" & '0' & '0' & "000" & "00" & "11" & '0' & temp_instr_reg (3 downto 1) & "0000" & '1'; --save register B into register file
				WHEN OTHERS => RETURN "----------------------------";  
			end case;
        	WHEN 4 => 
			case temp_instr_reg (7 downto 4) is 
				when "0000" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '1' & "000" & "00" & "00" & "0000" & "0000" & '0'; --store aluoutput into into register c and store status bit
				when "0001" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '1' & "000" & "00" & "00" & "0000" & "0000" & '0'; --store aluoutput into into register c and store status bit
				when "0010" =>
					case temp_instr_reg (3) is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --store value into regc
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --store value into regC
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "0011" =>
					case temp_instr_reg (3) is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --store value into regc
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --store value into regC
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "0100" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & "1000" & "0000" & '1'; --store result in register file
				when "0101" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & "1000" & "0000" & '1'; --store result in register file
				when "1000" => return '1' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000"  & '0'; --load result mem in load reg
				when "1001" => return '0' & '1' & "10" & "01" & "00" & "01" & '0' & '0' & "000" & "11" & "00" & "0000" & "0000" & '0'; --save output a and b reg in register a and B and store value in mem with address+1 and next 8 bits
				WHEN OTHERS => RETURN "----------------------------";  
			end case;
			WHEN 5 =>
			case temp_instr_reg (7 downto 4) is 
				when "0000" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & "000" & temp_instr_reg(3) & "0000" & '1'; --store regC into register
				when "0001" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & "000" & temp_instr_reg(3) & "0000" & '1'; --store regC into register
				when "0010" =>
					case temp_instr_reg (3) is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & '0' & temp_instr_reg(2 downto 0) & "0000" & '1'; --store value C into reg
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & '0' & temp_instr_reg(2 downto 0) & "0000" & '1'; --store value C into reg
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "0011" =>
					case temp_instr_reg (3) is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & '0' & temp_instr_reg(2 downto 0) & "0000" & '1'; --store value C into reg
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & '0' & temp_instr_reg(2 downto 0) & "0000" & '1'; --store value C into reg
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "1000" => return '0' & '0' & "00" & "00" & "10" & "00" & '0' & '0' & "000" & "00" & "11" & '0' & temp_instr_reg(2 downto 0) & "0000"  & '1'; --store load into reg
				when "1001" => return '0' & '1' & "10" & "10" & "00" & "10" & '0' & '0' & "000" & "11" & "00" & "0000" & "0000" & '1'; --store value in mem with address+2 and last 3 bits
				WHEN OTHERS => RETURN "----------------------------";  
			end case;
        	WHEN OTHERS => RETURN "----------------------------";      
      END CASE;
    END control_lines_instr;
	
	--function that takes the current clock cycle and returns a 28 bit wide binary number that gives information for all the intnernal components. This function only works for the prepare state and the last bit gives information about going to the next state.
	function control_lines_prep (temp_clock_cycle : integer) return std_logic_vector is
	begin
	case temp_clock_cycle is
		when 1 => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "0000" & "1000" & '0'; --load register PC
		when 2 => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --store in reg B
		when 3 => return '0' & '0' & "10" & "00" & "00" & "00" & '0' & '0' & "000" & "10" & "00" & "0000" & "0000" & '0'; --ask data from mem
		when 4 => return '0' & '0' & "00" & "00" & "00" & "00" & '1' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --store result in instr reg
		when 5 => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "1000" & "0111" & '0'; --ask data from register 
		when 6 => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --load into a and b 
		when 7 => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0'; --instruct ALU to add
		when 8 => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '1' & "000" & "00" & "00" & "0000" & "0000" & '0'; --load result in status bit and reg c
		when 9 => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & "1000" & "0000" & '1'; --save c (result) in register
		WHEN OTHERS => RETURN "----------------------------";
	end case;
	end control_lines_prep;
	
	--procedure that outputs the found control lines 
	procedure update_outputs(control_lines: std_logic_vector(27 downto 0)) is 
	begin
		demux_mem 			<= control_lines(27);
		demux_A 			<= control_lines(26);
		demux_B 			<= control_lines(25 downto 24);
		mux_mem 			<= control_lines(23 downto 22);
		mux_reg 			<= control_lines(21 downto 20);
		address_add 		<= control_lines(19 downto 18);
		enable_instr 		<= control_lines(17);
		enable_status_bit 	<= control_lines(16);
		alu_instr 			<= control_lines(15 downto 13);
		rw_mem_off 			<= control_lines(12 downto 11);
		rw_reg_off 			<= control_lines (10 downto 9);
		address_A_reg 		<= control_lines(8 downto 5);
		address_B_reg 		<= control_lines (4 downto 1);
	end update_outputs;

	--procedure that outputs the next register in the line on dig2 and dig3
	procedure outputdisplay(current_disp_out: integer range 1 to 5) is 
	FUNCTION hex2display (n:std_logic_vector(3 DOWNTO 0)) RETURN std_logic_vector IS
		VARIABLE res : std_logic_vector(6 DOWNTO 0);
	BEGIN
		CASE n IS          --        gfedcba; low active
			WHEN "0000" => RETURN NOT "0111111";
			WHEN "0001" => RETURN NOT "0000110";
			WHEN "0010" => RETURN NOT "1011011";
			WHEN "0011" => RETURN NOT "1001111";
			WHEN "0100" => RETURN NOT "1100110";
			WHEN "0101" => RETURN NOT "1101101";
			WHEN "0110" => RETURN NOT "1111101";
			WHEN "0111" => RETURN NOT "0000111";
			WHEN "1000" => RETURN NOT "1111111";
			WHEN "1001" => RETURN NOT "1101111";
			WHEN "1010" => RETURN NOT "1110111";
			WHEN "1011" => RETURN NOT "1111100";
			WHEN "1100" => RETURN NOT "0111001";
			WHEN "1101" => RETURN NOT "1011110";
			WHEN "1110" => RETURN NOT "1111001";
			when "1111" => RETURN NOT "1110001";
			WHEN OTHERS => RETURN NOT "1000000";	-- this part chenaged, when other would give "-"
		END CASE;
	END hex2display;
	begin
		CASE current_disp_out is
			WHEN 1=>
				dig2 <= hex2display(register_A(3 downto 0));
				dig3 <=hex2display(register_A(7 downto 4));
			WHEN 2=>
				dig2 <= hex2display(register_B(3 downto 0));
				dig3 <=hex2display(register_B(7 downto 4));
			WHEN 3=>
				dig2 <= hex2display(register_C(3 downto 0));
				dig3 <=hex2display(register_C(7 downto 4));
			WHEN 4=>
				dig2 <= hex2display(register_LOAD(3 downto 0));
				dig3 <=hex2display(register_LOAD(7 downto 4));
			WHEN 5=>
				dig2 <= hex2display(instr_reg(3 downto 0));
				dig3 <=hex2display(instr_reg(7 downto 4));
		END case;
	end outputdisplay;
	
	TYPE STATES IS (PREP, RUN_INSTR, FIRST_CLOCK_CYCLE);
    VARIABLE curr_state: states := FIRST_CLOCK_CYCLE;
	VARIABLE curr_clock_cycle: integer range 1 to 9 := 1;
	VARIABLE control_lines: std_logic_vector (27 downto 0) := (others =>	'0');
	
	variable previous_debug1 : std_logic := '1'; --active LOW
	variable gotonextcycle : std_logic := '0'; --active HIGH
	
	variable previous_debug0 : std_logic := '1';
	variable switch	: std_logic := '0';
	variable current_disp_out : integer range 1 to 5 := 1;
	
	CONSTANT debugging_onoff : std_logic := '1'; -- 1 means debugging is on and 0 means debugging is off
	
  BEGIN
    IF reset='0' THEN
		--when reset is pressed the curr_clock_cycle, curr_state and ouputs will all reset to the beginning state.
		
		curr_clock_cycle := 1;
		curr_state := FIRST_CLOCK_CYCLE;	
		control_lines := (others =>	'0');
		update_outputs(control_lines);
		previous_debug1 := '1';
		previous_debug0 := '1';
		switch := '0';
		gotonextcycle := '0';
		
    ELSIF rising_edge(clk) THEN
		
		--find rising edge of debug button debug(0)
		if (debug(0) = '0' AND previous_debug0 = '1') THEN 
			switch := '1';
		end if;
		
		if (switch) = '1' THEN 
			if (current_disp_out = 5) THEN 
				current_disp_out := 1;
			ELSE 
				current_disp_out := current_disp_out + 1;
			END if;
		END IF;
		
		--find rising edge of debug button debug(1)
		if (debug(1) = '0' AND previous_debug1 = '1') THEN 
			gotonextcycle := '1';
		end if;
		
		--in normal operation without debugging it works no matter what. when debugging is off the debug(2) button can be pressed to make it run normally. When this debug(2) button is not pressed and the debugging is off the debug(1) button can be pressed to execute one clock cycle.
		if ((NOT debug(2)) or (not debugging_onoff) or gotonextcycle) = '1' then			
			enable_reg <= '0'; --enable registers for normal operations (register A, B, C and LOAD)
			case curr_state is
				WHEN FIRST_CLOCK_CYCLE =>
					control_lines := '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "01" & "0000" & "0000" & '0';
					curr_state := PREP;
				WHEN PREP =>
					--find control lines output using the current clock cycle
					control_lines := control_lines_prep(curr_clock_cycle);
					
					--go to next state or add 1 to clock cycle
					IF  (control_lines(0) = '1') THEN
						curr_state := RUN_INSTR;
						curr_clock_cycle := 1;
					ELSE
						curr_clock_cycle := curr_clock_cycle + 1;
					END IF;
				
				WHEN RUN_INSTR =>
					IF instr_reg /= X"FF" THEN
						--find control lines output using the current clock cycle
						control_lines := control_lines_instr(instr_reg, curr_clock_cycle, status_bit_reg);
					
						--go to next state or add 1 to clock cycle
						IF  (control_lines(0) = '1') THEN
							curr_state := PREP;
							curr_clock_cycle := 1;
						ELSE
							curr_clock_cycle := curr_clock_cycle + 1;
						END IF;
					ELSE 
						control_lines := (others =>	'0');
					END IF;
					
				WHEN OTHERS =>
					--when unspecified behaviour occurs reset the processor
					curr_clock_cycle := 1;
					curr_state := PREP;
					control_lines := (others =>	'0');
			END CASE;
			
		else
			enable_reg <= '1'; --disable registers so no normal operation (A, B, c and LOAD)
		end if;
		
		outputdisplay(current_disp_out); --change dig2 and dig3 to the value of the selected register
		update_outputs(control_lines);	--output all the values (convert 28 bit vector to smaller ones)
		previous_debug1 := debug(1); --update previousdebug value
		previous_debug0 := debug(0); --update previousdebug value
		gotonextcycle := '0'; --make the variable 0 again.
		switch := '0'; --make the variable 0 again.
    END IF;
	
  END PROCESS;
  
end;