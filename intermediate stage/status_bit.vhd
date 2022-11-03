Library IEEE;
use IEEE.std_logic_1164.all;

Entity status_bit Is
Port(ALU : IN std_logic;
     ctrl: IN std_logic;
     clk: IN std_logic;
     reset: IN std_logic;
     Control: OUT std_logic);
End status_bit;

Architecture bhv of status_bit Is
begin
process(clk,ctrl)
begin 
  
     if rising_edge(clk) then
       if(ctrl ='0') then 
          Control<= ALU;
     end if;
     end if;
end process;
end bhv;
