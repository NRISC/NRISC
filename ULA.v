//ULA

/*************************************************************************
 *  descricao do bloco ula                              versao 0.01      *
 *                                                                       *
 *  Developer: Marlon 	                           27-11-2016            *
 *             marlonsigales@gmail.com                                   *
 *  Corrector: Mariano                             22-11-2016            *
 *             Jean Carlos Scheunemann             22-11-2016            *
 *             jeancarsch@gmail.com                                      *
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
					clk,        //input clock           saida na subida  
					rst	        //input	reset		    ativo baixo	
					);

					
					
						
	//Parameter numero de bits	
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] ULA_A;
	input wire [TAM-1:0] ULA_B;
	input wire clk;//teste
	input wire rst;
	input wire [3:0] ULA_ctrl;//4 fios de controle, do bit2 ao bit0 selecao de funcao, bit3 selecao para os rot/shr ou assim por diante
	//-------------portas de saida--------------------------------------------------------------------
	output reg [TAM-1:0] ULA_OUT;
	output reg [2:0] ULA_flags;
	
	//-------------fios-registradores-----------------------------------------------------------------
	
	wire minus; //flag menos
	wire zero;  //flag zero 
	wire carry; //flag carry
	
	wire carryl;   // auxilhares do carry
	wire carryr;
	wire carrymin;
	wire carrysom;
											
	wire cin;   //para escolher entre soma e subtracao  
	wire cmd;   //se 0 e shift e se 1 rotate
	wire [2:0] ctrla; //lsb do ula ctrl
	
	assign {cmd, ctrla} = ULA_ctrl;// controle 
	
					
	wire [TAM-1:0] Outsum; //saida soma(inc,twc) subtracao(dec) 
	wire [TAM-1:0] Outrr;  //saida rotate ou shift direita
	wire [TAM-1:0] Outrl;  //saida rotate ou shift esquerda
	wire [TAM-1:0] Outand; //saida and
	wire [TAM-1:0] Outor;  //saida or
	wire [TAM-1:0] Outnot; //saida not
	wire [TAM-1:0] Outxor; //saida xor


//descrever criterios de selecao do mux, chamar todas as funcoes em paralelo			
//chamadas das funcoes;
   
	
//nomemodulo nomelocal (.parametrolah(parametroaqui)) (conexoes)(   // .nomelah (nomeaqui))   
  andn    #(.TAM(TAM)) and1 ( .A (ULA_A), .B (ULA_B), .Outand (Outand));  
  orn     #(.TAM(TAM)) or1  ( .A (ULA_A), .B (ULA_B), .Outor (Outor));
	xorn    #(.TAM(TAM)) xor1 ( .A (ULA_A), .B (ULA_B), .Outxor (Outxor));
	notn    #(.TAM(TAM)) not1 ( .A (ULA_A), .Outnot (Outnot));
  rotshl  #(.TAM(TAM)) rotshiftl ( .A (ULA_A), .cmd (cmd), .Outrl (Outrl));  
  rotshr  #(.TAM(TAM)) rotshiftr ( .A (ULA_A), .cmd (cmd), .Outrr (Outrr)); 
	somaUla #(.TAM(TAM)) sumsub ( .A (ULA_A), .B (ULA_B), .cin (cin), .Outsum (Outsum));
//linkando os resultados das flags	   
    assign cin = (ctrla== 3'b001) ? 1'b1 : 1'b0; // selecao se eh menos ou mais
	
	  assign carryl = (ULA_A[TAM-1] & ~(cmd) & ctrla[2] & ctrla[1] & ~(ctrla[0]));//so eh 1 se a selecao estiver nele e se carry da operacao foi setado
    assign carryr = (ULA_A[0] & ~(cmd) & ctrla[2] & ~(ctrla[1]) & ctrla[0]);//                                       ||
    assign carrysom = (~(ULA_A[TAM-1]) & ~(ULA_B[TAM-1]) & Outsum[TAM-1] & ~(ctrla[2]) & ~(ctrla[1]) & ~(ctrla[0]));// ||
    assign carrymin = (ULA_A[TAM-1] & ULA_B[TAM-1] & ~(ctrla[2]) & ~(ctrla[1]) & ctrla[0]);//                           ||
    
	  assign carry = carrymin | carrysom  | carryl | carryr; //verifica se carry    
    assign zero = ULA_OUT ? 1'b0 : 1'b1;      //flag zero ativa quando a saida e zero
    assign minus = (((ULA_A[TAM-1] & ULA_B[TAM-1] ) ||Outsum[TAM-1]) && ~(ctrla[2]) && ~(ctrla[1])); //apenas operacoes de soma que retornam menos


	// registros das saidas 
	always @ (posedge clk)
		begin : rotadeclk
			if (rst == 0) begin                 //reset ativo baixo?
               ULA_OUT <= 0;
			end 
			else  begin
				//mux de selecao de saida 
				case( ctrla ) 
					3'b000 : ULA_OUT = Outsum;
					3'b001 : ULA_OUT = Outsum;//menos
					3'b010 : ULA_OUT = Outand;
					3'b011 : ULA_OUT = Outor;
					3'b100 : ULA_OUT = Outxor;
					3'b101 : ULA_OUT = Outrr;// 
					3'b110 : ULA_OUT = Outrl;//
					3'b111 : ULA_OUT = Outnot;
				endcase
			
				
	        end
	
		ULA_flags = {minus, zero, carry};  //concatena as flags para enviar para a saida 
	end	
		
endmodule








//not
module notn(A, Outnot);
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] A;
	
	//-------------portas de saida--------------------------------------------------------------------
	output wire [TAM-1:0] Outnot;	
	
	assign Outnot = ~(A);
endmodule;

//and
module andn(A, B, Outand);
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] A;
	input wire [TAM-1:0] B;
	
	//-------------portas de saida--------------------------------------------------------------------
	output wire [TAM-1:0] Outand;	
	
	assign Outand = A & B;
endmodule;



// or 
module orn(A, B, Outor);
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] A;
	input wire [TAM-1:0] B;
	
	//-------------portas de saida--------------------------------------------------------------------
	output wire [TAM-1:0] Outor;	
	
	assign Outor = A | B;
endmodule;




// xor
module xorn(A, B, Outxor);

	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] A;
	input wire [TAM-1:0] B;
	
	//-------------portas de saida--------------------------------------------------------------------
	output wire [TAM-1:0] Outxor;
	
	assign Outxor = A ^ B;
	

endmodule;



//rotate/shift right
module rotshr(A, cmd, Outrr);
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] A;
	input wire cmd;
	
	//-------------portas de saida--------------------------------------------------------------------
	output wire [TAM-1:0] Outrr;	

    
		
	assign Outrr[TAM-1] =  cmd ? A[0] : A[TAM-1]; //se rotate carrega o lsb pro msb
	
	genvar I;
	generate        
		for (I=0; I<=TAM-2 ; I=I+1) begin: rotater 
			assign Outrr[I] =A[I+1] ;             
	end
	endgenerate

endmodule;



//rotate/shift left
module rotshl(A, cmd, Outrl);
	parameter TAM = 16;
	//-------------portas de entrada------------------------------------------------------------------
	input wire [TAM-1:0] A;
	input wire cmd;
	
	//-------------portas de saida--------------------------------------------------------------------
	output wire [TAM-1:0] Outrl;	
		
	assign Outrl[0] =  cmd ? A[TAM-1] : 1'b0;  //se rotate carrega o msb pro lsb
	
	genvar J;
	generate        
		for (J=0; J<=TAM-2 ; J=J+1) begin: rotatel 
			assign Outrl[J+1] =A[J];
	end
	endgenerate
	
endmodule;
               

			   
// somas 			   
module somaUla(A, B, cin, Outsum);

		//Parameter numero de bits	
		parameter TAM = 16;
		//-------------portas de entrada------------------------------------------------------------------
		input wire [TAM-1:0] A;
		input wire [TAM-1:0] B;
		input wire cin;
		
		//-------------portas de saida--------------------------------------------------------------------
		output wire [TAM-1:0] Outsum;
		
		wire [TAM-1:0] Baux;
		
		wire [TAM-1:0] x;
		wire [TAM-1:0] y;
		wire [TAM-1:0] w;
		wire [TAM-1:0] suminternal;
		wire [TAM-1:0] coutinternal;
		
		assign Baux = B ^ {TAM{cin}};          //selecao entre mais ou menos
		
		//primeiro ful adder, o diferentao, que carrega a selecao
		assign x[0] = A[0] & Baux[0];
		assign y[0] = A[0] ^ Baux[0];
		assign w[0] = y[0] & cin;
		assign suminternal[0] = y[0] ^ cin;
		assign coutinternal[0] = w[0] | x[0];
					
		//descricao dos outros full adder com generate
		genvar I;
			generate        
				for (I=1; I<=TAM-1 ; I=I+1) begin: fulladers 
					
					assign x[I] = A[I] & Baux[I];
					assign y[I] = A[I] ^ Baux[I];
					assign w[I] = y[I] & coutinternal[I-1];
					assign suminternal[I] = y[I] ^ coutinternal[I-1];
					assign coutinternal[I] = w[I] | x[I];
			end
		endgenerate
		
		assign Outsum = suminternal;

endmodule;
