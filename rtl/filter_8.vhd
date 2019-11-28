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

---------------------------------------------------------------------------------------
-- A0
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A0 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0); -- 10 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0)  -- 10 bits
--    y3 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0)
);
END A0;

ARCHITECTURE comportamento OF A0 IS

BEGIN

-- out y1, y2
y1 <= x;
y2 <= x;

END comportamento;
---------------------------------------------------------------------------------------
-- A1
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A1 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+1 DOWNTO 0); -- 12 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+1 DOWNTO 0); -- 12 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0)  -- 10 bits
);
END A1;

ARCHITECTURE comportamento OF A1 IS

-- sinais auxiliares
signal x_2 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits

BEGIN

-- shifts 
x_2 <= (x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 x4

-- out y1, y2, y3
y1 <= x_2;
y2 <= x_2;
y3 <= x;

END comportamento;

---------------------------------------------------------------------------------------
-- A2
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A2 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+2 DOWNTO 0);-- 13 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0);-- 14 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+1 DOWNTO 0) -- 12 bits
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
SIGNAL x_2, n_x, s0 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0);-- 12 bits
SIGNAL x_x5 : STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0);-- 13 bits
SIGNAL x_4, n_s0, s1 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0);-- 14 bits

BEGIN

-- instanciamento de sinais
n_x <= x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 12 bits
n_s0 <= s0(s0'left)& s0(s0'left)& s0(bit_width+1 DOWNTO 0); -- 14 bits

-- shifts
x_2 <=(x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x
x_4 <=(x(bit_width-1 DOWNTO 0)&"0000"); -- shift <<4 16x
x_x5 <= (s0(bit_width+1 DOWNTO 0)&"0"); -- shift <<1 10x

-- Somadores
	U_S0: somador_n_n generic map (bit_width+2) PORT MAP (x_2, n_x, '0', s0); -- 12 bits
	U_S1: somador_n_n generic map (bit_width+4) PORT MAP (n_s0, NOT(x_4), '1', s1); -- 14 bits
	
-- out y1, y2, y3
y1 <= x_x5;
y2 <= s1;
y3 <= s0;

END comportamento;

---------------------------------------------------------------------------------------
-- A3
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A3 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+5 DOWNTO 0);-- 16 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+4 DOWNTO 0);-- 15 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0) -- 14 bits
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
SIGNAL x_s0, x_s1, ne_s0, s2 : STD_LOGIC_VECTOR ( bit_width+4 DOWNTO 0); -- 15 bits
SIGNAL x_s2 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits

BEGIN

-- instanciamento de sinais
n_x <= x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 12 bits
n_x4 <= x(x'left)& x(x'left)& x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 14 bits
ne_s0 <= s0(s0'left)& s0(s0'left)& s0(s0'left)& s0(bit_width+1 DOWNTO 0); -- 15 bits

-- shifts
x_2 <=(x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x
x_4 <=(x(bit_width-1 DOWNTO 0)&"0000"); -- shift <<4 16x
x_s0 <=(s0(bit_width+1 DOWNTO 0)&"000"); -- shift <<3 40x
x_s1 <=(s1(bit_width+3 DOWNTO 0)&"0"); -- shift <<1 34x
x_s2 <=(s2(bit_width+4 DOWNTO 0)&"0"); -- shift <<1 58x

-- Somadores
	U_S0: somador_n_n generic map (bit_width+2) PORT MAP (x_2, n_x, '0', s0); -- 12 bits
	U_S1: somador_n_n generic map (bit_width+4) PORT MAP (x_4, n_x4, '0', s1); -- 14 bits
	U_S2: somador_n_n generic map (bit_width+5) PORT MAP (x_s1, NOT(ne_s0), '1', s2); -- 15 bits
	
-- out y1, y2, y3
y1 <= x_s2;
y2 <= x_s0;
y3 <= s1; 

END comportamento;

---------------------------------------------------------------------------------------
-- A4
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A4 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0);-- 14 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+4 DOWNTO 0);-- 15 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+5 DOWNTO 0) -- 16 bits
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
SIGNAL x_2, n_x, s0 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
SIGNAL x_4, n_x4, s1 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
SIGNAL x_s0, x_s1, ne_s0, s2 : STD_LOGIC_VECTOR ( bit_width+4 DOWNTO 0); -- 15 bits
SIGNAL x_s2 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits

BEGIN

