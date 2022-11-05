Library IEEE;
use IEEE.std_logic_1164.all;

Entity demux_memory Is
Port(memory					: IN std_logic_vector(7 DOWNTO 0);
     ctrl					: IN std_logic;
     instruction_register	: OUT std_logic_vector(7 DOWNTO 0);
     load_register			: OUT std_logic_vector(7 DOWNTO 0)
	 );
END demux_memory;

Architecture bhv of demux_memory Is
begin
	process(memory, ctrl)
	begin 
		case ctrl is
			when '0' =>
				instruction_register <= memory;
				load_register <= (others => '0');
				
			when others =>
				instruction_register <= (others => '0');
				load_register <= memory;
		end case;
		
	End process;

End bhv;	  

