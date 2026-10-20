// File: axi_inheritance_polymorphism.sv
// Demonstrates multilevel inheritance, hierarchical inheritance,
// method overriding, super.display(), and the this keyword.

class base_transactions;
  logic [15:0] data;
  logic [15:0] addr;

  virtual function void display();
    $display("BASE_TRANSACTION: DATA=%0d ADDR=%0d",
             data, addr);
  endfunction
endclass


class axi_transaction extends base_transactions;
  logic [3:0] id;
  logic [3:0] burst_length;

  function void set_axi_fields(
    logic [3:0] id,
    logic [3:0] burst_length
  );
    this.id = id;
    this.burst_length = burst_length;
  endfunction

  virtual function void display();
    $display("AXI_TRANSACTION: ID=%0d BURST=%0d DATA=%0d ADDR=%0d",
             id, burst_length, data, addr);
    super.display();
  endfunction
endclass


class axi_write_transaction extends axi_transaction;
  logic [15:0] aw_addr;
  logic [15:0] aw_data;

  function void set_write_fields(
    logic [15:0] aw_addr,
    logic [15:0] aw_data
  );
    this.aw_addr = aw_addr;
    this.aw_data = aw_data;
  endfunction

  virtual function void display();
    $display("AXI_WRITE: AW_ADDR=%0d AW_DATA=%0d ID=%0d BURST=%0d",
             aw_addr, aw_data, id, burst_length);
    super.display();
  endfunction
endclass


class axi_read_transaction extends axi_transaction;
  logic [15:0] ar_addr;
  logic [15:0] ar_data;

  function void set_read_fields(
    logic [15:0] ar_addr,
    logic [15:0] ar_data
  );
    this.ar_addr = ar_addr;
    this.ar_data = ar_data;
  endfunction

  virtual function void display();
    $display("AXI_READ: AR_ADDR=%0d AR_DATA=%0d ID=%0d BURST=%0d",
             ar_addr, ar_data, id, burst_length);
    super.display();
  endfunction
endclass


module tb;
  axi_transaction       axi_tr;
  axi_write_transaction axi_wr;
  axi_read_transaction  axi_rd;

  initial begin
    axi_tr = new();
    axi_wr = new();
    axi_rd = new();

    // AXI transaction
    axi_tr.data = 23;
    axi_tr.addr = 34;
    axi_tr.set_axi_fields(3, 5);
    axi_tr.display();

    // AXI read transaction
    axi_rd.data = 23;
    axi_rd.addr = 34;
    axi_rd.set_axi_fields(4, 5);
    axi_rd.set_read_fields(12, 13);
    axi_rd.display();

    // AXI write transaction
    axi_wr.data = 23;
    axi_wr.addr = 34;
    axi_wr.set_axi_fields(5, 1);
    axi_wr.set_write_fields(23, 45);
    axi_wr.display();

    $finish;
  end
endmodule
