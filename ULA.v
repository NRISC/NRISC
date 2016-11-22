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
  
 //falta arvore de clk, verificar oque tem que ser reg ao invés de wire, sepá flags tem que ser regs
 
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

//-------------fios-registradores-----------------------------------------------------------------

wire minus; //flag menos
wire zero;  //flag zero 
wire carry; //flag carry

wire carryl;
wire carryr;
wire carrymin;
wire carrysom;
                                          
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

//nomemodulo nomelocal (.parametrolah(parametroaqui)) (conexoes)(   // .nomelah (nomeaqui))   
    andn #(.TAM(TAM)) and1 ( .A (A), .B (B), .Outand (Outand));  
    orn  #(.TAM(TAM)) or1  ( .A (A), .B (B), .Outor (Outor));
	xorn #(.TAM(TAM)) xor1 ( .A (A), .B (B), .Outxor (Outxor));
	notn #(.TAM(TAM)) not1 ( .A (A), .Outnot (Outnot));

	rotshl #(.TAM(TAM)) rotshiftl ( .A (A), .cmd (cmd), .Outrl (Outrl));  
    rotshr #(.TAM(TAM)) rotshiftr ( .A (A), .cmd (cmd), .Outrr (Outrr)); 
	
	somaUla #(.TAM(TAM)) sumsub ( .A (A), .B (B), .cin (cin), .Outsum (Outsum));
	   

	
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






assign cin = (ctrla== 3'b001) ? 1'b1 : 1'b0; // seleção se é menos ou mais

assign carryl = (A[TAM-1] && ~(cmd) && ctrla[2]&& ctrla[1] && ~(ctrla[0]));//só é 1 se a seleção estiver nele e se carry da operação foi setado
assign carryr = (A[0] && ~(cmd) && ctrla[2]&& ~(ctrla[1]) && ctrla[0]);//                                       ||
assign carrysom = (~(A[TAM-1]) && ~(B[TAM-1]) && Outsum[TAM-1] && ~(ctrla[2]) && ~(ctrla[1]) && ~(ctrla[0]));// ||
assign carrymin = (A[TAM-1] && B[TAM-1] && ~(ctrla[2]) && ~(ctrla[1]) && ctrla[0]);//                           ||

assign carry = carrymin|| carrysom  || carryl || carryr; //verifica se carry    
                     
assign zero = ULA_OUT ? 1'b1 : 1'b0;      //flag zero ativa quando a saida é zero

assign minus = (((A[TAM-1] && B[TAM-1] ) ||Outsum[TAM-1]) && ~(ctrla[2]) && ~(ctrla[1])); //apenas operações de soma que retornam menos

assign ULA_flags = {minus, zero, carry};  //concatena as flags para enviar para a saída 
		
assign ULA_OUT = x
		
endmodule;



















module somaUla(A, B, cin, Outsum);

//Parameter numero de bits	
parameter TAM = 16;
//-------------portas de entrada------------------------------------------------------------------
input wire [TAM-1:0] A;
input wire [TAM-1:0] B;
input wire cin;

//-------------portas de saida--------------------------------------------------------------------
output reg [TAM-1:0] Outsum;

wire [TAM-1] Baux;

wire [TAM-1] x;
wire [TAM-1] y;
wire [TAM-1] w;
wire [TAM-1] suminternal;
wire [TAM-1] coutinternal;

assign Baux = B ^ {TAM{cin}};          //seleção entre mais ou menos

//primeiro ful adder, o diferentão, que carrega a seleção
assign x[0] = A[0] & Baux[0];
assign y[0] = A[0] ^ Baux[0];
assign w[0] = y[0] & cin;
assign suminternal[0] = y[0] ^ cin;
assign coutinternal[0] = w[0] | x[0];
			
//descrição dos outros full adder com generate
genvar I;
	generate        
		for (I=1; I<TAM-1 ; I=I+1) begin: fulladers 
			
			assign x[I] = A[I] & Baux[I];
			assign y[I] = A[I] ^ Baux[I];
			assign w[I] = y[I] & coutinternal[I-1];
			assign suminternal[I] = y[I] ^ coutinternal[I-1];
			assign coutinternal[I] = w[I] | x[I];
	end
endgenerate

assign Outsum = suminternal;

endmodule;






module rotshr(A, cmd, Outrr);
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] A;
	input wire cmd;
	
	//-------------portas de saida--------------------------------------------------------------------
	output reg [TAM-1:0] Outrr;	
	output reg coutr	
    
		
	assign Outrr[TAM-1] =  cmd ? A[0] : A[TAM-1];
	
	genvar I;
	generate        
		for (I=0; I<TAM-2 ; I=I+1) begin: rotater 
			assign Outrr[I] =A[I+1]
	end
	endgenerate

endmodule;




module rotshl(A, cmd, Outrl);
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] A;
	input wire cmd;
	input wire clk;
	//-------------portas de saida--------------------------------------------------------------------
	output reg [TAM-1:0] Outrl;	
	output reg coutl
	
	assign Outrl[0] =  cmd ? A[TAM-1] : 1'b0;
	
	genvar I;
	generate        
		for (I=0; I<TAM-2 ; I=I+1) begin: rotatel 
			assign Outrl[I+1] =A[I]
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





               

