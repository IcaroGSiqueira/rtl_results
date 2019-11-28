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

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A0 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);  -- 10 bits
      y1 : OUT STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
      y2 : OUT STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
      y3 : OUT STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0)  -- 10 bits
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
SIGNAL x_2, n_x, s0 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0);-- 12 bits

BEGIN

-- instanciamento de sinais
n_x <= x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 12 bits

-- shifts
x_2 <=(x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x

-- Somadores
	U_S0: somador_n_n generic map (bit_width+2) PORT MAP (x_2, NOT(n_x), '1', s0); -- 12 bits

-- out y1, y2, y3
y1 <= s0;
y2 <= s0;
y3 <= x;

END comportamento;
-------------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A1 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+2 DOWNTO 0);-- 13 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0);-- 14 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+1 DOWNTO 0) -- 12 bits
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
SIGNAL x_2, n_x, s0: STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0);-- 12 bits
SIGNAL x_s0 : STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0);-- 13 bits
SIGNAL x_4, n_s0, s1 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0);-- 14 bits

BEGIN

-- instanciamento de sinais
n_x <= x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 12 bits
n_s0 <= s0(s0'left)& s0(s0'left)& s0(bit_width+1 DOWNTO 0); -- 14 bits

-- shifts
x_2 <=(x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x
x_4 <=(x(bit_width-1 DOWNTO 0)&"0000"); -- shift <<4 16x
x_s0 <= (s0(bit_width+1 DOWNTO 0)&"0"); -- shift <<1 10x

-- somadores
	U_S0: somador_n_n generic map (bit_width+2) PORT MAP (x_2, n_x, '0', s0); -- 12 bits
	U_S1: somador_n_n generic map (bit_width+4) PORT MAP (n_s0, NOT(x_4), '1', s1); -- 14 bits

-- out y1, y2, y3
y1 <= x_s0;
y2 <= s1;
y3 <= s0;

END comportamento;

---------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A2 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+5 DOWNTO 0);-- 16 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+4 DOWNTO 0);-- 15 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0) -- 14 bits
);
END A2;

ARCHITECTURE comportamento OF A2 IS

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
SIGNAL x_4, n_x4, s1 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
SIGNAL x_s0, x_s1, n_s0, s2 : STD_LOGIC_VECTOR ( bit_width+4 DOWNTO 0); -- 15 bits
SIGNAL x_s2 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits

BEGIN

-- instanciamento de sinais
n_x <= x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 12 bits
n_x4 <= x(x'left)& x(x'left)& x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 14 bits
n_s0 <= s0(s0'left)& s0(s0'left)& s0(s0'left)& s0(bit_width+1 DOWNTO 0); -- 15 bits

-- shifts
x_2 <= (x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x
x_4 <= (x(bit_width-1 DOWNTO 0)&"0000"); -- shift <<4 16x
x_s0 <= (s0(bit_width+1 DOWNTO 0)&"000"); -- shift <<3 40x
x_s1 <= (s1(bit_width+3 DOWNTO 0)&"0"); -- shift <<1 34x
x_s2 <= (s2(bit_width+4 DOWNTO 0)&"0"); -- shift <<1 58x

-- somadores
	U_S0: somador_n_n generic map (bit_width+2) PORT MAP (x_2, n_x, '0', s0); -- 12 bits
	U_S1: somador_n_n generic map (bit_width+4) PORT MAP (x_4, n_x4, '0', s1); -- 14 bits
--	U_S2: somador_n_n generic map (bit_width+5) PORT MAP (n_s0, NOT(x_s1), '1', s2); -- 15 bits
	U_S2: somador_n_n generic map (bit_width+5) PORT MAP (x_s1, NOT(n_s0), '1', s2); -- 15 bits

-- out y1, y2, y3
y1 <= x_s2; 
y2 <= x_s0;
y3 <= s1;

END comportamento;
------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A3 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0);-- 14 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+4 DOWNTO 0);-- 15 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+5 DOWNTO 0) -- 16 bits
);
END A3;

