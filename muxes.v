//MUX 

/*************************************************************************
 *  descricao do bloco mux                              versao 0.01      *
 *                                                                       *
 *  Developer: Marlon 	                           01-12-2016            *
 *             marlonsigales@gmail.com                                   *
 *  Corrector: Mariano                             28-11-2016            *
 *             Jean Carlos Scheunemann             27-11-2016            *
 *             jeancarsch@gmail.com                                      *
 *                                                                       *
 * MUX 4x1, MUX 2x1,                                                     *
 *                                                                       *
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
