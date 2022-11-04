Library IEEE;
use IEEE.std_logic_1164.all;

Entity demux_memory Is
Port(memory: IN std_logic_vector(7 DOWNTO 0);
     ctrl: IN std_logic;
     instruction_register: OUT std_logic_vector(7 DOWNTO 0);
     load_register: OUT std_logic_vector(7 DOWNTO 0));
END demux_memory;

Architecture bhv of demux_memory Is
begin
process(memory, ctrl)
begin 
    if(ctrl = '0') then 
    instruction_register <= memory;
    elsif(ctrl = '1') then
    load_register <= memory;
    end if;
End process;

End bhv;	  

