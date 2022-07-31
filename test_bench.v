`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:11:46 08/09/2021
// Design Name:   Asynchronous_FIFO
// Module Name:   E:/xil/Asynchronous_FIFO/fifo_tb.v
// Project Name:  Asynchronous_FIFO
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Asynchronous_FIFO
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_bench;

	// Inputs
	reg clk_read;
	reg clk_wr;
	reg reset;

	// Outputs
	wire [7:0] dout;
	wire r_empty;
	wire w_full;

	// Instantiate the Unit Under Test (UUT)
	Async_FIFO uut (
		.clk_read(clk_read), 
		.clk_wr(clk_wr), 
		.reset(reset), 
		.dout(dout), 
		.r_empty(r_empty), 
		.w_full(w_full)
	);

	initial begin
		// Initialize Inputs
		clk_read = 0;
		clk_wr = 0;
		reset = 1;
		#2 reset=0;
	end
		// Wait 100 ns for global reset to finish
		always begin
		#2.5 clk_wr = ~clk_wr;
		end
		always begin
		#25 clk_read = ~clk_read;
		end
        
		// Add stimulus here

      
endmodule