//CPU TB

/*************************************************************************
 *  descricao do testbench da CPU                  versao 2.02           *
 *                                                                       *
 *  Developer: Mariano                             05-03-2017            *
 *             marianobw@hotmail.com                                     *
 *  Corrector: Marlon                              DD-MM-AAAA            *
 *             marlonsigales@gmail.com                                   *
 *	           Jean Carlos Scheunemann             DD-MM-AAAA            *
 *             jeancarsch@gmail.com                                      *
 *                                                                       *
 *************************************************************************/ 
 `timescale 1 ns / 1 ns  // only for cadence, comment in modelSim
 
 
 
module CPU_TB2;

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
			.CPU_InstructionIN(CPU_InstructionIN),		       	//instruction input
			.CPU_InstructionToREGMux(CPU_InstructionToREGMux),	//MUX ctrl of instruction in to REGs
			.CPU_ctrl(CPU_ctrl),					   			//CPU external input ctrl BUS
			.CPU_Status(CPU_Status),					   		//CPU status output
			.CPU_ULA_ctrl(CPU_ULA_ctrl),				   		//ULA output ctrl BUS
			.CPU_ULA_flags(CPU_ULA_flags),				   		//ULA flags input
			.CPU_ULAMux_inc_dec(CPU_ULAMux_inc_dec),	   		//ULA Inc/dec output MUX ctrl
			.CPU_REG_RF1(CPU_REG_RF1),				   			//REGs to ULA ctrl 1
			.CPU_REG_RF2(CPU_REG_RF2),				   			//REGs to ULA ctrl 2
			.CPU_REG_RD(CPU_REG_RD),					   		//REGs inputs ctrl
			.CPU_REG_write(CPU_REG_write),				   		//REGs write ctrl
			.CPU_DATA_write(CPU_DATA_write),				   	//DATA write ctrl
			.CPU_DATA_load(CPU_DATA_load),				   		//DATA load ctrl
			.CPU_DATA_ADDR_clk(CPU_DATA_ADDR_clk),			   	//DATA clk
			.CPU_DATA_REGMux(CPU_DATA_REGMux),			   		//DATA to REGs MUX
			.CPU_STACK_ctrl(CPU_STACK_ctrl),					//CPU to STACK ctrl
			.CPU_PC_ctrl(CPU_PC_ctrl),							//CPU to PC ctrl MUX
			.CPU_PC_clk(CPU_PC_clk),							//PC clk
			.clk(clk),											//Main clk source
			.rst(rst)											//general rst
			);

	    

	
	
	
// clock generation
  initial clk = 1'b0;
  always #(PERIOD/2) clk = ~clk;



initial begin
 rst = 1 ;
 #(PERIOD/2) rst = 0;	
 
end 

reg[3:0] opcode, rf1, rf2, rd;
reg[1:0] x;
reg y;
reg[2:0] flags;
//initial rf1 = 4'b1010;
//initial rf2 = 4'b0101;
//initial rd  = 4'b1001;
initial x=0;
initial y=0;
initial CPU_ctrl = 3'b000;  // ainda nao implementado na CPU
initial CPU_ULA_flags = 3'b000;  // 


always @(negedge clk)begin
	if(x>0)begin
		x=x-1'b1;
	end
	if(x==0)begin
		/*random comand sintax:
		min + {$random(seed)}%(max-min+1) or can use $dist_uniform(seed, min, max) */
		opcode ={$random()}%(4'b1111) ; 
		rf1 ={$random()}%(4'b1111) ; 
		rf2 ={$random()}%(4'b1111) ; 
		rd ={$random()}%(4'b1111) ; 
		flags={$random()}%(3'b111) ;
		y=~y;
	end	
end

always @(y)begin
	#1;
	if((opcode==4'b0000)||(opcode==4'b0001)||(opcode==4'b0010)||(opcode==4'b0100)||(opcode==4'b0101)||(opcode==4'b0110)||(opcode==4'b0111))begin
		x=2'b10; // instruçao de 2 ciclos
		
	end
	

	
end

always @(negedge clk) begin
	CPU_InstructionIN={opcode,rd,rf1,rf2};
end

always @(negedge rst)begin
	#1;
	opcode=0;
	rd=0;
	rf1=0;
	rf2=0;
end
	
always @ ( posedge clk ) begin
	#1;
	if(x==0)begin
		case (opcode)
			4'b0000: begin
			
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
						if ((CPU_ULA_ctrl==4'b0000)&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RF1==rf1)&&(CPU_REG_RF2==rf2)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==2'b10)&&(CPU_REG_write==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==2'b01))begin
						//	$display(" \n\n CALL OK " , $time," <-time"  );
						end else begin
							$display(" \n\n CALL ERRO " , $time," <-time"  );
							$display("\n           recebido           esperado ");
							$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "             0000");
							$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
							$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
							$display("CPU_REG_RF2            ",CPU_REG_RF2 ,"         ",     rf2);
							$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
							$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
							$display("CPU_Status            ",CPU_Status ,     "             2");
							$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
							$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
							$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
							$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           1");
						end
					end
					4'h5:	begin//RET
						if ((CPU_ULA_ctrl==4'b0000)&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RF1==rf1)&&(CPU_REG_RF2==rf2)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==2'b10)&&(CPU_REG_write==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==2'b10))begin
						//	$display(" \n\n RET OK " , $time," <-time"  );
						end else begin
							$display(" \n\n RET ERRO " , $time," <-time"  );
							$display("\n           recebido           esperado ");
							$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "             0000");
							$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
							$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
							$display("CPU_REG_RF2            ",CPU_REG_RF2 ,"         ",     rf2);
							$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
							$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
							$display("CPU_Status            ",CPU_Status ,     "             2");
							$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
							$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
							$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
							$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           2");
						end
					end
					4'h6: begin//RETI
						if ((CPU_ULA_ctrl==4'b0000)&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RF1==rf1)&&(CPU_REG_RF2==rf2)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==2'b11)&&(CPU_REG_write==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==2'b10))begin
						//	$display(" \n\n RETI OK " , $time," <-time"  );
						end else begin
							$display(" \n\n RETI ERRO " , $time," <-time"  );
							$display("\n           recebido           esperado ");
							$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "             0000");
							$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
							$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
							$display("CPU_REG_RF2            ",CPU_REG_RF2 ,"         ",     rf2);
							$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
							$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
							$display("CPU_Status            ",CPU_Status ,     "             3");
							$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
							$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
							$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
							$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           2");
						end
					end
				endcase
			end
			
			4'b0001: begin
				if ((CPU_ULA_ctrl==4'b0000)&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RD==rd)&&(CPU_REG_RF1==rf1)&&(CPU_REG_RF2==rf2)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==1)&&(CPU_Status==2'b01)&&(CPU_REG_write==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
				//	$display(" \n\n LW OK " , $time," <-time"  );
				end else begin
					$display(" \n\n LW ERRO " , $time," <-time"  );
					$display("\n           recebido           esperado ");
					$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "             0000");
					$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
					$display("CPU_REG_RD           ",CPU_REG_RD ,"         ",     rd);
					$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
					$display("CPU_REG_RF2            ",CPU_REG_RF2 ,"         ",     rf2);
					$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
					$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          1");
					$display("CPU_Status            ",CPU_Status ,     "             1");
					$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
					$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
					$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
					$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
				end
		
			end
			
			4'b0010: begin
				if ((CPU_ULA_ctrl==4'b0000)&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RD==rd)&&(CPU_REG_RF1==rf1)&&(CPU_REG_RF2==rf2)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==2'b01)&&(CPU_REG_write==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
				//	$display(" \n\n SW OK " , $time," <-time"  );
				end else begin
					$display(" \n\n SW ERRO " , $time," <-time"  );
					$display("\n           recebido           esperado ");
					$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "             0000");
					$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
					$display("CPU_REG_RD           ",CPU_REG_RD ,"         ",     rd);
					$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
					$display("CPU_REG_RF2            ",CPU_REG_RF2 ,"         ",     rf2);
					$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
					$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
					$display("CPU_Status            ",CPU_Status ,     "             1");
					$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
					$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
					$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
					$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
				end
		
			end
			
			4'b0011: begin
				if ((CPU_ULAMux_inc_dec==0)&&(CPU_REG_RD==rd)&&(CPU_InstructionToREGMux==1)&&(CPU_DATA_REGMux==0)&&(CPU_Status==0)&&(CPU_REG_write==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
				//	$display(" \n\n LI OK " , $time," <-time"  );
				end else begin
					$display(" \n\n LI ERRO " , $time," <-time"  );
					$display("\n           recebido           esperado ");
					$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
					$display("CPU_REG_RD           ",CPU_REG_RD ,"         ",     rd);
					$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          1");
					$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
					$display("CPU_Status            ",CPU_Status ,     "             0");
					$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
					$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
					$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
					$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
				end
		
			end
			
			4'b0100: begin
				if ((CPU_ULA_ctrl==4'b0000)&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RF1==rf1)&&(CPU_REG_RF2==rf2)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==2'b10)&&(CPU_REG_write==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
				//	$display(" \n\n JMP OK " , $time," <-time"  );
				end else begin
					$display(" \n\n JMP ERRO " , $time," <-time"  );
					$display("\n           recebido           esperado ");
					$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "             0000");
					$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
					$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
					$display("CPU_REG_RF2            ",CPU_REG_RF2 ,"         ",     rf2);
					$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
					$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
					$display("CPU_Status            ",CPU_Status ,     "             2");
					$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
					$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
					$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
					$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
				end
		
			end
			
			4'b0101: begin
				if ((CPU_ULA_ctrl==4'b0000)&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RF1==rf1)&&(CPU_REG_RF2==rf2)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==(flags[1]?2:0))&&(CPU_REG_write==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
				//	$display(" \n\n JZ OK " , $time," <-time"  );
				end else begin
					$display(" \n\n JZ ERRO " , $time," <-time"  );
					$display("\n           recebido           esperado ");
					$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "             0000");
					$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
					$display("CPU_REG_RD           ",CPU_REG_RD ,"         ",     rd);
					$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
					$display("CPU_REG_RF2            ",CPU_REG_RF2 ,"         ",     rf2);
					$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
					$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
					$display("CPU_Status            ",CPU_Status ,     "            ",flags[1]?2:0);
					$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
					$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
					$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
					$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
				end
		
			end
			
			4'b0110: begin
				if ((CPU_ULA_ctrl==4'b0000)&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RF1==rf1)&&(CPU_REG_RF2==rf2)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==(flags[0]?2:0))&&(CPU_REG_write==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
				//	$display(" \n\n JC OK " , $time," <-time"  );
				end else begin
					$display(" \n\n JC ERRO " , $time," <-time"  );
					$display("\n           recebido           esperado ");
					$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "             0000");
					$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
					$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
					$display("CPU_REG_RF2            ",CPU_REG_RF2 ,"         ",     rf2);
					$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
					$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
					$display("CPU_Status            ",CPU_Status ,     "              " ,flags[0]?2:0);
					$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
					$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
					$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
					$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
				end
		
			end
			
			4'b0111: begin
				if ((CPU_ULA_ctrl==4'b0000)&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RF1==rf1)&&(CPU_REG_RF2==rf2)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==(flags[2]?2:0))&&(CPU_REG_write==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
				//	$display(" \n\n JM OK " , $time," <-time"  );
				end else begin
					$display(" \n\n JM ERRO " , $time," <-time"  );
					$display("\n           recebido           esperado ");
					$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "             0000");
					$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
					$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
					$display("CPU_REG_RF2            ",CPU_REG_RF2 ,"         ",     rf2);
					$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
					$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
					$display("CPU_Status            ",CPU_Status ,     "             ",flags[2]?2:0);
					$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
					$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
					$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
					$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
				end
		
			end
			
			
			
			
			4'b1000: begin
				if ((CPU_ULA_ctrl==4'b0000)&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RD==rd)&&(CPU_REG_RF1==rf1)&&(CPU_REG_RF2==rf2)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==0)&&(CPU_REG_write==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
				//	$display(" \n\n soma OK " , $time," <-time"  );
				end else begin
					$display(" \n\n soma ERRO " , $time," <-time"  );
					$display("\n           recebido           esperado ");
					$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "             0000");
					$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
					$display("CPU_REG_RD           ",CPU_REG_RD ,"         ",     rd);
					$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
					$display("CPU_REG_RF2            ",CPU_REG_RF2 ,"         ",     rf2);
					$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
					$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
					$display("CPU_Status            ",CPU_Status ,     "             0");
					$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
					$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
					$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
					$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
				end
		
			end
			
			4'b1001: begin
				if ((CPU_ULA_ctrl==4'b0001)&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RD==rd)&&(CPU_REG_RF1==rf1)&&(CPU_REG_RF2==rf2)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==0)&&(CPU_REG_write==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
				//	$display(" \n\n sub OK " , $time," <-time"  );
				end else begin
					$display(" \n\n sub ERRO " , $time," <-time"  );
					$display("\n           recebido           esperado ");
					$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "             0001");
					$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
					$display("CPU_REG_RD           ",CPU_REG_RD ,"         ",     rd);
					$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
					$display("CPU_REG_RF2            ",CPU_REG_RF2 ,"         ",     rf2);
					$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
					$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
					$display("CPU_Status            ",CPU_Status ,     "             0");
					$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
					$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
					$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
					$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
				end
		
			end
			
			4'b1010: begin
				if ((CPU_ULA_ctrl==4'b0010)&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RD==rd)&&(CPU_REG_RF1==rf1)&&(CPU_REG_RF2==rf2)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
				//	$display(" \n\n AND OK " , $time," <-time"  );
				end else begin
					$display(" \n\n AND ERRO " , $time," <-time"  );
					$display("\n           recebido           esperado ");
					$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "             0010");
					$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
					$display("CPU_REG_RD           ",CPU_REG_RD ,"         ",     rd);
					$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
					$display("CPU_REG_RF2            ",CPU_REG_RF2 ,"         ",     rf2);
					$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
					$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
					$display("CPU_Status            ",CPU_Status ,     "             0");
					$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
					$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
					$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
					$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
	
					
				end
		
			end
			
			4'b1011: begin
				if ((CPU_ULA_ctrl==4'b0011)&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RD==rd)&&(CPU_REG_RF1==rf1)&&(CPU_REG_RF2==rf2)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
				//	$display(" \n\n OR OK " , $time," <-time"  );
				end else begin
					$display(" \n\n OR ERRO " , $time," <-time"  );
					$display("\n                       recebido           esperado ");
					$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "             0011");
					$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
					$display("CPU_REG_RD           ",CPU_REG_RD ,"         ",     rd);
					$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
					$display("CPU_REG_RF2            ",CPU_REG_RF2 ,"         ",     rf2);
					$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
					$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
					$display("CPU_Status            ",CPU_Status ,     "             0");
					$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
					$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
					$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
					$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
				end
		
			end
			
			4'b1100: begin
				if ((CPU_ULA_ctrl==4'b0100)&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RD==rd)&&(CPU_REG_RF1==rf1)&&(CPU_REG_RF2==rf2)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
				//	$display(" \n\n XOR OK " , $time," <-time"  );
				end else begin
					$display(" \n\n XOR ERRO " , $time," <-time"  );
					$display("\n                      recebido           esperado  ");
					$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "             0100");
					$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
					$display("CPU_REG_RD           ",CPU_REG_RD ,"         ",     rd);
					$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
					$display("CPU_REG_RF2            ",CPU_REG_RF2 ,"         ",     rf2);
					$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
					$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
					$display("CPU_Status            ",CPU_Status ,     "             0");
					$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
					$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
					$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
					$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
				end
		
			end
			
			4'b1101: begin
				if ((CPU_ULA_ctrl=={rf2[0],3'b101})&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RD==rd)&&(CPU_REG_RF1==rf1)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
				//	$display(" \n\n SHR/RTR OK " , $time," <-time"  );
				end else begin
					$display(" \n\n SHR/RTR ERRO " , $time," <-time"  );
					$display("\n           recebido           esperado ");
					$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "            ",{rf2[0],3'b101});
					$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
					$display("CPU_REG_RD           ",CPU_REG_RD ,"         ",     rd);
					$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
					$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
					$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
					$display("CPU_Status            ",CPU_Status ,     "             0");
					$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
					$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
					$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
					$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
				end
		
			end
			
			4'b1110: begin
				if ((CPU_ULA_ctrl=={rf2[0],3'b110})&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RD==rd)&&(CPU_REG_RF1==rf1)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
				//	$display(" \n\n SHL/RTL OK " , $time," <-time"  );
				end else begin
					$display(" \n\n SHL/RTL ERRO " , $time," <-time"  );
					$display("\n           recebido           esperado ");
					$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "            ",{rf2[0],3'b101});
					$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
					$display("CPU_REG_RD           ",CPU_REG_RD ,"         ",     rd);
					$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
					$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
					$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
					$display("CPU_Status            ",CPU_Status ,     "             0");
					$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
					$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
					$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
					$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
				end
		
			end
			
			4'b1111: begin
					case(CPU_InstructionIN[3:0])
							4'h0:begin//NOT instruction
								if ((CPU_ULA_ctrl==4'b0111)&&(CPU_ULAMux_inc_dec==0)&&(CPU_REG_RD==rd)&&(CPU_REG_RF1==rf1)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
								//	$display(" \n\n NOT/TWC/INC/DEC OK " , $time," <-time"  );
								end else begin
									$display(" \n\n NOT/TWC/INC/DEC ERRO " , $time," <-time"  );
									$display("\n           recebido           esperado ");
									$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "            0111");
									$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            0");
									$display("CPU_REG_RD           ",CPU_REG_RD ,"         ",     rd);
									$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
									$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
									$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
									$display("CPU_Status            ",CPU_Status ,     "             0");
									$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
									$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
									$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
									$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
								end	
					
							end
							4'h1:begin//TWC instruction pseudo
			
			
			
							end
							4'h2:begin//INC instruction
								if ((CPU_ULA_ctrl==4'b0000)&&(CPU_ULAMux_inc_dec==1)&&(CPU_REG_RD==rd)&&(CPU_REG_RF1==rf1)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
								//	$display(" \n\n NOT/TWC/INC/DEC OK " , $time," <-time"  );
								end else begin
									$display(" \n\n NOT/TWC/INC/DEC ERRO " , $time," <-time"  );
									$display("\n           recebido           esperado ");
									$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "            0000");
									$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            1");
									$display("CPU_REG_RD           ",CPU_REG_RD ,"         ",     rd);
									$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
									$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
									$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
									$display("CPU_Status            ",CPU_Status ,     "             0");
									$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
									$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
									$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
									$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
								end	
	
							end
							4'h3:begin//DEC instruction
								if ((CPU_ULA_ctrl==4'b0001)&&(CPU_ULAMux_inc_dec==1)&&(CPU_REG_RD==rd)&&(CPU_REG_RF1==rf1)&&(CPU_InstructionToREGMux==0)&&(CPU_DATA_REGMux==0)&&(CPU_Status==0)&&(CPU_DATA_write==0)&&(CPU_DATA_load==0)&&(CPU_DATA_ADDR_clk==0)&&(CPU_STACK_ctrl==0))begin
								//	$display(" \n\n NOT/TWC/INC/DEC OK " , $time," <-time"  );
								end else begin
									$display(" \n\n NOT/TWC/INC/DEC ERRO " , $time," <-time"  );
									$display("\n           recebido           esperado ");
									$display("CPU_ULA_ctrl          ",CPU_ULA_ctrl ,     "            0001");
									$display("CPU_ULAMux_inc_dec       ",CPU_ULAMux_inc_dec ,     "            1");
									$display("CPU_REG_RD           ",CPU_REG_RD ,"         ",     rd);
									$display("CPU_REG_RF1            ",CPU_REG_RF1 ,"         ",    rf1);
									$display("CPU_InstructionToREGMux            ",CPU_InstructionToREGMux ,     "          0");
									$display("CPU_DATA_REGMux          ",CPU_DATA_REGMux ,     "          0");
									$display("CPU_Status            ",CPU_Status ,     "             0");
									$display("CPU_DATA_write            ",CPU_DATA_write ,     "         0");
									$display("CPU_DATA_load            ",CPU_DATA_load ,     "           0");
									$display("CPU_DATA_ADDR_clk        ",CPU_DATA_ADDR_clk ,     "         0");
									$display("CPU_STACK_ctrl           ",CPU_STACK_ctrl ,     "           0");
								end	
							end
					endcase
			
				end	

		endcase
	end
end
	
	
	
	
	
endmodule	
	