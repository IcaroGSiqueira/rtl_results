`timescale 1 ns / 1 ps  // velocidade de simulacao

module banch;

// Defining parameters size 
  parameter integer size_block = 16; // tamanho do bloco
  parameter integer Nu_TAPS = 4;     // numero de taps

  parameter integer IN = 10;      // largura de bit entrada
  parameter integer OUT = 10;     // largura de bit saida
  parameter integer HALF_N = 64;  // largura de bit para sintese, esse valor eh o valor maximo que o incisive aceita, deixo constante para todas simulacoes
  parameter integer LENGTH = 400; // numero de amostras da simulacao

  localparam integer PERIOD = 10000;  //periodo da sintese

// Signal declarations
// inputs to the DUT    // descriptions:
wire [IN-1:0] input_A1 [size_block + Nu_TAPS - 1 :0];
wire in_rst; // reset
reg clk;
reg [1:0] a;
reg [HALF_N-1:0] K;
reg [HALF_N-1:0] cont;  //variaveis da test


// outputs to the DUT   // descriptions:
wire [OUT-1:0] out_S1 [size_block+1 *2 :0][2:0];


// Device Under Test instantiation
	//rom_read   memory1  ( input_A1[0], in_rst); 	// chamando memoria la de baixo, essa memoria vai chamar seus arquivos das entradas
	rom_read    #(IN,HALF_N)  memory1  (K, input_A1[0], in_rst); //chamando memoria la de baixo	
	INTER_4 DUT ( input_A1[0], clk, in_rst, out_S1[0][0]); 	// o Modulo principal do circuito

// clock generation
initial begin // inicial o test
  clk = 1'b0;
  a=2'b0;
end

always begin
#(PERIOD/2) clk = ~clk;
end

// ------------------------  Apply stimulus  ------------------------------------------------------
initial 
 begin

	$dumpfile ("filtros4.vcd"); //create a specific VCD filename, used for switching activity (criar o arquivo VCD que vc vai usar na segunda sintese)
        $dumpvars(1,banch.DUT);

	@(posedge clk)
    		for (K=0; K <= LENGTH; K=K+1) // numeros de linhas no arquivo
		begin 
			
      	@(posedge clk);	// wait for some clocks 

		end
$finish; 
end   // --------------------end stimulus -------------------------------------------------------


endmodule


module rom_read (K, in_rst, input_A1) ; // modulo da memoria, ele vai chamar as entradas

  parameter integer TAM = 10; 
  parameter integer IN = 10;
  parameter integer OUT = 10;   
  parameter integer HALF_N = 64; 
  parameter integer index = 400; 

  input [HALF_N-1:0] K; // Index number of the memory, select k position of memory

  output reg in_rst;
  output reg [IN-1:0] input_A1;

  reg [TAM-1:0]  a0_rom  [0:index-1]; // reset
  reg [TAM-1:0]  a1_rom  [0:index-1];

initial 
 begin   // Sinais da entrada que vc vai usar para sintese, tem que colocar o enderec?o certinho que onde estao os arquivos txt, lembrando que os valores tem que estar em binario e cada linha deve ter somente uma entrada

 $readmemb ("/home/mgsilva/rafael_s/example/sbox_v1/rtl/reset.txt", a0_rom);  // reset
 $readmemb ("/home/mgsilva/rafael_s/example/sbox_v1/rtl/4tap_n16.txt" , a1_rom);   //  read file with ROMs values, is synthesizable

end

always @( K ) 
  begin

  in_rst = a0_rom[K] ;

input_A1 = a1_rom[K] ;

 end  
endmodule // --------------ROM--------------
