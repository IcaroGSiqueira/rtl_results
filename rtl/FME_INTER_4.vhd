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

-----------------------------------------------------------

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
--f2_a0 <= y2_a0(y2_a0'left)& y2_a0(y2_a0'left)& y2_a0( bit_width+2 DOWNTO 0); -- 15 bits
--f2_a3 <= y2_a3(y2_a3'left)& y2_a3(y2_a3'left)& y2_a3( bit_width+2 DOWNTO 0); -- 15 bits
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

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;
USE ieee.std_logic_arith.all;


package custom_functions is
	function f_log2   (x: positive) return natural;
end custom_functions;

 package body custom_functions is

 function f_log2 (x: positive) 
		 return natural is
    variable i : natural;
 begin
       i := 0;  
    while (2**i < x) and i < 31 loop
          i := i + 1;
    end loop;
    return i;
 end f_log2;

 end package body custom_functions;
-------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;
USE ieee.std_logic_arith.all;
use work.custom_functions.all;


PACKAGE types IS


CONSTANT size_block: INTEGER:= 16; 	-- tamanho do bloco
CONSTANT N_TAPS: INTEGER:= 4; 		-- numero de taps

CONSTANT horizontal: INTEGER:= (size_block + N_TAPS);
CONSTANT vertical: INTEGER:= size_block;
CONSTANT diagonal: INTEGER:= (3*(size_block+1));

--function f_log2   (x: positive) return natural;

constant buffer_rowaddr_width: natural:= f_log2 (size_block + N_TAPS); 	-- tamanho do bloco +1
constant buffer_coladdr_width: natural:= f_log2 (size_block + 1); 		-- tamanho da linha +8

type array_1d_3Np1_8bits  is array ( 0 to 3*(size_block+1)-1) of std_logic_vector ( 7 downto 0); -- saida linha 1 interpolation
type array_1d_3Np1_10bits is array ( 0 to 3*(size_block+1)-1) of std_logic_vector ( 9 downto 0); -- saida linha 1 interpolation
type array_1d_3Np1_11bits is array ( 0 to 3*(size_block+1)-1) of std_logic_vector (10 downto 0); -- saida linha 1 interpolation

type pixel_row is array ( 0 to (size_block + N_TAPS-1)) of std_logic_vector (7 downto 0); -- linha 1 entrada de tudo

type array_1d_Np8_10bits is array ( 0 to (size_block + N_TAPS-1)) of std_logic_vector(9 downto 0); -- buffer_coluna;

type INTERPOLATION_OUT_10b is array ( 0 to (size_block + N_TAPS-1) ) of std_logic_vector ( 9 downto 0);
type INTERPOLATION_OUT_11b is array ( 0 to (size_block + N_TAPS-1) ) of std_logic_vector (10 downto 0); -- saida linha 1 interpolation

type array_2d_Np8_3Np1_10bits is array ( 0 to (size_block + N_TAPS-1), 0 to 3*(size_block + 1) -1 ) of std_logic_vector (9 downto 0); -- buffer

type array_out_8bits is array ( 0 to (size_block - 1)) of std_logic_vector (7 downto 0); -- saida clipada


--constant bufferlinha_width: natural:= f_log2 (size_block + 8) -1; -- tamanho da linha +8
--constant buffercoluna_width: natural:= f_log2 (size_block + 1) -1 ;  -- tamanho do bloco +1
--type pixel_row is array ( size_block + 7 downto 0) of STD_LOGIC_VECTOR (7 DOWNTO 0); -- linha 1 entrada de tudo
--type pixel_row is array ( 0 to (size_block +7)) of std_logic_vector (7 downto 0); -- linha 1 entrada de tudo

--type INTERPOLATION_OUT_11b is array ( 0 to size_block) of std_logic_vector (10 downto 0); -- saida linha 1 interpolation
--type INTERPOLATION_OUT_10b is array ( 0 to size_block) of std_logic_vector (9 downto 0); -- saida linha 1 interpolation

--type array_coluna_10bits is array ( 0 to (size_block + 7)) of std_logic_vector(9 downto 0); -- buffer_coluna;

--type array_2d_12x5_10bits is array (0 to (size_block +7), 0 to size_block ) of std_logic_vector (9 downto 0); -- buffer

--type array_out_8bits is array ( 0 to (size_block - 1)) of std_logic_vector (7 downto 0); -- saida clipada

END types;
-----------------------------------------------------------------------------------------------------------------------

library IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;
USE work.types.all;

