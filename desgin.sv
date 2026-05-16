module fifo #(
parameter WIDTH = 65,
parameter DEPTH = 8
)(
input  logic clk,
input  logic reset,
input  logic wr_en,
input  logic rd_en,
input  logic [WIDTH-1:0] din,
output logic [WIDTH-1:0] dout,
output logic full,
output logic empty
);

logic [WIDTH-1:0] mem[0:DEPTH-1];
logic [$clog2(DEPTH)-1:0] wr_ptr, rd_ptr;
logic [$clog2(DEPTH+1)-1:0] count;

assign full  = (count == DEPTH);
assign empty = (count == 0);

always_ff @(posedge clk or negedge reset)
begin
if(!reset)
begin
wr_ptr <= 0;
rd_ptr <= 0;
count  <= 0;
dout   <= 0;
end

else begin

if(wr_en && !full)
begin
mem[wr_ptr] <= din;
wr_ptr <= wr_ptr + 1;
count  <= count + 1;
end

if(rd_en && !empty)
begin
dout <= mem[rd_ptr];
rd_ptr <= rd_ptr + 1;
count <= count - 1;
end
end
end
endmodule

module axi_master (
input logic clk,
input logic reset,
input logic write_en,
input logic read_en,

input logic [31:0] axi_wdata,
input logic [31:0] axi_awaddr,

output logic [31:0] addr,
output logic [31:0] data,
output logic write_valid,
output logic write_flag
);

always_ff @(posedge clk or negedge reset)
begin
if(!reset)
begin
write_valid <= 0;
end

else begin

if(write_en)
begin
addr <= axi_awaddr;
data <= axi_wdata;
write_flag <= 1;
write_valid <= 1;
end

else if(read_en)
begin
addr <= axi_awaddr;
data <= 0;
write_flag <= 0;
write_valid <= 1;
end

else
write_valid <= 0;

end
end

endmodule
module apb_controller(
input logic clk,
input logic reset,

input logic [64:0] fifo_data,
input logic fifo_empty,
output logic fifo_rd,

output logic [31:0] PADDR,
output logic [31:0] PWDATA,
output logic PWRITE,
output logic PSEL,
output logic PENABLE
);

typedef enum logic[1:0] {IDLE, SETUP, ACCESS} state_t;

state_t state,next;

always_ff @(posedge clk or negedge reset)
begin
if(!reset)
state <= IDLE;
else
state <= next;
end

always_comb
begin
next = state;

case(state)

IDLE:
if(!fifo_empty)
next = SETUP;

SETUP:
next = ACCESS;

ACCESS:
next = IDLE;

endcase
end

always_ff @(posedge clk)
begin

case(state)

IDLE:
begin
PSEL <= 0;
PENABLE <= 0;
fifo_rd <= 0;
end

SETUP:
begin
PSEL <= 1;
PENABLE <= 0;

PADDR  <= fifo_data[31:0];
PWDATA <= fifo_data[63:32];
PWRITE <= fifo_data[64];
end

ACCESS:
begin
PENABLE <= 1;
fifo_rd <= 1;
end

endcase

end

endmodule
module apb_slave(
input logic clk,
input logic reset,

input logic PSEL,
input logic PENABLE,
input logic PWRITE,
input logic [31:0] PADDR,
input logic [31:0] PWDATA,

output logic [31:0] PRDATA
);

logic [31:0] mem[0:255];

always_ff @(posedge clk or negedge reset)
begin
if(!reset)
PRDATA <= 0;

else if(PSEL && PENABLE)
begin

if(PWRITE)
mem[PADDR[7:0]] <= PWDATA;

else
PRDATA <= mem[PADDR[7:0]];

end
end

endmodule
module axi_fifo_apb_bridge(

input logic clk,
input logic reset,

input logic write_en,
input logic read_en,

input logic [31:0] axi_wdata,
input logic [31:0] axi_awaddr
);

logic [31:0] addr;
logic [31:0] data;
logic write_valid;
logic write_flag;

logic [64:0] fifo_in;
logic [64:0] fifo_out;

logic fifo_full;
logic fifo_empty;
logic fifo_rd;

axi_master axi(
.clk(clk),
.reset(reset),
.write_en(write_en),
.read_en(read_en),
.axi_wdata(axi_wdata),
.axi_awaddr(axi_awaddr),
.addr(addr),
.data(data),
.write_valid(write_valid),
.write_flag(write_flag)
);

assign fifo_in = {write_flag,data,addr};

fifo fifo_inst(
.clk(clk),
.reset(reset),
.wr_en(write_valid),
.rd_en(fifo_rd),
.din(fifo_in),
.dout(fifo_out),
.full(fifo_full),
.empty(fifo_empty)
);

logic [31:0] PADDR;
logic [31:0] PWDATA;
logic PWRITE;
logic PSEL;
logic PENABLE;

apb_controller apb_ctrl(
.clk(clk),
.reset(reset),
.fifo_data(fifo_out),
.fifo_empty(fifo_empty),
.fifo_rd(fifo_rd),
.PADDR(PADDR),
.PWDATA(PWDATA),
.PWRITE(PWRITE),
.PSEL(PSEL),
.PENABLE(PENABLE)
);

apb_slave apb_mem(
.clk(clk),
.reset(reset),
.PSEL(PSEL),
.PENABLE(PENABLE),
.PWRITE(PWRITE),
.PADDR(PADDR),
.PWDATA(PWDATA),
.PRDATA()
);

endmodule
