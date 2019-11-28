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
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
       y1 : OUT STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits
       y2 : OUT STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits
       y3 : OUT STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0)  -- 12 bits
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
SIGNAL x_2 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0);-- 12 bits
SIGNAL x_3, n_x, s0 : STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits

BEGIN

-- instanciamento de sinais
n_x <= x(x'left)& x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 13 bits

-- shifts
x_3 <=(x(bit_width-1 DOWNTO 0)&"000"); -- shift <<3 8x
x_2 <=(x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x

-- Somadores
	U_S0: somador_n_n generic map (bit_width+3) PORT MAP (n_x, NOT(x_3), '1', s0); -- 13 bits
	
-- out
y1 <= s0;
y2 <= x_3;
y3 <= x_2;

END comportamento;

-----------------------------------------------------------
-- A1
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A1 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
       y1 : OUT STD_LOGIC_VECTOR (bit_width+5 DOWNTO 0);-- 16 bits
       y2 : OUT STD_LOGIC_VECTOR (bit_width+4 DOWNTO 0);-- 15 bits
       y3 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0) -- 14 bits
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
SIGNAL x_4, n_x4, s1 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
SIGNAL x_3, x_1, n_s0, s2 : STD_LOGIC_VECTOR ( bit_width+4 DOWNTO 0); -- 15 bits
SIGNAL x_s : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits

BEGIN

-- instanciamento de sinais
n_x <= x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 12 bits
n_x4 <= x(x'left)& x(x'left)& x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 14 bits
n_s0 <= s0(s0'left)& s0(s0'left)& s0(s0'left)& s0(bit_width+1 DOWNTO 0); -- 15 bits

-- shifts
x_2 <=(x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x
x_4 <=(x(bit_width-1 DOWNTO 0)&"0000"); -- shift <<4 16x
x_3 <=(s0(bit_width+1 DOWNTO 0)&"000"); -- shift <<3 40x
x_1 <=(s1(bit_width+3 DOWNTO 0)&"0"); -- shift <<1 34x
x_s <=(s2(bit_width+4 DOWNTO 0)&"0"); -- shift <<1 58x

-- Somadores
	U_S0: somador_n_n generic map (bit_width+2) PORT MAP (x_2, n_x, '0', s0); -- 12 bits
	U_S1: somador_n_n generic map (bit_width+4) PORT MAP (x_4, n_x4, '0', s1); -- 14 bits
--	U_S2: somador_n_n generic map (bit_width+5) PORT MAP (n_s0, NOT(x_1), '1', s2); -- 15 bits
	U_S2: somador_n_n generic map (bit_width+5) PORT MAP (x_1, NOT(n_s0), '1', s2); -- 15 bits
	
-- out
y1 <= x_s;
y2 <= x_3; 
y3 <= s1;

END comportamento;

-----------------------------------------------------------
-- A2
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A2 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
	   y1 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0); -- 14 bits
       y2 : OUT STD_LOGIC_VECTOR (bit_width+4 DOWNTO 0);-- 15 bits       
       y3 : OUT STD_LOGIC_VECTOR (bit_width+5 DOWNTO 0)-- 16 bits
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
SIGNAL x_3, x_1, n_s0, s2 : STD_LOGIC_VECTOR ( bit_width+4 DOWNTO 0); -- 15 bits
SIGNAL x_s : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits

BEGIN

-- instanciamento de sinais
n_x <= x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 12 bits
n_x4 <= x(x'left)& x(x'left)& x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 14 bits
n_s0 <= s0(s0'left)& s0(s0'left)& s0(s0'left)& s0(bit_width+1 DOWNTO 0); -- 15 bits

-- shifts
x_2 <=(x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x
x_4 <=(x(bit_width-1 DOWNTO 0)&"0000"); -- shift <<4 16x
x_3 <=(s0(bit_width+1 DOWNTO 0)&"000"); -- shift <<3 40x
x_1 <=(s1(bit_width+3 DOWNTO 0)&"0"); -- shift <<1 34x
x_s <=(s2(bit_width+4 DOWNTO 0)&"0"); -- shift <<1 58x

-- Somadores
	U_S0: somador_n_n generic map (bit_width+2) PORT MAP (x_2, n_x, '0', s0); -- 12 bits
	U_S1: somador_n_n generic map (bit_width+4) PORT MAP (x_4, n_x4, '0', s1); -- 14 bits
--	U_S2: somador_n_n generic map (bit_width+5) PORT MAP (n_s0, NOT(x_1), '1', s2); -- 15 bits
	U_S2: somador_n_n generic map (bit_width+5) PORT MAP (x_1, NOT(n_s0), '1', s2); -- 15 bits
	
-- out
y3 <= x_s;
y2 <= x_3; 
y1 <= s1;

END comportamento;

-----------------------------------------------------------
-- A3
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY A3 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
       y1 : OUT STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0);  -- 12 bits
       y2 : OUT STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits
       y3 : OUT STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0) -- 13 bits
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
SIGNAL x_2 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0);-- 12 bits
SIGNAL x_3, n_x, s0 : STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits

BEGIN

-- instanciamento de sinais
n_x <= x(x'left)& x(x'left)& x(x'left)& x(bit_width-1 DOWNTO 0); -- 13 bits

-- shifts
x_3 <=(x(bit_width-1 DOWNTO 0)&"000"); -- shift <<3 8x
x_2 <=(x(bit_width-1 DOWNTO 0)&"00"); -- shift <<2 4x

-- Somadores
	U_S0: somador_n_n generic map (bit_width+3) PORT MAP (n_x, NOT(x_3), '1', s0); -- 13 bits
	
-- out
y3 <= s0;
y2 <= x_3;
y1 <= x_2;

END comportamento;
---------------------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY filter_4 IS
GENERIC (bit_width: INTEGER:=10); -- largura do bit
PORT ( e0, e1, e2, e3 : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
	    f1, f2, f3 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0) -- 10 bits
);
END filter_4;

ARCHITECTURE comportamento OF filter_4 IS

-- declaracao de componente
COMPONENT A0
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
       y1 : OUT STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits
       y2 : OUT STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits
       y3 : OUT STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0)  -- 12 bits
);
END COMPONENT;