-- instanciamento de sinais
n_x <= x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 12 bits
n_x4 <= x(x'left)& x(x'left)& x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 14 bits
ne_s0 <= s0(s0'left)& s0(s0'left)& s0(s0'left)& s0(bit_width+1 DOWNTO 0); -- 15 bits

-- shifts
x_2 <=(x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x
x_4 <=(x(bit_width-1 DOWNTO 0)&"0000"); -- shift <<4 16x
x_s0 <=(s0(bit_width+1 DOWNTO 0)&"000"); -- shift <<3 40x
x_s1 <=(s1(bit_width+3 DOWNTO 0)&"0"); -- shift <<1 34x
x_s2 <=(s2(bit_width+4 DOWNTO 0)&"0"); -- shift <<1 58x

-- Somadores
	U_S0: somador_n_n generic map (bit_width+2) PORT MAP (x_2, n_x, '0', s0); -- 12 bits
	U_S1: somador_n_n generic map (bit_width+4) PORT MAP (x_4, n_x4, '0', s1); -- 14 bits
	U_S2: somador_n_n generic map (bit_width+5) PORT MAP (x_s1, NOT(ne_s0), '1', s2); -- 15 bits
	
-- out y1, y2, y3
y1 <= s1;
y2 <= x_s0;
y3 <= x_s2;
 
END comportamento;

---------------------------------------------------------------------------------------
-- A5
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A5 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);
      y1 : OUT STD_LOGIC_VECTOR (bit_width+1 DOWNTO 0); -- 12 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0); -- 14 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+2 DOWNTO 0)  -- 13 bits
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
SIGNAL x_x5 : STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0);-- 13 bits
SIGNAL x_4, n_s0, s1 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0);-- 14 bits

BEGIN

-- instanciamento de sinais
n_x <= x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 12 bits
n_s0 <= s0(s0'left)& s0(s0'left)& s0(bit_width+1 DOWNTO 0); -- 14 bits

-- shifts
x_2 <=(x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x
x_4 <=(x(bit_width-1 DOWNTO 0)&"0000"); -- shift <<4 16x
x_x5 <= (s0(bit_width+1 DOWNTO 0)&"0"); -- shift <<1 10x

-- Somadores
	U_S0: somador_n_n generic map (bit_width+2) PORT MAP (x_2, n_x, '0', s0); -- 12 bits
	U_S1: somador_n_n generic map (bit_width+4) PORT MAP (n_s0, NOT(x_4), '1', s1); -- 14 bits

-- out y1, y2, y3
y1 <= s0;
y2 <= s1;
y3 <= x_x5;

END comportamento;

---------------------------------------------------------------------------------------
-- A6
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A6 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0);-- 10 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+1 DOWNTO 0);-- 12 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+1 DOWNTO 0) -- 12 bits
);
END A6;

ARCHITECTURE comportamento OF A6 IS

-- sinais auxiliares
SIGNAL x_2 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits

BEGIN

-- shifts
x_2 <= (x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x

-- out y1, y2, y3
y1 <= x;
y2 <= x_2;
y3 <= x_2;

END comportamento;

---------------------------------------------------------------------------------------
-- A7
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A7 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
--    y1 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0);
      y2 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0);-- 10 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0) -- 10 bits
);
END A7;

ARCHITECTURE comportamento OF A7 IS

BEGIN

-- out y2, y3
y2 <= x;
y3 <= x;

END comportamento;

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY filter_8 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( e0, e1, e2, e3, e4, e5, e6, e7 : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits

	    f1 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0); -- 10 bits
		 f2 : OUT STD_LOGIC_VECTOR (bit_width   DOWNTO 0); -- 11 bits 
		 f3 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0)  -- 10 bits
);
END filter_8;

ARCHITECTURE comportamento OF filter_8 IS

-- declaracao de componente
COMPONENT A0 IS
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0); -- 10 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0)  -- 10 bits
--    y3 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0)
);
END COMPONENT;

COMPONENT A1 IS
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+1 DOWNTO 0); -- 12 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+1 DOWNTO 0); -- 12 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0)  -- 10 bits
);
END COMPONENT;

COMPONENT A2 IS
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+2 DOWNTO 0);-- 13 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0);-- 14 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+1 DOWNTO 0) -- 12 bits
);
END COMPONENT;

COMPONENT A3 IS
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+5 DOWNTO 0);-- 16 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+4 DOWNTO 0);-- 15 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0) -- 14 bits
);
END COMPONENT;

COMPONENT A4 IS
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0);-- 14 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+4 DOWNTO 0);-- 15 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+5 DOWNTO 0) -- 16 bits
);
END COMPONENT;

