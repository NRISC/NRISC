//MUX TB

/*************************************************************************
 *  descricao do testbench dos mux                  versao 1.00          *
 *                                                                       *
 *  Developer: Mariano                             13-01-2017            *
 *             marianobw@hotmail.com                                     *
 *  Corrector: Marlon                              xx-xx-xxxx            *
 *             marlonsigales@gmail.com                                   *
 *			   Jean Carlos Scheunemann             xx-xx-xxxx            *
 *             jeancarsch@gmail.com                                      *
 *                                                                       *
 *************************************************************************/ 
 `timescale 1 ns / 1 ns  // only for cadence, comment in modelSim
 
 
 module mux4_tb;
 
 localparam integer PERIOD = 10;

 parameter TAM = 16;
 
 
reg [TAM-1:0] MUX_in0,MUX_in1,MUX_in2,MUX_in3;
wire [TAM-1:0] MUX_Out;
reg [3:0] MUX_sel;
 
 
  // Device Under Test instantiation <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
mux4x1 DUT
  (
  .MUX_in0 (MUX_in0),
  .MUX_in1 (MUX_in1),
  .MUX_in2 (MUX_in2),
  .MUX_in3 (MUX_in3),

  .MUX_Out (MUX_Out),
  .MUX_sel (MUX_sel)
  
  );
 
 
 // clock generation
 reg clk;
 initial clk = 1'b0;
  always #(PERIOD/2) clk = ~clk;
 
 always @(posedge clk)      
    begin
      /*random comand sintax:
        min + {$random(seed)}%(max-min+1) or can use $dist_uniform(seed, min, max) */
		MUX_in0 = {$random()}%(17'b11111111111111111) ; 
		MUX_in1 = {$random()}%(17'b11111111111111111) ; 
		MUX_in2 = {$random()}%(17'b11111111111111111) ; 
		MUX_in3 = {$random()}%(17'b11111111111111111) ; 
		MUX_sel = {$random()}%(3'b111) ; 
    end
 
	wire s0;//seleções
	wire s1;
		
	
	assign {s1,s0}= MUX_sel;
 
 always @ ( posedge clk ) begin
	#1;
	case ({s1,s0})
		2'b00:begin
			if (MUX_Out==MUX_in0)begin
			
				end else begin
					$display("\n \n", $time,"\n MUX_in0 ERROR     \n resultado esperado %b",MUX_in0,"  \n resultado recebido %b ", MUX_Out);
				end
			end
 		2'b01:begin
			if (MUX_Out==MUX_in1)begin
			
				end else begin
					$display("\n \n", $time,"\n MUX_in1 ERROR     \n resultado esperado %b",MUX_in1,"  \n resultado recebido %b ", MUX_Out);
				end
			end
 		2'b10:begin
			if (MUX_Out==MUX_in2)begin
			
				end else begin
					$display("\n \n", $time,"\n MUX_in2 ERROR     \n resultado esperado %b",MUX_in2,"  \n resultado recebido %b ", MUX_Out);
				end
			end
 		2'b11:begin
			if (MUX_Out==MUX_in0)begin
			
				end else begin
					$display("\n \n", $time,"\n MUX_in3 ERROR     \n resultado esperado %b",MUX_in3,"  \n resultado recebido %b ", MUX_Out);
				end
			end
 
 	endcase
 end
 endmodule
 
 
 
 
 
 