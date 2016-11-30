//registradores

/*************************************************************************
 *  descricao do bloco reg                              versao 0.00      *
 *                                                                       *
 *  Developer: Marlon 	                           30-11-2016            *
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
					
					clk,
					rst;  //ativo alto
					       
					);

					
					
						
	//Parameter numero de bits	
	parameter TAM = 16;
	//-------------portas de entrada e saida-----------demux entra e mux sai-------------------------------------------------------
	input wire [TAM-1:0] deMUX_out0;    // demux output out0 
	input wire [TAM-1:0] deMUX_out1;    // demux output out1
	input wire [TAM-1:0] deMUX_out2;    // demux output out2
	input wire [TAM-1:0] deMUX_out3;    // demux output out3
	input wire [TAM-1:0] deMUX_out4;    // demux output out4
	input wire [TAM-1:0] deMUX_out5;    // demux output out5
	input wire [TAM-1:0] deMUX_out6;    // demux output out6
	input wire [TAM-1:0] deMUX_out7;    // demux output out7
	input wire [TAM-1:0] deMUX_out8;    // demux output out8
	input wire [TAM-1:0] deMUX_out9;    // demux output out9
	input wire [TAM-1:0] deMUX_out10;   // demux output out10
	input wire [TAM-1:0] deMUX_out11;   // demux output out11
	input wire [TAM-1:0] deMUX_out12;   // demux output out12
	input wire [TAM-1:0] deMUX_out13;   // demux output out13
	input wire [TAM-1:0] deMUX_out14;   // demux output out14
	input wire [TAM-1:0] deMUX_out15;   // demux output out15
	
	output reg [TAM-1:0] MUX_in0;    // mux input in0 
	output reg [TAM-1:0] MUX_in1;    // mux input in1
	output reg [TAM-1:0] MUX_in2;    // mux input in2
	output reg [TAM-1:0] MUX_in3;    // mux input in3
	output reg [TAM-1:0] MUX_in4;    // mux input in4
	output reg [TAM-1:0] MUX_in5;    // mux input in5
	output reg [TAM-1:0] MUX_in6;    // mux input in6
	output reg [TAM-1:0] MUX_in7;    // mux input in7
	output reg [TAM-1:0] MUX_in8;    // mux input in8
	output reg [TAM-1:0] MUX_in9;    // mux input in9
	output reg [TAM-1:0] MUX_in10;   // mux input in10
	output reg [TAM-1:0] MUX_in11;   // mux input in11
	output reg [TAM-1:0] MUX_in12;   // mux input in12
	output reg [TAM-1:0] MUX_in13;   // mux input in13
	output reg [TAM-1:0] MUX_in14;   // mux input in14
	output reg [TAM-1:0] MUX_in15;   // mux input in15
					
	
	
	//-------------portas de saida--------------------------------------------------------------------
	
	//-------------fios-registradores-----------------------------------------------------------------
	  
    input wire clk;//seleções
	input wire rst;
	
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
	
	
	
	wire hz;
	assign hz = {TAM{1'bz}};
	
	
	assign in0  = (deMUX_out0== hz)? MUX_in0  : deMUX_out0 ; 
	assign in1  = (deMUX_out1== hz)? MUX_in1  : deMUX_out1 ;
	assign in2  = (deMUX_out2== hz)? MUX_in2  : deMUX_out2 ;
	assign in3  = (deMUX_out3== hz)? MUX_in3  : deMUX_out3 ;
	assign in4  = (deMUX_out4== hz)? MUX_in4  : deMUX_out4 ;
	assign in5  = (deMUX_out5== hz)? MUX_in5  : deMUX_out5 ;
	assign in6  = (deMUX_out6== hz)? MUX_in6  : deMUX_out6 ;
	assign in7  = (deMUX_out7== hz)? MUX_in7  : deMUX_out7 ;
	assign in8  = (deMUX_out8== hz)? MUX_in8  : deMUX_out8 ;
	assign in9  = (deMUX_out9== hz)? MUX_in9  : deMUX_out9 ;
	assign in10 = (deMUX_out10==hz)? MUX_in10 : deMUX_out10 ;
	assign in11 = (deMUX_out11==hz)? MUX_in11 : deMUX_out11 ;
	assign in12 = (deMUX_out12==hz)? MUX_in12 : deMUX_out12 ;
	assign in13 = (deMUX_out13==hz)? MUX_in13 : deMUX_out13 ;
	assign in14 = (deMUX_out14==hz)? MUX_in14 : deMUX_out14 ;
	assign in15 = (deMUX_out15==hz)? MUX_in15 : deMUX_out15 ;
	
	
	
always @(posedge clk) begin:	
	MUX_in0  = rst? 16'b0 :  in0  ;
    MUX_in1  = rst? 16'b0 :  in1  ;
    MUX_in2  = rst? 16'b0 :  in2  ;
    MUX_in3  = rst? 16'b0 :  in3  ;
	MUX_in4  = rst? 16'b0 :  in4  ;
    MUX_in5  = rst? 16'b0 :  in5  ;
    MUX_in6  = rst? 16'b0 :  in6  ;
    MUX_in7  = rst? 16'b0 :  in7  ;
    MUX_in8  = rst? 16'b0 :  in8  ;
    MUX_in9  = rst? 16'b0 :  in9  ;
    MUX_in10 = rst? 16'b0 :  in10 ;
    MUX_in11 = rst? 16'b0 :  in11 ;
    MUX_in12 = rst? 16'b0 :  in12 ;
    MUX_in13 = rst? 16'b0 :  in13 ;
    MUX_in14 = rst? 16'b0 :  in14 ;
    MUX_in15 = rst? 16'b0 :  in15 ;
end	
	
	
endmodule	