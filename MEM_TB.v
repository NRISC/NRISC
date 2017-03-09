//MEM_TB

/*************************************************************************
 *  descricao do testbench da MEM                   versao 2.02          *
 *                                                                       *
 *  Developer: Mariano                             15-12-2016            *
 *             marianobw@hotmail.com                                     *
 *  Corrector: Marlon                              15-12-2016            *
 *             marlonsigales@gmail.com                                   *
 *			   Jean Carlos Scheunemann             15-12-2016            *
 *             jeancarsch@gmail.com                                      *
 *                                                                       *
 *************************************************************************/ 
 module MEM_TB;
 
 parameter Ncores	 = 2;
 parameter Lmem	 = 8; //0xff +0x1 positions
 parameter TAM=16;

 wire clk;
 wire rst;

 wire [0:TAM-1][0:Ncores-1] dataIN;
 wire [0:TAM-1][0:Ncores-1] dataADDR;
 wire [0:Ncores-1] dataWrite;
 wire [0:Ncores-1] dataLoad;

 wire [0:TAM-1][0:Ncores-1] dataOUT;
 
 
 
 
 
 DataMEM DUT
			(
				.dataIN(dataIN),
				.dataOUT(dataOUT),
				.dataADDR(dataADDR),
				.dataLoad(dataLoad),
				.dataWrite(dataWrite),
				.clk(clk),
				.rst(rst),
				)
 