module progMEM(
                Instruction,
                progADDR,
                CoreStatus,
                clk,
                rst
                );
    parameter TAM=16;
    parameter Lmem=8;

    input wire [0:TAM-1] progADDR;
    input wire [1:0] CoreStatus;

    input wire rst;
    input wire clk;

    output reg [15:0] Instruction;

    reg [15:0] MainMEM [0:(1<<Lmem)-1];
    reg [1:0] lastCoreStatus;

    initial $readmemh("Prog.hex", MainMEM); //le o arquivo hexadecimal que contem o programa;

    always @ ( negedge clk ) begin
        lastCoreStatus=CoreStatus;
        if(CoreStatus==2'b00)
            Instruction=(lastCoreStatus==2'b00 || lastCoreStatus==2'b01) ? MainMEM[progADDR[0:Lmem]+1]:MainMEM[progADDR[0:Lmem]];
    end
endmodule
