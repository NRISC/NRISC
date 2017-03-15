module stack(
              ctrl,
              flagsIn,
              flagsOut,
              PCIn,
              PCout,
              clk,
              rst
              );
    parameter TAM=16;
    parameter NStack=8;

    input wire [1:0] ctrl;
    input wire [2:0] flagsIn;
    input wire [TAM-1:0] PCIn;

    output wire [2:0] flagsOut;
    output wire [TAM-1:0] PCout;

    input wire clk;
    input wire rst;

    reg [TAM+2:0] Stack [0:NStack-1];

    assign flagsOut=Stack[0][2:0];
    assign PCOut=Stack[0][TAM+2:3];



    integer i;
    always @ ( rst ) begin
        for(i=0; i<NStack; i=i+1) begin
          Stack[i]<=0;
        end
    end

    always @ (posedge ctrl[0] ) begin
        Stack[0]<={PCIn,flagsIn};
        for(i=1; i<NStack; i=i+1) begin
          Stack[i]<=Stack[i-1];
        end
    end

    always @ (posedge ctrl[1] ) begin
        for(i=NStack-2; i>=0; i=i-1) begin
          Stack[i]<=Stack[i+1];
        end
    end
endmodule
