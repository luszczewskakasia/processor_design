LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY button IS
  PORT ( button : in std_logic;
	 clk 	: in std_logic;
	 reset  : in std_logic;
	 led 	: out std_logic 
    );
END ENTITY button;

architecture bhv of button is 
begin 
	process (clk, reset)
		variable previous_value : std_logic := '1';
		VARIABLE status_led : std_logic := '0';
		variable switch : std_logic := '0';
		begin
		if reset = '0' then
			led <= '0';
			previous_value := '1';
		
		elsif rising_edge(clk) then
			if (previous_value = '1' and button = '0') then
				switch := '1';
			end if;
			
			if (switch and status_led) = '1' then 
				status_led := '0';
			elsif (switch and not status_led) = '1' then 
				status_led := '1';
			end if;
			led <= status_led;
			previous_value := button;
			switch := '0';
		end if;
	
	end process;

end;


