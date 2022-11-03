Library IEEE;
use IEEE.std_logic_1164.all;
use Ieee.numeric_std_unsigned.all;

Entity adder Is
Port(Data_In: IN std_logic_vector(18 DOWNTO 0);
     Data_Out: Out std_logic_vector(18 DOWNTO 0);
     ctrl: IN std_logic_vector(1 DOWNTO 0));
     
End adder;

Architecture bhv of adder Is


begin 
process(ctrl)
begin 
	if (ctrl="00") then
	  Data_Out <= Data_In;
	elsif (ctrl="01") then
	  Data_Out <= Data_In + 1;
	elsif( ctrl="10") then
	  Data_Out<= Data_In + 2;
	end if; 
	
end process;
end bhv;

 
