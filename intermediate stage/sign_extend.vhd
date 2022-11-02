Library IEEE;
use IEEE.std_logic_1164.all;

Entity sign_extend Is
Port(memory: IN std_logic_vector(7 DOWNTO 0);
     load_register: OUT std_logic_vector(18 DOWNTO 0));
End sign_extend;

Architecture bhv Of sign_extend Is
begin 
process(memory)
begin 
if (memory(7)='1') then
load_register<="11111111111"&memory;
else
load_register<="00000000000"&memory;
End if;
End process;
End bhv;