COMPONENT A1
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
       y1 : OUT STD_LOGIC_VECTOR (bit_width+5 DOWNTO 0);-- 16 bits
       y2 : OUT STD_LOGIC_VECTOR (bit_width+4 DOWNTO 0);-- 15 bits
       y3 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0) -- 14 bits
);
END COMPONENT;

COMPONENT A2
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0);-- 10 bits
	   y1 : OUT STD_LOGIC_VECTOR (bit_width+3 DOWNTO 0); -- 14 bits
       y2 : OUT STD_LOGIC_VECTOR (bit_width+4 DOWNTO 0);-- 15 bits       
       y3 : OUT STD_LOGIC_VECTOR (bit_width+5 DOWNTO 0)-- 16 bits
);
END COMPONENT;

COMPONENT A3
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( x : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
       y1 : OUT STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0);  -- 12 bits
       y2 : OUT STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits
       y3 : OUT STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0) -- 13 bits
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
signal y1_a3 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
signal y1_a0 : STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits
signal y1_a2 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
signal y1_a1 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits
-- y2
signal y2_a0, y2_a3 : STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits
signal y2_a1, y2_a2 : STD_LOGIC_VECTOR ( bit_width+4 DOWNTO 0); -- 15 bits
-- y3
signal y3_a0 : STD_LOGIC_VECTOR ( bit_width+1 DOWNTO 0); -- 12 bits
signal y3_a3 : STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits
signal y3_a1 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
signal y3_a2 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits
--------------------------------------------------------------------------

