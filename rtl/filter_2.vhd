LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_signed.all;

ENTITY somador_n_n IS
GENERIC (bit_width: INTEGER); 
PORT ( a, b : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);
		Cin : IN STD_LOGIC;
		  s : OUT STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0)
);
END somador_n_n;

ARCHITECTURE dataflow OF somador_n_n IS
BEGIN

s <= (a) + (b) + Cin;
--s <= ('0' & a) + ('0' & b) + Cin;

END dataflow;

-----------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY somador_n_np1 IS
GENERIC (bit_width: INTEGER); 
PORT ( a, b : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);
		Cin : IN STD_LOGIC;
		  s : OUT STD_LOGIC_VECTOR ( bit_width DOWNTO 0)
);
END somador_n_np1;

ARCHITECTURE dataflow OF somador_n_np1 IS
BEGIN

--s <= a + b + Cin;
s <= ('0' & a) + ('0' & b) + Cin;

END dataflow;

-----------------------------------------------------------
-- A0
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A0 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+5 DOWNTO 0);-- 16 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+4 DOWNTO 0);-- 15 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0) -- 14 bits
);
END A0;

ARCHITECTURE comportamento OF A0 IS

-- Declaracao de componentes
COMPONENT somador_n_n
GENERIC (bit_width: INTEGER); 
PORT ( 
	   a, b: IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
	   Cin : IN STD_LOGIC;
		  s: OUT STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0) -- 10 bits
);
END COMPONENT;

-- sinais auxiliares
SIGNAL x_2, n_x, s0 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
SIGNAL x_4, n_s0, s1 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
SIGNAL x_5 : STD_LOGIC_VECTOR ( bit_width+4 DOWNTO 0); -- 15 bits
SIGNAL x_s0, nn_s0, s2 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits

BEGIN

-- instanciamento de sinais
n_x <= x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 12 bits
n_s0 <= s0(s0'left)& s0(s0'left)& s0(bit_width+1 DOWNTO 0); -- 14 bits
nn_s0 <= s0(s0'left)& s0(s0'left)& s0(s0'left)& s0(s0'left)& s0(bit_width+1 DOWNTO 0); -- 16 bits

-- shifts
x_2 <= (x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x
x_4 <= (x(bit_width-1 DOWNTO 0)&"0000"); -- shift <<4 16x
x_5 <= (x(bit_width-1 DOWNTO 0)&"00000"); -- shift <<5 32x
x_s0 <= (s0(bit_width+1 DOWNTO 0)&"0000"); -- shift <<4 48x

-- somadores
	U_S0: somador_n_n generic map (bit_width+2) PORT MAP (x_2, NOT(n_x), '1', s0); -- 12 bits
	U_S1: somador_n_n generic map (bit_width+4) PORT MAP (x_4, NOT(n_s0), '1', s1); -- 14 bits
	U_S2: somador_n_n generic map (bit_width+6) PORT MAP (nn_s0, x_s0, '0', s2); -- 16 bits

-- out y1, y2, y3
y1 <= s2;
y2 <= x_5;
y3 <= s1;

END comportamento;
-----------------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A1 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0);-- 14 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+4 DOWNTO 0);-- 15 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+5 DOWNTO 0) -- 16 bits
);
END A1;

ARCHITECTURE comportamento OF A1 IS

-- Declaracao de componentes
COMPONENT somador_n_n
GENERIC (bit_width: INTEGER); 
PORT ( 
	   a, b: IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
	   Cin : IN STD_LOGIC;
		  s: OUT STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0) -- 10 bits
);
END COMPONENT;

-- sinais auxiliares
SIGNAL x_2, n_x, s0 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
SIGNAL x_4, n_s0, s1 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
SIGNAL x_5 : STD_LOGIC_VECTOR ( bit_width+4 DOWNTO 0); -- 15 bits
SIGNAL x_s0, nn_s0, s2 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits

BEGIN

-- instanciamento de sinais
n_x <= x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 12 bits
n_s0 <= s0(s0'left)& s0(s0'left)& s0(bit_width+1 DOWNTO 0); -- 14 bits
nn_s0 <= s0(s0'left)& s0(s0'left)& s0(s0'left)& s0(s0'left)& s0(bit_width+1 DOWNTO 0); -- 16 bits

