Library IEEE;
use IEEE.std_logic_1164.all;

Entity demux_b Is
Port( B_register	: IN std_logic_vector(18 DOWNTO 0);
      ctrl			: IN std_logic_vector(1 DOWNTO 0);
      ALU_input_B	: OUT std_logic_vector(18 DOWNTO 0);
      main_register	: OUT std_logic_vector(18 DOWNTO 0);
      memory		: OUT std_logic_vector(18 DOWNTO 0);
	  dummy			: OUT std_logic_vector(18 downto 0)
	  );
End demux_b;

Architecture bhv of demux_b Is

begin
	process(ctrl, B_register)
	begin 

		if(ctrl = "00") then 
			ALU_input_B		<= B_register;
			main_register	<= (others => '0');
			memory			<= (others => '0');
			dummy			<= (others => '0');
		elsif(ctrl = "01") then
			ALU_input_B		<= (others => '0');
			main_register	<= B_register;
			memory			<= (others => '0');
			dummy			<= (others => '0');
		elsif(ctrl = "10") then
			ALU_input_B		<= (others => '0');
			main_register	<= (others => '0');
			memory			<=  B_register;
			dummy			<= (others => '0');
		else 
			ALU_input_B		<= (others => '0');
			main_register	<= (others => '0');
			memory			<= (others => '0');  
			dummy			<= B_register;
		end if;
		
	End process;

End bhv;
