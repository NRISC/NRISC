module DataMEM(
				dataIN,
				dataOUT,
				dataADDR,
				dataLoad,
				dataWrite,
				clk,
				rst,
				);
				/*
				*Paremeter Def's
				*/
				parameter Ncores=2;
				parameter Lmem=8; //0xff +0x1 positions
				parameter TAM=16;
				/*
				* Inputs declaration
				*/
				input wire clk;
				input wire rst;

				input wire [0:TAM-1] dataIN[0:Ncores-1];
				input wire [0:TAM-1] dataADDR[0:Ncores-1] ;
				input wire [0:Ncores-1] dataWrite;
				input wire [0:Ncores-1] dataLoad;
				/*
				* Output declaration
				*/
				output wire [0:TAM-1] dataOUT [0:Ncores-1];
				/*
				* Internal components
				*/
				reg [0:TAM-1]SelfMEM [0:(1<<Lmem)-1][0:Ncores-1] ;
				reg [0:TAM-1] SharedMEM [0:(1<<Lmem)-1];
				reg [0:TAM-1] inREG [0:Ncores-1];
				reg [0:TAM-1] OutREG [0:Ncores-1];

				wire [0:Ncores-1] selfWriteCLK;

				assign selfWriteCLK[0]=dataWrite[0] & ~dataADDR[0][Lmem] & ~clk; //sinal auxiliar de comando
				assign selfWriteCLK[1]=dataWrite[1] & ~dataADDR[1][Lmem] & ~clk; //sinal auxiliar de comando

				always @ ( negedge selfWriteCLK[0]) begin
						SelfMEM[0][dataADDR[0:Lmem-1]]=dataIN[0];
				end

				always @ ( negedge selfWriteCLK[1]) begin
						SelfMEM[1][dataADDR[0:Lmem-1]]=dataIN[1];
				end



endmodule;
