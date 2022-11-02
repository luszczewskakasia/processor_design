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
	mem_status		: IN std_logic_vector (1 downto 0); -- if '10' - read, '11'- write, '00' - disable
	din				: IN std_logic_vector (addr_w-1 downto 0);
	address			: IN std_logic_vector (reg_w-1  downto 0);
	address_debug	: IN std_logic_vector (reg_w-1  downto 0);
	
	output_debug 	: OUT std_logic_vector (addr_w-1 down to 0);
    dout    		: OUT std_logic_vector(addr_w-1 downto 0)
  );
END main_memory;

architecture bhv of main_memory is

TYPE mem_block IS ARRAY (0 TO (2**reg_w)-1) OF std_logic_vector(addr_w-1 DOWNTO 0);
  SIGNAL mem: mem_block;

begin
	process(clk,reset)
	begin
		if reset = '0' then
			dout <= (others => '0');
			
			
		elsif rising_edge(clk) then
			if (mem_status = "10") then --when mem used for read
				dout <= mem(to_integer(unsigned(address)));
			
			elsif (mem_status = "11") then --when mem used for write
				mem(to_integer(unsigned(address))) <= din;
				dout <= "--------";
			
			elsif (mem_status = "00") then -- when mem disabled.
				dout <= "--------";
				
				
			end if;
			
		end if;
		
	end process;
end;
--After reset the first instruction is read from main memory address decimal 0.