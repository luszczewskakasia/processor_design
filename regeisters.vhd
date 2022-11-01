LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY reg IS
	PORT (
		din     : IN std_logic_vector(18 DOWNTO 0);
		a_add	: IN std_logic_vector(3 DOWNTO 0);
		b_add	: IN std_logic_vector(3 DOWNTO 0);
		clk     : IN std_logic;
		reset	: in std_logic;
		
		dout    : OUT std_logic_vector(18 DOWNTO 0);
		a_out	: OUT std_logic_vector(18 DOWNTO 0);
		b_out	: OUT std_logic_vector(18 DOWNTO 0)
	);
end reg;

architecture bhv of reg is
TYPE regs IS ARRAY (0 TO 2**4) OF std_logic_vector(18 DOWNTO 0);
  SIGNAL reg: regs;
  
	constant r0 : std_logic_vector := "0000";
	constant r1 : std_logic_vector := "0001";
	constant r2 : std_logic_vector := "0010";
	constant r3 : std_logic_vector := "0011";
	constant r4 : std_logic_vector := "0100";
	constant r5 : std_logic_vector := "0101";
	constant r6 : std_logic_vector := "0110";
	constant r7 : std_logic_vector := "0111";
	constant PC : std_logic_vector := "1000";
	
	signal reg_status : std_logic_vector (1 downto 0);
	
	
begin
	process(clk,reset)
	begin
		if reset = '0' then
			for i in 1 to 7 loop
				reg(i-1) <= (others => '0'); 					-- initializing r0 ~ r6 as 0
			end loop;
			
			reg(to_integer(unsigned(PC))) <= (others => '0'); 						-- initializing pc as 0
			reg(to_integer(unsigned(r7))) <= std_logic_vector(to_unsigned(1,19));   	-- initializing r7 as 1
			
		elsif rising_edge(clk) then
			if reg_status = "10" then 				-- read
				a_out <= reg(to_integer(unsigned(a_add)));
				b_out <= reg(to_integer(unsigned(b_add)));		
				
				
			elsif reg_status = "11" then			-- write, always to A address.
				reg(to_integer(unsigned(a_add))) <= din; 
				
			elsif reg_status = "00" then 			-- disabled
			
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