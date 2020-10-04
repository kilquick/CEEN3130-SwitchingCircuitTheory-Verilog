--Tyler Zoucha
--CEEN 3130
--Divider

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DIVIDER IS
	PORT (RESETn, CLK, S, MSB					: IN STD_LOGIC;
		  SEL, SUB, DVD, DSR, CLR, ENCNT, DONE	: OUT STD_LOGIC);
END DIVIDER;

ARCHITECTURE BEHAVIOR OF DIVIDER IS
TYPE STATE_TYPE IS (S0, S1, S2, S3);
SIGNAL Y		:	STATE_TYPE;
BEGIN
	PROCESS (RESETn, CLK, y, S, MSB)
	BEGIN
		IF RESETn = '0' THEN
			Y <= S0;
		ELSIF CLK'EVENT AND CLK = '1' THEN
			CASE Y IS
				WHEN S0 =>
					IF S = '1' THEN
						Y <= S1;
					ELSE
						Y <= S0;
					END IF;
				WHEN S1 =>
					Y <= S2;
				WHEN S2 =>
					IF MSB = '1' THEN
						Y <= S3;
					ELSE
						Y <= S2;
					END IF;
				WHEN S3 =>
					IF S = '1' THEN
						Y <= S3;
					ELSE
						Y <= S0;
					END IF;
				END CASE;
		END IF;
	END PROCESS;

	PROCESS (Y, S, MSB)
	BEGIN
		SEL <= '0';
		SUB <= '0';
		DVD <= '0';
		DSR <= '0';
		CLR <= '0';
		ENCNT <= '0';
		DONE <= '0';

		CASE Y IS
			WHEN S0 =>
				SEL <= S;
				DVD <= S;
				DSR <= S;
			WHEN S1 =>
				SUB <= '1';
				DVD <= '1';
			WHEN S2 =>
				DVD <= '1';
				SUB <= NOT MSB;
				ENCNT <= NOT MSB;
			WHEN S3 =>
				DONE <= '1';
				CLR <= NOT S;
		END CASE;
	END PROCESS;
END BEHAVIOR;

-----------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY ADDSUB IS
	PORT (X, Y				: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		  SUB 					: IN STD_LOGIC;
		  TOTAL					: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END ADDSUB;

ARCHITECTURE BEHAVIOR OF ADDSUB IS
SIGNAL TMP						: STD_LOGIC_VECTOR (7 DOWNTO 0);
BEGIN
	PROCESS (X, Y, SUB)
	BEGIN
		IF SUB = '0' THEN
			TMP <= X + Y;
		ELSE
			TMP <= X - Y;
		END IF;
	END PROCESS;
	TOTAL <= TMP;
END BEHAVIOR;

-----------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY STORE IS
	PORT (CLK, CLR, LOAD			: IN STD_LOGIC;
		  Din						: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		  Dout						: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END STORE;

ARCHITECTURE BEHAVIOR OF STORE IS
SIGNAL TMP							: STD_LOGIC_VECTOR (7 DOWNTO 0);
BEGIN
	PROCESS (CLR, CLK)
	BEGIN
		IF (CLK'EVENT AND CLK = '1') THEN
			IF CLR = '1' THEN
				TMP <= "00000000";
			ELSIF LOAD = '1' THEN
				TMP <= Din;
			END IF;
		END IF;
	END PROCESS;
	
	Dout <= TMP;
END BEHAVIOR;

-----------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY COUNT IS
	PORT (CLK, CLCNT, ENCNT		: IN STD_LOGIC;
		  COUNT					: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END COUNT;

ARCHITECTURE BEHAVIOR OF COUNT IS
SIGNAL TMP		: STD_LOGIC_VECTOR (7 DOWNTO 0);
BEGIN
	PROCESS (CLK, CLCNT, ENCNT)
	BEGIN
		IF (CLK'EVENT AND CLK = '1') THEN
			IF CLCNT = '1' THEN
				TMP <= "00000000";
			ELSIF ENCNT = '1' THEN
				TMP <= TMP + 1;
			END IF;
		END IF;
	END PROCESS;
	
	COUNT <= TMP;
END BEHAVIOR;

-----------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY MUX IS
	PORT (SEL					: IN STD_LOGIC;
		  Di1, Di2				: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		  Dout					: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END MUX;

ARCHITECTURE BEHAVIOR OF MUX IS
BEGIN
	WITH SEL SELECT
		Dout <= Di1 WHEN '0',
				Di2 WHEN '1';
END BEHAVIOR;