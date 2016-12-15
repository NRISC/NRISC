//ULA_TB 2

/*************************************************************************
 *  descricao do testbench da ula                   versao 2.01          *
 *                                                                       *
 *  Developer: Mariano                             15-12-2016            *
 *             marianobw@hotmail.com                                     *
 *  Corrector: Marlon                              15-12-2016            *
 *             marlonsigales@gmail.com                                   *
 *			   Jean Carlos Scheunemann             15-12-2016            *
 *             jeancarsch@gmail.com                                      *
 *                                                                       *
 *************************************************************************/ 
 
 `timescale 1 ns / 1 ns  // only for cadence, comment in modelSim

module ULA_TB2;

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

  // random value generation
always @(posedge clk)      
    begin
      /*random comand sintax:
        min + {$random(seed)}%(max-min+1) or can use $dist_uniform(seed, min, max) */
		ULA_A <= 16'b0 + {$random()}%(17'b11111111111111111) ; 
		ULA_B <= 16'b0 + {$random()}%(17'b11111111111111111) ; 
		ULA_ctrl[3:0] <= 4'b0 + {$random()}%(5'b11111) ; 
		//if ((ULA_ctrl[2:0]==3'b101) | (ULA_ctrl[2:0]==3'b110)) begin
		//	ULA_ctrl[3] <= 1'b0 + {$random()}%(2'b11) ;
		//	//ULA_ctrl[3] <= $dist_uniform(0, 0, 1) ;
		//end else begin
		//	ULA_ctrl[3]=0;
		//end
	  
    end
  
  
  
  

 
initial rst = 1; // conforme visto no codigo do Marlon reset e ativo em baixo
initial incdec = 0;
initial cmp2= 0;



//reg [TAM-1:0] A,B;
reg [TAM-1:0] amaisb;  // 0000
reg [TAM-1:0] amenosb; // 0001
reg [TAM-1:0] aandb;   // 0010
reg [TAM-1:0] aorb;    // 0011
reg [TAM-1:0] axorb;   // 0100
reg [TAM-1:0] ashr;    // 0101
reg [TAM-1:0] artr;    // 1101
reg [TAM-1:0] ashl;    // 0110
reg [TAM-1:0] artl;    // 1110
reg [TAM-1:0] anot;    // 0111

always @ ( ULA_A, ULA_B, clk ) begin
	amaisb = ULA_A + ULA_B;
	amenosb = ULA_A - ULA_B; 
	anot = ~ULA_A;
	aandb = ULA_A & ULA_B;
	aorb = ULA_A | ULA_B;
	axorb = ULA_A ^ ULA_B;
	ashr = ULA_A >> 1;
	artr = {ULA_A[0],ULA_A[TAM-1:1]};
	ashl = ULA_A << 1;
	artl = {ULA_A[TAM-2:0],ULA_A[TAM-1]};
	
end
  
  
always @ ( posedge clk ) begin
	#1;
	case (ULA_ctrl)
		4'b0000: begin
					if (ULA_OUT==amaisb)begin
					end else begin
					$display($time,"\n\n ADD ERROR     \n resultado esperado %b",amaisb,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b0001: begin
					if (ULA_OUT==amenosb)begin
					end else begin
					$display($time,"\n\n SUB ERROR     \n resultado esperado %b",amenosb,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b0010: begin
					if (ULA_OUT==aandb)begin
					end else begin
					$display($time,"\n\n AND ERROR     \n resultado esperado %b",aandb,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b0011: begin
					if (ULA_OUT==aorb)begin
					end else begin
					$display($time,"\n\n OR ERROR     \n resultado esperado %b",aorb,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b0100: begin
					if (ULA_OUT==axorb)begin
					end else begin
					$display($time,"\n\n XOR ERROR     \n resultado esperado %b",axorb,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b0101: begin
					if (ULA_OUT==ashr)begin
					end else begin
					$display($time,"\n\n ADD ERROR     \n resultado esperado %b",ashr,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b1101: begin
					if (ULA_OUT==artr)begin
					end else begin
					$display($time,"\n\n ADD ERROR     \n resultado esperado %b",artr,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b0110: begin
					if (ULA_OUT==ashl)begin
					end else begin
					$display($time,"\n\n ADD ERROR     \n resultado esperado %b",ashl,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b1110: begin
					if (ULA_OUT==artl)begin
					end else begin
					$display($time,"\n\n ADD ERROR     \n resultado esperado %b",artl,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b0111: begin
					if (ULA_OUT==anot)begin
					end else begin
					$display($time,"\n\n ADD ERROR     \n resultado esperado %b",anot,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		
	endcase
end
 endmodule