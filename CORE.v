//CORE, descricao da controle operativo
/*************************************************************************
 *  descricao do bloco CORE                              versao 0.01      *
 *                                                                       *
 *  Developer: Jean Carlos Scheunemann             23-11-2016            *
 *              jeancarsch@gmail.com                                     *

 *  Corrector: Mariano                                                   *
 *             Marlon 	                                                 *
 *             marlonsigales@gmail.com                                   *
 *                                                                       *
 * soma(inc, twc), sub(dec), xor, and, or, not, shr(rtr), shl(rtl)       *
 *                                                                       *
 *************************************************************************/


`timescale 1 ns / 1 ns
module NRISC_CORE(
								CORE_InstructionIN,				//instruction input
								CORE_InstructionToREGMux,	//MUX ctrl of instruction in to REGs
								CORE_ctrl,									//CORE external input ctrl BUS
								CORE_Status,								//CORE status output
								CORE_ULA_ctrl,							//ULA output ctrl BUS
								CORE_ULA_flags,						//ULA flags input
								CORE_ULAMux_inc_dec,				//ULA Inc/dec output MUX ctrl
								CORE_REG_RF1,							//REGs to ULA ctrl 1
								CORE_REG_RF2,							//REGs to ULA ctrl 2
								CORE_REG_RD,								//REGs inputs ctrl
								CORE_REG_write,						//REGs write ctrl
								CORE_DATA_write,						//DATA write ctrl
								CORE_DATA_load,						//DATA load ctrl
								CORE_DATA_ADDR_clk,				//DATA clk
								CORE_DATA_REGMux,					//DATA to REGs MUX
								CORE_STACK_ctrl,						//CORE to STACK ctrl
								CORE_PC_ctrl,							//CORE to PC ctrl MUX
								CORE_PC_clk,								//PC clk
								clk,											//Main clk source
								rst												//general rst
								);

		//CORE
		input wire clk;
		input wire rst;
		input wire [2:0] CORE_ctrl;
		output reg [1:0] CORE_Status;
		//Instruction
		input wire [15:0] CORE_InstructionIN;
		output reg CORE_InstructionToREGMux;
		//ULA
		input wire [2:0] CORE_ULA_flags;
		output reg [3:0] CORE_ULA_ctrl;
		output reg CORE_ULAMux_inc_dec;
		//REG ctrl
		output reg [3:0] CORE_REG_RD;
		output reg [3:0] CORE_REG_RF1;
		output reg [3:0] CORE_REG_RF2;
		output reg CORE_REG_write;
		//DATA
		output reg CORE_DATA_write;
		output reg CORE_DATA_load;
		output reg CORE_DATA_ADDR_clk;
		output reg CORE_DATA_REGMux;
		//STACK
		output reg [1:0] CORE_STACK_ctrl;
		//PC
		output wire [1:0] CORE_PC_ctrl;
		output reg CORE_PC_clk;

		//Internal REGs and WIREs
		//reg I;
		//reg [2:0] CORE_Instruction_Status;
		/*===================================================
		* 			Reset Tree
		*===================================================*/
		always @ ( negedge rst ) begin
				CORE_Status<=0;
				CORE_InstructionToREGMux<=0;
				CORE_ULA_ctrl<=0;
				CORE_ULAMux_inc_dec=0;
				CORE_REG_RD<=0;
				CORE_REG_RF1<=0;
				CORE_REG_RF2<=0;
				CORE_REG_write<=0;
				CORE_DATA_write<=0;
				CORE_DATA_load<=0;
				CORE_DATA_ADDR_clk<=0;
				CORE_DATA_REGMux<=0;
				CORE_STACK_ctrl<=0;
				CORE_PC_clk<=0;

				//TODO reset tree
		end
		/*===================================================
		*				PC control
		*====================================================*/
		assign CORE_PC_ctrl=CORE_Status[1:0];

		/*===================================================
		*				instruction decode
		*====================================================*/
		//assign CORE_DATA_load=CORE_InstructionIN[15];

		always @ ( posedge clk ) begin
				/*
				* hardware rst
				*/
				//STACK ctrl rst
				CORE_STACK_ctrl<=0;
				//PC Config
				CORE_PC_clk<=0;
				//REGs write rst
				CORE_REG_write<=0;
				//DATA clk rst
				CORE_DATA_ADDR_clk<=0;
				/*
				*		instruction decode state machine
				*/
				case (CORE_Status)
				3'h0:begin /* Instruction decode state machine */

								// DATA ctrl rst
								CORE_DATA_write<=0;
								CORE_DATA_load<=0;

								case (CORE_InstructionIN[15:12])
									4'h0: begin	//TODO CORE instructions
															//TODO
														case(CORE_InstructionIN[11:8])
																4'h0:	begin//NOT instruction

																			end
																4'h1:	begin//HALT

																			end
																4'h2:	begin//WAIT

																			end
																4'h3:	begin//SLEEP

																			end
																4'h4:	begin//CALL
																				//ULA config ADD mode
																				CORE_ULA_ctrl<=4'h0;
																				CORE_ULAMux_inc_dec<=0;
																				//REG config
																				//CORE_REG_RD<= CORE_InstructionIN[11:8];
																				CORE_REG_RF1<=CORE_InstructionIN[7:4];
																				CORE_REG_RF2<=CORE_InstructionIN[3:0];
																				//REG MUX's config
																				CORE_InstructionToREGMux<=0;
																				CORE_DATA_REGMux<=0;
																				//update Status
																				CORE_Status<=2;
																				//update STACK
																				CORE_STACK_ctrl=2'b01;
																			end
																4'h5:	begin//RET
																				//ULA config ADD mode
																				CORE_ULA_ctrl<=4'h0;
																				CORE_ULAMux_inc_dec<=0;
																				//REG config
																				//CORE_REG_RD<= CORE_InstructionIN[11:8];
																				CORE_REG_RF1<=CORE_InstructionIN[7:4];
																				CORE_REG_RF2<=CORE_InstructionIN[3:0];
																				//REG MUX's config
																				CORE_InstructionToREGMux<=0;
																				CORE_DATA_REGMux<=0;
																				//update Status
																				CORE_Status<=2;
																				//update STACK
																				CORE_STACK_ctrl=2'b10;
																			end
																4'h6: begin//RETI
																				//ULA config ADD mode
																				CORE_ULA_ctrl<=4'h0;
																				CORE_ULAMux_inc_dec<=0;
																				//REG config
																				//CORE_REG_RD<= CORE_InstructionIN[11:8];
																				CORE_REG_RF1<=CORE_InstructionIN[7:4];
																				CORE_REG_RF2<=CORE_InstructionIN[3:0];
																				//REG MUX's config
																				CORE_InstructionToREGMux<=0;
																				CORE_DATA_REGMux<=0;
																				//update Status
																				CORE_Status<=3;
																				//update STACK
																				CORE_STACK_ctrl=2'b10;
																			end
														endcase
												end
									//Memory instructions
									4'h1: begin	//LW instruction
														//Calculates the memory address
														//ULA config (ADD mode)
														CORE_ULA_ctrl<=4'h0;
														CORE_ULAMux_inc_dec<=0;
														//REG config
														CORE_REG_RD<= CORE_InstructionIN[11:8];
														CORE_REG_RF1<=CORE_InstructionIN[7:4];
														CORE_REG_RF2<=CORE_InstructionIN[3:0];
														//REG MUX's config
														CORE_InstructionToREGMux<=0;
														CORE_DATA_REGMux<=1;
														//update Status
														CORE_Status<=1;
												end
									4'h2: begin	//SW instruction
														//Calculates the memory address
														//ULA config (ADD mode)
														CORE_ULA_ctrl<=4'h0;
														CORE_ULAMux_inc_dec<=0;
														//REG config
														CORE_REG_RD<= CORE_InstructionIN[11:8];
														CORE_REG_RF1<=CORE_InstructionIN[7:4];
														CORE_REG_RF2<=CORE_InstructionIN[3:0];
														//update Status(CORE continue to work on the next clk pulse)
														CORE_Status<=1;

												end
									4'h3: begin	//LI instruction
														//REG config
														CORE_REG_RD<= CORE_InstructionIN[11:8];
														//REG MUX's config
														CORE_InstructionToREGMux<=1;
														CORE_DATA_REGMux<=0;
														//Status update
														CORE_Status<=0;

												end
									// jump's instructions
									4'h4: begin	//JMP instruction
														//ULA config ADD mode
														CORE_ULA_ctrl<=4'h0;
														CORE_ULAMux_inc_dec<=0;
														//REG config
														//CORE_REG_RD<= CORE_InstructionIN[11:8];
														CORE_REG_RF1<=CORE_InstructionIN[7:4];
														CORE_REG_RF2<=CORE_InstructionIN[3:0];
														//REG MUX's config
														CORE_InstructionToREGMux<=0;
														CORE_DATA_REGMux<=0;
														//update Status
														CORE_Status<=2;
												end
									4'h5: begin	//JZ instruction
														//ULA config ADD mode
														CORE_ULA_ctrl<=4'h0;
														CORE_ULAMux_inc_dec<=0;
														//REG config
														//CORE_REG_RD<= CORE_InstructionIN[11:8];
														CORE_REG_RF1<=CORE_InstructionIN[7:4];
														CORE_REG_RF2<=CORE_InstructionIN[3:0];
														//REG MUX's config
														CORE_InstructionToREGMux<=0;
														CORE_DATA_REGMux<=0;
														//update Status
														CORE_Status<=2 & {2{CORE_ULA_flags[1]}};
												end
									4'h6: begin	//JC instruction
														//ULA config ADD mode
														CORE_ULA_ctrl<=4'h0;
														CORE_ULAMux_inc_dec<=0;
														//REG config
														//CORE_REG_RD<= CORE_InstructionIN[11:8];
														CORE_REG_RF1<=CORE_InstructionIN[7:4];
														CORE_REG_RF2<=CORE_InstructionIN[3:0];
														//REG MUX's config
														CORE_InstructionToREGMux<=0;
														CORE_DATA_REGMux<=0;
														//update Status
														CORE_Status<=2 & {2{CORE_ULA_flags[2]}};
												end
									4'h7: begin	//JM instruction
													//ULA config ADD mode
													CORE_ULA_ctrl<=4'h0;
													CORE_ULAMux_inc_dec<=0;
													//REG config
													//CORE_REG_RD<= CORE_InstructionIN[11:8];
													CORE_REG_RF1<=CORE_InstructionIN[7:4];
													CORE_REG_RF2<=CORE_InstructionIN[3:0];
													//REG MUX's config
													CORE_InstructionToREGMux<=0;
													CORE_DATA_REGMux<=0;
													//update Status
													CORE_Status<=2 & {2{CORE_ULA_flags[0]}};
												end
									//ULA instructions
									4'h8: begin	//ADD instruction
														//ULA config
														CORE_ULA_ctrl<=4'h0;
														CORE_ULAMux_inc_dec<=0;
														//REG config
														CORE_REG_RD<= CORE_InstructionIN[11:8];
														CORE_REG_RF1<=CORE_InstructionIN[7:4];
														CORE_REG_RF2<=CORE_InstructionIN[3:0];
														//REG MUX's config
														CORE_InstructionToREGMux<=0;
														CORE_DATA_REGMux<=0;
														//update Status
														CORE_Status<=0;
												end
									4'h9: begin	//SUB instruction
														//ULA config
														CORE_ULA_ctrl<=4'h1;
														CORE_ULAMux_inc_dec<=0;
														//REG config
														CORE_REG_RD<= CORE_InstructionIN[11:8];
														CORE_REG_RF1<=CORE_InstructionIN[7:4];
														CORE_REG_RF2<=CORE_InstructionIN[3:0];
														//REG MUX's config
														CORE_InstructionToREGMux<=0;
														CORE_DATA_REGMux<=0;
														//update Status
														CORE_Status<=0;
												end
									4'hA: begin	//AND instruction
														//ULA config
														CORE_ULA_ctrl<=4'h2;
														CORE_ULAMux_inc_dec<=0;
														//REG config
														CORE_REG_RD<= CORE_InstructionIN[11:8];
														CORE_REG_RF1<=CORE_InstructionIN[7:4];
														CORE_REG_RF2<=CORE_InstructionIN[3:0];
														//REG MUX's config
														CORE_InstructionToREGMux<=0;
														CORE_DATA_REGMux<=0;
														//update Status
														CORE_Status<=0;
												end
									4'hB: begin	//OR instruction
														//ULA config
														CORE_ULA_ctrl<=4'h3;
														CORE_ULAMux_inc_dec<=0;
														//REG config
														CORE_REG_RD<= CORE_InstructionIN[11:8];
														CORE_REG_RF1<=CORE_InstructionIN[7:4];
														CORE_REG_RF2<=CORE_InstructionIN[3:0];
														//REG MUX's config
														CORE_InstructionToREGMux<=0;
														CORE_DATA_REGMux<=0;
														//update Status
														CORE_Status<=0;
												end
									4'hC: begin	//XOR instruction
														//ULA config
														CORE_ULA_ctrl<=4'h4;
														CORE_ULAMux_inc_dec<=0;
														//REG config
														CORE_REG_RD<= CORE_InstructionIN[11:8];
														CORE_REG_RF1<=CORE_InstructionIN[7:4];
														CORE_REG_RF2<=CORE_InstructionIN[3:0];
														//REG MUX's config
														CORE_InstructionToREGMux<=0;
														CORE_DATA_REGMux<=0;
														//update Status
														CORE_Status<=0;
												end
									4'hD: begin	//SHR/RTR instruction
														//ULA config
														CORE_ULA_ctrl<={CORE_InstructionIN[0],3'h5};
														CORE_ULAMux_inc_dec<=0;
														//REG config
														CORE_REG_RD<= CORE_InstructionIN[11:8];
														CORE_REG_RF1<=CORE_InstructionIN[7:4];
														//REG MUX's config
														CORE_InstructionToREGMux<=0;
														CORE_DATA_REGMux<=0;
														//update Status
														CORE_Status<=0;
												end
									4'hE: begin	//SHL/RTL instruction
														//ULA config
														CORE_ULA_ctrl<={CORE_InstructionIN[0],3'h6};
														CORE_ULAMux_inc_dec<=0;
														//REG config
														CORE_REG_RD<= CORE_InstructionIN[11:8];
														CORE_REG_RF1<=CORE_InstructionIN[7:4];
														//REG MUX's config
														CORE_InstructionToREGMux<=0;
														CORE_DATA_REGMux<=0;
														//update Status
														CORE_Status<=0;
												end
									4'hF: begin	//NOT/TWC/INC/DEC instruction
														//REG config
														CORE_REG_RD<= CORE_InstructionIN[11:8];
														CORE_REG_RF1<=CORE_InstructionIN[7:4];
														//REG MUX's config
														CORE_InstructionToREGMux<=0;
														CORE_DATA_REGMux<=0;
														//update Status
														CORE_Status<=0;
														//ULA config
														case(CORE_InstructionIN[3:0])
																4'h0:begin//NOT instruction
																			CORE_ULA_ctrl<=4'h7;
																			CORE_ULAMux_inc_dec<=0;
																		end
																4'h1:begin//TWC instruction pseudo

																		end
																4'h2:begin//INC instruction
																			CORE_ULA_ctrl<=4'h0;
																			CORE_ULAMux_inc_dec<=1;
																		end
																4'h3:begin//DEC instruction
																			CORE_ULA_ctrl<=4'h1;
																			CORE_ULAMux_inc_dec<=1;
																		end
														endcase
												end
								endcase
						end
				3'h1:begin
								/*
								*  Memory operations
								*  LW & SW
								*/
								//update Status
								CORE_Status<=0;
								case(CORE_InstructionIN[15:12])
										4'h1: begin	//LW
															CORE_REG_RD=CORE_InstructionIN[11:8];
															// DATA MEM read config
															CORE_DATA_load<=1;
													end
										4'h2: begin	//SW
															//ULA config
															CORE_ULA_ctrl<=4'h2;
															CORE_ULAMux_inc_dec<=0;
															//REG config
															CORE_REG_RF1<=CORE_InstructionIN[11:8];
															CORE_REG_RF2<=CORE_InstructionIN[11:8];
															//DATA mem write config
															CORE_DATA_write<=1;

													end

								endcase

						end
				3'h2:begin
								/*
								*  CALLs and JUMPs
								*/
								CORE_Status<=0;
						end
				3'h3:begin
								/*
								*  RETs and RETIs
								*/
								CORE_Status<=0;
						end
				endcase

		end

		/*===================================================
		*				Instruction update Memory and REGs
		*====================================================*/
		always @ ( negedge clk ) begin
			case(CORE_Status)
						3'h0:begin//Update PC, PC++
									CORE_PC_clk<=1;//PC update clk
									CORE_REG_write=	CORE_InstructionIN[15]||	// ULA instruction
																	(CORE_InstructionIN[15:12]==4'h1)||	//Load instruction
																	(CORE_InstructionIN[15:12]==4'h3); 	//Load imediate instruction
								end
						3'h1:begin//LOAD STORE instruction
									CORE_DATA_ADDR_clk=(CORE_InstructionIN[15:12]==4'h1)||(CORE_InstructionIN[15:12]==4'h2);
								end
						3'h2:begin//Update PC,PC=ULA_out (JMP function)
									CORE_PC_clk<=1;//PC update clk
								end
						3'h3:begin//Update PC,PC=STACK[0]
									//TODO
								end
				endcase

		end
endmodule
