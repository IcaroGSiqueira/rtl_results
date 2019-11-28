LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
--USE work.types.all;

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