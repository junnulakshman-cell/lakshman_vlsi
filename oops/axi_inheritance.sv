// File: axi_inheritance.sv
// Demonstrates multilevel inheritance, hierarchical inheritance,
// method overriding, super.display(), and the this keyword.
// This example shows how different AXI transaction types share
// common base behavior while adding their own specialized fields.

class base_transactions;
// Base class that contains common transaction properties
// shared by all derived AXI transaction classes.
  logic [15:0] data;
  logic [15:0] addr;

  // Default display method for a generic transaction
  virtual function void display();
    $display("BASE_TRANSACTION: DATA=%0d ADDR=%0d",
             data, addr);
  endfunction
endclass


class axi_transaction extends base_transactions;
// Derived class from base_transactions
// Adds AXI-specific fields: id and burst length.
  logic [3:0] id;
  logic [3:0] burst_length;

  // Method to set AXI fields using the this keyword
  // so the class members are explicitly assigned.
  function void set_axi_fields(
    logic [3:0] id,
    logic [3:0] burst_length
  );
    this.id = id;
    this.burst_length = burst_length;
  endfunction

  // Overridden display method
  // Calls the base class display using super.display().
  virtual function void display();
    $display("AXI_TRANSACTION: ID=%0d BURST=%0d DATA=%0d ADDR=%0d",
             id, burst_length, data, addr);
    super.display();
  endfunction
endclass


class axi_write_transaction extends axi_transaction;
// Hierarchical inheritance example:
// axi_write_transaction inherits from axi_transaction,
// which itself inherits from base_transactions.
// This class adds write-specific AXI fields.
  logic [15:0] aw_addr;
  logic [15:0] aw_data;

  // Set write-specific fields
  function void set_write_fields(
    logic [15:0] aw_addr,
    logic [15:0] aw_data
  );
    this.aw_addr = aw_addr;
    this.aw_data = aw_data;
  endfunction

  // Overridden display method for a write transaction
  // It prints write fields and then calls the parent display.
  virtual function void display();
    $display("AXI_WRITE: AW_ADDR=%0d AW_DATA=%0d ID=%0d BURST=%0d",
             aw_addr, aw_data, id, burst_length);
    super.display();
  endfunction
endclass


class axi_read_transaction extends axi_transaction;
// Another derived class from axi_transaction
// Adds read-specific AXI fields.
  logic [15:0] ar_addr;
  logic [15:0] ar_data;

  // Set read-specific fields
  function void set_read_fields(
    logic [15:0] ar_addr,
    logic [15:0] ar_data
  );
    this.ar_addr = ar_addr;
    this.ar_data = ar_data;
  endfunction

  // Overridden display method for a read transaction
  // It prints read fields and then calls the parent display.
  virtual function void display();
    $display("AXI_READ: AR_ADDR=%0d AR_DATA=%0d ID=%0d BURST=%0d",
             ar_addr, ar_data, id, burst_length);
    super.display();
  endfunction
endclass


module tb;
  // Handle objects for the base and derived classes
  axi_transaction       axi_tr;
  axi_write_transaction axi_wr;
  axi_read_transaction  axi_rd;

  initial begin
    // Create objects for each class
    axi_tr = new();
    axi_wr = new();
    axi_rd = new();

    // AXI transaction example
    // Set common transaction fields and AXI-specific fields
    axi_tr.data = 23;
    axi_tr.addr = 34;
    axi_tr.set_axi_fields(3, 5);
    axi_tr.display();

    // AXI read transaction example
    // Uses inherited fields from axi_transaction plus read-specific fields
    axi_rd.data = 23;
    axi_rd.addr = 34;
    axi_rd.set_axi_fields(4, 5);
    axi_rd.set_read_fields(12, 13);
    axi_rd.display();

    // AXI write transaction example
    // Uses inherited fields from axi_transaction plus write-specific fields
    axi_wr.data = 23;
    axi_wr.addr = 34;
    axi_wr.set_axi_fields(5, 1);
    axi_wr.set_write_fields(23, 45);
    axi_wr.display();

    $finish;
  end
endmodule