ARCHITECTURE comportamento OF A3 IS

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
SIGNAL x_4, n_x4, s1 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
SIGNAL x_s0, x_s1, n_s0, s2 : STD_LOGIC_VECTOR ( bit_width+4 DOWNTO 0); -- 15 bits
SIGNAL x_s2 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits

BEGIN

-- instanciamento de sinais
n_x <= x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 12 bits
n_x4 <= x(x'left)& x(x'left)& x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 14 bits
n_s0 <= s0(s0'left)& s0(s0'left)& s0(s0'left)& s0(bit_width+1 DOWNTO 0); -- 15 bits

-- shifts
x_2 <= (x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x
x_4 <= (x(bit_width-1 DOWNTO 0)&"0000"); -- shift <<4 16x
x_s0 <= (s0(bit_width+1 DOWNTO 0)&"000"); -- shift <<3 40x
x_s1 <= (s1(bit_width+3 DOWNTO 0)&"0"); -- shift <<1 34x
x_s2 <= (s2(bit_width+4 DOWNTO 0)&"0"); -- shift <<1 58x

-- somadores
	U_S0: somador_n_n generic map (bit_width+2) PORT MAP (x_2, n_x, '0', s0); -- 12 bits
	U_S1: somador_n_n generic map (bit_width+4) PORT MAP (x_4, n_x4, '0', s1); -- 14 bits
--	U_S2: somador_n_n generic map (bit_width+5) PORT MAP (n_s0, NOT(x_s1), '1', s2); -- 15 bits
	U_S2: somador_n_n generic map (bit_width+5) PORT MAP (x_s1, NOT(n_s0), '1', s2); -- 15 bits

-- out y1, y2, y3
y1 <= s1;
y2 <= x_s0;
y3 <= x_s2;

END comportamento;
------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A4 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);
      y1 : OUT STD_LOGIC_VECTOR (bit_width+1 DOWNTO 0); -- 12 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0); -- 14 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+2 DOWNTO 0)  -- 13 bits
);
END A4;

ARCHITECTURE comportamento OF A4 IS

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
SIGNAL x_2, n_x, s0: STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0);-- 12 bits
SIGNAL x_s0 : STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0);-- 13 bits
SIGNAL x_4, n_s0, s1 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0);-- 14 bits

BEGIN

-- instanciamento de sinais
n_x <= x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 12 bits
n_s0 <= s0(s0'left)& s0(s0'left)& s0(bit_width+1 DOWNTO 0); -- 14 bits

-- shifts
x_2 <=(x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x
x_4 <=(x(bit_width-1 DOWNTO 0)&"0000"); -- shift <<4 16x
x_s0 <= (s0(bit_width+1 DOWNTO 0)&"0"); -- shift <<1 10x

-- somadores
	U_S0: somador_n_n generic map (bit_width+2) PORT MAP (x_2, n_x, '0', s0); -- 12 bits
	U_S1: somador_n_n generic map (bit_width+4) PORT MAP (n_s0, NOT(x_4), '1', s1); -- 14 bits

-- out y1, y2, y3
y1 <= s0;
y2 <= s1;
y3 <= x_s0;

END comportamento;
--------------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A5 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
      y1 : OUT STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
      y2 : OUT STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
      y3 : OUT STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0)  -- 12 bits
);
END A5;

ARCHITECTURE comportamento OF A5 IS

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
SIGNAL x_2, n_x, s0 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0);-- 12 bits

BEGIN

-- instanciamento de sinais
n_x <= x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 12 bits

