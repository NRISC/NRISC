module ZueiraCore(
                GPIN,
                GPOUT,
                clk,
                rst
              );
      parameter TAM=16;     //tamanho da palavra de dados
      parameter LDataMem=8; // 256 posicoes proprias e 256 compartilhadas( sempre simetrico)
      parameter LProgMem=8; // 256 instrucoes
      parameter NStack=8;   //profundidade da pilha
      parameter Ncores=2;   //numero de processadores(implementados de maneira parcial, funciona soh para 1 e 2)
      /*
      * port conections
      */
      input wire clk;
      input wire rst;

      input wire [TAM-1:0] GPIN;
      output wire [TAM-1:0] GPOUT;
      //DATA signals
      wire [TAM-1:0] CPU0_DATA, CPU1_DATA, DATA_CPU0, DATA_CPU1, CPU0_DATAAddr,CPU1_DATAAddr;
      wire  CPU0_DATALoad,CPU1_DATALoad,CPU0_DATAWrite,CPU1_DATAWrite;
      //CPU signals
      wire [15:0] CPU0_InstructionIN,CPU1_InstructionIN;
      wire [1:0] CPU0_Status,CPU1_Status;
      wire [TAM-1:0] CPU0_PC,CPU1_PC;

      //PROG MEM

      CPU #(.TAM(TAM),.NStack(NStack))
          NRISC0( // DATA MEM
          			.DATA_IN(DATA_CPU0),
          			.DATA_Out(CPU0_DATA),
          			.CORE_DATA_write(CPU0_DATAWrite),
          			.CORE_DATA_load(CPU0_DATALoad),
          			.CORE_DATA_ADDR(CPU0_DATAAddr),
          			.Instruction(CPU0_InstructionIN),
          			.CORE_Status(CPU0_Status),
          			.ProgADDR(CPU0_PC),
          			.clk(clk),
          			.rst(rst)
      			);
      CPU #(.TAM(TAM),.NStack(NStack))
          NRISC1( // DATA MEM
          			.DATA_IN(DATA_CPU1),
          			.DATA_Out(CPU1_DATA),
          			.CORE_DATA_write(CPU1_DATAWrite),
          			.CORE_DATA_load(CPU1_DATALoad),
          			.CORE_DATA_ADDR(CPU1_DATAAddr),
          			.Instruction(CPU1_InstructionIN),
          			.CORE_Status(CPU1_Status),
          			.ProgADDR(CPU1_PC),
          			.clk(clk),
          			.rst(rst)
      			);
      progMEM #(.TAM(TAM),.Lmem(LProgMem),.ProgFile("CORE0.hex"))
          PROGMEM0(
                      .Instruction(CPU0_InstructionIN),
                      .progADDR(CPU0_PC),
                      .CoreStatus(CPU0_Status),
                      .clk(clk),
                      .rst(rst)
                      );

      progMEM #(.TAM(TAM),.Lmem(LProgMem),.ProgFile("CORE1.hex"))
          PROGMEM1(
                      .Instruction(CPU1_InstructionIN),
                      .progADDR(CPU1_PC),
                      .CoreStatus(CPU1_Status),
                      .clk(clk),
                      .rst(rst)
                      );

      DataMEM #(.TAM(TAM),.Lmem(LDataMem),.Ncores(Ncores))
          DATA (
      				.dataIN0(CPU0_DATA),
      				.dataIN1(CPU1_DATA),
      				.dataOUT0(DATA_CPU0),
      				.dataOUT1(DATA_CPU1),
      				.dataADDR0(CPU0_DATAAddr),
      				.dataADDR1(CPU1_DATAAddr),
      				.dataLoad({CPU1_DATALoad,CPU0_DATALoad}),
      				.dataWrite({CPU1_DATAWrite,CPU0_DATAWrite}),
      				.GPIN(GPIN),
      				.GPOUT(GPOUT),
      				.clk(clk),
      				.rst(rst)
				    );

endmodule
