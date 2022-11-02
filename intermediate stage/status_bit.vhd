Library IEEE;
use IEEE.std_logic_1164.all;

Entity status_bit Is
Port(ALU : IN std_logic;
     ctrl: IN std_logic;
     Control: OUT std_logic);
End status_bit;

Architecture bhv of status_bit Is
begin
process(clk,ctrl)
begin 
     if rising_edge(clk) then
       if(ctrl ='1') then 
          Control<= ALU;
       elsif(reset ='1') then 
          Control<="00000000";
       end if;
     end if;
end process;
end bhv;
