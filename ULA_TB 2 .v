//ULA_TB 2

/*************************************************************************
 *  descricao do testbench da ula                   versao 2.05          *
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

module ULA_TB2;

localparam integer PERIOD = 10;

parameter TAM = 4;

reg signed [TAM-1:0] ULA_A;
reg signed [TAM-1:0] ULA_B;
reg clk, rst, incdec, cmp2;
reg [3:0] ULA_ctrl;

wire signed [TAM-1:0] ULA_OUT;
wire [2:0] ULA_flags;
 
 
 // Device Under Test instantiation <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 
NRISC_ULA #(.TAM(TAM)) DUT
  (
  .ULA_A (ULA_A),
  .ULA_B (ULA_B),
  .incdec(incdec),
  .ULA_ctrl (ULA_ctrl),
  .ULA_OUT (ULA_OUT),
  .ULA_flags (ULA_flags)
  
  );

// clock generation
initial clk = 1'b0;
  always #(PERIOD/2) clk = ~clk;
  
  
  
initial rst = 1; // conforme visto no codigo do Marlon reset e ativo em baixo
initial incdec = 0;
initial cmp2= 0;

reg [TAM-1:0] A,B,Am,Bm;

  // random value generation
always @(posedge clk)      
    begin
      /*random comand sintax:
        min + {$random(seed)}%(max-min+1) or can use $dist_uniform(seed, min, max) */
		A = {$random()}%(17'b11111111111111111) ; 
		B = {$random()}%(17'b11111111111111111) ; 
		ULA_ctrl[3:0] <= {$random()}%(5'b11111) ; 
		ULA_B <= B;
		ULA_A <= A;



	//if ((ULA_ctrl[2:0]==3'b101) | (ULA_ctrl[2:0]==3'b110)) begin
		//	ULA_ctrl[3] <= 1'b0 + {$random()}%(2'b11) ;
		//	//ULA_ctrl[3] <= $dist_uniform(0, 0, 1) ;
		//end else begin
		//	ULA_ctrl[3]=0;
		//end
	  
    end
	
always @ (ULA_ctrl)
	begin
		if (ULA_ctrl==4'b0000 | ULA_ctrl==0001)
			incdec <= $random%(2'b11);
		else incdec=0;
	
	end
	
	
always @ (incdec)
	begin
		if (incdec==1)
			B <=16'b0000000000000001;
	end


//reg [TAM-1:0] A,B;
reg signed [TAM-1:0] amaisb;  // 0000
reg signed [TAM:0] amaisb2;  // 0000
reg signed [TAM-1:0] amenosb; // 0001
reg signed [TAM:0] amenosb2; // 0001
reg [TAM-1:0] aandb;   // 0010
reg [TAM-1:0] aorb;    // 0011
reg [TAM-1:0] axorb;   // 0100
reg [TAM-1:0] ashr;    // 0101
reg [TAM-1:0] artr;    // 1101
reg [TAM-1:0] ashl;    // 0110
reg [TAM-1:0] artl;    // 1110
reg [TAM-1:0] anot;    // 0111
reg [2:0] flag0,flag1,flag2,flag3,flag4,flag5,flag6,flag7,flag8,flag9;
reg carrymais,carrymenos,negmenos,negmais,zero;


always @ ( * ) begin
	amaisb = A + B;
	amenosb = A - B; 
	amaisb2 = A + B;
	amenosb2 = A - B;	
	aandb = ULA_A & ULA_B;
	aorb = ULA_A | ULA_B;
	axorb = ULA_A ^ ULA_B;
	ashr = {ULA_A[TAM-1],ULA_A[TAM-1:1]};
	artr = {ULA_A[0],ULA_A[TAM-1:1]};
	ashl = ULA_A << 1;
	artl = {ULA_A[TAM-2:0],ULA_A[TAM-1]};
	anot = ~ULA_A;
	//bcomp2 = 0 - B;
	
	if (ULA_OUT == 0) begin
		zero = 1;
	end else begin
		zero = 0;
	end
	
	
	if (A[TAM-1]==B[TAM-1]) begin
		carrymais=amaisb[TAM-1];
	end else begin
		carrymais=~(amaisb[TAM-1]);
	end
	
	if (B==0)begin
		carrymenos=0;
	end else if(A[TAM-1]==B[TAM-1]) begin
		carrymenos=~(amenosb[TAM-1]);
	end else begin
		carrymenos=(amenosb[TAM-1]);
	end
	
	
	
	//carrymenos = ~carrymais;
	
	// tirar modulo de um numero 
	if (A[TAM-1]==1'b1) begin
		Am = ~A + 1;
	end else begin
		Am = A;
	end
	
	if (B[TAM-1] ==1'b1)begin
		Bm = ~B + 1;
	end else begin
		Bm = B;
	end
	
	// analize do minus 
	if (Am[TAM-1:0] > Bm[TAM-1:0]) begin
		negmais = A[TAM-1];
	end else if (Bm[TAM-1:0] > Am[TAM-1:0])begin
		negmais = B[TAM-1];
	end else if (A==B)begin
		negmais = A[TAM-1];
	end else if (A != B) begin
		negmais = 0 ;
	end
	
	if (Am[TAM-1:0] > Bm[TAM-1:0]) begin
		negmenos = A[TAM-1];
	end else if (Bm[TAM-1:0] > Am[TAM-1:0]) begin
		negmenos = ~B[TAM-1];
	end else if ($signed(A) < $signed(B)) begin
		negmenos = 1;
	end else if ($signed(A) > $signed(B)) begin
		negmenos = 0;
	end else begin // se A = B 
		negmenos = 0;
	end
		
	
	
	flag0 = {negmais,zero,carrymais};
	flag1 = {negmenos,zero,carrymenos};
	flag2 = {1'b0,zero,1'b0};
	flag3 = {1'b0,zero,1'b0};
	flag4 = {1'b0,zero,1'b0}; 
	flag5 = {1'b0,zero,ULA_A[0]}; 
	flag6 = {1'b0,zero,1'b0}; 
	flag7 = {1'b0,zero,ULA_A[TAM-1]};
	flag8 = {1'b0,zero,1'b0};  
	flag9 = {1'b0,zero,1'b0};
			
end
// always @ ( * ) begin
	
//end 
  
always @ ( posedge clk ) begin
	#1;
	case (ULA_ctrl)
		4'b0000: begin

					if (ULA_OUT==amaisb[TAM-1:0])begin
						if (flag0==ULA_flags)begin
						end else begin							
							$display("\n \n", $time,"\n ADD FLAG ERROR \n resultado esperado %b",flag0,"  \n resultado recebido %b ", ULA_flags);
						end
					end else begin
						$display("\n \n", $time,"\n ADD ERROR     \n resultado esperado %b",amaisb,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b0001: begin
					if (ULA_OUT==amenosb[TAM-1:0])begin
						if (flag1==ULA_flags)begin
						end else begin
							$display("\n \n", $time,"\n SUB FLAG ERROR \n resultado esperado %b",flag1,"  \n resultado recebido %b ", ULA_flags);
						end
					end else begin
						$display("\n \n", $time,"\n SUB ERROR     \n resultado esperado %b",amenosb,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b0010: begin
					if (ULA_OUT==aandb)begin
						if (flag2==ULA_flags)begin
						end else begin
							$display("\n \n", $time,"\n AND FLAG ERROR \n resultado esperado %b",flag2,"  \n resultado recebido %b ", ULA_flags);
						end
					end else begin
						$display("\n \n", $time,"\n AND ERROR     \n resultado esperado %b",aandb,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b0011: begin
					if (ULA_OUT==aorb)begin
						if (flag3==ULA_flags)begin
						end else begin
							$display("\n \n", $time,"\n OR FLAG ERROR \n resultado esperado %b",flag3,"  \n resultado recebido %b ", ULA_flags);
						end
					end else begin
					$display("\n \n", $time,"\n OR ERROR     \n resultado esperado %b",aorb,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b0100: begin
					if (ULA_OUT==axorb)begin
						if (flag4==ULA_flags)begin
						end else begin
							$display("\n \n", $time,"\n XOR FLAG ERROR \n resultado esperado %b",flag4,"  \n resultado recebido %b ", ULA_flags);
						end
					end else begin
					$display("\n \n", $time,"\n XOR ERROR     \n resultado esperado %b",axorb,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b0101: begin
					if (ULA_OUT==ashr)begin
						if (flag5==ULA_flags)begin
						end else begin
							$display("\n \n", $time,"\n SHR FLAG ERROR \n resultado esperado %b",flag5,"  \n resultado recebido %b ", ULA_flags);
						end
					end else begin
					$display("\n \n", $time,"\n SHR ERROR     \n resultado esperado %b",ashr,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b1101: begin
					if (ULA_OUT==artr)begin
						if (flag6==ULA_flags)begin
						end else begin
							$display("\n \n", $time,"\n RTR FLAG ERROR \n resultado esperado %b",flag6,"  \n resultado recebido %b ", ULA_flags);
						end
					end else begin
					$display("\n \n", $time,"\n RTR ERROR     \n resultado esperado %b",artr,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b0110: begin
					if (ULA_OUT==ashl)begin
						if (flag7==ULA_flags)begin
						end else begin
							$display("\n \n", $time,"\n SHL FLAG ERROR \n resultado esperado %b",flag7,"  \n resultado recebido %b ", ULA_flags);
						end
					end else begin
					$display("\n \n", $time,"\n SHL ERROR     \n resultado esperado %b",ashl,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b1110: begin
					if (ULA_OUT==artl)begin
						if (flag8==ULA_flags)begin
						end else begin
							$display("\n \n", $time,"\n RTL FLAG ERROR \n resultado esperado %b",flag8,"  \n resultado recebido %b ", ULA_flags);
						end
					end else begin
					$display("\n \n", $time,"\n RTL ERROR     \n resultado esperado %b",artl,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		4'b0111: begin
					if (ULA_OUT==anot)begin
						if (flag9==ULA_flags)begin
						end else begin
							$display("\n \n", $time,"\n NOT FLAG ERROR \n resultado esperado %b",flag9,"  \n resultado recebido %b ", ULA_flags);
						end
					end else begin
					$display("\n \n", $time,"\n NOT ERROR     \n resultado esperado %b",anot,"  \n resultado recebido %b ", ULA_OUT);
					end
				end
		
	endcase
end
 endmodule