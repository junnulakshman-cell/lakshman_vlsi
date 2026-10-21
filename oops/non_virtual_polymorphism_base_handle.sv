// -----------------------------------------------------------------------------
// SystemVerilog Polymorphism Using Base Class Handle
// -----------------------------------------------------------------------------
// This example demonstrates that method overriding alone does NOT create
// runtime polymorphism. When the base class method is not declared as virtual,
// the simulator performs static binding and calls the base-class method even
// when the handle points to a derived object.
//
// Concept covered:
//   - Inheritance
//   - Method overriding
//   - Base class handle
//   - $cast() assignment
//   - Static binding
// -----------------------------------------------------------------------------

class Base_Transactions;
  // Common AXI transaction fields
  logic [15:0] data;
  logic [31:0] addr;
  logic [2:0]  id;
  logic [2:0]  burst_len;
  logic [2:0]  burst_size;

  // Constructor to initialize the base transaction attributes
  function new(logic [15:0] data_in,
               logic [31:0] addr_in,
               logic [2:0]  id_in,
               logic [2:0]  burst_len_in,
               logic [2:0]  burst_size_in);
    data       = data_in;
    addr       = addr_in;
    id         = id_in;
    burst_len  = burst_len_in;
    burst_size = burst_size_in;
  endfunction : new

  // NOTE: This method is intentionally NOT virtual.
  // Because of this, the call is bound at compile time using the handle type.
  function void axi_txn();
    $display("Base-TRANS->");
    $display("  WRITE_DATA  = %0d", data);
    $display("  WRITE_ADDR  = %0d", addr);
    $display("  ID          = %0d", id);
    $display("  BURST_LEN   = %0d", burst_len);
    $display("  BURST_SIZE  = %0d", burst_size);
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
    w_data   = w_data_in;
    aw_addr  = aw_addr_in;
    b_resp   = b_resp_in;
  endfunction : new

  // This method has the same name as the base method,
  // but it does not override dynamically because the base method is not virtual.
  function void axi_txn();
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

  // Same idea as write: this method will not be called through dynamic dispatch.
  function void axi_txn();
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
    // Create a write transaction object
    tr_w = new(16'd23, 32'd34, 2'd1,
               16'd23, 32'd34, 3'd3, 3'd2, 3'd3);

    // Assign derived object to base handle using $cast
    if ($cast(tr_b, tr_w))
      $display("casting is success");
    else
      $display("casting is failed");

    // Call the method through the base handle.
    // Because axi_txn() is NOT virtual, the base implementation runs.
    tr_b.axi_txn();

    // Create a read transaction object
    tr_r = new(16'd24, 32'd33, 2'd5,
               16'd2, 32'd1, 3'd3, 3'd4, 3'd7);

    // Reuse the same base handle for a different derived object
    if ($cast(tr_b, tr_r))
      $display("casting is success");
    else
      $display("casting is failed");

    // Again, the base class method is called due to static binding.
    tr_b.axi_txn();
  end
endmodule : tb

// -----------------------------------------------------------------------------
// Expected Output:
//
// casting is success
// Base-TRANS->
//   WRITE_DATA  = 23
//   WRITE_ADDR  = 34
//   ID          = 3
//   BURST_LEN   = 2
//   BURST_SIZE  = 3
// casting is success
// Base-TRANS->
//   WRITE_DATA  = 2
//   WRITE_ADDR  = 1
//   ID          = 3
//   BURST_LEN   = 4
//   BURST_SIZE  = 7
// -----------------------------------------------------------------------------
