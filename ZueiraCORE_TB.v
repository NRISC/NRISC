// Zueira core tb

`timescale 1 ns / 1 ns  // only for cadence, comment in modelSim
module ZC_TB;

      parameter TAM=16;     //tamanho da palavra de dados
      parameter LDataMem=8; // 256 posicoes proprias e 256 compartilhadas( sempre simetrico)
      parameter LProgMem=8; // 256 instrucoes
      parameter NStack=8;   //profundidade da pilha
      parameter Ncores=2;   //numero de processadores(implementados de maneira parcial, funciona soh para 1 e 2)

reg clk;
reg rst;

reg [TAM-1:0] GPIN;
wire [TAM-1:0] GPOUT;

ZueiraCore dut (
                .GPIN(GPIN),
                .GPOUT(GPOUT),
                .clk(clk),
                .rst(rst)
              );

 localparam integer PERIOD = 10;
initial clk = 1'b0; 
always #(PERIOD/2) clk = ~clk;  // geração do clock

initial begin
 rst = 1 ;
 #1 rst = 0;	
 
end 

initial GPIN=0;


endmodule