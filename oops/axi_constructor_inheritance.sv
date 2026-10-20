// File: axi_constructor_inheritance.sv
// Demonstrates constructor chaining, inheritance, method overriding,
// this keyword, super.new(), and super.display().

class base_transactions;
  logic [15:0] data;
  logic [15:0] addr;

  function new(logic [15:0] data, logic [15:0] addr);
    this.data = data;
    this.addr = addr;

    // These statements modify the arguments, not the class properties.
    // Remove them if random values are not intended.
    data = $random;
    addr = $random;
  endfunction

  virtual function void display();
    $display("Base_Transaction :-\n DATA = %0d\n ADDR = %0d\n",
             data, addr);
  endfunction
endclass


class axi_transaction extends base_transactions;
  logic [3:0] id;
  logic [3:0] burst_length;

  function new(
    logic [15:0] addr,
    logic [15:0] data,
    logic [3:0] id,
    logic [3:0] burst_length
  );
    super.new(data, addr);
    this.addr = addr;
    this.data = data;
    this.id = id;
    this.burst_length = burst_length;
  endfunction

  virtual function void display();
    $display("Axi_transaction :-\n ID = %0d\n Burst_Length = %0d\n DATA = %0d\n ADDR = %0d\n",
             id, burst_length, data, addr);
    super.display();
  endfunction
endclass


class axi_write_transaction extends axi_transaction;
  logic [15:0] aw_addr;
  logic [15:0] aw_data;

  function new(
    logic [15:0] aw_addr,
    logic [15:0] aw_data,
    logic [3:0] id,
    logic [3:0] burst_length
  );
    super.new(aw_addr, aw_data, id, burst_length);
    this.aw_addr = aw_addr;
    this.aw_data = aw_data;
  endfunction

  virtual function void display();
    $display("AXI_WRITE_Transaction :-\n WRITE_ADDR = %0d\n WRITE_DATA = %0d\n ID = %0d\n BURST = %0d\n",
             aw_addr, aw_data, id, burst_length);
    // This version prints only write-specific fields.
    // Add super.display() here if parent details should also be printed.
  endfunction
endclass


class axi_read_transaction extends axi_transaction;
  logic [15:0] ar_addr;
  logic [15:0] ar_data;

  function new(
    logic [15:0] ar_addr,
    logic [15:0] ar_data,
    logic [3:0] id,
    logic [3:0] burst_length
  );
    super.new(ar_addr, ar_data, id, burst_length);
    this.ar_addr = ar_addr;
    this.ar_data = ar_data;
  endfunction

  virtual function void display();
    $display("AXI_READ_Transaction :-\n READ_ADDR = %0d\n READ_DATA = %0d\n ID = %0d\n BURST = %0d\n",
             ar_addr, ar_data, id, burst_length);
    super.display();
  endfunction
endclass


module tb;
  axi_transaction       axi_tr;
  axi_write_transaction axi_wr;
  axi_read_transaction  axi_rd;

  initial begin
    axi_tr = new(23, 34, 3, 5);
    axi_rd = new(12, 13, 6, 7);
    axi_wr = new(45, 67, 1, 2);

    axi_tr.display();

    // READ_TRANSACTION
    axi_rd.display();

    // WRITE_TRANSACTION
    axi_wr.display();

    $finish;
  end
endmodule
