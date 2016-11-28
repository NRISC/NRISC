//deMUX 16x1

/*************************************************************************
 *  descricao do bloco demux                              versao 0.00      *
 *                                                                       *
 *  Developer: Marlon 	                           27-11-2016            *
 *             marlonsigales@gmail.com                                   *
 *  Corrector: Mariano                             27-11-2016            *
 *             Jean Carlos Scheunemann             27-11-2016            *
 *             jeancarsch@gmail.com                                      *
 *                                                                       *
 * deMUX 16x1                                                     *
 *                                                                       *
 *************************************************************************/ 

 
`timescale 1 ns / 1 ns
 
module NRISC_ULA(

					deMUX_out0,    // demux output out0 
					deMUX_out1,    // demux output out1
					deMUX_out2,    // demux output out2
					deMUX_out3,    // demux output out3
					deMUX_out4,    // demux output out4
					deMUX_out5,    // demux output out5
					deMUX_out6,    // demux output out6
					deMUX_out7,    // demux output out7
					deMUX_out8,    // demux output out8
					deMUX_out9,    // demux output out9
					deMUX_out10,   // demux output out10
					deMUX_out11,   // demux output out11
					deMUX_out12,   // demux output out12
					deMUX_out13,   // demux output out13
					deMUX_out14,   // demux output out14
					deMUX_out15,   // demux output out15
					
					deMUX_in,    // demux output
					deMUX_sel    //  demux input sel
					
					       
					);

					
					
						
	//Parameter numero de bits	
	parameter TAM = 16;
	//-------------portas de saida------------------------------------------------------------------
	output wire [TAM-1:0] deMUX_out0;    // demux output out0 
	output wire [TAM-1:0] deMUX_out1;    // demux output out1
	output wire [TAM-1:0] deMUX_out2;    // demux output out2
	output wire [TAM-1:0] deMUX_out3;    // demux output out3
	output wire [TAM-1:0] deMUX_out4;    // demux output out4
	output wire [TAM-1:0] deMUX_out5;    // demux output out5
	output wire [TAM-1:0] deMUX_out6;    // demux output out6
	output wire [TAM-1:0] deMUX_out7;    // demux output out7
	output wire [TAM-1:0] deMUX_out8;    // demux output out8
	output wire [TAM-1:0] deMUX_out9;    // demux output out9
	output wire [TAM-1:0] deMUX_out10;   // demux output out10
	output wire [TAM-1:0] deMUX_out11;   // demux output out11
	output wire [TAM-1:0] deMUX_out12;   // demux output out12
	output wire [TAM-1:0] deMUX_out13;   // demux output out13
	output wire [TAM-1:0] deMUX_out14;   // demux output out14
	output wire [TAM-1:0] deMUX_out15;   // demux output out15
					
	
	
	//-------------portas de saida--------------------------------------------------------------------
	input wire [TAM-1:0] deMUX_in;    // demux output
	input wire [3:0] deMUX_sel;    // demux output sel
	//-------------fios-registradores-----------------------------------------------------------------
	  
    wire s0;//seleções
	wire s1;
	wire s2;
	wire s3;
	wire [TAM-1:0] hz;
	
	assign hz = {TAM{1'bz}};
	assign {s3,s2,s1,s0}= deMUX_sel;
	
	
	
	
	
	assign deMUX_out0  = (~(s3)&~(s2)&~(s1)&~(s0))? deMUX_in : hz ; //pois acho que o mux quando são selecionado deve conter alta impedância
	assign deMUX_out1  = (~(s3)&~(s2)&~(s1)&s0   )? deMUX_in : hz ;
	assign deMUX_out2  = (~(s3)&~(s2)&s1&~(s0)   )? deMUX_in : hz ;
	assign deMUX_out3  = (~(s3)&~(s2)&s1&s0      )? deMUX_in : hz ;
	assign deMUX_out4  = (~(s3)&s2&~(s1)&~(s0)   )? deMUX_in : hz ;
	assign deMUX_out5  = (~(s3)&s2&~(s1)&s0      )? deMUX_in : hz ;
	assign deMUX_out6  = (~(s3)&s2&s1&~(s0)      )? deMUX_in : hz ;
	assign deMUX_out7  = (~(s3)&s2&s1&s0         )? deMUX_in : hz ;
	assign deMUX_out8  = (s3&~(s2)&~(s1)&~(s0)   )? deMUX_in : hz ;
	assign deMUX_out9  = (s3&~(s2)&~(s1)&s0      )? deMUX_in : hz ;
	assign deMUX_out10 = (s3&~(s2)&s1&~(s0)      )? deMUX_in : hz ;
	assign deMUX_out11 = (s3&~(s2)&s1&s0         )? deMUX_in : hz ;
	assign deMUX_out12 = (s3&s2&~(s1)&~(s0)      )? deMUX_in : hz ;
	assign deMUX_out13 = (s3&s2&~(s1)&s0         )? deMUX_in : hz ;
	assign deMUX_out14 = (s3&s2&s1&~(s0)         )? deMUX_in : hz ;
	assign deMUX_out15 = (s3&s2&s1&s0            )? deMUX_in : hz ;
endmodule
