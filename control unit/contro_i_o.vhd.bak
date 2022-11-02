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
				when "0000" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "000" & temp_instr_reg(3) & '0' & temp_instr_reg(2 downto 0) & '0';
				when "0001" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "000" & temp_instr_reg(3) & '0' & temp_instr_reg(2 downto 0) & '0';
				when "0010" =>
					case temp_instr_reg (3) is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & '0' & temp_instr_reg(2 downto 0) & "0000" & '0';
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & '0' & temp_instr_reg(2 downto 0) & "0000" & '0';
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "0011" =>
					case temp_instr_reg (3) is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & '0' & temp_instr_reg(2 downto 0) & "0000" & '0';
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & '0' & temp_instr_reg(2 downto 0) & "0000" & '0';
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "0100" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "1000" & '0' & temp_instr_reg(2 downto 0) & '0';
				when "0101" => 
					case  temp_status_bit is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '1';
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "1000" & '0' & temp_instr_reg(2 downto 0) & '0';
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "0110" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "0000" & '0' & temp_instr_reg(2 downto 0) & '0';
				when "1000" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "0000" & "000" & temp_instr_reg(3) & '0';
				when "1001" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "000" & temp_instr_reg(3) & '0' & temp_instr_reg(2 downto 0) & '0';
				when "1010" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "0000" & "000" & temp_instr_reg(0) & '0';
				WHEN OTHERS => RETURN "----------------------------";  
			end case;
         	WHEN 2 => 
			case temp_instr_reg (7 downto 4) is 
				when "0000" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '1' & "001" & "00" & "00" & "0000" & "0000" & '0';
				when "0001" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '1' & "000" & "00" & "00" & "0000" & "0000" & '0';
				when "0010" =>
					case temp_instr_reg (3) is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "010" & "00" & "00" & "0000" & "0000" & '0';
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "011" & "00" & "00" & "0000" & "0000" & '0';
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "0011" =>
					case temp_instr_reg (3) is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "100" & "00" & "00" & "0000" & "0000" & '0';
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "101" & "00" & "00" & "0000" & "0000" & '0'; 
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "0100" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0';
				when "0101" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0';
				when "0110" => return '0' & '0' & "01" & "00" & "01" & "00" & '0' & '0' & "000" & "00" & "11" & "1000" & "0000" & '1';
				when "1000" => return '1' & '0' & "01" & "00" & "00" & "00" & '0' & '0' & "000" & "10" & "00" & "0000" & "0000" & '0';
				when "1001" => return '0' & '1' & "10" & "00" & "00" & "00" & '0' & '0' & "000" & "11" & "10" & "000"&  temp_instr_reg(3) & '0' & temp_instr_reg(2 downto 0) & '0';
				when "1010" => return '0' & '0' & "01" & "00" & "01" & "00" & '0' & '0' & "000" & "00" & "11" & '0' & temp_instr_reg(3 downto 1) & "0000" & '0';
				WHEN OTHERS => RETURN "----------------------------";  
			end case;
        	WHEN 3 => 
			case temp_instr_reg (7 downto 4) is 
				when "0000" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & "000" & temp_instr_reg(3) & "0000" & '1';
				when "0001" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & "000" & temp_instr_reg(3) & "0000" & '1';
				when "0010" =>
					case temp_instr_reg (3) is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & '0' & temp_instr_reg(2 downto 0) & "0000" & '1';
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & '0' & temp_instr_reg(2 downto 0) & "0000" & '1';
						WHEN OTHERS => RETURN "----------------------------";
					end case;
				when "0011" =>
					case temp_instr_reg (3) is
						when '0' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & '0' & temp_instr_reg(2 downto 0) & "0000" & '1';
						when '1' => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & '0' & temp_instr_reg(2 downto 0) & "0000" & '1';
						WHEN OTHERS => RETURN "----------------------------"; 
					end case;
				when "0100" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & "1000" & "0000" & '1';
				when "0101" => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & "1000" & "0000" & '1';
				when "1000" => return '0' & '0' & "00" & "00" & "10" & "00" & '0' & '0' & "000" & "00" & "11" & '0' & temp_instr_reg(2 downto 0) & "0000"  & '1';
				when "1001" => return '0' & '1' & "10" & "01" & "00" & "01" & '0' & '0' & "000" & "11" & "10" & "000" & temp_instr_reg(3) & '0' & temp_instr_reg(2 downto 0) & '0';
				WHEN OTHERS => RETURN "----------------------------";  
			end case;
        	WHEN 4 => 
			case temp_instr_reg (7 downto 4) is 
				when "1001" => return '0' & '1' & "10" & "10" & "00" & "10" & '0' & '0' & "000" & "11" & "00" & "0000" & "0000"& '1';
				WHEN OTHERS => RETURN "----------------------------";  
			end case;
        	WHEN OTHERS => RETURN "----------------------------";      
      END CASE;
    END control_lines_instr;
	
	--function that takes the current clock cycle and returns a 28 bit wide binary number that gives information for all the intnernal components. This function only works for the prepare state and the last bit gives information about going to the next state.
	function control_lines_prep (temp_clock_cycle : integer) return std_logic_vector is
	begin
	case temp_clock_cycle is
		when 1 => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "0000" & "1000" & '0';
		when 2 => return '0' & '0' & "10" & "00" & "00" & "00" & '1' & '0' & "000" & "10" & "00" & "0000" & "0000" & '0';
		when 3 => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "10" & "1000" & "0111" & '0';
		when 4 => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "00" & "0000" & "0000" & '0';
		when 5 => return '0' & '0' & "00" & "00" & "00" & "00" & '0' & '0' & "000" & "00" & "11" & "1000" & "0000" & '1';
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

	TYPE STATES IS (PREP, RUN_INSTR);
    VARIABLE curr_state: states;
	VARIABLE curr_clock_cycle: integer range 1 to 5 := 1;
	VARIABLE control_lines: std_logic_vector (27 downto 0) := "----------------------------";
	
	variable previous_debug1 : std_logic := '1'; --active LOW
	variable gotonextcycle : std_logic := '0'; --active HIGH
	
	CONSTANT debugging_onoff : std_logic := '1'; -- 1 means debugging is on and 0 means debugging is off
	
  BEGIN
    IF reset='0' THEN
		--when reset is pressed the curr_clock_cycle, curr_state and ouputs will all reset to the beginning state.
		
		curr_clock_cycle := 1;
		curr_state := PREP;	
		control_lines := (others =>	'0');
		update_outputs(control_lines);
		
    ELSIF rising_edge(clk) THEN
		
		--find rising edge of debug button debug(1)
		if (debug(1) = '0' AND previous_debug1 = '1') THEN 
			gotonextcycle := '1';
		end if;
		
		--in normal operation without debugging it works no matter what. when debugging is off the debug(2) button can be pressed to make it run normally. When this debug(2) button is not pressed and the debugging is off the debug(1) button can be pressed to execute one clock cycle.
		if ((NOT debug(2)) or (not debugging_onoff) or gotonextcycle) = '1' then			
			enable_reg <= '0'; --enable registers for normal operations (register A, B, C and LOAD)
			case curr_state is
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
			
			--output all the values (convert 28 bit vector to smaller ones)
			update_outputs(control_lines);
		elsif
			enable_reg <= '1'; --disable registers so no normal operation (A, B, c and LOAD)
		end if;
		
		previous_debug1 := debug(1); --update previousdebug value
		gotonextcycle := '0'; --make the variable 0 again.

    END IF;
	
  END PROCESS;
  
  
end;