module REGs(
              RD,
              RF1,
              RF2,
              CORE_REG_RD,
              CORE_REG_RF1,
              CORE_REG_RF2,
              write,
              rst
            );
            parameter TAM=16;

            input wire write;
            input wire rst;

            input wire [3:0] CORE_REG_RD;
            input wire [3:0] CORE_REG_RF1;
            input wire [3:0] CORE_REG_RF2;

            input wire [TAM-1:0] RD;

            output wire [TAM-1:0] RF1;
            output wire [TAM-1:0] RF2;

            reg [TAM-1:0] REGS [15:0];

            assign RF1=REGS[CORE_REG_RF1];
            assign RF2=REGS[CORE_REG_RF2];

            //TODO fazer corretamente o reset
            integer i;
            always @ ( rst ) begin
            for(i=0; i<16; i=i+1) begin
                REGS[i]={16'h0};
              end
            end

            always @ ( posedge write ) begin
              if(|CORE_REG_RD)
                REGS[CORE_REG_RD]=RD;
            end



endmodule
