// -----------------------------------------------------------------------------
// Topic: Runtime Polymorphism with virtual Methods
// -----------------------------------------------------------------------------
// This example shows the correct way to enable polymorphism in SystemVerilog.
// By declaring the method as virtual in the base class, the call is resolved
// based on the actual object type at runtime.
//
// This is called DYNAMIC DISPATCH or RUNTIME POLYMORPHISM.
// -----------------------------------------------------------------------------

class Base_Transactions;
  logic [15:0] data;
  logic [31:0] addr;
  logic [2:0]  id;
  logic [2:0]  burst_len;
  logic [2:0]  burst_size;

  function new(logic [15:0] data_in,
               logic [31:0] addr_in,
               logic [2:0]  id_in,
               logic [2:0]  burst_len_in,
               logic [2:0]  burst_size_in);
    data      = data_in;
    addr      = addr_in;
    id        = id_in;
    burst_len = burst_len_in;
    burst_size = burst_size_in;
  endfunction : new

  // This is virtual, so the actual object type decides which method runs.
  virtual function void axi_txn();
    $display("Base-TRANS->");
    $display("  DATA      = %0d", data);
    $display("  ADDR      = %0d", addr);
    $display("  ID        = %0d", id);
    $display("  BURST_LEN = %0d", burst_len);
    $display("  BURST_SZ  = %0d", burst_size);
  endfunction : axi_txn

endclass : Base_Transactions

class Axi_write_transactions extends Base_Transactions;
  logic [15:0] w_data;
  logic [31:0] aw_addr;
  logic [1:0]  b_resp;

  function new(logic [15:0] w_data_in,
               logic [31:0] aw_addr_in,
               logic [1:0]  b_resp_in,
               logic [15:0] data_in,
               logic [31:0] addr_in,
               logic [2:0]  id_in,
               logic [2:0]  burst_len_in,
               logic [2:0]  burst_size_in);
    super.new(data_in, addr_in, id_in, burst_len_in, burst_size_in);
    w_data  = w_data_in;
    aw_addr = aw_addr_in;
    b_resp  = b_resp_in;
  endfunction : new

  virtual function void axi_txn();
    $display("AXI-WRITE_TRANS->");
    $display("  WRITE_DATA = %0d", w_data);
    $display("  WRITE_ADDR = %0d", aw_addr);
    $display("  ID         = %0d", id);
    $display("  BURST_LEN  = %0d", burst_len);
    $display("  WRITE_RESP = %0d", b_resp);
  endfunction : axi_txn

endclass : Axi_write_transactions

class Axi_read_transactions extends Base_Transactions;
  logic [15:0] r_data;
  logic [31:0] ar_addr;
  logic [1:0]  r_resp;

  function new(logic [15:0] r_data_in,
               logic [31:0] ar_addr_in,
               logic [1:0]  r_resp_in,
               logic [15:0] data_in,
               logic [31:0] addr_in,
               logic [2:0]  id_in,
               logic [2:0]  burst_len_in,
               logic [2:0]  burst_size_in);
    super.new(data_in, addr_in, id_in, burst_len_in, burst_size_in);
    r_data  = r_data_in;
    ar_addr = ar_addr_in;
    r_resp  = r_resp_in;
  endfunction : new

  virtual function void axi_txn();
    $display("READ_TRAN->");
    $display("  READ_DATA  = %0d", r_data);
    $display("  READ_ADDR  = %0d", ar_addr);
    $display("  ID         = %0d", id);
    $display("  BURST_LEN  = %0d", burst_len);
    $display("  READ_RESP  = %0d", r_resp);
  endfunction : axi_txn

endclass : Axi_read_transactions

module tb;
  Base_Transactions tr_b;
  Axi_write_transactions tr_w;
  Axi_read_transactions tr_r;

  initial begin
    tr_w = new(16'd23, 32'd34, 2'd1,
               16'd23, 32'd34, 3'd3, 3'd2, 3'd3);

    $cast(tr_b, tr_w);
    tr_b.axi_txn();

    tr_r = new(16'd24, 32'd33, 2'd5,
               16'd2, 32'd1, 3'd3, 3'd4, 3'd7);

    $cast(tr_b, tr_r);
    tr_b.axi_txn();
  end
endmodule : tb

// -----------------------------------------------------------------------------
// Expected output:
//
// AXI-WRITE_TRANS->
//   WRITE_DATA = 23
//   WRITE_ADDR = 34
//   ID         = 3
//   BURST_LEN  = 2
//   WRITE_RESP = 1
// READ_TRAN->
//   READ_DATA  = 24
//   READ_ADDR  = 33
//   ID         = 3
//   BURST_LEN  = 4
//   READ_RESP  = 5
// -----------------------------------------------------------------------------
