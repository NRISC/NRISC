



module regs_tb;
 
            
localparam integer PERIOD = 10;
parameter TAM=16;



reg write;
reg rst;

reg [3:0] CORE_REG_RD;
reg [3:0] CORE_REG_RF1;
reg [3:0] CORE_REG_RF2;

reg [TAM-1:0] RD;

wire [TAM-1:0] RF1;
wire [TAM-1:0] RF2;
			
reg clk;			
initial clk = 1'b0;			
always #(PERIOD/2) clk = ~clk;  // geração do clock
reg[TAM:0] x;


REGs DUT (
              .RD(RD),
              .RF1(RF1),
              .RF2(RF2),
              .CORE_REG_RD(CORE_REG_RD),
              .CORE_REG_RF1(CORE_REG_RF1),
              .CORE_REG_RF2(CORE_REG_RF2),
              .write(write),
              .rst(rst)
            );







initial begin
CORE_REG_RD=0;
CORE_REG_RF1=0;
CORE_REG_RF2=0;
x=0;
rst=1;
#1 rst=0;
RD=0;
end
reg[TAM-1:0] reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,reg16;

initial reg1=0;


always@(posedge clk)begin

	
	
	if (x<TAM)begin
		CORE_REG_RD=CORE_REG_RD+1;
		x=x+1;
	end else begin
		CORE_REG_RD={$random()}%(5'b11111);
		CORE_REG_RF1={$random()}%(5'b11111);
		CORE_REG_RF2={$random()}%(5'b11111);
		RD={$random()}%(17'b11111111111111111);
	end
	write=0;
end

always@(negedge clk)begin
	write=1;

	end

always @(posedge write)begin
	
	case  (CORE_REG_RD)
		4'b0000:begin
			//reg1=RD;
		end
		4'b0001:begin
			reg2=RD;
		end
		4'b0010:begin
			reg3=RD;
		end
		4'b0011:begin
			reg4=RD;
		end
		4'b0100:begin
			reg5=RD;
		end
		4'b0101:begin
			reg6=RD;
		end
		4'b0110:begin
			reg7=RD;
		end
		4'b0111:begin
			reg8=RD;
		end
		4'b1000:begin
			reg9=RD;
		end
		4'b1001:begin
			reg10=RD;
		end
		4'b1010:begin
			reg11=RD;
		end
		4'b1011:begin
			reg12=RD;
		end
		4'b1100:begin
			reg13=RD;
		end
		4'b1101:begin
			reg14=RD;
		end
		4'b1110:begin
			reg15=RD;
		end
		4'b1111:begin
			reg16=RD;
		end		
	
	
	
	
	endcase
end	


always @(CORE_REG_RF1)begin
	
	case  (CORE_REG_RF1)
		4'b0000:begin
			if (reg1==RF1);
			
			else
				$display("\n\n erro RF1",$time,"   ns","\n       esperado  ",reg1,"\n       recebido   ",RF1  );
		end
		4'b0001:begin
			if (reg2==RF1);
			
			else
				$display("\n\n erro RF1",$time,"   ns","\n       esperado  ",reg2,"\n       recebido   ",RF1  );
		end
		4'b0010:begin
			if (reg3==RF1);
			
			else
				$display("\n\n erro RF1",$time,"   ns","\n       esperado  ",reg3,"\n       recebido   ",RF1  );
		end
		4'b0011:begin
			if (reg4==RF1);
			
			else
				$display("\n\n erro RF1",$time,"   ns","\n       esperado  ",reg4,"\n       recebido   ",RF1 );
		end
		4'b0100:begin
			if (reg5==RF1);
			
			else
				$display("\n\n erro RF1",$time,"   ns","\n       esperado  ",reg5,"\n       recebido   ",RF1  );
		end
		4'b0101:begin
			if (reg6==RF1);
			
			else
				$display("\n\n erro RF1",$time,"   ns","\n       esperado  ",reg6,"\n       recebido   ",RF1  );
		end
		4'b0110:begin
			if (reg7==RF1);
			
			else
				$display("\n\n erro RF1",$time,"   ns","\n       esperado  ",reg7,"\n       recebido   ",RF1  );
		end
		4'b0111:begin
			if (reg8==RF1);
			
			else
				$display("\n\n erro RF1",$time,"   ns","\n       esperado  ",reg8,"\n       recebido   ",RF1  );
		end
		4'b1000:begin
			if (reg9==RF1);
			
			else
				$display("\n\n erro RF1",$time,"   ns","\n       esperado  ",reg9,"\n       recebido   ",RF1  );
		end
		4'b1001:begin
			if (reg10==RF1);
			
			else
				$display("\n\n erro RF1",$time,"   ns","\n       esperado  ",reg10,"\n       recebido   ",RF1  );
		end
		4'b1010:begin
			if (reg11==RF1);
			
			else
				$display("\n\n erro RF1",$time,"   ns","\n       esperado  ",reg11,"\n       recebido   ",RF1  );
		end
		4'b1011:begin
			if (reg12==RF1);
			
			else
				$display("\n\n erro RF1",$time,"   ns","\n       esperado  ",reg12,"\n       recebido   ",RF1  );
		end
		4'b1100:begin
			if (reg13==RF1);
			
			else
				$display("\n\n erro RF1",$time,"   ns","\n       esperado  ",reg13,"\n       recebido   ",RF1  );
		end
		4'b1101:begin
			if (reg14==RF1);
			
			else
				$display("\n\n erro RF1",$time,"   ns","\n       esperado  ",reg14,"\n       recebido   ",RF1  );
		end
		4'b1110:begin
			if (reg15==RF1);
			
			else
				$display("\n\n erro RF1",$time,"   ns","\n       esperado  ",reg15,"\n       recebido   ",RF1  );
		end
		4'b1111:begin
			if (reg16==RF1);
			
			else
				$display("\n\n erro RF1",$time,"   ns","\n       esperado  ",reg16,"\n       recebido   ",RF1  );
		end
	
	endcase
end	




always @(CORE_REG_RF2)begin
	
	case  (CORE_REG_RF2)
		4'b0000:begin
			if (reg1==RF2);
			
			else
				$display("\n\n erro RF2",$time,"   ns","\n       esperado  ",reg1,"\n       recebido   ",RF2  );
		end
		4'b0001:begin
			if (reg2==RF2);
			
			else
				$display("\n\n erro RF2",$time,"   ns","\n       esperado  ",reg2,"\n       recebido   ",RF2  );
		end
		4'b0010:begin
			if (reg3==RF2);
			
			else
				$display("\n\n erro RF2",$time,"   ns","\n       esperado  ",reg3,"\n       recebido   ",RF2  );
		end
		4'b0011:begin
			if (reg4==RF2);
			
			else
				$display("\n\n erro RF2",$time,"   ns","\n       esperado  ",reg4,"\n       recebido   ",RF2  );
		end
		4'b0100:begin
			if (reg5==RF2);
			
			else
				$display("\n\n erro RF2",$time,"   ns","\n       esperado  ",reg5,"\n       recebido   ",RF2  );
		end
		4'b0101:begin
			if (reg6==RF2);
			
			else
				$display("\n\n erro RF2",$time,"   ns","\n       esperado  ",reg6,"\n       recebido   ",RF2  );
		end
		4'b0110:begin
			if (reg7==RF2);
			
			else
				$display("\n\n erro RF2",$time,"   ns","\n       esperado  ",reg7,"\n       recebido   ",RF2  );
		end
		4'b0111:begin
			if (reg8==RF2);
			
			else
				$display("\n\n erro RF2",$time,"   ns","\n       esperado  ",reg8,"\n       recebido   ",RF2  );
		end
		4'b1000:begin
			if (reg9==RF2);
			
			else
				$display("\n\n erro RF2",$time,"   ns","\n       esperado  ",reg9,"\n       recebido   ",RF2  );
		end
		4'b1001:begin
			if (reg10==RF2);
			
			else
				$display("\n\n erro RF2",$time,"   ns","\n       esperado  ",reg10,"\n       recebido   ",RF2  );
		end
		4'b1010:begin
			if (reg11==RF2);
			
			else
				$display("\n\n erro RF2",$time,"   ns","\n       esperado  ",reg11,"\n       recebido   ",RF2  );
		end
		4'b1011:begin
			if (reg12==RF2);
			
			else
				$display("\n\n erro RF2",$time,"   ns","\n       esperado  ",reg12,"\n       recebido   ",RF2  );
		end
		4'b1100:begin
			if (reg13==RF2);
			
			else
				$display("\n\n erro RF2",$time,"   ns","\n       esperado  ",reg13,"\n       recebido   ",RF2  );
		end
		4'b1101:begin
			if (reg14==RF2);
			
			else
				$display("\n\n erro RF2",$time,"   ns","\n       esperado  ",reg14,"\n       recebido   ",RF2  );
		end
		4'b1110:begin
			if (reg15==RF2);
			
			else
				$display("\n\n erro RF2",$time,"   ns","\n       esperado  ",reg15,"\n       recebido   ",RF2  );
		end
		4'b1111:begin
			if (reg16==RF2);
			
			else
				$display("\n\n erro RF2",$time,"   ns","\n       esperado  ",reg16,"\n       recebido   ",RF2  );
		end
	
	endcase
end	
	
	
	
	
	
	
	
endmodule