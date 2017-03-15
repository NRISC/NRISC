//CPU

/*************************************************************************
 *  descricao da CPU                                versao 0.01          *
 *                                                                       *
 *  Developer: Mariano                             11-01-2017            *
 *             marianobw@hotmail.com                                     *
 *  Corrector: Marlon                              15-12-2016            *
 *             marlonsigales@gmail.com                                   *
 *			   Jean Carlos Scheunemann             15-12-2016            *
 *             jeancarsch@gmail.com                                      *
 *                                                                       *
 *************************************************************************/ 
 
 `timescale 1 ns / 1 ns  // only for cadence, comment in modelSim

module CPU( // DATA MEM
			DATA_IN,			
			DATA_Out,
			CORE_DATA_write,
			CORE_DATA_load,
			CORE_DATA_ADDR,
			

			// PROG MEM
			Instruction,
			CORE_Status
			ProgADDR//,
			
			clk,
			rst

			);

//localparam integer PERIOD = 10;

parameter TAM = 16;

// clock generation
//initial clk = 1'b0;
//  always #(PERIOD/2) clk = ~clk;

output wire[TAM-1:0] DATA_IN;
input wire[TAM-1:0] DATA_Out;
output wire CORE_DATA_write;
output wire CORE_DATA_load;
output reg [TAM-1:0] CORE_DATA_ADDR;


//input wire[TAM-1:0] Instruction;
output wire CORE_Status;

input wire rst;
input wire clk;

//reg  [TAM-1:0] RF1;
//reg  [TAM-1:0] RF2;

reg [3:0] ULA_ctrl;

wire [TAM-1:0] ULA_OUT;



reg [TAM-1:0] PC;
wire [2:0] STACK_FLAGS;
wire [TAM-1:0] STACK_OUT

reg  [TAM-1:0] CORE_InstructionIN;   
wire CORE_InstructionToREGMux;
reg  [2:0] CORE_ctrl;             
wire [1:0] CORE_Status;
wire [3:0] CORE_ULA_ctrl; ///
reg  [2:0] CORE_ULA_flags, ULA_flags, flag; ///      
wire CORE_ULAMux_inc_dec; ///
wire [3:0] CORE_REG_RF1;
wire [3:0] CORE_REG_RF2;
wire [3:0] CORE_REG_RD;
wire CORE_DATA_ADDR_clk;
wire DATA_ADD
wire CORE_DATA_REGMux;
wire CORE_STACK_ctrl;
wire [1:0] CORE_PC_ctrl;          
wire CORE_PC_clk;
//reg  clk;
//reg  rst;



reg write;
//reg rst;

//reg [3:0] CORE_REG_RD;
//reg [3:0] CORE_REG_RF1;
//reg [3:0] CORE_REG_RF2;

reg [TAM-1:0] RD;

wire [TAM-1:0] RF1;
wire [TAM-1:0] RF2;

		
// Device Under Test instantiation <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 
NRISC_ULA #(.TAM(TAM)) DUT(
			.ULA_A (RF1), ///
			.ULA_B (RF2), /// 
			.incdec(CORE_ULAMux_inc_dec), ///
			.ULA_ctrl (CORE_ULA_ctrl),  ///
			.ULA_OUT (ULA_OUT),///
			.ULA_flags (ULA_flags) ///
			
			);
			
			
REGs DUT #(.TAM(TAM)) (
              .RD(RD), ///
              .RF1(RF1), ///
              .RF2(RF2), ///
              .CORE_REG_RD(CORE_REG_RD), ///
              .CORE_REG_RF1(CORE_REG_RF1), ///
              .CORE_REG_RF2(CORE_REG_RF2), ///
              .write(CORE_REG_write), ///
              .rst(rst)
            );

			
NRISC_CORE DUT #(.TAM(TAM))(
			.CORE_InstructionIN(CORE_InstructionIN),///		    		//instruction input
			.CORE_InstructionToREGMux(CORE_InstructionToREGMux),///		//MUX ctrl of instruction in to REGs
			.CORE_ctrl(CORE_ctrl),	//não implementado	   				//CORE external input ctrl BUS
			.CORE_Status(CORE_Status),///					   			//CORE status output
			.CORE_ULA_ctrl(CORE_ULA_ctrl),	 ///			   			//ULA output ctrl BUS
			.CORE_ULA_flags(CORE_ULA_flags),	///		   				//ULA flags input
			.CORE_ULAMux_inc_dec(CORE_ULAMux_inc_dec), ///   			//ULA Inc/dec output MUX ctrl
			.CORE_REG_RF1(CORE_REG_RF1),///				   				//REGs to ULA ctrl 1
			.CORE_REG_RF2(CORE_REG_RF2),///				   				//REGs to ULA ctrl 2
			.CORE_REG_RD(CORE_REG_RD),	///				   				//REGs inputs ctrl
			.CORE_REG_write(CORE_REG_write),///				   			//REGs write ctrl
			.CORE_DATA_write(CORE_DATA_write),	///			   			//DATA write ctrl
			.CORE_DATA_load(CORE_DATA_load), ///						//DATA load ctrl
			.CORE_DATA_ADDR_clk(CORE_DATA_ADDR_clk),/// 				//DATA clk
			.CORE_DATA_REGMux(CORE_DATA_REGMux), ///					//DATA to REGs MUX
			.CORE_STACK_ctrl(CORE_STACK_ctrl),							//CORE to STACK ctrl
			.CORE_PC_ctrl(CORE_PC_ctrl),//não implementado				//CORE to PC ctrl MUX
			.CORE_PC_clk(CORE_PC_clk),	//não implementado				//PC clk
			.clk(clk),													//Main clk source
			.rst(rst)													//general rst
			);

//------------------------------------

wire[TAM-1:0] LI_inst;

assign LI_inst = (CORE_InstructionToREGMux)? {8{CORE_InstructionIN[7]},CORE_InstructionIN[7:0]} : ULA_OUT;

assign RD = (CORE_DATA_REGMux)? DATA_Out : LI_inst;

assign DATA_IN = ULA_OUT;


//-------------------------------------------------------
always @(posedge CORE_DATA_ADDR_clk)begin
	CORE_DATA_ADDR = ULA_OUT;
end


always @(negedge clk) begin
       CORE_ULA_flags = (CORE_Status[0] & CORE_Status[1]) ? STACK_FLAGS[0:2] : ULA_flags;
end

always @(posedge clk) begin 
       PC = (CORE_Status[1]) ? (CORE_Status[0]? STACK_OUT : ULA_OUT) : (CORE_Status[0] ? PC : (PC+1));
end
//---------------------------------------------------------
//stack (entradas (CORE_STACK_ctrl, PC, CORE_ULA_flags )saídas(STACK_FLAGS, STACK_OUT));





