signal const32 : STD_LOGIC_VECTOR ( bit_width+2 DOWNTO 0); -- 13 bits
signal s0, s2, s11, s20, s22, f1_a3, f3_a0 : STD_LOGIC_VECTOR ( bit_width+3 DOWNTO 0); -- 14 bits
--signal f2_a0, f2_a3 : STD_LOGIC_VECTOR ( bit_width+4 DOWNTO 0); -- 15 bits
signal s1, s3, s10, s12, s13, s21, s23, f1_a2, n_s2, f2_const, f3_a1, n_s22, n_s11 : STD_LOGIC_VECTOR ( bit_width+5 DOWNTO 0); -- 16 bits

BEGIN

const32 <= "0000000100000"; -- 32
f2_const <= "0000000000100000"; -- 32

-- instanciamento de sinais y1
f1_a2 <= y1_a2(y1_a2'left)& y1_a2(y1_a2'left)& y1_a2( bit_width+3 DOWNTO 0); -- 16 bits
f1_a3 <= y1_a3(y1_a3'left)& y1_a3(y1_a3'left)& y1_a3( bit_width+1 DOWNTO 0); -- 14 bits
n_s2 <= s2(s2'left)& s2(s2'left)& s2( bit_width+3 DOWNTO 0); -- 16 bits
n_s11 <= s11(s11'left)& s11(s11'left)& s11(bit_width+3 DOWNTO 0); -- 16 bits
f3_a1 <= y3_a1(y3_a1'left)& y3_a1(y3_a1'left)& y3_a1( bit_width+3 DOWNTO 0); -- 16 bits
f3_a0 <= y3_a0(y3_a0'left)& y3_a0(y3_a0'left)& y3_a0( bit_width+1 DOWNTO 0); -- 14 bits
n_s22 <= s22(s22'left)& s22(s22'left)& s22( bit_width+3 DOWNTO 0); -- 16 bits

-- ENTRADAS A0...A3
	U_0: A0 generic map (bit_width) port map ( e0, y1_a0, y2_a0, y3_a0); -- a0
	U_1: A1 generic map (bit_width) port map ( e1, y1_a1, y2_a1, y3_a1); -- a1
	U_2: A2 generic map (bit_width) port map ( e2, y1_a2, y2_a2, y3_a2); -- a2
	U_3: A3 generic map (bit_width) port map ( e3, y1_a3, y2_a3, y3_a3); -- a3
-- END ENTRADAS

-- SOMADORES y1
	U_S0: somador_n_np1 generic map (bit_width+3) port map ( const32, y1_a0, '0', s0);	-- 14 bits
	U_S1: somador_n_n   generic map (bit_width+6) port map ( y1_a1, f1_a2, '0', s1);		-- 16 bits
	U_S2: somador_n_n   generic map (bit_width+4) port map ( s0, NOT(f1_a3), '1', s2);	-- 14 bits
	U_s3: somador_n_n   generic map (bit_width+6) port map ( n_s2, s1, '0', s3);			-- 16 bits
	
-- SOMADORES y2
	U_S10: somador_n_np1 generic map (bit_width+5) port map ( y2_a1, y2_a2, '0', s10);		-- 16 bits
	U_S11: somador_n_np1 generic map (bit_width+3) port map ( y2_a0, y2_a3, '0', s11);		-- 14 bits
	U_S12: somador_n_n   generic map (bit_width+6) port map ( s10, NOT(n_s11), '1', s12);	-- 16 bits
	U_S13: somador_n_n   generic map (bit_width+6) port map ( s12, f2_const, '0', s13); 	-- 16 bits
	
-- SOMADORES y3
	U_S20: somador_n_np1 generic map (bit_width+3) port map ( const32, y3_a3, '0', s20);	-- 14 bits
	U_S21: somador_n_n generic map (bit_width+6) port map ( f3_a1, y3_a2, '0', s21);			-- 16 bits
	U_S22: somador_n_n generic map (bit_width+4) port map ( s20, NOT(f3_a0), '1', s22);		-- 14 bits
	U_s23: somador_n_n generic map (bit_width+6) port map ( n_s22, s21, '0', s23);			-- 16 bits
	
-- out
f1 <= s3 ( s3'left downto 6); -- >>6
f2 <= s13(s13'left downto 6); -- >>6
f3 <= s23(s23'left downto 6); -- >>6

END comportamento;