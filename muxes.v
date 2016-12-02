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
 * MUX 4x1, MUX 2x1,                                                     *
 *OR para a selecao do complemento de 2(B), INCDEC selecao(A)            *
 *                                                                       *
 *************************************************************************/ 

 
`timescale 1 ns / 1 ns
 

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


module incdec(

					REG_OUT_B,    // mux input in0 
					incdec,       // controle de complemento de 2 
						
					
					B_ULA,    // mux output
						
					       
					);

						
	//Parameter numero de bits	
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] REG_OUT_B;    // mux input in0 
	input wire incdec;    // mux input in1
					
	
	
	//-------------portas de saida--------------------------------------------------------------------
	output wire [TAM-1:0] B_ULA;    // mux output
	
	wire [TAM-1:1]A; 
	wire B;
	
	assign {A,B}= REG_OUT_B;
	
	assign B_ULA   = {(A & ~(incdec)), (B | incdec)} ; //se cmp2 setado, entrada da ula é -1 daí faz notA -(-1) 
	
	
endmodule  
