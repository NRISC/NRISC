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
				reg [TAM-1:0] SelfMEM0 [0:(1<<Lmem)-1] ;
				reg [TAM-1:0] SelfMEM1 [0:(1<<Lmem)-1] ;
				reg [TAM-1:0] SharedMEM [0:(1<<Lmem)-1];
				reg [TAM-1:0] sharedIn1REG;
				reg [Lmem-1:0] sharedIn1ADDR;
				reg sharedCtrlREG;

				wire [TAM-1:0] sharedInDATA;
				wire [Lmem-1:0] sharedInADDR;
				wire [Ncores-1:0] selfWriteCLK;
				wire [Ncores-1:0] selfReadCLK;
				wire  sharedWriteCLK;
				wire [Ncores-1:0] sharedReadCLK;

				/*
				* Escrita e leitura na memoria propria
				*/
				//Escrita core 0
				assign selfWriteCLK[0]=dataWrite[0] & ~dataADDR0[Lmem] & ~clk; //sinal auxiliar de comando de escrita na memoria
				always @ ( posedge selfWriteCLK[0]) begin
						SelfMEM0[0][dataADDR0[Lmem-1:0]]=dataIN0[0];
				end
				//Leitura core 0
				assign selfReadCLK[0]=dataLoad[0] & ~dataADDR0[Lmem] & ~clk; //sinal auxiliar de comando de leitura na memoria
				always @ ( posedge selfReadCLK[0]) begin
						dataOUT0=SelfMEM0[0][dataADDR0[Lmem-1:0]];
				end
				//Escrita core 1
				assign selfWriteCLK[1]=dataWrite[1] & ~dataADDR1[Lmem] & ~clk; //sinal auxiliar de comando
				always @ ( posedge selfWriteCLK[1]) begin
						SelfMEM1[1][dataADDR1[Lmem-1:0]]=dataIN1[1];
				end
				//Leitura core 1
				assign selfReadCLK[1]=dataLoad[1] & ~dataADDR1[Lmem] & ~clk; //sinal auxiliar de comando de leitura na memoria
				always @ ( posedge selfReadCLK[1]) begin
						dataOUT1=SelfMEM0[1][dataADDR1[Lmem-1:0]];
				end
				/*
				* Leitura e escrita na memoria compartilhada
				*/

				//Leitura
				//cpu0
				assign sharedReadCLK[0]=dataLoad[0] & dataADDR0[Lmem] & ~clk;
				always @ ( posedge sharedReadCLK[0]) begin
						dataOUT0=SharedMEM[0][dataADDR1[Lmem-1:0]];
				end
				//cpu1
				assign sharedReadCLK[1]=dataLoad[1] & dataADDR1[Lmem] & ~clk;
				always @ ( posedge sharedReadCLK[1]) begin
						dataOUT1=SharedMEM[1][dataADDR1[Lmem-1:0]];
				end
				//Escrita
				always @ ( negedge clk ) begin
					sharedCtrlREG=dataWrite[0] & dataWrite[1] & dataADDR1[Lmem];
					sharedIn1REG=dataIN1;
					sharedIn1ADDR=dataADDR1[Lmem-1:0];
				end
				assign sharedWriteCLK=(dataWrite[0] | sharedCtrlREG) & ~clk; //<----------- verificar se funciona
				assign sharedInDATA = (dataLoad[0]) ? dataIN0 : ( sharedCtrlREG ? sharedIn1REG : dataIN1 ); //Data Mux
				assign sharedInADDR = (dataLoad[0]) ? dataADDR0[Lmem-1:0] : ( sharedCtrlREG ? sharedIn1ADDR : dataADDR1[Lmem-1:0]);// ADDR mux
				always @ ( posedge sharedWriteCLK ) begin
					SharedMEM[sharedInADDR]=sharedInDATA;
				end



endmodule;
