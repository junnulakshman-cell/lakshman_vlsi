// File: oops/abstract_class_pure_virtual_methods.sv
// -----------------------------------------------------------------------------
// Topic: SystemVerilog OOP - Abstract Class and Pure Virtual Methods
// -----------------------------------------------------------------------------
// This example demonstrates:
// 1) abstract base class using `virtual class`
// 2) pure virtual method using `pure virtual function`
// 3) inheritance and implementation by the child class
// 4) runtime polymorphism using a parent-class handle
// -----------------------------------------------------------------------------

// Base class is abstract because it is declared as `virtual class`.
// It cannot be instantiated directly.
virtual class vehicle;

  protected int speed;

  // Pure virtual method: no implementation is provided here.
  // Every derived class must implement it.
  pure virtual function void start();

  // Regular method in the abstract base class.
  function void set_speed(int speed);
    this.speed = speed;
  endfunction

endclass

// Derived class `car` implements the pure virtual method.
class car extends vehicle;

  // Method implementation required by the abstract base class.
  function void start();
    $display("Car started. Speed = %0d", speed);
  endfunction

endclass

// Derived class `bike` also implements the pure virtual method.
class bike extends vehicle;

  function void start();
    $display("Bike started. Speed = %0d", speed);
  endfunction

endclass

module tb;

  vehicle v;
  car c;
  bike b;

  initial begin
    c = new();
    b = new();

    // Assign child objects to the parent handle.
    v = c;
    c.set_speed(80);
    v.start();

    v = b;
    b.set_speed(50);
    v.start();

  end

endmodule

// -----------------------------------------------------------------------------
// Expected output:
// -----------------------------------------------------------------------------
// Car started. Speed = 80
// Bike started. Speed = 50
// -----------------------------------------------------------------------------
