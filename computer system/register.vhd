LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY reg IS
	PORT (
		din     	: IN std_logic_vector(18 DOWNTO 0);
		a_add		: IN std_logic_vector(3 DOWNTO 0);
		b_add		: IN std_logic_vector(3 DOWNTO 0);
		rw_reg_off 	: IN std_logic_vector(1 downto 0);--
		clk     	: IN std_logic;--
		reset		: IN std_logic;--
		app_input	: IN std_logic_vector (9 downto 0);--
		
		dig0		: OUT std_logic_vector (6 downto 0);
		dig1		: OUT std_logic_vector (6 downto 0);		
		a_out		: OUT std_logic_vector(18 DOWNTO 0);
		b_out		: OUT std_logic_vector(18 DOWNTO 0)
	);
end reg;

architecture bhv of reg is

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
	    WHEN OTHERS => RETURN NOT "1000000";	-- this part changed, when other would give "-"
    END CASE;
  END hex2display;
TYPE regs IS ARRAY (0 TO 2**4) OF std_logic_vector(18 DOWNTO 0);
  SIGNAL reg: regs;
  	
	--signal reg_status : std_logic_vector (1 downto 0);
	
	
begin
	process(clk,reset)
	
	variable pre_dig0, pre_dig1 : std_logic_vector (3 downto 0);
	
	begin
		if reset = '0' then
			for i in 1 to 7 loop
				reg(i-1) <= (others => '0'); 					-- initializing r0 ~ r6 as 0
			end loop;
			
			reg(8) <= (others => '0'); 							-- initializing pc:reg(8) as 0
			reg(7) <= std_logic_vector(to_unsigned(1,19));   	-- initializing r7 as 1
			dig0 <= (others => '-');
			dig1 <= (others => '-');
			a_out <= (others => '-');
			b_out <= (others => '-');
			
		elsif rising_edge(clk) then
				
			pre_dig0 := reg(0)(3 downto 0);pre_dig1 := reg(0)(7 downto 4);
			dig0 <= hex2display(pre_dig0);dig1 <= hex2display(pre_dig1);
																-- showing r0 to dig0, dig1
			
			if rw_reg_off = "10" then 							-- read
				a_out <= reg(to_integer(unsigned(a_add)));
				b_out <= reg(to_integer(unsigned(b_add)));		
				
			elsif rw_reg_off = "11" then						-- write, always to A address.
				if a_add /= "0111" then							-- when write address is not r7.
					reg(to_integer(unsigned(a_add))) <= din;
					a_out <= (others => '-');
					b_out <= (others => '-');	
				else											-- if writing address is r7. make sure r7 is always 1.
					reg(to_integer(unsigned(a_add))) <= std_logic_vector(to_unsigned(1,19));
				end if;
			
			elsif rw_reg_off = "01" then
				reg(6) <= "000000000" & app_input;				-- updating app_input to r6
			
			elsif rw_reg_off = "00" then 						-- disabled
			
				a_out <= (others => '-');
				b_out <= (others => '-');
			
			end if;
		
		end if;
	end process;
end;

-- 2 registers op : and, nand
-- 1 registers op : rotate, shift, jump, ba, beq
-- 1 register reverse : relocate
-- r0(B) : source(1bit), r1(A) : destination(3bit).

-- write always A_add output

-- reg_status 00 off, 11 write, 10 read

-- in a_add, b_add: std_logic_vector(4 downto 0), din
-- out a_out, b_out

-- when writing, always to A address

-- swtich input name : app_input
--always update app_input to  r0, and output to r6