//MEM_TB

/*************************************************************************
 *  descricao do testbench da MEM                   versao 2.02          *
 *                                                                       *
 *  Developer: Marlon                              15-12-2016            *
 *             marlonsigales@gmail.com                                   *                                     *
 *  Corrector: 
 *             Mariano                             15-12-2016            *
 *             marianobw@hotmail.com
 *			   Jean Carlos Scheunemann             15-12-2016            *
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

 reg [0:TAM-1]		dataIN0;
 reg [0:TAM-1]		dataIN1;
 reg [0:TAM-1]		dataOUT0;
 reg [0:TAM-1]		dataOUT1;
 reg [0:TAM-1]		dataADDR0;
 reg [0:TAM-1]		dataADDR1;
 reg [0:Ncores-1] 	dataWrite;
 reg [0:Ncores-1] 	dataLoad;

 reg
 
 
 DataMEM #(.Ncores(Ncores), .Lmem(Lmem), .TAM(TAM)) dut (
				dataIN0(dataIN0),
				dataIN1(dataIN1),
				dataOUT0(dataOUT0),
				dataOUT1(dataOUT1),
				dataADDR0(dataADDR0),
				dataADDR1(dataADDR1),
				dataLoad(dataLoad),
				dataWrite(dataWrite),
				clk(clk),
				rst(rst)
				);
 
 
/*-----------------------inicio------------------------*/ 
initial clk = 1'b0;
initial rst = 1'b0;

initial dataADDR0 = 0;
initial dataADDR1 = 0;
initial dataIN0 = 1;
initial dataIN1 = 2;
initial dataLoad = {Ncores{1'b1}};
initial dataWrite = 0;


always #(PERIOD/2) clk = ~clk;
 
 
always @(message)      //sempre que houver mensagem troca as variáveis e mostra se é ok ou não
    begin
	
	$display (" %s ", message);         
    //$stop;  
	
	
        /*random comand sintax:
        min + {$random(seed)}%(max-min+1) or can use $dist_uniform(seed, min, max) */
	
		dataIN0   <=    {tam{1'b0}} + {$random()}%((tam){1'b1});
		dataIN0   <=    {tam{1'b0}} + {$random()}%((tam){1'b1});
		dataADDR0 <=    {tam{1'b0}} + {$random()}%((tam){1'b1});
		dataADDR1 <=    {tam{1'b0}} + {$random()}%((tam){1'b1});
		dataLoad  <= {Ncores{1'b0}} + {$random()}%((Ncores){1'b1});
		dataWrite <= {Ncores{1'b0}} + {$random()}%((Ncores){1'b1});
	   
    end 
 
/*==========================================================*/ 
 
 
 
/*-------------------- testes ---------------------------*/
initial      
//  verifica se oque foi enviado foi escrito... e lido 
    begin 
	
	for (i=0; i<200; i++) begin
	
			@(posedge clk)
				dataWrite=~dataWrite;
				dataLoad=~dataLoad;
				
			@(posedge clk)
				dataWrite=~dataWrite;
				dataLoad=~dataLoad;
						
			if ((dataOUT0 == dataIN0) && (dataOUT1 == dataIN1)) begin
				message = "escrita e leitura teste ok" , $time, "unidade de tempo";
			end
			else begin
				if ((dataOUT0 == dataIN0)) 
					message = "data0 com erro", $time, "unidade de tempo";
				if ((dataOUT1 == dataIN1)) 
					message = "data1 com erro", $time, "unidade de tempo";	
			end
			
			dataADDR0=dataADDR0+1;
			dataADDR1=dataADDR1+1;
			@(posedge clk);
			if ((dataOUT0 == dataIN0) && (dataOUT1 == dataIN1))
				message = "pode ser que está escrevendo em toda memória a mesma coisa" , $time, "unidade de tempo";
	end
	
   
  end 




 
endmodule 