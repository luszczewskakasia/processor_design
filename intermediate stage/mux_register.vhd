Library IEEE;
use IEEE.std_logic_1164.all;

Entity mux_register Is
Port( ALU : IN std_logic_vector(18 DOWNTO 0);
      B_register : IN std_logic_vector(18 DOWNTO 0);
      load_register : IN std_logic_vector(7 DOWNTO 0);
      ctrl : IN std_logic_vector(1 DOWNTO 0);
      b : OUT std_logic_vector(18 DOWNTO 0));
End Entity mux_register;

Architecture bhv of mux_register Is
Begin 
     b <= ALU when (ctrl="00") else
          B_register when (ctrl="01") else
          load_register when (ctrl="10");
End bhv;
