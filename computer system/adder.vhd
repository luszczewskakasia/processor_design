LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY adder IS
  PORT (
    Data_IN	: IN std_logic_vector(18 DOWNTO 0);
    ctrl	: IN std_logic_vector(1 DOWNTO 0);
    S       : OUT std_logic_vector(18 DOWNTO 0)
    );
END adder;

ARCHITECTURE bhv OF adder IS

	SIGNAL c_buf : std_logic_vector(19 DOWNTO 0) := (OTHERS => '0');
	SIGNAL temp_S, p, g : std_logic_vector(18 DOWNTO 0) := (OTHERS => '0');
	signal A : std_logic_vector(18 DOWNTO 0);
	signal B : std_logic_vector(18 DOWNTO 0);
	signal Ci: std_logic;
BEGIN
	A <= Data_In;
	B <= "0000000000000000000" when (ctrl="00") else
             "0000000000000000001" when (ctrl="01") else
             "0000000000000000010" when (ctrl="10") else
			 (others => '0');
	temp_S <= A XOR B;
	p <= A OR B;
	g <= A AND B;
	carry: process(c_buf, p, g,ci)
	
	BEGIN
		IF Ci = '0' THEN
			c_buf(0) <= '0';
		ELSIF Ci = '1' THEN
			c_buf(0) <= '1';
		END IF;

		cll: FOR i IN 0 to 18 LOOP
			c_buf(i+1) <= g(i) OR (p(i) AND c_buf(i));
		END LOOP;

	END PROCESS; 
	S <= temp_S XOR c_buf(18 DOWNTO 0);
END;
