// ULA_TB

// versao 0.01  23/11/2016


`timescale 1 ns / 1 ns  // only for cadence, comment in modelSim

module ULA_TB;

parameter TAM = 16;

reg [TAM-1:0] ULA_A;
reg [TAM-1:0] ULA_B;
reg clk, rst;
reg [3:0] ULA_ctrl;

wire [TAM-1:0] ULA_OUT;
wire [2:0] ULA_flags;


// Device Under Test instantiation <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
NRISC_ULA DUT
  (
  .ULA_A (ULA_A),
  .ULA_B (ULA_B),
  .clk (clk),
  .rst (rst),
  .ULA_ctrl (ULA_ctrl),
  .ULA_OUT (ULA_OUT),
  .ULA_flags (ULA_flags)
  );