ENTITY interpolation IS
generic (bit_width: integer:=10); -- largura do bit
PORT ( 	
		 linha: in array_1d_Np8_10bits;
--		 clk, rst: in std_logic;
		-- out	
		 out_interpolation: out array_1d_3Np1_10bits	
 );
END interpolation;

ARCHITECTURE dataflow OF interpolation IS

-- declaracao de componente 
COMPONENT filter_4
GENERIC (bit_width: INTEGER); -- largura do bit
PORT ( e0, e1, e2, e3 : IN STD_LOGIC_VECTOR ( bit_width-1 DOWNTO 0); -- 10 bits
	    f1, f2, f3 : OUT STD_LOGIC_VECTOR (bit_width-1 DOWNTO 0) -- 10 bits
);
END COMPONENT;

-- sinais auxiliares
signal S_out: array_1d_3Np1_10bits;
signal out_f1, out_f3 : INTERPOLATION_OUT_10b;
signal out_f2 : INTERPOLATION_OUT_10b;

BEGIN

PUs: for i in 0 to (size_block) generate
 
U_F8: filter_4 	generic map (bit_width) 
						port map (	linha( size_block + 3-i),
										linha( size_block + 2-i),
										linha( size_block + 1-i),
										linha( size_block - i),
--										clk, rst,
										out_f1(i),out_f2(i),out_f3(i));
						end generate;

U_out: for i in 0 to (size_block) generate	

S_out(3*(i))   <= out_f1(i);
S_out(3*(i)+1) <= out_f2(i);
S_out(3*(i)+2) <= out_f3(i);
	
end generate;		

out_interpolation <= S_out;
			
END dataflow;
-------------------------------------------------------------------------------

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
USE work.types.all;

ENTITY mux_sel IS
port (	entrada_Ref: IN pixel_row; 			-- linha do bloco de referencia
			feedback_in: IN array_1d_Np8_10bits;-- entrada do mux que vem do buffer 10(N+8)
	 mux_in_or_buffer: IN std_logic; -- inp_source
	     in_or_buffer: OUT array_1d_Np8_10bits 	-- saida do mux 10(N+8)
);
END mux_sel;

ARCHITECTURE funcional OF mux_sel IS

BEGIN

	U_mux: for i in 0 to (size_block + N_TAPS-1) generate -- size_block = 4
	       with mux_in_or_buffer select -- seleciona a entrada dos filtros
	            in_or_buffer(i) <= "00" & entrada_Ref(i) when '0', 
								                 feedback_in(i) when '1', 
		                                     "0000000000" when others;
                                     end generate;

END funcional;
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE work.types.all;

ENTITY clip8 IS
generic (bit_width: integer:=10); -- largura do bit
port ( 
--		clk: in std_logic;
		in_clip: in std_logic_vector ( bit_width-1 downto 0); -- 10 bits
		out_clip: out std_logic_vector ( 7 downto 0)			 -- 8 bits
);
END clip8;

ARCHITECTURE funcional OF clip8 IS

BEGIN

out_clip <= "00000000" when (in_clip < 0  ) else
		      "11111111" when (in_clip >=255) else
		              in_clip ( 7 downto 0); -- 8 bits
		  
END funcional;
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.types.all;

-- Buffer 
ENTITY buffer_shift IS
PORT (
		  clk, rst, r, w: IN std_logic; -- r=read; w=write
		  address_linha: in std_logic_vector ( buffer_rowaddr_width-1 downto 0); -- N+8 linhas possiveis
		  linha_in: in array_1d_3Np1_10bits; -- buffer_linha

		  -- out buffer
		  coluna_out: out array_1d_Np8_10bits
);  
END buffer_shift;

ARCHITECTURE Behavioral OF buffer_shift IS

-- sinais auxiliares
SIGNAL buffer_signal: array_2d_Np8_3Np1_10bits; 
SIGNAL reg_out, out_reg: array_1d_Np8_10bits; 

BEGIN

