LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY carry_look_up_adder IS
  PORT (
    Data_IN : IN std_logic_vector(18 DOWNTO 0);
    ctrl : IN std_logic_vector(1 DOWNTO 0);
    Ci: IN std_logic;
    S             : OUT std_logic_vector(18 DOWNTO 0)
    );
END carry_look_up_adder;

ARCHITECTURE bhv OF carry_look_up_adder IS

	SIGNAL c_buf : std_logic_vector(19 DOWNTO 0) := (OTHERS => '0');
	SIGNAL temp_S, p, g : std_logic_vector(18 DOWNTO 0) := (OTHERS => '0');
	signal A : std_logic_vector(18 DOWNTO 0);
	signal B : std_logic_vector(18 DOWNTO 0);
        signal add0: std_logic_vector(18 DOWNTO 0) :="0000000000000000000";
	signal add1: std_logic_vector(18 DOWNTO 0) :="0000000000000000001";
	signal add2: std_logic_vector(18 DOWNTO 0) :="0000000000000000010";
	signal C: std_logic_vector(18 DOWNTO 0);
BEGIN
	A <= Data_In;
	B <= add0 when (ctrl="00") else
             add1 when (ctrl="01") else
             add2 when (ctrl="10");
	temp_S <= A XOR B;
	p <= A OR B;
	g <= A AND B;
	carry: process(c_buf, p, g)
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
	C <= c_buf(18 DOWNTO 0);
	S <= temp_S XOR c_buf(18 DOWNTO 0);
END;
