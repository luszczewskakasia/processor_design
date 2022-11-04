Library IEEE;
use IEEE.std_logic_1164.all;

Entity demux_A Is 
Port( A_register : IN std_logic_vector(18 DOWNTO 0);
      ctrl: IN std_logic;
      ALU_input_A: OUT std_logic_vector(18 DOWNTO 0);
      memory: OUT std_logic_vector(18 DOWNTO 0));
END demux_A;

Architecture bhv of demux_A Is
begin
process(ctrl)
begin 
    if(ctrl = '0') then 
    ALU_input_A <= A_register;
    elsif(ctrl ='1') then 
    memory <= A_register;
    end if;
End process;

End bhv;	
