LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY ALU IS
  PORT (
    reset     : IN std_logic;
    clk       : IN std_logic;
    A, B      : IN std_logic_vector(18 DOWNTO 0); -- coming from the register file, through A & B
    ALU_instr : IN std_logic_vector(2 DOWNTO 0); -- instruction coming from the controller
    C         : OUT std_logic_vector(18 DOWNTO 0); -- output of ALU
    status_bit : OUT std_logic
    );
END ALU;

ARCHITECTURE bhv OF ALU IS

BEGIN
	PROCESS(clk, reset, A, B, ALU_instr)
	variable ALU_res : std_logic_vector (18 DOWNTO 0); 
	VARIABLE ALU_status : std_logic; -- this variable is for the reset
	BEGIN	
		IF reset='0' THEN
			ALU_status := '0';
		ELSIF rising_edge(clk) THEN
		status_bit <= '0';
			IF ALU_status = '0' THEN
				ALU_status := '1';
			ELSE
				CASE(ALU_instr) IS
					WHEN "000" => -- ADD
						ALU_res := A + B; 
						if (A+B)="0000000000000000000" THEN
							status_bit <= '1';
						end if;
					WHEN "001" => -- NAND
						ALU_res := A NAND B;
					WHEN "010" => -- shift A left by 1 bit
						ALU_res := std_logic_vector(shift_left(signed(A), 1));
					WHEN "011" => -- shift A right by 1 bit
						ALU_res := std_logic_vector(shift_right(signed(A), 1));
					WHEN "100" => -- rotate A left
						ALU_res := std_logic_vector(signed(A) ROL 1);
					WHEN "101" => -- rotate A right
						ALU_res := std_logic_vector(signed(A) ROR 1);
					WHEN OTHERS => -- so that unwanted behaviour can be detected
						ALU_res := (OTHERS => '-');
				END CASE;
			END IF;
		END IF;
		ALU_status := '1'; -- make the ALU_status '1' again
	C <= ALU_res; -- the result will be assigned to C
	END PROCESS;
	
END;
			