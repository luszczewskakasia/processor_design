Library IEEE;
use IEEE.std_logic_1164.all;

Entity load_register Is
Port(Data_In : IN std_logic_vector(18 DOWNTO 0);
     clk : IN std_logic;
     reset : IN std_logic;
     Data_Out : OUT std_logic_vector(18 DOWNTO 0));
End load_register;

Architecture bhv of load_register Is
begin
process(clk,ctrl)
begin 
     if rising_edge(clk) then
       if(ctrl ='1') then 
          Data_Out<= Data_In;
       elsif(reset ='1') then 
          Data_Out<="00000000";
       end if;
     end if;
end process;
end bhv;
