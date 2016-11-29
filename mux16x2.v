//MUX 

/*************************************************************************
 *  descricao do bloco mux                              versao 0.01      *
 *                                                                       *
 *  Developer: Marlon 	                           29-11-2016            *
 *             marlonsigales@gmail.com                                   *
 *  Corrector: Mariano                             28-11-2016            *
 *             Jean Carlos Scheunemann             27-11-2016            *
 *             jeancarsch@gmail.com                                      *
 *                                                                       *
 * MUX 16x1; MUX 8x1, MUX 4x1, MUX 2x1,                                  *
 *OR para a selecao do complemento de 2(B), INCDEC DELEÇÃO(A)            *
 *                                                                       *
 *************************************************************************/ 

 
`timescale 1 ns / 1 ns
 
module mux16x1(

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
	 wire s0;//seleções
	wire s1;
	wire s2;
	wire s3;
	
	assign {s3,s2,s1,s0}= MUX_sel;
	
	
	//wire [TAM-1:0] a0;//primeiro nível de auxilhares
	//wire [TAM-1:0] b0;
	//wire [TAM-1:0] c0;
	//wire [TAM-1:0] d0;
	//wire [TAM-1:0] e0;
	//wire [TAM-1:0] f0;
	//wire [TAM-1:0] g0;
	//wire [TAM-1:0] h0;
	//wire [TAM-1:0] a1;//segundo nível
	//wire [TAM-1:0] b1;
	//wire [TAM-1:0] c1;
	//wire [TAM-1:0] d1;
	//wire [TAM-1:0] a2;//terceiro nível
	//wire [TAM-1:0] b2;
  
   
	
	//assign MUX_Out= s3? b2:a2;
	
	//assign a2= s2? b1:a1;
	//assign b2= s2? d1:c1;
	//
	//assign a1= s1? b0:a0;
	//assign b1= s1? d0:c0;
	//assign c1= s1? f0:e0;
	//assign d1= s1? h0:g0;
	//
	//assign a0= s0? MUX_in1 : MUX_in0;
	//assign b0= s0? MUX_in3 : MUX_in2;
	//assign c0= s0? MUX_in5 : MUX_in4;
	//assign d0= s0? MUX_in7 : MUX_in6;
	//assign e0= s0? MUX_in9 : MUX_in8;
	//assign f0= s0? MUX_in11 : MUX_in10;
	//assign g0= s0? MUX_in13 : MUX_in12;
	//assign h0= s0? MUX_in15 : MUX_in14;
	
	assign MUX_out   = (~(s3)&~(s2)&~(s1)&~(s0))& MUX_in0 |
					   (~(s3)&~(s2)&~(s1)&s0   )& MUX_in1 |
					   (~(s3)&~(s2)&s1&~(s0)   )& MUX_in2 |
					   (~(s3)&~(s2)&s1&s0      )& MUX_in3 |
					   (~(s3)&s2&~(s1)&~(s0)   )& MUX_in4 |
					   (~(s3)&s2&~(s1)&s0      )& MUX_in5 |
					   (~(s3)&s2&s1&~(s0)      )& MUX_in6 |
					   (~(s3)&s2&s1&s0         )& MUX_in7 |
					   (s3&~(s2)&~(s1)&~(s0)   )& MUX_in8 |
					   (s3&~(s2)&~(s1)&s0      )& MUX_in9 |
					   (s3&~(s2)&s1&~(s0)      )& MUX_in10 |
					   (s3&~(s2)&s1&s0         )& MUX_in11 |
					   (s3&s2&~(s1)&~(s0)      )& MUX_in12 |
					   (s3&s2&~(s1)&s0         )& MUX_in13 |
					   (s3&s2&s1&~(s0)         )& MUX_in14 |
					   (s3&s2&s1&s0            )& MUX_in15 ;
	
	
endmodule



module mux8x1(

					MUX_in0,    // mux input in0 
					MUX_in1,    // mux input in1
					MUX_in2,    // mux input in2
					MUX_in3,    // mux input in3
					MUX_in4,    // mux input in4
					MUX_in5,    // mux input in5
					MUX_in6,    // mux input in6
					MUX_in7,    // mux input in7
						
					
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
					
	
	input wire [3:0] MUX_sel;    // mux input sel
	
	//-------------portas de saida--------------------------------------------------------------------
	output wire [TAM-1:0] MUX_Out;    // mux output
	
	wire s0;//seleções
	wire s1;
	wire s2;
	
	
	assign {s2,s1,s0}= MUX_sel;
	
	output wire [TAM-1:0] MUX_Out;    // mux output
	assign MUX_out   = (~(s2)&~(s1)&~(s0))& MUX_in0 | 
					   (~(s2)&~(s1)&s0   )& MUX_in1 |
					   (~(s2)&s1&~(s0)   )& MUX_in2 |
					   (~(s2)&s1&s0      )& MUX_in3 |
					   (s2&~(s1)&~(s0)   )& MUX_in4 |
					   (s2&~(s1)&s0      )& MUX_in5 |
					   (s2&s1&~(s0)      )& MUX_in6 |
					   (s2&s1&s0         )& MUX_in7 ;
	
	
endmodule      

module mux4x1(

					MUX_in0,    // mux input in0 
					MUX_in1,    // mux input in1
					MUX_in2,    // mux input in2
					MUX_in3,    // mux input in3
						
					
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
					
	
	input wire [3:0] MUX_sel;    // mux input sel
	//-------------portas de saida--------------------------------------------------------------------
	output wire [TAM-1:0] MUX_Out;    // mux output
	
	wire s0;//seleções
	wire s1;
		
	
	assign {s1,s0}= MUX_sel;
	
	output wire [TAM-1:0] MUX_Out;    // mux output
	assign MUX_out   = (~(s1)&~(s0))& MUX_in0 | 
					   (~(s1)&s0   )& MUX_in1 |
					   (s1&~(s0)   )& MUX_in2 |
					   (s1&s0      )& MUX_in3 ;
	
	
endmodule           



module mux2x1(

					MUX_in0,    // mux input in0 
					MUX_in1,    // mux input in1
						
					
					MUX_Out,    // mux output
					MUX_sel    // mux input sel
					
					       
					);

					
					
						
	//Parameter numero de bits	
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] MUX_in0;    // mux input in0 
	input wire [TAM-1:0] MUX_in1;    // mux input in1
					
	
	input wire [3:0] MUX_sel;    // mux input sel
	//-------------portas de saida--------------------------------------------------------------------
	output wire [TAM-1:0] MUX_Out;    // mux output
	
	wire s0;//seleções
		
	
	assign s0= MUX_sel;
	
	output wire [TAM-1:0] MUX_Out;    // mux output
	assign MUX_out   = (~(s0))& MUX_in0 | 
					   (s0   )& MUX_in1 ;
	
	
endmodule           


module or_cmp2(

					REG_OUT_A,    // mux input in0 
					cmp2,       // controle de complemento de 2 
						
					
					A_ULA,    // mux output
						
					       
					);

						
	//Parameter numero de bits	
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] REG_OUT_A;    // mux input in0 
	input wire cmp2;    // mux input in1
					
	
	
	//-------------portas de saida--------------------------------------------------------------------
	output wire [TAM-1:0] A_ULA;    // mux output
	
	assign A_ULA   = REG_OUT_A | {TAM{cmp2}}; //se cmp2 setado, entrada da ula é -1 daí faz notA -(-1) 
	
	
endmodule  


module or_cmp2(

					REG_OUT_B,    // mux input in0 
					incdec,       // controle de complemento de 2 
						
					
					B_ULA,    // mux output
						
					       
					);

						
	//Parameter numero de bits	
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] MUX_in0;    // mux input in0 
	input wire incdec;    // mux input in1
					
	
	
	//-------------portas de saida--------------------------------------------------------------------
	output wire [TAM-1:0] B_ULA;    // mux output
	wire [TAM-1:1]A; 
	wire B;
	
	assign {A,B}= MUX_in0;
	
	assign B_ULA   = {(A & ~(incdec)), (B | incdec)} ; //se cmp2 setado, entrada da ula é -1 daí faz notA -(-1) 
	
	
endmodule  
