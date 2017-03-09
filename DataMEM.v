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

				input wire [0:TAM-1] dataIN0;
				input wire [0:TAM-1] dataIN1;
				input wire [0:TAM-1] dataADDR0;
				input wire [0:TAM-1] dataADDR1;
				input wire [0:Ncores-1] dataWrite;
				input wire [0:Ncores-1] dataLoad;
				/*
				* Output declaration
				*/
				output reg [0:TAM-1] dataOUT0;
				output reg [0:TAM-1] dataOUT1;
				/*
				* Internal components
				*/
				reg [0:TAM-1] SelfMEM0 [0:(1<<Lmem)-1] ;
				reg [0:TAM-1] SelfMEM1 [0:(1<<Lmem)-1] ;
				reg [0:TAM-1] SharedMEM [0:(1<<Lmem)-1];
				reg [0:TAM-1] sharedIn1REG;
				reg [0:Lmem-1] sharedIn1ADDR;
				reg sharedCtrlREG;

				wire [0:TAM-1] sharedInDATA;
				wire [0:Lmem-1] sharedInADDR;
				wire [0:Ncores-1] selfWriteCLK;
				wire [0:Ncores-1] selfReadCLK;
				wire  sharedWriteCLK;
				wire [0:Ncores-1] sharedReadCLK;

				/*
				* Escrita e leitura na memoria propria
				*/
				//Escrita core 0
				assign selfWriteCLK[0]=dataWrite[0] & ~dataADDR0[Lmem] & ~clk; //sinal auxiliar de comando de escrita na memoria
				always @ ( posedge selfWriteCLK[0]) begin
						SelfMEM0[0][dataADDR0[0:Lmem-1]]=dataIN0[0];
				end
				//Leitura core 0
				assign selfReadCLK[0]=dataLoad[0] & ~dataADDR0[Lmem] & ~clk; //sinal auxiliar de comando de leitura na memoria
				always @ ( posedge selfReadCLK[0]) begin
						dataOUT0=SelfMEM0[0][dataADDR0[0:Lmem-1]];
				end
				//Escrita core 1
				assign selfWriteCLK[1]=dataWrite[1] & ~dataADDR1[Lmem] & ~clk; //sinal auxiliar de comando
				always @ ( posedge selfWriteCLK[1]) begin
						SelfMEM1[1][dataADDR1[0:Lmem-1]]=dataIN1[1];
				end
				//Leitura core 1
				assign selfReadCLK[1]=dataLoad[1] & ~dataADDR1[Lmem] & ~clk; //sinal auxiliar de comando de leitura na memoria
				always @ ( posedge selfReadCLK[1]) begin
						dataOUT1=SelfMEM0[1][dataADDR1[0:Lmem-1]];
				end
				/*
				* Leitura e escrita na memoria compartilhada
				*/

				//Leitura
				//cpu0
				assign sharedReadCLK[0]=dataLoad[0] & dataADDR0[Lmem] & ~clk;
				always @ ( posedge sharedReadCLK[0]) begin
						dataOUT0=SharedMEM[0][dataADDR1[0:Lmem-1]];
				end
				//cpu1
				assign sharedReadCLK[1]=dataLoad[1] & dataADDR1[Lmem] & ~clk;
				always @ ( posedge sharedReadCLK[1]) begin
						dataOUT1=SharedMEM[1][dataADDR1[0:Lmem-1]];
				end
				//Escrita
				always @ ( negedge clk ) begin
					sharedCtrlREG=dataWrite[0] & dataWrite[1] & dataADDR1[Lmem];
					sharedIn1REG=dataIN1;
					sharedIn1ADDR=dataADDR1[0:Lmem-1];
				end
				assign sharedWriteCLK=(dataWrite[0] | sharedCtrlREG) & ~clk; //<----------- verificar se funciona
				assign sharedInDATA = (dataLoad[0]) ? dataIN0 : ( sharedCtrlREG ? sharedIn1REG : dataIN1 ); //Data Mux
				assign sharedInADDR = (dataLoad[0]) ? dataADDR0[0:Lmem-1] : ( sharedCtrlREG ? sharedIn1ADDR : dataADDR1[0:Lmem-1]);// ADDR mux
				always @ ( posedge sharedWriteCLK ) begin
					SharedMEM[sharedInADDR]=sharedInDATA;
				end



endmodule;
