module DataMEM(
				dataIN0,
				dataIN1,
				dataOUT0,
				dataOUT1,
				dataADDR0,
				dataADDR1,
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

				input wire [TAM-1:0] dataIN0;
				input wire [TAM-1:0] dataIN1;
				input wire [TAM-1:0] dataADDR0;
				input wire [TAM-1:0] dataADDR1;
				input wire [Ncores-1:0] dataWrite;
				input wire [Ncores-1:0] dataLoad;
				/*
				* Output declaration
				*/
				output reg [TAM-1:0] dataOUT0;
				output reg [TAM-1:0] dataOUT1;
				/*
				* Internal components
				*/
				reg [TAM-1:0] SelfMEM0 [(1<<Lmem)-1:0] ;
				reg [TAM-1:0] SelfMEM1 [(1<<Lmem)-1:0] ;
				reg [TAM-1:0] SharedMEM [(1<<Lmem)-1:0];
				reg [TAM-1:0] sharedIn1REG;
				reg [Lmem-1:0] sharedIn1ADDR;
				reg sharedCtrlREG;

				wire [TAM-1:0] sharedInDATA;
				wire [Lmem-1:0] sharedInADDR;
				wire [Ncores-1:0] selfWriteCLK;
				wire [Ncores-1:0] selfReadCLK;
				wire  sharedWriteCLK;
				wire [Ncores-1:0] sharedReadCLK;
				wire SharedWriteConflict;

				/*
				* Escrita e leitura na memoria propria
				*/
				//Escrita core 0
				assign selfWriteCLK[0]=dataWrite[0] & ~dataADDR0[Lmem] & ~clk; //sinal auxiliar de comando de escrita na memoria
				always @ ( posedge selfWriteCLK[0]) begin
						SelfMEM0[dataADDR0[Lmem-1:0]]=dataIN0;
				end
				//Leitura core 0
				assign selfReadCLK[0]=dataLoad[0] & ~dataADDR0[Lmem] & ~clk; //sinal auxiliar de comando de leitura na memoria
				always @ ( posedge selfReadCLK[0]) begin
						dataOUT0=SelfMEM0[dataADDR0[Lmem-1:0]];
				end
				//Escrita core 1
				assign selfWriteCLK[1]=dataWrite[1] & ~dataADDR1[Lmem] & ~clk; //sinal auxiliar de comando
				always @ ( posedge selfWriteCLK[1]) begin
						SelfMEM1[dataADDR1[Lmem-1:0]]=dataIN1;
				end
				//Leitura core 1
				assign selfReadCLK[1]=dataLoad[1] & ~dataADDR1[Lmem] & ~clk; //sinal auxiliar de comando de leitura na memoria
				always @ ( posedge selfReadCLK[1]) begin
						dataOUT1=SelfMEM1[dataADDR1[Lmem-1:0]];
				end
				/*
				* Leitura e escrita na memoria compartilhada
				*/

				//Leitura
				//cpu0
				assign sharedReadCLK[0]=dataLoad[0] & dataADDR0[Lmem] & ~clk;
				always @ ( posedge sharedReadCLK[0]) begin
						dataOUT0=SharedMEM[dataADDR0[Lmem-1:0]];
				end
				//cpu1
				assign sharedReadCLK[1]=dataLoad[1] & dataADDR1[Lmem] & ~clk;
				always @ ( posedge sharedReadCLK[1]) begin
						dataOUT1=SharedMEM[dataADDR1[Lmem-1:0]];
				end
				//Escrita
				assign SharedWriteConflict=(dataWrite[1] & dataADDR1[Lmem])&(dataWrite[0] & dataADDR0[Lmem]);
				always @ ( posedge SharedWriteConflict ) begin
					sharedCtrlREG=1;
					sharedIn1REG=dataIN1;
					sharedIn1ADDR=dataADDR1[Lmem-1:0];
				end
				assign sharedWriteCLK=((dataWrite[1] & dataADDR1[Lmem])|(dataWrite[0] & dataADDR0[Lmem]) | sharedCtrlREG) & ~clk; //<----------- verificar se funciona
				assign sharedInDATA = (dataWrite[0] & dataADDR0[Lmem]) ? dataIN0 : ( sharedCtrlREG ? sharedIn1REG : dataIN1 ); //Data Mux
				assign sharedInADDR = (dataWrite[0] & dataADDR0[Lmem]) ? dataADDR0[Lmem-1:0] : ( sharedCtrlREG ? sharedIn1ADDR : dataADDR1[Lmem-1:0]);// ADDR mux
				always @ ( posedge sharedWriteCLK ) begin
					SharedMEM[sharedInADDR]=sharedInDATA;
					if(~(((dataWrite[1] & dataADDR1[Lmem])|(dataWrite[0] & dataADDR0[Lmem]))&sharedCtrlREG))
							sharedCtrlREG=0;
				end



endmodule
