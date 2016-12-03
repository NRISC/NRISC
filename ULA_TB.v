// ULA_TB

// versao 0.01  23/11/2016


`timescale 1 ns / 1 ns  // only for cadence, comment in modelSim

module ULA_TB;

localparam integer PERIOD = 10;

parameter TAM = 16;

reg signed [TAM-1:0] ULA_A;
reg signed [TAM-1:0] ULA_B;
reg clk, rst, incdec, cmp2;
reg [3:0] ULA_ctrl;

wire signed [TAM-1:0] ULA_OUT;
wire [2:0] ULA_flags;


// Device Under Test instantiation <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
NRISC_ULA DUT
  (
  .ULA_A (ULA_A),
  .ULA_B (ULA_B),
  .clk (clk),
  .rst (rst),
  .incdec(incdec),
  .cmp2(cmp2),
  .ULA_ctrl (ULA_ctrl),
  .ULA_OUT (ULA_OUT),
  .ULA_flags (ULA_flags)
  
  );

// clock generation
  initial clk = 1'b0;
  always #(PERIOD/2) clk = ~clk;


initial ULA_A = 16'b1010101010101010;
initial ULA_B = 16'b0101010101010101;
initial rst = 1; // conforme visto no codigo do Marlon reset e ativo em baixo
initial incdec = 0;
initial cmp2= 0;

reg [TAM-1:0] amaisb;
reg [TAM-1:0] amenosb; 

initial begin
amaisb = ULA_A+ULA_B;
amenosb = ULA_A-ULA_B; 
  $display("\n\n NOT ");
  //ULA_ctrl = 4'b0111;
   @ ( negedge clk ) 
      ULA_ctrl = 4'b0111;
   @ ( posedge clk ) begin
	 #1;
    if (ULA_OUT==16'b0101010101010101) begin
      $display("\n\n NOT OK ", $time,"<-time" );
      if (ULA_flags==3'b000) begin
        $display("\n\n\ flag OK",$time);
      end else begin
        $display("\n\n\ flag ERROR", $time,"<-time       \n resultado esperado 000","     \n resultado recebido %b ", ULA_flags);
      end
     end else begin
      $display("\n\n NOT ERROR ", $time,"<-time      \n resultado esperado 0101010101010101","    \n resultado recebido %b ", ULA_OUT);
    end
  end

//-------------------------------------------------------------
  $display("\n\n AND ");
  //ULA_ctrl = 4'b0010;
	@ ( negedge clk ) 
	   ULA_ctrl = 4'b0010;
   @ ( posedge clk ) begin
	#1;
    if (ULA_OUT==16'b0000000000000000) begin
      $display("\n\n AND OK ", $time,"<-time");
      if (ULA_flags==3'b010) begin
        $display("\n\n\ flag OK",$time);
      end else begin
        $display("\n\n\ flag ERROR", $time,"<-time     \n resultado esperado 010","     \n resultado recebido %b ", ULA_flags);
      end
     end else begin
      $display("\n\n AND ERROR ", $time,"<-time     \n resultado esperado 0000000000000000","    \n resultado recebido %b ", ULA_OUT);
    end
  end

//-------------------------------------------------------------
  $display("\n\n OR ");
  //ULA_ctrl = 4'b0011;
  @ ( negedge clk ) 
	ULA_ctrl = 4'b0011;
   @ ( posedge clk ) begin
	#1;
    if (ULA_OUT==16'b1111111111111111) begin
      $display("\n\n OR OK ", $time,"<-time   ");
      if (ULA_flags==3'b000) begin
        $display("\n flag OK");
      end else begin
        $display("\n flag ERROR", $time,"<-time        \n resultado esperado 000","   \n resultado recebido %b ", ULA_flags);
      end
     end else begin
      $display("\n OR ERROR ", $time,"<-time      \n resultado esperado 1111111111111111","    \n resultado recebido %b ", ULA_OUT);
    end
  end

//-------------------------------------------------------------
  $display("\n\n XOR ");
  @ ( negedge clk ) 
  ULA_ctrl = 4'b0100;
   @ ( posedge clk ) begin
   #1;
    if (ULA_OUT==16'b1111111111111111) begin
      $display("\n\n XOR OK ", $time,"<-time   ");
      if (ULA_flags==3'b000) begin
        $display("\n\n\ flag OK");
      end else begin
        $display("\n\n\ flag ERROR", $time,"<-time   \n resultado esperado 000","   \n resultado recebido %b ", ULA_flags);
      end
     end else begin
      $display("\n\n XOR ERROR ", $time,"<-time     \n resultado esperado 1111111111111111","   \n resultado recebido %b ", ULA_OUT);
    end
  end

//-------------------------------------------------------------
  $display("\n\n ADD ");
  @ ( negedge clk ) 
  ULA_ctrl = 4'b0000;
   @ ( posedge clk ) begin
   #1;
    if (ULA_OUT==amaisb) begin
      $display("\n\n ADD OK ", $time,"<-time ");
      if (ULA_flags==3'b100) begin
        $display("\n\n\ flag OK");
      end else begin
        $display("\n\n\ flag ERROR", $time,"<-time  \n resultado esperado 100","   \n resultado recebido %b ", ULA_flags);
      end
     end else begin
      $display("\n\n ADD ERROR ", $time,"<-time     \n resultado esperado %b",amaisb,"  \n resultado recebido %b ", ULA_OUT);
    end
  end

//-------------------------------------------------------------
  $display("\n\n SUB ");
  @ ( negedge clk ) 
  ULA_ctrl = 4'b0001;
   @ ( posedge clk ) begin
   #1;
    if (ULA_OUT==amenosb) begin
      $display("\n\n SUB OK ", $time,"<-time");
      if (ULA_flags==3'b000) begin
        $display("\n\n\ flag OK");
      end else begin
        $display("\n\n\ flag ERROR", $time,"<-time   \n resultado esperado 000","   \n resultado recebido %b ", ULA_flags);
      end
     end else begin
      $display("\n\n SUB ERROR ", $time,"<-time     \n resultado esperado %b",amenosb,"     \n resultado recebido %b ", ULA_OUT);
    end
  end

//-------------------------------------------------------------
  $display("\n\n SHR ");
  @ ( negedge clk ) 
  ULA_ctrl = 4'b0101;
   @ ( posedge clk ) begin
   #1;
    if (ULA_OUT==16'b1101010101010101) begin
      $display("\n\n SHR OK ", $time,"<-time");
      if (ULA_flags==3'b100) begin
        $display("\n\n\ flag OK");
      end else begin
        $display("\n\n\ flag ERROR", $time,"<-time  \n  resultado esperado 100","     \n resultado recebido %b ", ULA_flags);
      end
     end else begin
      $display("\n\n SHR ERROR ", $time,"<-time    \n resultado esperado 0101010101010101","  \n resultado recebido %b ", ULA_OUT);
    end
  end

//-------------------------------------------------------------
  $display("\n\n RTR ");
  @ ( negedge clk ) 
  ULA_ctrl = 4'b1101;
   @ ( posedge clk ) begin
   #1;
    if (ULA_OUT==16'b0101010101010101) begin
      $display("\n\n RTR OK ", $time,"<-time");
      if (ULA_flags==3'b000) begin
        $display("\n\n\ flag OK");
      end else begin
        $display("\n\n\ flag ERROR", $time,"<-time    \n resultado esperado 000","  \n  resultado recebido %b ", ULA_flags);
      end
     end else begin
      $display("\n\n RTR ERROR ", $time,"<-time    \n resultado esperado 0101010101010101","    \n resultado recebido %b ", ULA_OUT);
    end
  end

  //-------------------------------------------------------------
  $display("\n\n SHL ");
  @ ( negedge clk )
  ULA_ctrl = 4'b0110;
   @ ( posedge clk ) begin
   #1;
    if (ULA_OUT==16'b0101010101010100) begin
      $display("\n\n SHL OK ", $time,"<-time");
      if (ULA_flags==3'b001) begin
        $display("\n\n\ flag OK");
      end else begin
        $display("\n\n\ flag ERROR", $time,"<-time \n resultado esperado 001","  \n resultado recebido %b ", ULA_flags);
      end
     end else begin
      $display("\n\n SHL ERROR ", $time,"<-time   \n resultado esperado 0101010101010100","    \n resultado recebido %b ", ULA_OUT);
    end
  end

  //-------------------------------------------------------------
  $display("\n\n RTL ");
  @ ( negedge clk ) ULA_ctrl = 4'b1110;
  
   @ ( posedge clk ) begin
   #1;
    if (ULA_OUT==16'b0101010101010101) begin
      $display("\n\n RTL OK ", $time,"<-time ");
      if (ULA_flags==3'b000) begin
        $display("\n\n\ flag OK");
      end else begin
        $display("\n\n\ flag ERROR", $time,"<-time   \n resultado esperado 000","  \n resultado recebido %b ", ULA_flags);
      end
    end else begin
      $display("\n\n RTL ERROR ", $time,"<-time    \n resultado esperado 0101010101010101","  \n resultado recebido %b ", ULA_OUT);
    end
  end


end
endmodule