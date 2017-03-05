//cpu, descricao da controle operativo
/*************************************************************************
 *  descricao do bloco CPU                              versao 0.01      *
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
module NRISC_CPU(
								CPU_InstructionIN,				//instruction input
								CPU_InstructionToREGMux,	//MUX ctrl of instruction in to REGs
								CPU_ctrl,									//CPU external input ctrl BUS
								CPU_Status,								//CPU status output
								CPU_ULA_ctrl,							//ULA output ctrl BUS
								CPU_ULA_flags,						//ULA flags input
								CPU_ULAMux_inc_dec,				//ULA Inc/dec output MUX ctrl
								CPU_REG_RF1,							//REGs to ULA ctrl 1
								CPU_REG_RF2,							//REGs to ULA ctrl 2
								CPU_REG_RD,								//REGs inputs ctrl
								CPU_REG_write,						//REGs write ctrl
								CPU_DATA_write,						//DATA write ctrl
								CPU_DATA_load,						//DATA load ctrl
								CPU_DATA_ADDR_clk,				//DATA clk
								CPU_DATA_REGMux,					//DATA to REGs MUX
								CPU_STACK_ctrl,						//CPU to STACK ctrl
								CPU_PC_ctrl,							//CPU to PC ctrl MUX
								CPU_PC_clk,								//PC clk
								clk,											//Main clk source
								rst												//general rst
								);

		//CPU
		input wire clk;
		input wire rst;
		input wire [2:0] CPU_ctrl;
		output reg [1:0] CPU_Status;
		//Instruction
		input wire [15:0] CPU_InstructionIN;
		output reg CPU_InstructionToREGMux;
		//ULA
		input wire [2:0] CPU_ULA_flags;
		output reg [3:0] CPU_ULA_ctrl;
		output reg CPU_ULAMux_inc_dec;
		//REG ctrl
		output reg [3:0] CPU_REG_RD;
		output reg [3:0] CPU_REG_RF1;
		output reg [3:0] CPU_REG_RF2;
		output reg CPU_REG_write;
		//DATA
		output reg CPU_DATA_write;
		output reg CPU_DATA_load;
		output reg CPU_DATA_ADDR_clk;
		output reg CPU_DATA_REGMux;
		//STACK
		output reg [1:0] CPU_STACK_ctrl;
		//PC
		output wire [1:0] CPU_PC_ctrl;
		output reg CPU_PC_clk;

		//Internal REGs and WIREs
		//reg I;
		//reg [2:0] CPU_Instruction_Status;
		/*===================================================
		* 			Reset Tree
		*===================================================*/
		always @ ( negedge rst ) begin
				CPU_Status<=0;
				CPU_InstructionToREGMux<=0;
				CPU_ULA_ctrl<=0;
				CPU_ULAMux_inc_dec=0;
				CPU_REG_RD<=0;
				CPU_REG_RF1<=0;
				CPU_REG_RF2<=0;
				CPU_REG_write<=0;
				CPU_DATA_write<=0;
				CPU_DATA_load<=0;
				CPU_DATA_ADDR_clk<=0;
				CPU_DATA_REGMux<=0;
				CPU_STACK_ctrl<=0;
				CPU_PC_clk<=0;

				//TODO reset tree
		end
		/*===================================================
		*				PC control
		*====================================================*/
		assign CPU_PC_ctrl=CPU_Status[1:0];

		/*===================================================
		*				instruction decode
		*====================================================*/
		//assign CPU_DATA_load=CPU_InstructionIN[15];

		always @ ( posedge clk ) begin
				/*
				* hardware rst
				*/
				//STACK ctrl rst
				CPU_STACK_ctrl<=0;
				//PC Config
				CPU_PC_clk<=0;
				//REGs write rst
				CPU_REG_write<=0;
				//DATA clk rst
				CPU_DATA_ADDR_clk<=0;
				/*
				*		instruction decode state machine
				*/
				case (CPU_Status)
				3'h0:begin /* Instruction decode state machine */

								// DATA ctrl rst
								CPU_DATA_write<=0;
								CPU_DATA_load<=0;

								case (CPU_InstructionIN[15:12])
									4'h0: begin	//TODO CPU instructions
															//TODO
														case(CPU_InstructionIN[11:8])
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
																				CPU_ULA_ctrl<=4'h0;
																				CPU_ULAMux_inc_dec<=0;
																				//REG config
																				//CPU_REG_RD<= CPU_InstructionIN[11:8];
																				CPU_REG_RF1<=CPU_InstructionIN[7:4];
																				CPU_REG_RF2<=CPU_InstructionIN[3:0];
																				//REG MUX's config
																				CPU_InstructionToREGMux<=0;
																				CPU_DATA_REGMux<=0;
																				//update Status
																				CPU_Status<=2;
																				//update STACK
																				CPU_STACK_ctrl=2'b01;
																			end
																4'h5:	begin//RET
																				//ULA config ADD mode
																				CPU_ULA_ctrl<=4'h0;
																				CPU_ULAMux_inc_dec<=0;
																				//REG config
																				//CPU_REG_RD<= CPU_InstructionIN[11:8];
																				CPU_REG_RF1<=CPU_InstructionIN[7:4];
																				CPU_REG_RF2<=CPU_InstructionIN[3:0];
																				//REG MUX's config
																				CPU_InstructionToREGMux<=0;
																				CPU_DATA_REGMux<=0;
																				//update Status
																				CPU_Status<=2;
																				//update STACK
																				CPU_STACK_ctrl=2'b10;
																			end
																4'h6: begin//RETI
																				//ULA config ADD mode
																				CPU_ULA_ctrl<=4'h0;
																				CPU_ULAMux_inc_dec<=0;
																				//REG config
																				//CPU_REG_RD<= CPU_InstructionIN[11:8];
																				CPU_REG_RF1<=CPU_InstructionIN[7:4];
																				CPU_REG_RF2<=CPU_InstructionIN[3:0];
																				//REG MUX's config
																				CPU_InstructionToREGMux<=0;
																				CPU_DATA_REGMux<=0;
																				//update Status
																				CPU_Status<=3;
																				//update STACK
																				CPU_STACK_ctrl=2'b10;
																			end
														endcase
												end
									//Memory instructions
									4'h1: begin	//LW instruction
														//Calculates the memory address
														//ULA config (ADD mode)
														CPU_ULA_ctrl<=4'h0;
														CPU_ULAMux_inc_dec<=0;
														//REG config
														CPU_REG_RD<= CPU_InstructionIN[11:8];
														CPU_REG_RF1<=CPU_InstructionIN[7:4];
														CPU_REG_RF2<=CPU_InstructionIN[3:0];
														//REG MUX's config
														CPU_InstructionToREGMux<=0;
														CPU_DATA_REGMux<=1;
														//update Status
														CPU_Status<=1;
												end
									4'h2: begin	//SW instruction
														//Calculates the memory address
														//ULA config (ADD mode)
														CPU_ULA_ctrl<=4'h0;
														CPU_ULAMux_inc_dec<=0;
														//REG config
														CPU_REG_RD<= CPU_InstructionIN[11:8];
														CPU_REG_RF1<=CPU_InstructionIN[7:4];
														CPU_REG_RF2<=CPU_InstructionIN[3:0];
														//update Status(CPU continue to work on the next clk pulse)
														CPU_Status<=1;

												end
									4'h3: begin	//LI instruction
														//REG config
														CPU_REG_RD<= CPU_InstructionIN[11:8];
														//REG MUX's config
														CPU_InstructionToREGMux<=1;
														CPU_DATA_REGMux<=0;
														//Status update
														CPU_Status<=0;

												end
									// jump's instructions
									4'h4: begin	//JMP instruction
														//ULA config ADD mode
														CPU_ULA_ctrl<=4'h0;
														CPU_ULAMux_inc_dec<=0;
														//REG config
														//CPU_REG_RD<= CPU_InstructionIN[11:8];
														CPU_REG_RF1<=CPU_InstructionIN[7:4];
														CPU_REG_RF2<=CPU_InstructionIN[3:0];
														//REG MUX's config
														CPU_InstructionToREGMux<=0;
														CPU_DATA_REGMux<=0;
														//update Status
														CPU_Status<=2;
												end
									4'h5: begin	//JZ instruction
														//ULA config ADD mode
														CPU_ULA_ctrl<=4'h0;
														CPU_ULAMux_inc_dec<=0;
														//REG config
														//CPU_REG_RD<= CPU_InstructionIN[11:8];
														CPU_REG_RF1<=CPU_InstructionIN[7:4];
														CPU_REG_RF2<=CPU_InstructionIN[3:0];
														//REG MUX's config
														CPU_InstructionToREGMux<=0;
														CPU_DATA_REGMux<=0;
														//update Status
														CPU_Status<=2 & {2{CPU_ULA_flags[1]}};
												end
									4'h6: begin	//JC instruction
														//ULA config ADD mode
														CPU_ULA_ctrl<=4'h0;
														CPU_ULAMux_inc_dec<=0;
														//REG config
														//CPU_REG_RD<= CPU_InstructionIN[11:8];
														CPU_REG_RF1<=CPU_InstructionIN[7:4];
														CPU_REG_RF2<=CPU_InstructionIN[3:0];
														//REG MUX's config
														CPU_InstructionToREGMux<=0;
														CPU_DATA_REGMux<=0;
														//update Status
														CPU_Status<=2 & {2{CPU_ULA_flags[2]}};
												end
									4'h7: begin	//JM instruction
													//ULA config ADD mode
													CPU_ULA_ctrl<=4'h0;
													CPU_ULAMux_inc_dec<=0;
													//REG config
													//CPU_REG_RD<= CPU_InstructionIN[11:8];
													CPU_REG_RF1<=CPU_InstructionIN[7:4];
													CPU_REG_RF2<=CPU_InstructionIN[3:0];
													//REG MUX's config
													CPU_InstructionToREGMux<=0;
													CPU_DATA_REGMux<=0;
													//update Status
													CPU_Status<=2 & {2{CPU_ULA_flags[0]}};
												end
									//ULA instructions
									4'h8: begin	//ADD instruction
														//ULA config
														CPU_ULA_ctrl<=4'h0;
														CPU_ULAMux_inc_dec<=0;
														//REG config
														CPU_REG_RD<= CPU_InstructionIN[11:8];
														CPU_REG_RF1<=CPU_InstructionIN[7:4];
														CPU_REG_RF2<=CPU_InstructionIN[3:0];
														//REG MUX's config
														CPU_InstructionToREGMux<=0;
														CPU_DATA_REGMux<=0;
														//update Status
														CPU_Status<=0;
												end
									4'h9: begin	//SUB instruction
														//ULA config
														CPU_ULA_ctrl<=4'h1;
														CPU_ULAMux_inc_dec<=0;
														//REG config
														CPU_REG_RD<= CPU_InstructionIN[11:8];
														CPU_REG_RF1<=CPU_InstructionIN[7:4];
														CPU_REG_RF2<=CPU_InstructionIN[3:0];
														//REG MUX's config
														CPU_InstructionToREGMux<=0;
														CPU_DATA_REGMux<=0;
														//update Status
														CPU_Status<=0;
												end
									4'hA: begin	//AND instruction
														//ULA config
														CPU_ULA_ctrl<=4'h2;
														CPU_ULAMux_inc_dec<=0;
														//REG config
														CPU_REG_RD<= CPU_InstructionIN[11:8];
														CPU_REG_RF1<=CPU_InstructionIN[7:4];
														CPU_REG_RF2<=CPU_InstructionIN[3:0];
														//REG MUX's config
														CPU_InstructionToREGMux<=0;
														CPU_DATA_REGMux<=0;
														//update Status
														CPU_Status<=0;
												end
									4'hB: begin	//OR instruction
														//ULA config
														CPU_ULA_ctrl<=4'h3;
														CPU_ULAMux_inc_dec<=0;
														//REG config
														CPU_REG_RD<= CPU_InstructionIN[11:8];
														CPU_REG_RF1<=CPU_InstructionIN[7:4];
														CPU_REG_RF2<=CPU_InstructionIN[3:0];
														//REG MUX's config
														CPU_InstructionToREGMux<=0;
														CPU_DATA_REGMux<=0;
														//update Status
														CPU_Status<=0;
												end
									4'hC: begin	//XOR instruction
														//ULA config
														CPU_ULA_ctrl<=4'h4;
														CPU_ULAMux_inc_dec<=0;
														//REG config
														CPU_REG_RD<= CPU_InstructionIN[11:8];
														CPU_REG_RF1<=CPU_InstructionIN[7:4];
														CPU_REG_RF2<=CPU_InstructionIN[3:0];
														//REG MUX's config
														CPU_InstructionToREGMux<=0;
														CPU_DATA_REGMux<=0;
														//update Status
														CPU_Status<=0;
												end
									4'hD: begin	//SHR/RTR instruction
														//ULA config
														CPU_ULA_ctrl<={CPU_InstructionIN[0],3'h5};
														CPU_ULAMux_inc_dec<=0;
														//REG config
														CPU_REG_RD<= CPU_InstructionIN[11:8];
														CPU_REG_RF1<=CPU_InstructionIN[7:4];
														//REG MUX's config
														CPU_InstructionToREGMux<=0;
														CPU_DATA_REGMux<=0;
														//update Status
														CPU_Status<=0;
												end
									4'hE: begin	//SHL/RTL instruction
														//ULA config
														CPU_ULA_ctrl<={CPU_InstructionIN[0],3'h6};
														CPU_ULAMux_inc_dec<=0;
														//REG config
														CPU_REG_RD<= CPU_InstructionIN[11:8];
														CPU_REG_RF1<=CPU_InstructionIN[7:4];
														//REG MUX's config
														CPU_InstructionToREGMux<=0;
														CPU_DATA_REGMux<=0;
														//update Status
														CPU_Status<=0;
												end
									4'hF: begin	//NOT/TWC/INC/DEC instruction
														//REG config
														CPU_REG_RD<= CPU_InstructionIN[11:8];
														CPU_REG_RF1<=CPU_InstructionIN[7:4];
														//REG MUX's config
														CPU_InstructionToREGMux<=0;
														CPU_DATA_REGMux<=0;
														//update Status
														CPU_Status<=0;
														//ULA config
														case(CPU_InstructionIN[3:0])
																4'h0:begin//NOT instruction
																			CPU_ULA_ctrl<=4'h7;
																			CPU_ULAMux_inc_dec<=0;
																		end
																4'h1:begin//TWC instruction pseudo

																		end
																4'h2:begin//INC instruction
																			CPU_ULA_ctrl<=4'h0;
																			CPU_ULAMux_inc_dec<=1;
																		end
																4'h3:begin//DEC instruction
																			CPU_ULA_ctrl<=4'h1;
																			CPU_ULAMux_inc_dec<=1;
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
								CPU_Status<=0;
								case(CPU_InstructionIN[15:12])
										4'h1: begin	//LW
															CPU_REG_RD=CPU_InstructionIN[11:8];
															// DATA MEM read config
															CPU_DATA_load<=1;
													end
										4'h2: begin	//SW
															//ULA config
															CPU_ULA_ctrl<=4'h2;
															CPU_ULAMux_inc_dec<=0;
															//REG config
															CPU_REG_RF1<=CPU_InstructionIN[11:8];
															CPU_REG_RF2<=CPU_InstructionIN[11:8];
															//DATA mem write config
															CPU_DATA_write<=1;

													end

								endcase

						end
				3'h2:begin
								/*
								*  CALLs and JUMPs
								*/
								CPU_Status<=0;
						end
				3'h3:begin
								/*
								*  RETs and RETIs
								*/
								CPU_Status<=0;
						end
				endcase

		end

		/*===================================================
		*				Instruction update Memory and REGs
		*====================================================*/
		always @ ( negedge clk ) begin
			case(CPU_Status)
						3'h0:begin//Update PC, PC++
									CPU_PC_clk<=1;//PC update clk
									CPU_REG_write=	CPU_InstructionIN[15]||	// ULA instruction
																	(CPU_InstructionIN[15:12]==4'h1)||	//Load instruction
																	(CPU_InstructionIN[15:12]==4'h3); 	//Load imediate instruction
								end
						3'h1:begin//LOAD STORE instruction
									CPU_DATA_ADDR_clk=(CPU_InstructionIN[15:12]==4'h1)||(CPU_InstructionIN[15:12]==4'h2);
								end
						3'h2:begin//Update PC,PC=ULA_out (JMP function)
									CPU_PC_clk<=1;//PC update clk
								end
						3'h3:begin//Update PC,PC=STACK[0]
									//TODO
								end
				endcase

		end
endmodule;
