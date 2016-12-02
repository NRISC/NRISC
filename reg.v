//registradores

/*************************************************************************
 *  descricao do bloco reg                              versao 0.10      *
 *                                                                       *
 *  Developer: Marlon 	                           31-11-2016            *
 *             marlonsigales@gmail.com                                   *
 *  Corrector: Mariano                             27-11-2016            *
 *             Jean Carlos Scheunemann             27-11-2016            *
 *             jeancarsch@gmail.com                                      *
 *                                                                       *
 * 16registradores                                                       *
 *                                                                       *
 *************************************************************************/ 

 
`timescale 1 ns / 1 ns
 
module registradores(

					reg_in,
					selecaoin,

					OUTA,
					selecaooutA,
					
					OUTB,
					selecaooutB,
					
					clk,
					rst);  //ativo alto
					       
					

					
					
						
	//Parameter numero de bits	
	parameter TAM = 16;
	//-------------portas de entrada e saida-----------demux entra e mux sai-------------------------------------------------------
	input wire	[TAM-1:0] reg_in;
	input wire	[3:0] selecaoin;
	
	input wire	[3:0] selecaooutA;
	output wire  [TAM-1:0] OUTA;
					       
	input wire	[3:0] selecaooutB;
	output wire  [TAM-1:0] OUTB;
					
	input wire	clk;
	input wire 	rst;
	
	
	
	//-------------fios-registradores-----------------------------------------------------------------
	reg	[TAM-1:0] reg_0;    // saída dos registradores 0 
	reg	[TAM-1:0] reg_1;    // saída dos registradores 1
	reg	[TAM-1:0] reg_2;    // saída dos registradores 2
	reg	[TAM-1:0] reg_3;    // saída dos registradores 3
	reg	[TAM-1:0] reg_4;    // saída dos registradores 4
	reg	[TAM-1:0] reg_5;    // saída dos registradores 5
	reg	[TAM-1:0] reg_6;    // saída dos registradores 6
	reg	[TAM-1:0] reg_7;    // saída dos registradores 7
	reg	[TAM-1:0] reg_8;    // saída dos registradores 8
	reg	[TAM-1:0] reg_9;    // saída dos registradores 9
	reg	[TAM-1:0] reg_10;   // saída dos registradores 10
	reg	[TAM-1:0] reg_11;   // saída dos registradores 11
	reg	[TAM-1:0] reg_12;   // saída dos registradores 12
	reg	[TAM-1:0] reg_13;   // saída dos registradores 13
	reg	[TAM-1:0] reg_14;   // saída dos registradores 14
	reg	[TAM-1:0] reg_15;   // saída dos registradores 15
	
	wire [TAM-1:0] in0  ;
	wire [TAM-1:0] in1  ;
	wire [TAM-1:0] in2  ;
	wire [TAM-1:0] in3  ;
	wire [TAM-1:0] in4  ;
	wire [TAM-1:0] in5  ;
	wire [TAM-1:0] in6  ;
	wire [TAM-1:0] in7  ;
	wire [TAM-1:0] in8  ;
	wire [TAM-1:0] in9  ;
	wire [TAM-1:0] in10 ;
	wire [TAM-1:0] in11 ;
	wire [TAM-1:0] in12 ;
	wire [TAM-1:0] in13 ;
	wire [TAM-1:0] in14 ;
	wire [TAM-1:0] in15 ;
	
	
	wire s03;
	wire s02;
	wire s01;
	wire s00;
	
	wire s13;
	wire s12;
	wire s11;
	wire s10;
	
	wire s23;
	wire s22;
	wire s21;
	wire s20;
	
	assign {s03,s02,s01,s00}=selecaoin;
	assign {s13,s12,s11,s10}=selecaooutA;
	assign {s23,s22,s21,s20}=selecaooutB;

//demutiplexação da entrada	                             se enable entrar colocar ele nas ands aqui 
	assign in0  = (~(s03)&~(s02)&~(s01)&~(s00))? reg_in : in0  ; 
	assign in1  = (~(s03)&~(s02)&~(s01)&s00   )? reg_in : in1  ;
	assign in2  = (~(s03)&~(s02)&s01&~(s00)   )? reg_in : in2  ;
	assign in3  = (~(s03)&~(s02)&s01&s00      )? reg_in : in3  ;
	assign in4  = (~(s03)&s02&~(s01)&~(s00)   )? reg_in : in4  ;
	assign in5  = (~(s03)&s02&~(s01)&s00      )? reg_in : in5  ;
	assign in6  = (~(s03)&s02&s01&~(s00)      )? reg_in : in6  ;
	assign in7  = (~(s03)&s02&s01&s00         )? reg_in : in7  ;
	assign in8  = (s03&~(s02)&~(s01)&~(s00)   )? reg_in : in8  ;
	assign in9  = (s03&~(s02)&~(s01)&s00      )? reg_in : in9  ;
	assign in10 = (s03&~(s02)&s01&~(s00)      )? reg_in : in10 ;
	assign in11 = (s03&~(s02)&s01&s00         )? reg_in : in11 ;
	assign in12 = (s03&s02&~(s01)&~(s00)      )? reg_in : in12 ;
	assign in13 = (s03&s02&~(s01)&s00         )? reg_in : in13 ;
	assign in14 = (s03&s02&s01&~(s00)         )? reg_in : in14 ;
	assign in15 = (s03&s02&s01&s00            )? reg_in : in15 ;
	
//mutiplexação das saídas	
		assign OUTA   = (~(s13)&~(s12)&~(s11)&~(s10))& reg_0  |
					    (~(s13)&~(s12)&~(s11)&s10   )& reg_1  |
					    (~(s13)&~(s12)&s11&~(s10)   )& reg_2  |
					    (~(s13)&~(s12)&s11&s10      )& reg_3  |
					    (~(s13)&s12&~(s11)&~(s10)   )& reg_4  |
					    (~(s13)&s12&~(s11)&s10      )& reg_5  |
					    (~(s13)&s12&s11&~(s10)      )& reg_6  |
					    (~(s13)&s12&s11&s10         )& reg_7  |
					    (s13&~(s12)&~(s11)&~(s10)   )& reg_8  |
					    (s13&~(s12)&~(s11)&s10      )& reg_9  |
					    (s13&~(s12)&s11&~(s10)      )& reg_10 |
					    (s13&~(s12)&s11&s10         )& reg_11 |
					    (s13&s12&~(s11)&~(s10)      )& reg_12 |
					    (s13&s12&~(s11)&s10         )& reg_13 |
					    (s13&s12&s11&~(s10)         )& reg_14 |
					    (s13&s12&s11&s10            )& reg_15 ;
					   
		assign OUTB   = (~(s23)&~(s22)&~(s21)&~(s20))& reg_0  |
					    (~(s23)&~(s22)&~(s21)&s20   )& reg_1  |
					    (~(s23)&~(s22)&s21&~(s20)   )& reg_2  |
					    (~(s23)&~(s22)&s21&s20      )& reg_3  |
					    (~(s23)&s22&~(s21)&~(s20)   )& reg_4  |
					    (~(s23)&s22&~(s21)&s20      )& reg_5  |
					    (~(s23)&s22&s21&~(s20)      )& reg_6  |
					    (~(s23)&s22&s21&s20         )& reg_7  |
					    (s23&~(s22)&~(s21)&~(s20)   )& reg_8  |
					    (s23&~(s22)&~(s21)&s20      )& reg_9  |
					    (s23&~(s22)&s21&~(s20)      )& reg_10 |
					    (s23&~(s22)&s21&s20         )& reg_11 |
					    (s23&s22&~(s21)&~(s20)      )& reg_12 |
					    (s23&s22&~(s21)&s20         )& reg_13 |
					    (s23&s22&s21&~(s20)         )& reg_14 |
					    (s23&s22&s21&s20            )& reg_15 ;				   
	

//------------ atualização dos registros ------------	
	always @(posedge clk) begin: registro	
	  reg_0  = rst? 16'b0 :  in0  ;
    reg_1  = rst? 16'b0 :  in1  ;
    reg_2  = rst? 16'b0 :  in2  ;
    reg_3  = rst? 16'b0 :  in3  ;
	  reg_4  = rst? 16'b0 :  in4  ;
    reg_5  = rst? 16'b0 :  in5  ;
    reg_6  = rst? 16'b0 :  in6  ;
    reg_7  = rst? 16'b0 :  in7  ;
    reg_8  = rst? 16'b0 :  in8  ;
    reg_9  = rst? 16'b0 :  in9  ;
    reg_10 = rst? 16'b0 :  in10 ;
    reg_11 = rst? 16'b0 :  in11 ;
    reg_12 = rst? 16'b0 :  in12 ;
    reg_13 = rst? 16'b0 :  in13 ;
    reg_14 = rst? 16'b0 :  in14 ;
    reg_15 = rst? 16'b0 :  in15 ;
	end	
	
endmodule		