-- register
Process(clk, rst)
begin
	if (rst = '1') then
		reg_out <= (others => (others =>'0'));
		 
	elsif (clk'event and clk = '1') then
		reg_out <= out_reg;
		
	end if;
end process;
-- end register


PROCESS (clk, rst, r, w)
	begin
		if (rst = '1') then
		
			buffer_signal <= (others => (others => (others =>'0')));
			
		elsif (clk'event and clk = '1') then	
			if (w = '1') then -- escrita
				for coluna in 0 to 3*(size_block+1)-1 loop -- 3*N+1 pixels
				
					 buffer_signal (conv_integer(address_linha),coluna) <= linha_in (coluna); -- recebe posicao [0]
					 
				end loop;
				
			elsif (r = '1') then -- leitura com deslocamento
				for i in 0 to size_block+N_TAPS-1 loop -- N+8 pixels
				
					out_reg(i) <= buffer_signal(i, size_block); 
					
				end loop;
				
				for coluna in size_block+1-1 downto 1 loop
					for row in 0 to size_block+N_TAPS-1 loop
				 
						 buffer_signal(row, coluna) <= buffer_signal(row, coluna-1); -- n-1
						 
					end loop;
				end loop;	
			else
				for coluna in size_block+1-1 downto 0 loop
					for row in 0 to size_block+N_TAPS-1 loop
					
						 buffer_signal(row, coluna) <= buffer_signal(row, coluna);
						 
					end loop;
				end loop;
			end if;
	end if;	
END PROCESS;

coluna_out <= reg_out;

END Behavioral;
-------------------------------------------------------------------------------

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.types.all;

ENTITY CRTL IS
GENERIC (bit_width: integer:=10);-- largura do bit
PORT (	
		 clk : in std_logic; 
		 rst : in std_logic;
		 inp_source: out std_logic; 	-- sinal mux da entrada
		 read_en, write_en: out std_logic -- sinal buffer
);
END CRTL;

ARCHITECTURE funcional OF CRTL IS


-- sinais para a maquina de estados
TYPE estados IS (RST_0, WRT, IDLE, READY); -- s0=rst ; s1=write ; s2=idle ; s3=ready
SIGNAL estado_atual, proximo_estado : estados;

SIGNAL cont_H, cont_V, cont_D: std_logic; -- habilita contagem

SIGNAL contagem_H : std_logic_vector(6 downto 0); -- max 72
SIGNAL contagem_V : std_logic_vector(6 downto 0); -- max 64
SIGNAL contagem_D : std_logic_vector(7 downto 0); -- max 195

BEGIN

-- Descricao das transicoes da maquina de estado
process(estado_atual, proximo_estado, contagem_H, contagem_V, contagem_D )
begin
  case estado_atual is
	 when RST_0 =>
			proximo_estado <= WRT;
		
	 when WRT =>
		if (contagem_H < horizontal-1) then
			proximo_estado <= WRT;
		else 
			proximo_estado <= IDLE;	
		end if;
	 
	 when IDLE =>
		if (contagem_V < vertical-1) then
			proximo_estado <= IDLE;
	   else
			proximo_estado <= READY;
	   end if;
				
	 when READY =>
		if (contagem_D < diagonal-1) then	 
			proximo_estado <= READY;	
		else
		    proximo_estado <= WRT;
	 	end if;
		
  end case;
end process;
	 
-- processo para mudanca de estados
process(rst, clk, estado_atual, proximo_estado)
begin
  if rst = '1' then
    estado_atual <= RST_0;

  elsif ( clk'event and clk = '1') then 
    estado_atual <= proximo_estado;
  end if;
end process;	 


-- geracao dos sinais de controle	 	 
with estado_atual select
   write_en <= '1' when WRT,
               '0' when others;	 
	 
with estado_atual select
   read_en <= '1' when READY,
              '0' when others;
              
with estado_atual select 
   inp_source  <= '1' when READY,
				  '0' when others;            	 

-- habilitacao de contagem_H
with estado_atual select
   cont_H <= '1' when WRT,
             '0' when others;
				  
-- habilitacao de contagem_V
with estado_atual select
   cont_V <= '1' when IDLE,
             '0' when others;
				  
-- habilitacao de contagem_D
with estado_atual select
   cont_D <= '1' when READY,
             '0' when others;				 
				 
						 
-- descricao do contador HORIZONTAL
process(clk, rst, cont_H)
begin
	if (rst = '1') then
		contagem_H <= (others => '0');
		
	elsif  clk'event and clk = '1' then
		if cont_H = '1' then
			contagem_H <= contagem_H + 1;		
		else
			contagem_H <= (others => '0');
		end if;
	end if;	
end process;

-- descricao do contador VERTICAL
process(clk, rst, cont_V)
begin
	if (rst = '1') then
		contagem_V <= (others => '0');
		
	elsif clk'event and clk = '1' then
		if cont_V = '1' then
			contagem_V <= contagem_V + 1;
		else
			contagem_V <= (others => '0');
		end if;
	end if;	
end process;

-- descricao do contador DIAGONAL
process(clk, rst, cont_D)
begin
	if (rst = '1') then
		contagem_D <= (others => '0');
		
	elsif clk'event and clk = '1' then
		if cont_D = '1' then
			contagem_D <= contagem_D + 1;
		else
			contagem_D <= (others => '0');
		end if;
	end if;	
end process; 
	 
end funcional;
-------------------------------------------------------------------------------

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;
USE work.types.all;

ENTITY FME_INTER_4 IS

GENERIC (bit_width: integer:=10);	-- largura do bit
PORT (	
			line_in: in pixel_row;	-- entrada de referencia
			address_linha1: in std_logic_vector ( buffer_rowaddr_width-1 downto 0);
			clk, rst: in std_logic;		
-- out
			out_clipping: out array_1d_3Np1_8bits

);
END FME_INTER_4;

ARCHITECTURE rtl OF FME_INTER_4 IS

-------------------- Componentes --------------------

-- mux entrada
COMPONENT mux_sel
port (	entrada_Ref: IN pixel_row; 			 -- linha do bloco de referencia
			feedback_in: IN array_1d_Np8_10bits; -- entrada do mux que vem do buffer 10(N+8)
	 mux_in_or_buffer: IN std_logic; 			 -- inp_source
	     in_or_buffer: OUT array_1d_Np8_10bits -- saida do mux 10(N+8)
);
END COMPONENT;

-- interpolacao
COMPONENT interpolation 
generic (bit_width: integer:=10);-- largura do bit
PORT ( 	
		linha: in array_1d_Np8_10bits;
--		clk, rst: in std_logic;
		-- out
		out_interpolation: out array_1d_3Np1_10bits -- out interpolation	
 );
END COMPONENT;

-- controle do buffer
COMPONENT CRTL
GENERIC (bit_width: integer:=10);-- largura do bit
PORT (	
		 clk : in std_logic; 
		 rst : in std_logic;
		 inp_source: out std_logic; 	-- sinal mux da entrada
		 read_en, write_en: out std_logic -- sinal buffer
);
END COMPONENT;

-- Buffer
COMPONENT buffer_shift
PORT (
		  clk, rst, r, w: IN std_logic;	-- r=read; w=write
		  address_linha: in std_logic_vector ( buffer_rowaddr_width-1 downto 0); -- N+8 linhas possiveis
		  linha_in: in array_1d_3Np1_10bits; -- buffer_linha

		  -- out buffer
		  coluna_out: out array_1d_Np8_10bits
);  
END COMPONENT;

-- clip (0-255)
COMPONENT clip8
generic (bit_width: integer); -- largura do bit
port ( 
--		clk: in std_logic;
		in_clip: in std_logic_vector ( bit_width-1 downto 0); -- 10 bits
		out_clip: out std_logic_vector ( 7 downto 0)			 -- 8 bits
);
END COMPONENT;

-- sinais auxiliares
SIGNAL reg_line_in : pixel_row;
SIGNAL in_or_buffer_1, out_buffer : array_1d_Np8_10bits;
SIGNAL out_pixel_sig, sig_out : array_1d_3Np1_10bits;
SIGNAL clip_out, reg_out_clip : array_1d_3Np1_8bits;
SIGNAL read_en1, write_en1, inp_source1: std_logic; -- sinal buffer

BEGIN

-- descricao dos registradores de entrada e saida
process ( clk, rst)
begin

	if rst = '1' then
		reg_line_in   <= (others => (others =>'0'));
		reg_out_clip  <= (others => (others =>'0'));
		
	elsif clk'event and clk = '1' then
		reg_line_in   <= line_in;
		reg_out_clip  <= clip_out;
		
	end if;
end process;

-- mapeamento MUX
	U_mux: mux_sel port map ( reg_line_in, out_buffer, inp_source1, in_or_buffer_1);

-- mapeamento INTERPOLACAO
	U_inter: interpolation port map ( in_or_buffer_1, sig_out);
																						 
-- mapeamento do controle do buffer
	U_crtl : CRTL port map ( clk, rst, inp_source1, read_en1, write_en1 );

-- mapeamento BUFFER
	U_buffer : buffer_shift port map ( clk, rst, read_en1, write_en1, address_linha1, sig_out, out_buffer );
												  
out_pixel_sig <= sig_out;

-- mapeamento clipping
	clipping: for i in 0 to (3*(size_block+1)-1) generate
		U_clip: clip8 generic map (bit_width) port map ( out_pixel_sig(i), clip_out(i) );																	
	end generate;

-- out
out_clipping <= reg_out_clip;

END rtl;
