module DataMEM(
				dataIN,
				dataOUT,
				dataADDR,
				dataLoad,
				dataWrite,
				clk,
				rst,
				)
				/*
				*Paremeter Def's
				*/
				parameter Ncores	 = 2;
				parameter Lmem	 = 8; //0xff +0x1 positions
				parameter TAM=16;
				/*
				* Inputs declaration
				*/
				input wire clk;
				input wire rst;

				input wire [0:TAM-1][0:Ncores-1] dataIN;
				input wire [0:TAM-1][0:Ncores-1] dataADDR;
				input wire [0:Ncores-1] dataWrite;
				input wire [0:Ncores-1] dataLoad;
				/*
				* Output declaration
				*/
				output wire [0:TAM-1][0:Ncores-1] dataOUT;
				/*
				* Internal components
				*/
				reg [0:TAM-1][0:(1<<Lmem)-1][0:Ncore-1] SelfMEM;
				reg [0:TAM-1][0:(1<<Lmem)-1] SharedMEM;
				reg [0:TAM-1][0:Ncores-1] inREG;
				reg [0:TAM-1][0:Ncores-1] OutREG;

				wire [0:Ncore-1] selfCLK;

				assign selfCLK=dataWrite[0:Ncore-1][Lmem];

				always @ ( negedge clk ) begin
					if(dataWrite[i] & ~dataADDR[i][Lmem]) begin
						SelfMEM[0][dataADDR[0:Lmem-1]=dataIN[0];
					end
				end



endmodule;
