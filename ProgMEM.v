module progMEM(
                Instruction,
                progADDR,
                CoreStatus,
                clk,
                rst
                );
    parameter TAM=16;
    parameter LMEM=8;


    input wire [0:TAM-1] progADDR;
    input wire [1:0] CoreStatus;

    input wire rst;
    input wire clk;

    output reg [0:15] Instruction;

    reg [0:15] MainMEM [0:(1<<Lmem)-1];
    reg rstPipeline;

    //TODO icialzacao
    always @ ( negedge clk ) begin
        Instruction=(CoreStatus==2'b00) ? MainMEM[progADDR[0:Lmem]]:((CoreStatus==2'b01) Instruction ?);
    end
    always @ (posedge clk) begin


    end

endmodule
