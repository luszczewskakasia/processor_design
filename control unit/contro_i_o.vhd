--quick change
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY control_unit IS
  PORT (
    instr_reg   		: IN std_logic_vector(7 DOWNTO 0);
    debug    			: IN std_logic_vector(2 DOWNTO 0); 
    status_bit_reg		: IN std_logic;
    clk     			: IN std_logic;
    reset				: IN std_logic;

    demux_mem 			: OUT std_logic;
    demux_A				: OUT std_logic;
    demux_B				: OUT std_logic_vector (1 DOWNTO 0);

    mux_mem				: OUT std_logic_vector (1 DOWNTO 0);
    mux_reg				: OUT std_logic_vector (1 DOWNTO 0);

    address_add 		: OUT std_logic_vector (1 DOWNTO 0);	--adder
    enable_instr 		: OUT std_logic; 						--instruction
    enable_status_bit 	: OUT std_logic;

    alu_instr			: OUT std_logic_vector (2 DOWNTO 0);
    rw_mem_off			: OUT std_logic_vector (1 DOWNTO 0);

    rw_reg_off			: OUT std_logic_vector (1 DOWNTO 0);
    address_A_reg		: OUT std_logic_vector (3 DOWNTO 0);
    address_B_reg		: OUT std_logic_vector (3 DOWNTO 0)
    
  );
END ENTITY control_unit;

architecture bhv of control_unit is
begin
  PROCESS(clk,reset)

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
  BEGIN
    -- NO VHDL CODE HERE
    IF reset='0' THEN

 
    ELSIF rising_edge(clk) THEN


    END IF;
    -- NO VHDL CODE HERE
  END PROCESS;

end;