-- shifts
x_2 <= (x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x
x_4 <= (x(bit_width-1 DOWNTO 0)&"0000"); -- shift <<4 16x
x_5 <= (x(bit_width-1 DOWNTO 0)&"00000"); -- shift <<5 32x
x_s0 <= (s0(bit_width+1 DOWNTO 0)&"0000"); -- shift <<4 48x

-- somadores
	U_S0: somador_n_n generic map (bit_width+2) PORT MAP (x_2, NOT(n_x), '1', s0); -- 12 bits
	U_S1: somador_n_n generic map (bit_width+4) PORT MAP (x_4, NOT(n_s0), '1', s1); -- 14 bits
	U_S2: somador_n_n generic map (bit_width+6) PORT MAP (nn_s0, x_s0, '0', s2); -- 16 bits

-- out y1, y2, y3
y1 <= s1;
y2 <= x_5;
y3 <= s2;

END comportamento;
-----------------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY filter_2 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( e0, e1 : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
	        f1 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0); -- 10 bits
		     f2 : OUT STD_LOGIC_VECTOR (bit_width-3 DOWNTO 0); -- 8 bits 
		     f3 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0) -- 10 bits
);
END filter_2;

ARCHITECTURE comportamento OF filter_2 IS

-- declaracao de componente
COMPONENT A0
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+5 DOWNTO 0);-- 16 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+4 DOWNTO 0);-- 15 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0) -- 14 bits
);
END COMPONENT;

COMPONENT A1
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0);-- 14 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+4 DOWNTO 0);-- 15 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+5 DOWNTO 0) -- 16 bits
);
END COMPONENT;

-- Somador
COMPONENT somador_n_n
GENERIC (bit_width: INTEGER); 
PORT ( a, b : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);
		Cin : IN STD_LOGIC;
		  s : OUT STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0)
);
END COMPONENT;

COMPONENT somador_n_np1
GENERIC (bit_width: INTEGER); 
PORT ( a, b : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);
		Cin : IN STD_LOGIC;
		  s : OUT STD_LOGIC_VECTOR ( bit_width DOWNTO 0)
);
END COMPONENT;

-- sinais auxiliares
-- y1
signal y1_a1 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
signal y1_a0 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits
-- y2
signal y2_a0, y2_a1 : STD_LOGIC_VECTOR ( bit_width+4 DOWNTO 0); -- 15 bits
-- y3
signal y3_a0 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
signal y3_a1 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits

signal s10: STD_LOGIC_VECTOR ( 8 DOWNTO 0 ); -- 9 bits
signal f1_a1, f3_a0, const_32, s0, s1, s20, s21 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits



BEGIN

const_32 <= "0000000000100000"; -- 32

-- instanciamento de sinais
f1_a1 <= y1_a1(y1_a1'left)& y1_a1(y1_a1'left)& y1_a1( bit_width+3 DOWNTO 0); --16 bits
f3_a0 <= y3_a0(y3_a0'left)& y3_a0(y3_a0'left)& y3_a0( bit_width+3 DOWNTO 0); --16 bits

-- ENTRADAS A0 - A1
	U_0: A0 generic map (bit_width) port map ( e0, y1_a0, y2_a0, y3_a0); -- a0
	U_1: A1 generic map (bit_width) port map ( e1, y1_a1, y2_a1, y3_a1); -- a1

-- SOMADORES y1
	U_S0: somador_n_n generic map (bit_width+6) port map ( y1_a0, f1_a1, '0', s0); -- 16 bits
	U_S1: somador_n_n generic map (bit_width+6) port map ( s0, const_32, '0', s1); -- 16 bits
	
-- SOMADORES y2
	U_S10: somador_n_np1 generic map (bit_width-2) PORT MAP ( y2_a0( 7 downto 0), y2_a1(7 downto 0), '1', s10); -- saem 9 bits
	
-- SOMADORES y3
	U_S20: somador_n_n generic map (bit_width+6) port map ( f3_a0, y3_a1, '0', s20); -- 16 bits
	U_S21: somador_n_n generic map (bit_width+6) port map ( s20, const_32, '0', s21); -- 16 bits
	
-- out
f1 <= s1(s1'left downto 6); -- >>6
f2 <= s10(s10'left downto 1); -- >> 1
f3 <= s21(s21'left downto 6); -- >>6

END comportamento;

