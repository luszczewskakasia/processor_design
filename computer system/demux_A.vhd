Library IEEE;
use IEEE.std_logic_1164.all;

Entity demux_A Is 
Port( A_register	: IN std_logic_vector(18 DOWNTO 0);
      ctrl			: IN std_logic;
      ALU_input_A	: OUT std_logic_vector(18 DOWNTO 0);
      memory		: OUT std_logic_vector(18 DOWNTO 0)
	  );
END demux_A;

Architecture bhv of demux_A Is
begin
	process(A_register, ctrl)
	begin 
		
		case ctrl is
			when '0' => 
				ALU_input_A <= A_register;
				memory <= (others => '0');
			when others => 
				memory <= A_register;
				ALU_input_A <= (others => '0');
		end case;
		
	End process;

End bhv;	
