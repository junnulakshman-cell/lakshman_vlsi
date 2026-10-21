// File: oops/pure_virtual_polymorshims.sv
// -----------------------------------------------------------------------------
// SystemVerilog example: Pure Virtual Class + Runtime Polymorphism
// -----------------------------------------------------------------------------
// This example demonstrates the following OOP concepts:
// 1) Abstract base class using `virtual class`
// 2) Pure virtual function `pure virtual function void axi_txn();`
// 3) Inheritance using `extends`
// 4) Method overriding in derived classes
// 5) Runtime polymorphism through a base-class handle
// 6) Safe upcasting using `$cast`
// -----------------------------------------------------------------------------

// -------------------------
// Abstract base transaction class
// -------------------------
// A virtual class cannot be instantiated directly.
// It defines a common interface that every AXI transaction type must implement.
virtual class Base_Transactions;

  // Common transaction fields
  logic [15:0] data;
  logic [31:0] addr;
  logic [2:0]  id;
  logic [2:0]  burst_len;
  logic [2:0]  burst_size;

  // ---------------------------------------------------------------------------
  // Constructor of the base class
  // ---------------------------------------------------------------------------
  // This initializes the common AXI properties for all derived transaction types.
  function new(logic [15:0] data,
               logic [31:0] addr,
               logic [2:0]  id,
               logic [2:0]  burst_len,
               logic [2:0]  burst_size);
    this.data      = data;
    this.addr      = addr;
    this.id        = id;
    this.burst_len = burst_len;
    this.burst_size = burst_size;
  endfunction

  // ---------------------------------------------------------------------------
  // Pure virtual function
  // ---------------------------------------------------------------------------
  // This function has no body and must be implemented by every child class.
  // Without implementation, the derived class remains abstract and cannot be used.
  pure virtual function void axi_txn();

endclass

// -------------------------
// Write transaction class
// -------------------------
class Axi_write_transactions extends Base_Transactions;

  // Write-specific signals
  logic [15:0] w_data;
  logic [31:0] aw_addr;
  logic [1:0]  b_resp;

  // ---------------------------------------------------------------------------
  // Derived constructor
  // ---------------------------------------------------------------------------
  // It first calls the base constructor using `super.new()` to initialize shared
  // fields, then assigns the transaction-specific write fields.
  function new(logic [15:0] w_data,
               logic [31:0] aw_addr,
               logic [1:0]  b_resp,
               logic [15:0] data,
               logic [31:0] addr,
               logic [2:0]  id,
               logic [2:0]  burst_len,
               logic [2:0]  burst_size);
    super.new(data, addr, id, burst_len, burst_size);
    this.w_data  = w_data;
    this.aw_addr = aw_addr;
    this.b_resp  = b_resp;
  endfunction

  // ---------------------------------------------------------------------------
  // Method overriding for write transaction
  // ---------------------------------------------------------------------------
  // This method must match the abstract method signature defined in the base class.
  function void axi_txn();
    $display("AXI-WRITE_TRANS->");
    $display("WRITE_DATA = %0d", w_data);
    $display("WRITE_ADDR = %0d", aw_addr);
    $display("ID = %0d", id);
    $display("BURST_LEN = %0d", burst_len);
    $display("WRITE_RESP = %0d", b_resp);
  endfunction

endclass

// -------------------------
// Read transaction class
// -------------------------
class Axi_read_transactions extends Base_Transactions;

  // Read-specific signals
  logic [15:0] r_data;
  logic [31:0] ar_addr;
  logic [1:0]  r_resp;

  // ---------------------------------------------------------------------------
  // Derived constructor
  // ---------------------------------------------------------------------------
  function new(logic [15:0] r_data,
               logic [31:0] ar_addr,
               logic [1:0]  r_resp,
               logic [15:0] data,
               logic [31:0] addr,
               logic [2:0]  id,
               logic [2:0]  burst_len,
               logic [2:0]  burst_size);
    super.new(data, addr, id, burst_len, burst_size);
    this.r_data  = r_data;
    this.ar_addr = ar_addr;
    this.r_resp  = r_resp;
  endfunction

  // ---------------------------------------------------------------------------
  // Method overriding for read transaction
  // ---------------------------------------------------------------------------
  function void axi_txn();
    $display("READ_TRAN->");
    $display("READ_DATA = %0d", r_data);
    $display("READ_ADDR = %0d", ar_addr);
    $display("ID = %0d", id);
    $display("BURST_LEN = %0d", burst_len);
    $display("READ_RESP = %0d", r_resp);
  endfunction

endclass

// -------------------------
// Testbench module
// -------------------------
module tb;

  // Base-class handle used for polymorphic access
  Base_Transactions tr_b;

  // Derived transaction objects
  Axi_write_transactions tr_w;
  Axi_read_transactions  tr_r;

  initial begin

    // -------------------------------------------------------------------------
    // Create a write transaction object and assign it to a base-class handle
    // -------------------------------------------------------------------------
    tr_w = new('d23, 'd34, 'd1, 'd23, 'd34, 'd3, 'd2, 'd3);

    // `$cast` is used to safely assign a child handle to a parent handle.
    if ($cast(tr_b, tr_w))
      $display("casting is success");
    else
      $display("casting is failed");

    // Runtime polymorphism:
    // The base handle calls the write version of axi_txn() because the actual
    // object stored in tr_b is an Axi_write_transactions object.
    tr_b.axi_txn();

    // -------------------------------------------------------------------------
    // Create a read transaction object and assign it to the same base handle
    // -------------------------------------------------------------------------
    tr_r = new('d24, 'd33, 'd5, 'd2, 'd1, 'd3, 'd4, 'd7);

    if ($cast(tr_b, tr_r))
      $display("casting is success");
    else
      $display("casting is failed");

    // This call dispatches to the read version of axi_txn() at runtime.
    tr_b.axi_txn();

  end
endmodule

// -----------------------------------------------------------------------------
// Summary:
// - `virtual class` creates an abstract base class.
// - `pure virtual function` forces derived classes to implement the method.
// - A base-class handle can point to different child objects.
// - The correct overridden method is selected at runtime.
// - This is the core idea behind runtime polymorphism in SystemVerilog.
// -----------------------------------------------------------------------------
