module DataMEM(
				dataIN,
				dataOUT,
				dataADDR,
				dataCTRL,
				clk,
				rst,
				)
				/*
				*Paremeter Def's
				*/
				parameter Ncores	 = 2;
				parameter Lmem	 = 0xff;
				parameter TAM=16;
				/*
				* Inputs declaration
				*/
				input wire clk;
				input wire rst;

				input wire [0:TAM-1][0:Ncores-1] dataIN;
				input wire [0:TAM-1][0:Ncores-1] dataADDR;
				input wire  [0:1][0:Ncores-1] dataCTRL;
				/*
				* Output declaration
				*/
				output wire [0:TAM-1][0:Ncores-1] dataOUT;
				/*
				* Internal components
				*/
				reg [0:TAM-1][0:Lmem][0:Ncore-1] SelfMEM;
				reg [0:TAM-1][0:Lmem] SharedMEM;
				reg [0:TAM-1][0:Ncores-1] inREG;
				reg [0:TAM-1][0:Ncores-1] OutREG;


endmodule;