-- shifts
x_2 <=(x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x

-- Somadores
	U_S0: somador_n_n generic map (bit_width+2) PORT MAP (x_2, NOT(n_x), '1', s0); -- 12 bits

-- out y1, y2, y3
y1 <= x;
y2 <= s0;
y3 <= s0;

END comportamento;
----------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY filter_6 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( e0, e1, e2, e3, e4, e5 : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits

	    f1 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0); -- 10 bits
		 f2 : OUT STD_LOGIC_VECTOR (bit_width   DOWNTO 0); -- 11 bits 
		 f3 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0)  -- 10 bits
);
END filter_6;

ARCHITECTURE comportamento OF filter_6 IS

-- declaracao de componente
COMPONENT A0
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);  -- 10 bits
      y1 : OUT STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
      y2 : OUT STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
      y3 : OUT STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0)  -- 10 bits
);
END COMPONENT;

COMPONENT A1
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+2 DOWNTO 0);-- 13 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0);-- 14 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+1 DOWNTO 0) -- 12 bits
);
END COMPONENT;

COMPONENT A2
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+5 DOWNTO 0);-- 16 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+4 DOWNTO 0);-- 15 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0) -- 14 bits
);
END COMPONENT;

COMPONENT A3
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0);-- 14 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+4 DOWNTO 0);-- 15 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+5 DOWNTO 0) -- 16 bits
);
END COMPONENT;

COMPONENT A4
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);
      y1 : OUT STD_LOGIC_VECTOR (bit_width+1 DOWNTO 0); -- 12 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0); -- 14 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+2 DOWNTO 0)  -- 13 bits
);
END COMPONENT;

COMPONENT A5
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
      y1 : OUT STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
      y2 : OUT STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
      y3 : OUT STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0)  -- 12 bits
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
signal y1_a5 : STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
signal y1_a0, y1_a4 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
signal y1_a1 : STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits
signal y1_a3 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
signal y1_a2 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits
-- y2
signal y2_a0, y2_a5 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
signal y2_a1, y2_a4  : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
signal y2_a2, y2_a3 : STD_LOGIC_VECTOR ( bit_width+4 DOWNTO 0); -- 15 bits
-- y3
signal y3_a0 : STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
signal y3_a1, y3_a5 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
signal y3_a4 : STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits
signal y3_a2 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
signal y3_a3 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits
--------------------------------------------------------------------------

signal const32 : STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
signal s0, s20 : STD_LOGIC_VECTOR ( bit_width DOWNTO 0); -- 11 bits
signal s1, s3, s21, s23, n_s0, n_s20 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
signal s11, s13, cons_32 : STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits
signal s2, s22, n1_a1, n3_a4 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
signal s12, s14, n_s13 : STD_LOGIC_VECTOR ( bit_width+4 DOWNTO 0); -- 15 bits
signal s4, s5, s24, s25, s10, n_s2, n_s3, n_s22, n_s23, n_s14 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits
signal s15 : STD_LOGIC_VECTOR ( bit_width+6 DOWNTO 0); -- 17 bits


BEGIN

const32 <= "0000100000"; -- 32
cons_32 <= "0000000100000"; -- 32

