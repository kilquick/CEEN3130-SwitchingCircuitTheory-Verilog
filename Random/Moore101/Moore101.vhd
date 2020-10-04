--Tyler Zoucha
--CEEN 3130

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Moore101 IS
	PORT (Clock, Resetn, w		: IN STD_LOGIC;
		  z						: OUT STD_LOGIC);
END Moore101;

ARCHITECTURE Behavior of Moore101 IS
	TYPE State_type IS (A, B, C, D, E);
	SIGNAL y_present, y_next	: State_type;
BEGIN
	PROCESS (w, y_present)
	BEGIN
		CASE y_present IS
			WHEN A =>
				IF w = '0' THEN
					y_next <= A;
				ELSE
					y_next <= B;
				END IF;
			WHEN B =>
				IF w = '0' THEN
					y_next <= C;
				ELSE
					y_next <= B;
				END IF;
			WHEN C =>
				IF w = '0' THEN
					y_next <= A;
				ELSE
					y_next <= D;
				END IF;
			WHEN D =>
				IF w = '0' THEN
					y_next <= A;
				ELSE
					y_next <= E;
				END IF;
			WHEN E =>
				IF w = '0' THEN
					y_next <= A;
				ELSE
					y_next <= E;
				END IF;
		END CASE;
	END PROCESS;
	
	PROCESS (Clock, Resetn)
	BEGIN
		IF Resetn = '0' THEN
			y_present <= A;
		ELSIF (Clock'EVENT AND Clock = '1') THEN
			y_present <= y_next;
		END IF;
	END PROCESS;
	
	z <= '1' WHEN y_present = D ELSE '0';
END Behavior;