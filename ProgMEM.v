module progMEM(
                Instruction,
                progADDR,
                CoreStatus,
                clk,
                rst
                );
    parameter TAM=16;
    parameter Lmem=8;
    parameter ProgFile= "Prog.hex";


    input wire [TAM-1:0] progADDR;
    input wire [1:0] CoreStatus;

    input wire rst;
    input wire clk;

    output reg [15:0] Instruction;

    reg [15:0] MainMEM [0:(1<<Lmem)-1];
    reg [1:0] lastCoreStatus;

    initial $readmemh(ProgFile, MainMEM); //le o arquivo hexadecimal que contem o programa;

    always @ ( negedge clk ) begin
        lastCoreStatus=CoreStatus;
        if(CoreStatus==2'b00)
            Instruction=(lastCoreStatus==2'b00 || lastCoreStatus==2'b01) ? MainMEM[progADDR[Lmem:0]+1]:MainMEM[progADDR[Lmem:0]];
    end
endmodule
