Library IEEE;
use IEEE.std_logic_1164.all;

Entity register_A Is
Port(Data_In : IN std_logic_vector(18 DOWNTO 0);
     clk : IN std_logic;
     reset : IN std_logic;
     Data_Out : OUT std_logic_vector(18 DOWNTO 0));
End register_A;

Architecture bhv of register_A Is
begin
process(clk,ctrl)
begin
	if (reset= '0') THEN 
		Data_Out<= (OTHERS => '0');
    else rising_edge(clk) then
       if(ctrl ='1') then 
          Data_Out<= Data_In;
       end if;
     end if;
end process;
end bhv;
