Library IEEE;
use IEEE.std_logic_1164.all;

Entity mux_register Is
Port( ALU			: IN std_logic_vector(18 DOWNTO 0);
      B_register	: IN std_logic_vector(18 DOWNTO 0);
      load_register : IN std_logic_vector(18 DOWNTO 0);
      dummy			: IN std_logic_vector(18 downto 0);
      ctrl			: IN std_logic_vector(1 DOWNTO 0);
      b 			: OUT std_logic_vector(18 DOWNTO 0));
End Entity mux_register;

Architecture bhv of mux_register Is

begin
    		  
	process(ALU, B_register, load_register, dummy, ctrl)
	begin 
		
		case ctrl is
			when "00" =>
				b <= ALU;				
			when "01" =>
				b <= B_register;
			when "10" =>
				b <= load_register;
			when others =>
				b <= dummy;
		end case;
		
	End process;
	
End bhv;
