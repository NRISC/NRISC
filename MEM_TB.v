//MEM_TB

/*************************************************************************
 *  descricao do testbench da MEM                   versao 2.02          *
 *                                                                       *
 *  Developer: Mariano                              11-03-2017           *
 *             marianobw@hotmail.com                                     *                                     
 *  		   Marlon                               08-03-2017           *
 *             marlonsigales@gmail.com                                   *
 *	Corrector: Jean Carlos Scheunemann              08-03-2017           *
 *             jeancarsch@gmail.com                                      *
 *                                                                       *
 *************************************************************************/ 
 `timescale 1 ns / 1 ns  // only for cadence, comment in modelSim
 
 module MEM_TB;
 
 parameter Ncores = 2;
 parameter Lmem	 = 8; //0xff +0x1 positions
 parameter TAM=16;

 localparam integer PERIOD = 10;
 
 reg clk;
 reg rst;

 reg [TAM-1:0]		dataIN0;
 reg [TAM-1:0]		dataIN1;
 wire [TAM-1:0]		dataOUT0;
 wire [TAM-1:0]		dataOUT1;
 reg [TAM-1:0]		dataADDR0;
 reg [TAM-1:0]		dataADDR1;
 reg [Ncores-1:0] 	dataWrite;
 reg [Ncores-1:0] 	dataLoad;

 
 // Device Under Test instantiation <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 DataMEM #(.Ncores(Ncores), .Lmem(Lmem), .TAM(TAM)) dut
				(
				.dataIN0(dataIN0),
				.dataIN1(dataIN1),
				.dataOUT0(dataOUT0),
				.dataOUT1(dataOUT1),
				.dataADDR0(dataADDR0),
				.dataADDR1(dataADDR1),
				.dataLoad(dataLoad),
				.dataWrite(dataWrite),
				.clk(clk),
				.rst(rst)
				);
 
 
/*-----------------------inicio------------------------*/ 
initial clk = 1'b0;
initial rst = 1'b0;

initial dataADDR0 = 0;
initial dataADDR1 = 0;
initial dataIN0 = 1;
initial dataIN1 = 2;
initial dataLoad = 0;
initial dataWrite = 0;

reg x;				// flag de controle
initial x=0;        // flag de controle
reg[1:0] i;         // flag de controle
initial i=0;        // flag de controle

always #(PERIOD/2) clk = ~clk;  // geração do clock
 
 
 // random value generation
always @(x)     
    begin

        /*random comand sintax:
        min + {$random(seed)}%(max-min+1) or can use $dist_uniform(seed, min, max) */
		#4 // espera estabilizar a saída
		dataIN0   <= {$random()}%(17'b11111111111111111);
		dataIN1   <= {$random()}%(17'b11111111111111111);
		dataADDR0 <= {$random()}%(9'b111111111);
		dataADDR1 <= {$random()}%(8'b11111111);

	   
    end 
 
/*==========================================================*/ 
 
 always @(posedge clk)begin
	
	if ((i==2)||(i==0))begin	// escrita da memória
		dataWrite=2'b11;
		dataLoad=2'b00;	
		i=1;
	end else if (i==1)begin		// leitura da memória
		dataWrite=2'b00;
		dataLoad=2'b11;
		i=2;
	end
 end
/*-------------------- testes ---------------------------*/

 always@(negedge clk) begin	
	if(i==2)begin
	#1 // espera estabilizar a saída
	
		if ((dataOUT0 == dataIN0) && (dataOUT1 == dataIN1)) begin
			$display("\n \n escrita e leitura teste ok" , $time, "   unidade de tempo");
			x=~x;
		end else begin
			if ((dataOUT1 == dataIN1))begin 
				$display("\n \n data0 com erro", $time, "   unidade de tempo","\n      recebido ",dataOUT0,"\n      esperado  ",dataIN0);
				x=~x;
			end else if ((dataOUT0 == dataIN0))begin
				$display("\n \n data1 com erro", $time, "   unidade de tempo","\n      recebido ",dataOUT1,"\n      esperado  ",dataIN1);	
				x=~x;
			end else begin
				$display("\n\n  ERRO ", $time, "   unidade de tempo");
				$display("\n data0 com erro","\n      recebido ",dataOUT0,"\n      esperado  ",dataIN0);
				$display("\n data1 com erro","\n      recebido ",dataOUT1,"\n      esperado  ",dataIN1);
				x=~x;
			end
			
			
		end
 	end
 
 
 
 end 

 
endmodule 