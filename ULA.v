//ULA

/*************************************************************************
 *  descricao do bloco ula                              versao 0.1      *
 *                                                                       *
 *  Developer: Marlon                              15-12-2016            *
 *             marlonsigales@gmail.com                                   *
 *  Corrector: Mariano                             28-11-2016            *
 *             Jean Carlos Scheunemann             22-11-2016            *
 *             jeancarsch@gmail.com                                      *
 *                                                                       *
 * soma(inc, twc), sub(dec), xor, and, or, not, shr(rtr), shl(rtl)       *
 * selecoes incdec e comp2 inclusas; sem registradores, menor tempo      *
 * shift não sinalizado                                                  *
 *************************************************************************/ 

 
`timescale 1 ns / 1 ns
 
module NRISC_ULA(
                    ULA_A,      //ULA input A 
                    ULA_B,      //ULA input B 
                    ULA_OUT,    // output output 
                    ULA_ctrl,   //input comando
                    ULA_flags,  //output minus, carry, zero
                    clk,        //input clock           saida na subida  
                    rst,            //input reset           ativo baixo 
                    incdec,
                    cmp2
                    );

                    
                    
                        
    //Parameter numero de bits  
    parameter TAM = 16;
    //-------------portas de entrada------------------------------------------------------------------
    input wire [TAM-1:0] ULA_A;
    input wire [TAM-1:0] ULA_B;
    input wire clk;//teste
    input wire rst;
    input wire incdec;
    input wire cmp2;
    input wire [3:0] ULA_ctrl;//4 fios de controle, do bit2 ao bit0 selecao de funcao, bit3 selecao para os rot/shr ou assim por diante
    //-------------portas de saida--------------------------------------------------------------------
    output wire [TAM-1:0] ULA_OUT;
    output wire [2:0] ULA_flags;
    
    //-------------fios-registradores-----------------------------------------------------------------
    wire [TAM-1:0] A;
    wire [TAM-1:0] B;
    
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

    wire [TAM-1:0] auxsum; //auxiliar selecao 
    wire [TAM-1:0] auxrr;  //
    wire [TAM-1:0] auxrl;  //
    wire [TAM-1:0] auxand; //
    wire [TAM-1:0] auxor;  //
    wire [TAM-1:0] auxnot; //
    wire [TAM-1:0] auxxor; //

//descrever criterios de selecao do mux, chamar todas as funcoes em paralelo            
//chamadas das funcoes;

//descrição da entrada B incdec  e A comp2   
    wire [TAM-1:1]Alpha; 
    wire Beta;
    assign {Alpha,Beta}= ULA_B;
    assign B  = {(Alpha & ~(incdec)), (Beta | incdec)} ; //se incdec setado, entrada da ula é 1, pra somar com oque já tinhas 
    assign A   = ULA_A | {TAM{cmp2}}; //se cmp2 setado, entrada da ula é -1 daí faz notA -(-1) 
    //se ambos ativos, vai fazer uma operação com 1 e -1, e vai ser mó doido, ucp não pode ter isso.
   
    
//nomemodulo nomelocal (.parametrolah(parametroaqui)) (conexoes)(   // .nomelah (nomeaqui))   
    andn    #(.TAM(TAM)) and1 ( .A (A), .B (B), .Outand (Outand));  
    orn     #(.TAM(TAM)) or1  ( .A (A), .B (B), .Outor (Outor));
    xorn    #(.TAM(TAM)) xor1 ( .A (A), .B (B), .Outxor (Outxor));
    notn    #(.TAM(TAM)) not1 ( .A (A), .Outnot (Outnot));
    rotshl  #(.TAM(TAM)) rotshiftl ( .A (A), .cmd (cmd), .Outrl (Outrl));  
    rotshr  #(.TAM(TAM)) rotshiftr ( .A (A), .cmd (cmd), .Outrr (Outrr)); 
    somaUla #(.TAM(TAM)) sumsub ( .A (A), .B (B), .cin (cin), .Outsum (Outsum));
	
	
//linkando os resultados das flags     
    assign cin = (ctrla== 3'b001) ? 1'b1 : 1'b0; // selecao se eh menos ou mais
    
    assign carryl = (A[TAM-1] & ~(cmd) & ctrla[2] & ctrla[1] & ~(ctrla[0]));//so eh 1 se a selecao estiver nele e se carry da operacao foi setado
    assign carryr = (A[0] & ~(cmd) & ctrla[2] & ~(ctrla[1]) & ctrla[0]);//                                       ||
    assign carrysom = (~(A[TAM-1]) & ~(B[TAM-1]) & Outsum[TAM-1] & ~(ctrla[2]) & ~(ctrla[1]) & ~(ctrla[0]));// ||
    assign carrymin = (A[TAM-1] & B[TAM-1] & ~(ctrla[2]) & ~(ctrla[1]) & ctrla[0]);//                           ||
    
    assign carry = carrymin | carrysom  | carryl | carryr; //verifica se carry    
    assign zero = ULA_OUT ? 1'b0 : 1'b1;      //flag zero ativa quando a saida e zero
    assign minus = (((A[TAM-1] & B[TAM-1] ) ||Outsum[TAM-1]) && ~(ctrla[2]) && ~(ctrla[1])); //apenas operacoes de soma que retornam menos
    assign ULA_flags = {minus, zero, carry};  //concatena as flags para enviar para a saida 

    // registros das saidas 
    
    assign auxnot =({TAM{(ctrla[2] & ctrla[1] & ctrla[0])}}        & Outnot);
    assign auxrl  =({TAM{(ctrla[2] & ctrla[1] & ~(ctrla[0]))}}     & Outrl);
    assign auxrr = ({TAM{(ctrla[2] & ~(ctrla[1]) & ctrla[0])}}     & Outrr);
    assign auxxor =({TAM{(ctrla[2] & ~(ctrla[1]) & ~(ctrla[0]))}} & Outxor);
    assign auxor = ({TAM{(~(ctrla[2]) & ctrla[1] & ctrla[0])}}     & Outor);
    assign auxand =({TAM{(~(ctrla[2]) & ctrla[1] & ~(ctrla[0]))}}  & Outand);
    assign auxsum =({TAM{(~(ctrla[2]) & ~(ctrla[1]))}} & Outsum);
    
    
    assign ULA_OUT = {TAM{rst}} & ( auxnot| auxrl| auxrr| auxxor| auxor| auxand| auxsum);
            
        
endmodule








//not
module notn(A, Outnot);
    parameter TAM = 16;
    //-------------portas de entrada------------------------------------------------------------------
    input wire [TAM-1:0] A;
    
    //-------------portas de saida--------------------------------------------------------------------
    output wire [TAM-1:0] Outnot;   
    
    assign Outnot = ~(A);
endmodule

//and
module andn(A, B, Outand);
    parameter TAM = 16;
    //-------------portas de entrada------------------------------------------------------------------
    input wire [TAM-1:0] A;
    input wire [TAM-1:0] B;
    
    //-------------portas de saida--------------------------------------------------------------------
    output wire [TAM-1:0] Outand;   
    
    assign Outand = A & B;
endmodule



// or 
module orn(A, B, Outor);
    parameter TAM = 16;
    //-------------portas de entrada------------------------------------------------------------------
    input wire [TAM-1:0] A;
    input wire [TAM-1:0] B;
    
    //-------------portas de saida--------------------------------------------------------------------
    output wire [TAM-1:0] Outor;    
    
    assign Outor = A | B;
endmodule




// xor
module xorn(A, B, Outxor);

    parameter TAM = 16;
    //-------------portas de entrada------------------------------------------------------------------
    input wire [TAM-1:0] A;
    input wire [TAM-1:0] B;
    
    //-------------portas de saida--------------------------------------------------------------------
    output wire [TAM-1:0] Outxor;
    
    assign Outxor = A ^ B;
    

endmodule



//rotate/shift right
module rotshr(A, cmd, Outrr);
    parameter TAM = 16;
    //-------------portas de entrada------------------------------------------------------------------
    input wire [TAM-1:0] A;
    input wire cmd;
    
    //-------------portas de saida--------------------------------------------------------------------
    output wire [TAM-1:0] Outrr;    

    
        //se rotate carrega o lsb pro msb
    //assign Outrr[TAM-1] =  cmd ? A[0] : A[TAM-1]; //sinalizado
	assign Outrr[TAM-1] =  cmd ? A[0] : 1'b0 ; //não sinalizado
	
	
    
    genvar I;
    generate        
        for (I=0; I<=TAM-2 ; I=I+1) begin: rotater 
            assign Outrr[I] =A[I+1] ;             
    end
    endgenerate

endmodule



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
    
endmodule
               

               
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

endmodule











                        
    

