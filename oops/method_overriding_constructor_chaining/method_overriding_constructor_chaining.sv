// File: oops/method_overriding_constructor_chaining.sv
// -----------------------------------------------------------------------------
// Topic: SystemVerilog OOP - Method Overriding and Constructor Chaining
// -----------------------------------------------------------------------------
// This example demonstrates the following OOP features:
// 1) inheritance
// 2) method overriding
// 3) using `super.method_name()` to call parent method
// 4) constructor chaining using `super.new()`
// 5) runtime dispatch using base-class handle
// -----------------------------------------------------------------------------

// Base class: `base_txn`
// It defines a shared method `display()` that derived classes will override.
class base_txn;

  protected int id;

  // Parent constructor initializes the shared field.
  function new(int id);
    this.id = id;
  endfunction

  // Virtual method allows overriding in derived classes.
  virtual function void display();
    $display("BASE: id = %0d", id);
  endfunction

endclass

// Derived class: `write_txn`
// It overrides the parent display() method and adds a new field.
class write_txn extends base_txn;

  protected int data;

  // Child constructor calls the parent constructor first.
  function new(int id, int data);
    super.new(id);
    this.data = data;
  endfunction

  // Overridden method: same name and signature as parent.
  function void display();
    // `super.display();` calls the parent implementation.
    super.display();
    $display("WRITE: data = %0d", data);
  endfunction

endclass

// Another derived class: `read_txn`
// It also overrides `display()` and uses its own logic.
class read_txn extends base_txn;

  protected int address;

  function new(int id, int address);
    super.new(id);
    this.address = address;
  endfunction

  function void display();
    super.display();
    $display("READ: address = %0d", address);
  endfunction

endclass

module tb;

  base_txn tx;
  write_txn w;
  read_txn r;

  initial begin
    // Create derived objects.
    w = new(10, 25);
    r = new(20, 40);

    // Base handle can point to derived object.
    tx = w;
    tx.display();

    // Reassign base handle to another derived object.
    tx = r;
    tx.display();

    // Demonstrate constructor chaining explicitly with child object creation.
    $display("--- Constructor chaining example ---");
    $display("Created write object with id = %0d and data = %0d", w.id, w.data);
    $display("Created read object with id = %0d and address = %0d", r.id, r.address);
  end

endmodule

// -----------------------------------------------------------------------------
// Expected output:
// -----------------------------------------------------------------------------
// BASE: id = 10
// WRITE: data = 25
// BASE: id = 20
// READ: address = 40
// --- Constructor chaining example ---
// Created write object with id = 10 and data = 25
// Created read object with id = 20 and address = 40
// -----------------------------------------------------------------------------
