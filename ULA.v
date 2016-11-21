//ULA

/*************************************************************************
 *  descricao do bloco ula                              versao 0.0       *
 *                                                                       *
 *  Developer: Marlon 	                           20-11-2016            *
 *             marlonsigales@gmail.com                                   *
 *  Corrector: Mariano                             22-11-2016            *
 *             Jean Carlos Scheunemann             22-11-2016            *
 *              jeancarsch@gmail.com                                     *
 *                                                                       *
 * soma(inc, twc), sub(dec), xor, and, or, not, shr(rtr), shl(rtl)       *
 *                                                                       *
 *************************************************************************/ 
 
`timescale 1 ns / 1 ns
 
module NRISC_ULA(
					ULA_A,      //ULA input A 
					ULA_B,      //ULA input B 
					ULA_OUT,    // output output 
					ULA_ctrl,   //input comando
					ULA_flags,  //output minus, carry, zero
					clk,        //input clock
					rst	        //input	reset			
					);

					
					
					
//Parameter numero de bits	
parameter TAM = 16;
//-------------portas de entrada------------------------------------------------------------------
input wire [TAM-1:0] ULA_A;
input wire [TAM-1:0] ULA_B;
input wire clk;//teste
input wire rst;
input wire [3:0] ULA_ctrl;//4 fios de controle, do bit2 ao bit0 seleção de função, bit3 seleção para os rot/shr ou assim por diante
//-------------portas de saida--------------------------------------------------------------------
output reg [TAM-1:0] ULA_OUT;
output reg [2:0] ULA_flags;

//-------------fios-------------------------------------------------------------------------

wire minus; //flag menos
wire zero;  //flag zero 
wire carry; //flag carry
                                          
wire cin;   //para escolher entre soma e subtraçao  
wire cmd;   //se 0 é shift e se 1 rotate
wire [2:0] ctrla; //lsb do ula ctrl

assign {cmd, ctrla} = ULA_ctrl;// controle 

reg coutr; //carry do shift direita 
reg coutl; //carry do shift esquerda
reg coutsum; //carry da soma
 
			
wire [TAM-1:0] Outsum; //saida soma(inc,twc) subtração(dec) 
wire [TAM-1:0] Outrr;  //saida rotate ou shift direita
wire [TAM-1:0] Outrl;  //saida rotate ou shift esquerda
wire [TAM-1:0] Outand; //saida and
wire [TAM-1:0] Outor;  //saida or
wire [TAM-1:0] Outnot; //saida not
wire [TAM-1:0] Outxor; //saida xor

reg x; //auxilhar mux


//descrever criterios de seleção do mux, chamar todas as funções em paralelo			
//chamadas das funções;


//mux de seleção de saída 
always @ (clk)
begin : MUX
 case( ctrla ) 
    3'b000 : x = Outsum;
    3'b001 : x = Outsum;//menos
	3'b010 : x = Outand;
    3'b011 : x = Outor;
	3'b100 : x = Outxor;
    3'b101 : x = Outrr;// 
	3'b110 : x = Outrl;//
    3'b111 : x = Outnot;
 endcase 
end
assign ULA_OUT = x






assign carry = coutsum || coutl || coutr; //verifica se alguma flag é 1;
assign zero = ULA_OUT ? 1'b1 : 1'b0;      //flag zero ativa quando a saida é zero
assign ULA_flags = {minus, zero, carry};  //concatena as flags para enviar para a saída 
		
endmodule;




module somaUla(A,B,cin,coutsum,minus,zero, Outsum);

//inicialmente verifica e limpa os carrys
//Parameter numero de bits	
parameter TAM = 16;
//-------------portas de entrada------------------------------------------------------------------
input wire [TAM-1:0] A;
input wire [TAM-1:0] B;

//-------------portas de saida--------------------------------------------------------------------
output reg [TAM-1:0] ULA_OUT;
output reg [2:0] ULA_flags;


endmodule;

module rotshr(A, cmd, coutr, Outrr);
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] A;
	input wire cmd;
	
	//-------------portas de saida--------------------------------------------------------------------
	output reg [TAM-1:0] Outrr;	
	output reg coutr	


endmodule;




module rotshl(A, cmd, coutl, Outrl, clk);
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] A;
	input wire cmd;
	input wire clk;
	//-------------portas de saida--------------------------------------------------------------------
	output reg [TAM-1:0] Outrl;	
	output reg coutl
	
	always @ (clk)
	begin : MUX1
		case( cmd ) 
			1'b0 : x = Outsum;
			1'b1 : x = Outsum;//menos
		endcase 
	end
	
	genvar I;
	generate        
		for (I=0; I<TAM ; I=I+1) begin: rotate 
	end
	endgenerate
	
endmodule;




module andn(A, B, Outand);
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] A;
	input wire [TAM-1:0] B;
	
	//-------------portas de saida--------------------------------------------------------------------
	output reg [TAM-1:0] Outand;	
	
	assign Outand = A & B;
endmodule;




module orn(A, B, Outor);
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] A;
	input wire [TAM-1:0] B;
	
	//-------------portas de saida--------------------------------------------------------------------
	output reg [TAM-1:0] Outor;	
	
	assign Outor = A | B;
endmodule;




module notn(A, Outnot);
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] A;
	
	//-------------portas de saida--------------------------------------------------------------------
	output reg [TAM-1:0] Outnot;	
	
	assign Outnot = ~(A);
endmodule;





module xorn(A, B, Outxor);

	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] A;
	input wire [TAM-1:0] B;
	
	//-------------portas de saida--------------------------------------------------------------------
	output reg [TAM-1:0] Outxor;
	
	assign Outxor = A ^ B;
	

endmodule;





               

