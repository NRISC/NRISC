//MUX 16x1

/*************************************************************************
 *  descricao do bloco mux                              versao 0.00      *
 *                                                                       *
 *  Developer: Marlon 	                           27-11-2016            *
 *             marlonsigales@gmail.com                                   *
 *  Corrector: Mariano                             27-11-2016            *
 *             Jean Carlos Scheunemann             27-11-2016            *
 *             jeancarsch@gmail.com                                      *
 *                                                                       *
 * MUX 16x1                                                     *
 *                                                                       *
 *************************************************************************/ 

 
`timescale 1 ns / 1 ns
 
module NRISC_ULA(

					MUX_in0,    // mux input in0 
					MUX_in1,    // mux input in1
					MUX_in2,    // mux input in2
					MUX_in3,    // mux input in3
					MUX_in4,    // mux input in4
					MUX_in5,    // mux input in5
					MUX_in6,    // mux input in6
					MUX_in7,    // mux input in7
					MUX_in8,    // mux input in8
					MUX_in9,    // mux input in9
					MUX_in10,   // mux input in10
					MUX_in11,   // mux input in11
					MUX_in12,   // mux input in12
					MUX_in13,   // mux input in13
					MUX_in14,   // mux input in14
					MUX_in15,   // mux input in15
					
					MUX_Out,    // mux output
					MUX_sel    // mux input sel
					
					       
					);

					
					
						
	//Parameter numero de bits	
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] MUX_in0;    // mux input in0 
	input wire [TAM-1:0] MUX_in1;    // mux input in1
	input wire [TAM-1:0] MUX_in2;    // mux input in2
	input wire [TAM-1:0] MUX_in3;    // mux input in3
	input wire [TAM-1:0] MUX_in4;    // mux input in4
	input wire [TAM-1:0] MUX_in5;    // mux input in5
	input wire [TAM-1:0] MUX_in6;    // mux input in6
	input wire [TAM-1:0] MUX_in7;    // mux input in7
	input wire [TAM-1:0] MUX_in8;    // mux input in8
	input wire [TAM-1:0] MUX_in9;    // mux input in9
	input wire [TAM-1:0] MUX_in10;   // mux input in10
	input wire [TAM-1:0] MUX_in11;   // mux input in11
	input wire [TAM-1:0] MUX_in12;   // mux input in12
	input wire [TAM-1:0] MUX_in13;   // mux input in13
	input wire [TAM-1:0] MUX_in14;   // mux input in14
	input wire [TAM-1:0] MUX_in15;   // mux input in15
					
	
	input wire [3:0] MUX_sel;    // mux input sel
	//-------------portas de saida--------------------------------------------------------------------
	output wire [TAM-1:0] MUX_Out;    // mux output
	
	//-------------fios-registradores-----------------------------------------------------------------
	wire [TAM-1:0] a0;//primeiro nível de auxilhares
	wire [TAM-1:0] b0;
	wire [TAM-1:0] c0;
	wire [TAM-1:0] d0;
	wire [TAM-1:0] e0;
	wire [TAM-1:0] f0;
	wire [TAM-1:0] g0;
	wire [TAM-1:0] h0;
	wire [TAM-1:0] a1;//segundo nível
	wire [TAM-1:0] b1;
	wire [TAM-1:0] c1;
	wire [TAM-1:0] d1;
	wire [TAM-1:0] a2;//terceiro nível
	wire [TAM-1:0] b2;
  
  wire s0;//seleções
	wire s1;
	wire s2;
	wire s3;
	
	assign {s3,s2,s1,s0}= MUX_sel;
	
	assign MUX_Out= s3? b2:a2;
	
	assign a2= s2? b1:a1;
	assign b2= s2? d1:c1;
	
	assign a1= s1? b0:a0;
	assign b1= s1? d0:c0;
	assign c1= s1? f0:e0;
	assign d1= s1? h0:g0;
	
	assign a0= s0? MUX_in1 : MUX_in0;
	assign b0= s0? MUX_in3 : MUX_in2;
	assign c0= s0? MUX_in5 : MUX_in4;
	assign d0= s0? MUX_in7 : MUX_in6;
	assign e0= s0? MUX_in9 : MUX_in8;
	assign f0= s0? MUX_in11 : MUX_in10;
	assign g0= s0? MUX_in13 : MUX_in12;
	assign h0= s0? MUX_in15 : MUX_in14;
	
	
endmodule





               