COMPONENT A5 IS
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);
      y1 : OUT STD_LOGIC_VECTOR (bit_width+1 DOWNTO 0); -- 12 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0); -- 14 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+2 DOWNTO 0)  -- 13 bits
);
END COMPONENT;

COMPONENT A6 IS
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
      y1 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0);-- 10 bits
      y2 : OUT STD_LOGIC_VECTOR (bit_width+1 DOWNTO 0);-- 12 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width+1 DOWNTO 0) -- 12 bits
);
END COMPONENT;

COMPONENT A7 IS
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
--    y1 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0);
      y2 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0);-- 10 bits
      y3 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0) -- 10 bits
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
signal y1_a0, y1_a6 : STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
signal y1_a1, y1_a5 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
signal y1_a2 : STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits
signal y1_a4 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
signal y1_a3 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits
-- y2
signal y2_a0, y2_a7 : STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
signal y2_a1, y2_a6 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
signal y2_a2, y2_a5 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
signal y2_a3, y2_a4 : STD_LOGIC_VECTOR ( bit_width+4 DOWNTO 0); -- 15 bits
-- y3
signal y3_a1, y3_a7 : STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
signal y3_a2, y3_a6 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
signal y3_a5 : STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits
signal y3_a3 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
signal y3_a4 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits
--------------------------------------------------------------------------

signal const32 : STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
signal s1, s21 : STD_LOGIC_VECTOR ( bit_width DOWNTO 0); -- 11 bits
signal s0, s2, s20, s22, s10, s11, n1_a0, n_s1, n3_a7, n_s21, n2_a0 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
signal n2_a7 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
signal s12, s14, cons_32 : STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits
signal s3, s4, s23, s24, n1_a5, n_s2, n3_a2, n_s22 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
signal s15 : STD_LOGIC_VECTOR ( bit_width+4 DOWNTO 0); -- 15 bits
signal s5, s6, s25, s26, s13, s16, n1_a2, n_s4, n3_a5, n_s24, n_s14, n_s15 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits
signal s17 : STD_LOGIC_VECTOR ( bit_width+6 DOWNTO 0); -- 17 bits

BEGIN

const32 <= "0000100000"; -- 32
cons_32 <= "0000000100000"; -- 32

