module progMEM(
                Instruction,
                progADDR,
                clk,
                rst
                );
    parameter TAM=16;
    parameter LMEM=8;


    input wire [0:TAM-1] progADDR;
    input wire rst;
    input wire clk;

    output reg [0:15] Instruction;

    reg [0:15] MainMEM [0:(1<<Lmem)-1];
    reg [0:15] peipe1;

    //TODO icialzacao

    always @ (posedge clk) begin
          Instruction=pipe1;
          pipe1=MainMEM[progADDR[0:Lmem]];

    end

endmodule
