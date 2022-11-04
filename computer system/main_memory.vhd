LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY main_memory IS
  GENERIC (
    addr_w : natural := 8;
	reg_w : natural := 4
	);
	
  PORT (
    reset  			: IN std_logic;
    clk     		: IN std_logic;
	rw_mem_off		: IN std_logic_vector (1 downto 0); -- if '10' - read, '11'- write, '00' - disable
	din				: IN std_logic_vector (7 downto 0);
	address			: IN std_logic_vector (18  downto 0);
	app_input		: IN std_logic_vector (9 downto 0);
	
	dig4 			: OUT std_logic_vector (6 downto 0); -- for debug
	dig5 			: OUT std_logic_vector (6 downto 0); -- for debug
    dout    		: OUT std_logic_vector(7 downto 0)
  );
END main_memory;

architecture bhv of main_memory is

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

TYPE mem_block IS ARRAY (0 TO (2**8)-1) OF std_logic_vector(7 DOWNTO 0);
  SIGNAL mem: mem_block:= (0 => "00011111", 1 => "10100001", 2=> "11111111", 255 downto 3 => (others => '0'));
	

begin

	process(clk,reset)
	
	variable pre_dig4, pre_dig5 : std_logic_vector (3 downto 0);
	variable temp :	std_logic_vector(7 DOWNTO 0);
	variable debug_out : std_logic_vector (18 downto 0);
	
	begin
		if reset = '0' then
			dout <= (others => '-');
			dig4 <= (others => '-');
			dig5 <= (others => '-');
			
			
			
			
		elsif rising_edge(clk) then
			if (rw_mem_off = "10") then --when mem used for read
				dout <= mem(to_integer(unsigned(address)));
			
			elsif (rw_mem_off = "11") then --when mem used for write
				mem(to_integer(unsigned(address))) <= din;
				dout <= "--------";
			
			elsif (rw_mem_off = "00") then -- when mem disabled.
				dout <= "--------";
				
				debug_out := "000000000" & app_input;
				temp := mem(to_integer(unsigned(debug_out)));
				pre_dig4 := temp(3 downto 0); pre_dig5 := temp(7 downto 4);
				dig4 <= hex2display(pre_dig4);dig5 <= hex2display(pre_dig5);
				
				
			end if;
			
		end if;
		
	end process;
end;
--After reset the first instruction is read from main memory address decimal 0.