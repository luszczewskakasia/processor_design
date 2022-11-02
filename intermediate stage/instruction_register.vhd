Library IEEE;
use IEEE.std_logic_1164.all;

Entity instruction_register Is
Port(Data_In : IN std_logic_vector(7 DOWNTO 0);
     clk: IN std_logic;
     reset: IN std_logic;
     ctrl: IN std_logic;
     Data_Out : OUT std_logic_vector(7 DOWNTO 0));

End instruction_register;

Architecture bhv of instruction_register Is
begin
process(clk,ctrl)
begin 
     if (reset='0') then
	Data_Out<=(OTHERS=>'0');
     elsif rising_edge(clk) then
       if(ctrl ='0') then 
          Data_Out<= Data_In;
       end if;
     end if;
end process;
end bhv;
