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

-------------------------------------------------------------------------------------------------------------------------------
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