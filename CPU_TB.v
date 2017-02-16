//CPU TB

/*************************************************************************
 *  descricao do testbench da CPU                  versao 1.00           *
 *                                                                       *
 *  Developer: Mariano                             13-02-2017            *
 *             marianobw@hotmail.com                                     *
 *  		   Marlon                              13-02-2017            *
 *             marlonsigales@gmail.com                                   *
 *	Corrector: Jean Carlos Scheunemann             DD-MM-AAAA            *
 *             jeancarsch@gmail.com                                      *
 *                                                                       *
 *************************************************************************/ 
 `timescale 1 ns / 1 ns  // only for cadence, comment in modelSim
 
 
 
module CPU_TB;

localparam integer PERIOD = 10;

parameter TAM = 16;

		reg [15:0] CPU_InstructionIN;   //
		wire CPU_InstructionToREGMux;
		reg [2:0] CPU_ctrl;             //
		wire [1:0] CPU_Status;
		wire [3:0] CPU_ULA_ctrl;
		reg [2:0] CPU_ULA_flags;        //
		wire CPU_ULAMux_inc_dec;
		wire [3:0] CPU_REG_RF1;
		wire [3:0] CPU_REG_RF2;
		wire [3:0] CPU_REG_RD;
		wire CPU_REG_write;
		wire CPU_DATA_write;
		wire CPU_DATA_load;
		wire CPU_DATA_ADDR_clk;
		wire CPU_DATA_REGMux;
		wire CPU_STACK_ctrl;
		wire [1:0] CPU_PC_ctrl;         // 
		wire CPU_PC_clk;
		reg clk;
		reg rst;

// Device Under Test instantiation <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
NRISC_CPU DUT(
			CPU_InstructionIN,		    //instruction input
			CPU_InstructionToREGMux,	//MUX ctrl of instruction in to REGs
			CPU_ctrl,					//CPU external input ctrl BUS
			CPU_Status,					//CPU status output
			CPU_ULA_ctrl,				//ULA output ctrl BUS
			CPU_ULA_flags,				//ULA flags input
			CPU_ULAMux_inc_dec,			//ULA Inc/dec output MUX ctrl
			CPU_REG_RF1,				//REGs to ULA ctrl 1
			CPU_REG_RF2,				//REGs to ULA ctrl 2
			CPU_REG_RD,					//REGs inputs ctrl
			CPU_REG_write,				//REGs write ctrl
			CPU_DATA_write,				//DATA write ctrl
			CPU_DATA_load,				//DATA load ctrl
			CPU_DATA_ADDR_clk,			//DATA clk
			CPU_DATA_REGMux,			//DATA to REGs MUX
			CPU_STACK_ctrl,				//CPU to STACK ctrl
			CPU_PC_ctrl,				//CPU to PC ctrl MUX
			CPU_PC_clk,					//PC clk
			clk,						//Main clk source
			rst							//general rst
			);

	    

	
	
	
// clock generation
  initial clk = 1'b0;
  always #(PERIOD/2) clk = ~clk;



initial rst = 1; // conforme visto no codigo do Marlon reset e ativo em baixo

reg[3:0] opcode, rf1, rf2, rd;

initial rf1 = 4'b1010;
initial rf2 = 4'b0101;
initial rd  = 4'b1001;

initial CPU_ctrl = 3'b000;  // ainda nao implementado na CPU
initial CPU_ULA_flags = 3'b000;  // 


always @(negedge clk)
	CPU_InstructionIN={opcode,rd,rf1,rf2};

initial begin
$display(" \n\n TESTE operacao com ULA SIMPLES" , $time," <-time" );
// soma
	@(posedge clk);opcode= 4'b1000;
	@(posedge clk);opcode= 4'b1000;
	
    @(negedge clk) opcode= 4'b1000;
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0000 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RF2==rf2 && CPU_REG_RD==rd) begin
						$display(" \n\n soma OK " , $time," <-time"  );
					end else begin
						$display(" \n\n soma erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1," reg_rf2=" , CPU_REG_RF2, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display("  esperava-se: ula_ctrl= 0x0, incdec=0, reg_rf1=" , rf1, " reg_rf2=" , rf2, "  reg_rd=" , rd,  " \n\n" );
					end	
	end
//subtração	
	@(negedge clk) opcode= 4'b1001;
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0001 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RF2==rf2 && CPU_REG_RD==rd) begin
						$display(" \n\n sub OK " , $time," <-time"  );
					end else begin
						$display(" \n\n sub erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1," reg_rf2=" , CPU_REG_RF2, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display("  esperava-se: ula_ctrl= 0x1, incdec=0, reg_rf1=" , rf1,"  reg_rf2=" , rf2, " reg_rd=" , rd,  " \n\n" );
					end	
	end
//and
@(negedge clk) opcode= 4'b1010;
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0010 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RF2==rf2 && CPU_REG_RD==rd) begin
						$display(" \n\n and OK " , $time," <-time"  );
					end else begin
						$display(" \n\n and erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1," reg_rf2=" , CPU_REG_RF2, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x2, incdec=0, reg_rf1=" , rf1," reg_rf2=" , rf2, " reg_rd=" , rd,  " \n\n" );
					end	
	end


//or
	@(negedge clk) opcode= 4'b1011;
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0011 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RF2==rf2 && CPU_REG_RD==rd) begin
						$display(" \n\n or OK " , $time," <-time"  );
					end else begin
						$display(" \n\n or erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1," reg_rf2=" , CPU_REG_RF2, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x3, incdec=0, reg_rf1=" , rf1," reg_rf2=" , rf2, " reg_rd=" , rd,  " \n\n" );
					end	
	end
//xor
	@(negedge clk) opcode= 4'b1100;
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0100 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RF2==rf2 && CPU_REG_RD==rd) begin
						$display(" \n\n xor OK " , $time," <-time"  );
					end else begin
						$display(" \n\n xor erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1," reg_rf2=" , CPU_REG_RF2, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x4, incdec=0, reg_rf1=" , rf1," reg_rf2=" , rf2, " reg_rd=" , rd,  " \n\n" );
					end	
	end



//shr
@(negedge clk)begin 
		opcode= 4'b1101;
		rf2= 4'b0000;
	end	
	
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0101 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RD==rd) begin
						$display(" \n\n shr OK " , $time," <-time"  );
					end else begin
						$display(" \n\n shr erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x5, incdec=0, reg_rf1=" , rf1, " reg_rd=" , rd,  " \n\n" );
					end	
	end
//rtr
@(negedge clk)	rf2= 4'b0001;

	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b1101 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RD==rd) begin
						$display(" \n\n rtr OK " , $time," <-time"  );
					end else begin
						$display(" \n\n rtr erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0xd, incdec=0, reg_rf1=" , rf1, " reg_rd=" , rd,  " \n\n" );
					end	
	end
	
//shl
@(negedge clk)begin 
		opcode= 4'b1110;
		rf2= 4'b0000;
	end	
	
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0110 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RD==rd) begin
						$display(" \n\n shl OK " , $time," <-time"  );
					end else begin
						$display(" \n\n shl erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x6, incdec=0, reg_rf1=" , rf1, " reg_rd=" , rd,  " \n\n" );
					end	
	end
	
	
//rtl
@(negedge clk) rf2= 4'b0001;
	
	
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b1110 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RD==rd) begin
						$display(" \n\n rtl OK " , $time," <-time"  );
					end else begin
						$display(" \n\n rtl erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0xe, incdec=0, reg_rf1=" , rf1, " reg_rd=" , rd,  " \n\n" );
					end	
	end


//not
	@(negedge clk)begin 
		opcode= 4'b1111;
		rf2= 4'b0000;
	end	
	
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0111 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RD==rd) begin
						$display(" \n\n not OK " , $time," <-time"  );
					end else begin
						$display(" \n\n not erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x7, incdec=0, reg_rf1=" , rf1, " reg_rd=" , rd,  " \n\n" );
					end	
	end
	
//twc
	@(negedge clk) rf2 = 4'b0001;
	
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0001 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==4'b0000 && CPU_REG_RF2==rf1 && CPU_REG_RD==rd) begin
						$display(" \n\n twc OK " , $time," <-time"  );
					end else begin
						$display(" \n\n twc erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1," reg_rf2=" , CPU_REG_RF2, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x1, incdec=0, reg_rf1=" , 4'b0000 ," reg_rf2=" , rf1, " reg_rd=" , rd,  " \n\n" );
					end	
	end

//inc
	@(negedge clk) rf2 = 4'b0010;
	
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0000 && CPU_ULAMux_inc_dec==1'b1 && CPU_REG_RF1==rf1 && CPU_REG_RD==rd) begin
						$display(" \n\n inc OK " , $time," <-time"  );
					end else begin
						$display(" \n\n inc erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x0, incdec=1, reg_rf1=" , rf1 , " reg_rd=" , rd,  " \n\n" );
					end	
	end
//dec
	@(negedge clk) rf2 = 4'b0011;
	
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0001 && CPU_ULAMux_inc_dec==1'b1 && CPU_REG_RF1==rf1 && CPU_REG_RD==rd) begin
						$display(" \n\n dec OK " , $time," <-time"  );
					end else begin
						$display(" \n\n dec erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x1, incdec=1, reg_rf1=" , rf1, " reg_rd=" , rd,  " \n\n" );
					end	
	rst = ~rst;
	rst = ~rst;
	rf2 = 4'b0101;
	end
$display(" \n\n FIM TESTE operacao com ULA SIMPLES " , $time," <-time \n\n\n"  );














$display(" \n\n TESTE operacao com ULA e reset entre cada operacao" , $time," <-time" );
// soma
	
    @(negedge clk) opcode= 4'b1000; rst = ~rst;
	@(posedge clk) begin
	
					if ( CPU_ULA_ctrl==4'b0000 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RF2==rf2 && CPU_REG_RD==rd) begin
						$display(" \n\n soma OK " , $time," <-time"  );
					end else begin
						$display(" \n\n soma erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1," reg_rf2=" , CPU_REG_RF2, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display("  esperava-se: ula_ctrl= 0x0, incdec=0, reg_rf1=" , rf1, " reg_rf2=" , rf2, "  reg_rd=" , rd,  " \n\n" );
					end	
	rst = ~rst;
	rst = ~rst;				
	end
//subtração	
	@(negedge clk) opcode= 4'b1001;
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0001 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RF2==rf2 && CPU_REG_RD==rd) begin
						$display(" \n\n sub OK " , $time," <-time"  );
					end else begin
						$display(" \n\n sub erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1," reg_rf2=" , CPU_REG_RF2, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display("  esperava-se: ula_ctrl= 0x1, incdec=0, reg_rf1=" , rf1,"  reg_rf2=" , rf2, " reg_rd=" , rd,  " \n\n" );
					end	
	rst = ~rst;
	rst = ~rst;
	end
//and
@(negedge clk) opcode= 4'b1010;
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0010 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RF2==rf2 && CPU_REG_RD==rd) begin
						$display(" \n\n and OK " , $time," <-time"  );
					end else begin
						$display(" \n\n and erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1," reg_rf2=" , CPU_REG_RF2, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x2, incdec=0, reg_rf1=" , rf1," reg_rf2=" , rf2, " reg_rd=" , rd,  " \n\n" );
					end	
	rst = ~rst;
	rst = ~rst;
	end


//or
	@(negedge clk) opcode= 4'b1011;
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0011 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RF2==rf2 && CPU_REG_RD==rd) begin
						$display(" \n\n or OK " , $time," <-time"  );
					end else begin
						$display(" \n\n or erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1," reg_rf2=" , CPU_REG_RF2, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x3, incdec=0, reg_rf1=" , rf1," reg_rf2=" , rf2, " reg_rd=" , rd,  " \n\n" );
					end	
	rst = ~rst;
	rst = ~rst;
	end
//xor
	@(negedge clk) opcode= 4'b1100;
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0100 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RF2==rf2 && CPU_REG_RD==rd) begin
						$display(" \n\n xor OK " , $time," <-time"  );
					end else begin
						$display(" \n\n xor erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1," reg_rf2=" , CPU_REG_RF2, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x4, incdec=0, reg_rf1=" , rf1," reg_rf2=" , rf2, " reg_rd=" , rd,  " \n\n" );
					end	
	rst = ~rst;
	rst = ~rst;
	end



//shr
@(negedge clk)begin 
		opcode= 4'b1101;
		rf2= 4'b0000;
	end	
	
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0101 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RD==rd) begin
						$display(" \n\n shr OK " , $time," <-time"  );
					end else begin
						$display(" \n\n shr erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x5, incdec=0, reg_rf1=" , rf1, " reg_rd=" , rd,  " \n\n" );
					end	
	rst = ~rst;
	rst = ~rst;
	end
//rtr
@(negedge clk)	rf2= 4'b0001;

	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b1101 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RD==rd) begin
						$display(" \n\n rtr OK " , $time," <-time"  );
					end else begin
						$display(" \n\n rtr erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0xd, incdec=0, reg_rf1=" , rf1, " reg_rd=" , rd,  " \n\n" );
					end	
	rst = ~rst;
	rst = ~rst;
	end
	
//shl
@(negedge clk)begin 
		opcode= 4'b1110;
		rf2= 4'b0000;
	end	
	
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0110 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RD==rd) begin
						$display(" \n\n shl OK " , $time," <-time"  );
					end else begin
						$display(" \n\n shl erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x6, incdec=0, reg_rf1=" , rf1, " reg_rd=" , rd,  " \n\n" );
					end	
	rst = ~rst;
	rst = ~rst;
	end
	
	
//rtl
@(negedge clk) rf2= 4'b0001;
	
	
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b1110 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RD==rd) begin
						$display(" \n\n rtl OK " , $time," <-time"  );
					end else begin
						$display(" \n\n rtl erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0xe, incdec=0, reg_rf1=" , rf1, " reg_rd=" , rd,  " \n\n" );
					end	
	rst = ~rst;
	rst = ~rst;
	end


//not
	@(negedge clk)begin 
		opcode= 4'b1111;
		rf2= 4'b0000;
	end	
	
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0111 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==rf1 && CPU_REG_RD==rd) begin
						$display(" \n\n not OK " , $time," <-time"  );
					end else begin
						$display(" \n\n not erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x7, incdec=0, reg_rf1=" , rf1, " reg_rd=" , rd,  " \n\n" );
					end	
	rst = ~rst;
	rst = ~rst;
	end
	
//twc
	@(negedge clk) rf2 = 4'b0001;
	
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0001 && CPU_ULAMux_inc_dec==1'b0 && CPU_REG_RF1==4'b0000 && CPU_REG_RF2==rf1 && CPU_REG_RD==rd) begin
						$display(" \n\n twc OK " , $time," <-time"  );
					end else begin
						$display(" \n\n twc erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1," reg_rf2=" , CPU_REG_RF2, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x1, incdec=0, reg_rf1=" , 4'b0000 ," reg_rf2=" , rf1, " reg_rd=" , rd,  " \n\n" );
					end	
	rst = ~rst;
	rst = ~rst;
	end

//inc
	@(negedge clk) rf2 = 4'b0010;
	
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0000 && CPU_ULAMux_inc_dec==1'b1 && CPU_REG_RF1==rf1 && CPU_REG_RD==rd) begin
						$display(" \n\n inc OK " , $time," <-time"  );
					end else begin
						$display(" \n\n inc erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x0, incdec=1, reg_rf1=" , rf1 , " reg_rd=" , rd,  " \n\n" );
					end	
	rst = ~rst;
	rst = ~rst;
	end
//dec
	@(negedge clk) rf2 = 4'b0011;
	
	@(posedge clk) begin
					if ( CPU_ULA_ctrl==4'b0001 && CPU_ULAMux_inc_dec==1'b1 && CPU_REG_RF1==rf1 && CPU_REG_RD==rd) begin
						$display(" \n\n dec OK " , $time," <-time"  );
					end else begin
						$display(" \n\n dec erro " , $time," <-time \n recebeu-se: ula_ctrl=" , CPU_ULA_ctrl, " incdec=" ,CPU_ULAMux_inc_dec, " reg_rf1=" , CPU_REG_RF1, " reg_rd=" , CPU_REG_RD,  " \n" );
						$display(" esperava-se: ula_ctrl= 0x1, incdec=1, reg_rf1=" , rf1, " reg_rd=" , rd,  " \n\n" );
					end	
	rst = ~rst;
	rst = ~rst;
	end
$display(" \n\n FIM TESTE operacao com ULA e reset entre cada operacao" , $time," <-time  \n\n\n" );
end





endmodule