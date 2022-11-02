Library IEEE;
use IEEE.std_logic_1164.all;

Entity demux_b Is
Port( B_register : IN std_logic_vector(18 DOWNTO 0);
      ctrl: IN std_logic_vector(1 DOWNTO 0);
      ALU_input_B: OUT std_logic_vector(18 DOWNTO 0);
      main_register: OUT std_logic_vector(18 DOWNTO 0);
      memory: OUT std_logic_vector(18 DOWNTO 0));
End demux_b;

Architecture bhv of demux_b Is
begin
demux : process(ctrl)
begin 
    if(ctrl = "00") then 
    ALU_input_B <= B_register;
    elsif(ctrl = "01") then
    main_register <= B_register;
    elsif(ctrl = "10") then
    memory <= B_register;
    end if;
End process demux;

End bhv;	
     
       