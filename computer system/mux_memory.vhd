Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

Entity mux_memory Is
Port( a0_18 : IN std_logic_vector(18 DOWNTO 0);
      ctrl : IN std_logic_vector(1 DOWNTO 0);
      memory : OUT std_logic_vector(7 DOWNTO 0));
End mux_memory;

Architecture bhv of mux_memory Is
signal a0_7: std_logic_vector(7 DOWNTO 0);
signal a8_15: std_logic_vector(7 DOWNTO 0);
signal a16_19: std_logic_vector(2 DOWNTO 0);
signal a16_19_f: std_logic_vector(7 DOWNTO 0);
signal dash: std_logic_vector(7 DOWNTO 0):="--------";

begin
process(a16_19, a0_18)
begin
	a0_7<=a0_18(7 DOWNTO 0);
	a8_15<=a0_18(15 DOWNTO 8);
	a16_19<=a0_18(18 DOWNTO 16);
        
        if (a16_19(2)='1') then 
           a16_19_f<="11111"&a16_19;
	elsif (a16_19(2)='0') then
	   a16_19_f<="00000"&a16_19;
	end if;
end process;
            memory <= a0_7 when (ctrl="00") else
            a8_15 when (ctrl="01") else
            a16_19_f when (ctrl="10")else
            dash when (ctrl="11");
            

End bhv;
