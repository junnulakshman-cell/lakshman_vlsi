// File: oops/virtual_class_runtime_polymorphism_dynamic_casting.sv
// -----------------------------------------------------------------------------
// Topic: SystemVerilog OOP - Abstraction, Inheritance, Runtime Polymorphism,
//        and Dynamic Casting using $cast()
// -----------------------------------------------------------------------------
// This example demonstrates the following OOP features:
// 1) virtual class (abstract base class)
// 2) pure virtual method
// 3) inheritance
// 4) protected member access
// 5) runtime polymorphism using a parent handle
// 6) dynamic casting using $cast()
// -----------------------------------------------------------------------------

// A virtual class cannot be instantiated directly.
// It acts as a template and requires derived classes to implement the abstract method.
virtual class parent;

  // `protected int status;` is inherited by the child class.
  // It is hidden from the testbench.
  protected int status;

  // Pure virtual method: no implementation is provided here.
  // The child class must implement this method.
  pure virtual function void display();

endclass

// The child class extends the parent class and implements the pure virtual function.
class child extends parent;

  // `retry_count` is local to the child class.
  local int retry_count;

  // Constructor for the child class.
  function new();
    super.new();
  endfunction

  // This method updates the inherited status flag.
  function void set_status(int status);
    this.status = status;
    $display("Status = %0b", status);
  endfunction

  // Required implementation of the pure virtual method.
  // It uses the inherited `status` and the local `retry_count`.
  function void display();
    if(status == 1)
      retry_count = 1'b1;
    else
      retry_count = 1'b0;

    if(retry_count == 1)
      $display("COUNT IS RESTARTED\nStatus = %0b Count = %0b",
               retry_count, status);
    else
      $display("COUNT IS NOT RESTARTED\nStatus = %0b Count = %0b",
               retry_count, status);
  endfunction

endclass

module tb;

  parent p;
  child  c;

  initial begin

    // Create child object.
    c = new();

    // Parent handle is assigned to the child object.
    // This is a key runtime polymorphism example.
    p = c;

    // Enable status.
    c.set_status(1);
    p.display();

    // Disable status.
    c.set_status(0);
    p.display();

    // Enable status again.
    c.set_status(1);
    p.display();

    // Dynamic casting: child -> parent (upcasting)
    if($cast(p, c))
      $display("Casting is success");
    else
      $display("Casting is failed");

  end

endmodule

// -----------------------------------------------------------------------------
// Expected Output:
// -----------------------------------------------------------------------------
// Status = 1
// COUNT IS RESTARTED
// Status = 1 Count = 1
// Status = 0
// COUNT IS NOT RESTARTED
// Status = 0 Count = 0
// Status = 1
// COUNT IS RESTARTED
// Status = 1 Count = 1
// Casting is success
// -----------------------------------------------------------------------------
