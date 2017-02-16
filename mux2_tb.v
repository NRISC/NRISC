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
 
 
 module mux2_tb;
 
 localparam integer PERIOD = 10;

 parameter TAM = 16;
 
 
reg [TAM-1:0] MUX_in0,MUX_in1;
wire [TAM-1:0] MUX_Out;
reg  [3:0]MUX_sel;

 
 
  // Device Under Test instantiation <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
mux2x1 DUT
  (
  .MUX_in0 (MUX_in0),
  .MUX_in1 (MUX_in1),

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
		MUX_sel = {$random()}%(4'b1111) ; 
    end
 
	wire s0;//seleções
	
		
	
	assign {s0}= MUX_sel;
 
 always @ ( posedge clk ) begin
	#1;
	case (s0)
		1'b0:begin
			if (MUX_Out==MUX_in0)begin
			
				end else begin
					$display("\n \n", $time,"\n MUX_in0 ERROR     \n resultado esperado %b",MUX_Out,"  \n resultado recebido %b ", MUX_in0);
				end
			end
 		1'b1:begin
			if (MUX_Out==MUX_in1)begin
			
				end else begin
					$display("\n \n", $time,"\n MUX_in1 ERROR     \n resultado esperado %b",MUX_Out,"  \n resultado recebido %b ", MUX_in1);
				end
			end
 
 	endcase
 end
 endmodule
 
 
 
 
 
 