-- instanciamento de sinais
n1_a0 <= y1_a0(y1_a0'left)& y1_a0(y1_a0'left)& y1_a0(bit_width-1 DOWNTO 0); -- 12 bits
n_s1 <= s1(s1'left)& s1(bit_width DOWNTO 0); -- 12 bits
n1_a5 <= y1_a5(y1_a5'left)& y1_a5(y1_a5'left)& y1_a5(bit_width+1 DOWNTO 0); -- 14 bits
n_s2 <= s2(s2'left)& s2(s2'left)& s2(bit_width+1 DOWNTO 0); -- 14 bits
n1_a2 <= y1_a2(y1_a2'left)& y1_a2(y1_a2'left)& y1_a2(y1_a2'left)& y1_a2(bit_width+2 DOWNTO 0); -- 16 bits
n_s4 <= s4(s4'left)& s4(s4'left)& s4(bit_width+3 DOWNTO 0); -- 16 bits
n3_a7 <= y3_a7(y3_a7'left)& y3_a7(y3_a7'left)& y3_a7(bit_width-1 DOWNTO 0); -- 12 bits
n_s21 <= s21(s21'left)& s21(bit_width DOWNTO 0); -- 12 bits
n3_a2 <= y3_a2(y3_a2'left)& y3_a2(y3_a2'left)& y3_a2(bit_width+1 DOWNTO 0); -- 14 bits
n_s22 <= s22(s22'left)& s22(s22'left)& s22(bit_width+1 DOWNTO 0); -- 14 bits
n3_a5 <= y3_a5(y3_a5'left)& y3_a5(y3_a5'left)& y3_a5(y3_a5'left)& y3_a5(bit_width+2 DOWNTO 0); -- 16 bits
n_s24 <= s24(s24'left)& s24(s24'left)& s24(bit_width+3 DOWNTO 0); -- 16 bits
n2_a0 <= y2_a0(y2_a0'left)& y2_a0(y2_a0'left)& y2_a0(bit_width-1 DOWNTO 0); -- 12 bits
n2_a7 <= y2_a7(y2_a7'left)& y2_a7(y2_a7'left)& y2_a7(bit_width-1 DOWNTO 0); -- 12 bits
n_s14 <= s14(s14'left)& s14(s14'left)& s14(s14'left)& s14(bit_width+2 DOWNTO 0); -- 16 bits
n_s15 <= s15(s15'left)& s15(bit_width+4 DOWNTO 0); -- 16 bits

-- ENTRADAS A0...A7
	U_0: A0 generic map (bit_width) port map ( e0, y1_a0, y2_a0); -- a0
	U_1: A1 generic map (bit_width) port map ( e1, y1_a1, y2_a1, y3_a1); -- a1
	U_2: A2 generic map (bit_width) port map ( e2, y1_a2, y2_a2, y3_a2); -- a2
	U_3: A3 generic map (bit_width) port map ( e3, y1_a3, y2_a3, y3_a3); -- a3
	U_4: A4 generic map (bit_width) port map ( e4, y1_a4, y2_a4, y3_a4); -- a4
	U_5: A5 generic map (bit_width) port map ( e5, y1_a5, y2_a5, y3_a5); -- a5
	U_6: A6 generic map (bit_width) port map ( e6, y1_a6, y2_a6, y3_a6); -- a6
	U_7: A7 generic map (bit_width) port map ( e7, y2_a7, y3_a7); -- a7
-- END ENTRADAS

-- somadores y1
	U_S0: somador_n_n   generic map (bit_width+2) port map ( y1_a1, NOT(n1_a0), '1', s0); 	-- 12 bits
	U_S1: somador_n_np1 generic map (bit_width  ) port map ( y1_a6, const32, '0', s1); 		-- 11 bits
	U_S2: somador_n_n   generic map (bit_width+2) port map ( s0, n_s1, '0', s2); 				-- 12 bits
	U_S3: somador_n_n   generic map (bit_width+4) port map ( y1_a4, NOT(n1_a5), '1', s3); 	-- 14 bits
	U_S4: somador_n_n   generic map (bit_width+4) port map ( n_s2, s3, '0', s4); 				-- 14 bits
	U_S5: somador_n_n   generic map (bit_width+6) port map ( y1_a3, NOT(n1_a2), '1', s5);  -- 16 bits
	U_S6: somador_n_n   generic map (bit_width+6) port map ( n_s4, s5, '0', s6); 				-- 16 bits
	
-- somadores y2
	U_S10: somador_n_n   generic map (bit_width+2) port map ( y2_a1, NOT(n2_a0), '1', s10); -- 12 bits
	U_S11: somador_n_n   generic map (bit_width+2) port map ( y2_a6, NOT(n2_a7), '1', s11); -- 12 bits
	U_S12: somador_n_np1 generic map (bit_width+2) port map ( s10, s11, '0', s12); 			 -- 13 bits
	U_S13: somador_n_np1 generic map (bit_width+5) port map ( y2_a3, y2_a4, '0', s13); 		 -- 16 bits
	U_S14: somador_n_n   generic map (bit_width+3) port map ( s12, cons_32, '0', s14); 	 	 -- 13 bits
	U_S15: somador_n_np1 generic map (bit_width+4) port map ( y2_a2, y2_a5, '0', s15); 		 -- 15 bits
	U_S16: somador_n_n   generic map (bit_width+6) port map ( n_s14, s13, '0', s16); 		 -- 16 bits
	U_S17: somador_n_np1 generic map (bit_width+6) port map ( s16, n_s15, '0', s17); 		 -- 17 bits
	
-- somadores y3
	U_S20: somador_n_n   generic map (bit_width+2) port map ( y3_a6, NOT(n3_a7), '1', s20); -- 12 bits
	U_S21: somador_n_np1 generic map (bit_width  ) port map ( y1_a6, const32, '0', s21); 	 -- 11 bits
	U_S22: somador_n_n   generic map (bit_width+2) port map ( s20, n_s21, '0', s22); 		 -- 12 bits
	U_S23: somador_n_n   generic map (bit_width+4) port map ( y3_a3, NOT(n3_a2), '1', s23); -- 14 bits
	U_S24: somador_n_n   generic map (bit_width+4) port map ( n_s22, s23, '0', s24);			 -- 14 bits
	U_S25: somador_n_n   generic map (bit_width+6) port map ( y3_a4, NOT(n3_a5), '1', s25); -- 16 bits
	U_S26: somador_n_n   generic map (bit_width+6) port map ( n_s24, s25, '0', s26); 		 -- 16 bits
	
-- out
f1 <= s6 ( s6'left downto 6); -- >>6
f2 <= s17(s17'left downto 6); -- >>6
f3 <= s26(s26'left downto 6); -- >>6

END comportamento;
