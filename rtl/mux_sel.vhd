LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;

PACKAGE types IS

CONSTANT size_block: INTEGER:= 4; 	-- tamanho do bloco
CONSTANT N_TAPS: INTEGER:= 8; 		-- numero de taps

CONSTANT horizontal: INTEGER:= (size_block + N_TAPS);
CONSTANT vertical: INTEGER:= size_block;
CONSTANT diagonal: INTEGER:= (3*(size_block+1));

function f_log2   (x: positive) return natural;

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

END types;

package body types is

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

end package body types;
-------------------------------------------------------------------------------------------------------------------------------------------------------

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

	U_mux: for i in 0 to (size_block + 7) generate -- size_block = 4
	       with mux_in_or_buffer select -- seleciona a entrada dos filtros
	            in_or_buffer(i) <= "00" & entrada_Ref(i) when '0', 
								                 feedback_in(i) when '1', 
		                                     "0000000000" when others;
                                     end generate;

END funcional;