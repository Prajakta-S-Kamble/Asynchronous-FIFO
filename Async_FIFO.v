`timescale 1ns/ 1ps



////

module ROM(ROM_ptr,out);

output [7:0] out;
input [7:0] ROM_ptr;
reg [7:0] input_ROM [127:0];
integer i;
initial begin

for(i=0;i<128;i=i+1)
input_ROM[i] = i*4;
end


assign out = input_ROM[ROM_ptr];

endmodule

module Async_FIFO(clk_read,clk_wr,reset,dout,r_empty,w_full);



parameter addr_size =4;
parameter data_size=8;
parameter RAM_size = 1<< addr_size;

input clk_read,clk_wr;
input reset;
output w_full,r_empty;
output [data_size-1 : 0] dout;

wire [data_size-1 :0] data_in;
wire [addr_size:0] read_ptr_gray, write_ptr_gray;
wire [addr_size:0] read_ptr_bin, write_ptr_bin;

reg [addr_size:0] read_ptr,read_s1,read_s2;
reg [addr_size:0] write_ptr,write_s1,write_s2;
reg [data_size-1:0] memory[RAM_size-1:0];
reg [7:0] ROM_ptr;
reg full,empty;


//------------write logic-----------
always @(posedge reset or  posedge clk_wr)
begin 
	if (reset) begin
		write_ptr <=0;
		ROM_ptr <=0;
	end
	else if (full !== 1'b1) begin //full condition
		write_ptr <= write_ptr+1;
		ROM_ptr<= ROM_ptr+1;
		memory[write_ptr[addr_size-1:0]]<= data_in;
	end
end

ROM r(ROM_ptr,data_in);  //external ROM memory

//------two stage synchronizer for full---
always @(posedge clk_wr) begin
	read_s1 <= read_ptr_gray;
	read_s2 <= read_s1;
end

//------------Read logic-----------
always @(posedge reset or posedge clk_read) 
begin
	if (reset) begin
		read_ptr <=0;
	end
	else if(empty !== 1'b1) begin
		read_ptr <= read_ptr +1;
	end
end

//------two stage synchronizer for empty---
always @ (posedge clk_read) begin
	write_s1 <= write_ptr_gray;
	write_s2 <= write_s1;
end


//---check empty codition after 2 stage sync
always @(*)
begin	
	if(write_ptr_bin==read_ptr)
		empty=1;
	else
		empty=0;
end

//---check full codition after 2 stage sync
always @(*)
begin
	if({~write_ptr[addr_size],write_ptr[addr_size-1:0]}==read_ptr_bin)
		full = 1;
	else
		full = 0;
end
	
	
    assign dout = memory[read_ptr[addr_size-1 : 0]];
	assign w_full = full;
	assign r_empty=empty;
	
	//----binary to gray pointer------------
	assign write_ptr_gray = write_ptr ^ (write_ptr >> 1);
    assign read_ptr_gray = read_ptr ^ (read_ptr >> 1);
	
	
	//--------gray to binary pointer----------
	assign write_ptr_bin[4]=write_s2[4];
	assign write_ptr_bin[3]=write_s2[3] ^ write_ptr_bin[4];
	assign write_ptr_bin[2]=write_s2[2] ^ write_ptr_bin[3];
	assign write_ptr_bin[1]=write_s2[1] ^ write_ptr_bin[2];
	assign write_ptr_bin[0]=write_s2[0] ^ write_ptr_bin[1];
	
	assign read_ptr_bin[4]=read_s2[4];
	assign read_ptr_bin[3]=read_s2[3] ^ read_ptr_bin[4];
	assign read_ptr_bin[2]=read_s2[2] ^ read_ptr_bin[3];
	assign read_ptr_bin[1]=read_s2[1] ^ read_ptr_bin[2];
	assign read_ptr_bin[0]=read_s2[0] ^ read_ptr_bin[1];

endmodule