-- instanciamento de sinais
n1_a1 <= y1_a1(y1_a1'left)& y1_a1(bit_width+2 DOWNTO 0); -- 14 bits
n_s0 <= s0(s0'left)& s0(bit_width DOWNTO 0); -- 12 bits
n_s2 <= s2(s2'left)& s2(s2'left)& s2(bit_width+3 DOWNTO 0); -- 16 bits
n_s3 <= s3(s3'left)& s3(s3'left)& s3(s3'left)& s3(s3'left)& s3(bit_width+1 DOWNTO 0); -- 16 bits
n3_a4 <= y3_a4(y3_a4'left)& y3_a4(bit_width+2 DOWNTO 0); -- 14 bits
n_s20 <= s20(s20'left)& s20(bit_width DOWNTO 0); -- 12 bits
n_s22 <= s22(s22'left)& s22(s22'left)& s22(bit_width+3 DOWNTO 0); -- 16 bits
n_s23 <= s23(s23'left)& s23(s23'left)& s23(s3'left)& s23(s23'left)& s23(bit_width+1 DOWNTO 0); -- 16 bits
n_s13 <= s13(s13'left)& s13(s13'left)& s13(bit_width+2 DOWNTO 0); -- 15 bits
n_s14 <= s14(s14'left)& s14(bit_width+4 DOWNTO 0); -- 16 bits

-- ENTRADAS A0...A5
	U_0: A0 generic map (bit_width) port map ( e0, y1_a0, y2_a0, y3_a0); -- a0
	U_1: A1 generic map (bit_width) port map ( e1, y1_a1, y2_a1, y3_a1); -- a1
	U_2: A2 generic map (bit_width) port map ( e2, y1_a2, y2_a2, y3_a2); -- a2
	U_3: A3 generic map (bit_width) port map ( e3, y1_a3, y2_a3, y3_a3); -- a3
	U_4: A4 generic map (bit_width) port map ( e4, y1_a4, y2_a4, y3_a4); -- a4
	U_5: A5 generic map (bit_width) port map ( e5, y1_a5, y2_a5, y3_a5); -- a5
-- END ENTRADAS

-- SOMADORES y1
	U_S0: somador_n_np1 generic map (bit_width  ) port map ( y1_a5, const32, '0', s0);		-- 11 bits
	U_S1: somador_n_n   generic map (bit_width+2) port map ( y1_a0, NOT(y1_a4), '1', s1);	-- 12 bits
	U_S2: somador_n_n   generic map (bit_width+4) port map ( y1_a3, NOT(n1_a1), '1', s2);	-- 14 bits
	U_S3: somador_n_n   generic map (bit_width+2) port map ( n_s0, s1, '0', s3);				-- 12 bits
	U_S4: somador_n_n   generic map (bit_width+6) port map ( n_s2, y1_a2, '0', s4);			-- 16 bits
	U_S5: somador_n_n   generic map (bit_width+6) port map ( n_s3, s4, '0', s5);				-- 16 bits
	
-- somadores y2
	U_S10: somador_n_np1 generic map (bit_width+5) port map ( y2_a2, y2_a3, '0', s10); -- 16 bits
	U_S11: somador_n_np1 generic map (bit_width+2) port map ( y2_a0, y2_a5, '0', s11); -- 13 bits
	U_S12: somador_n_np1 generic map (bit_width+4) port map ( y2_a1, y2_a4, '0', s12); -- 15 bits
	U_S13: somador_n_n   generic map (bit_width+3) port map ( cons_32, s11, '0', s13); -- 13 bits
	U_S14: somador_n_n   generic map (bit_width+5) port map ( s12, n_s13, '0', s14);   -- 15 bits
	U_S15: somador_n_np1 generic map (bit_width+6) port map ( s10, n_s14, '0', s15); -- 17 bits

-- somadores y3
	U_S20: somador_n_np1 generic map (bit_width  ) port map ( y3_a0, const32, '0', s20);		-- 11 bits
	U_S21: somador_n_n   generic map (bit_width+2) port map ( y3_a5, NOT(y3_a1), '1', s21);	-- 12 bits
	U_S22: somador_n_n   generic map (bit_width+4) port map ( y3_a2, NOT(n3_a4), '1', s22);	-- 14 bits
	U_S23: somador_n_n   generic map (bit_width+2) port map ( n_s20, s21, '0', s23);				-- 12 bits
	U_s24: somador_n_n   generic map (bit_width+6) port map ( n_s22, y3_a3, '0', s24);			-- 16 bits
	U_S25: somador_n_n   generic map (bit_width+6) port map ( n_s23, s24, '0', s25);				-- 16 bits

-- out
f1 <= s5 ( s5'left downto 6); -- >>6
f2 <= s15(s15'left downto 6); -- >>6
f3 <= s25(s25'left downto 6); -- >>6
	
END comportamento;