// File: oops/inheritance_basic.sv
// -----------------------------------------------------------------------------
// Topic: SystemVerilog OOP - Inheritance
// -----------------------------------------------------------------------------
// This example demonstrates the following OOP concepts:
// 1) Base class creation
// 2) Derived class creation using `extends`
// 3) Inheriting data members and methods
// 4) Using `super.new()` to initialize parent data
// 5) Accessing inherited protected members inside the child class
// -----------------------------------------------------------------------------

// `class parent;` defines the base class.
// The parent contains a protected variable `a`.
// `protected` means the variable is available in the child class,
// but not directly from the outside testbench.
class parent;

  // `protected int a;` can be accessed by derived classes.
  protected int a;

  // Constructor for the parent class.
  function new(int a);
    // `this.a = a;` assigns the incoming value to the member variable.
    this.a = a;
  endfunction

  // `function void display();` is a method available in the parent class.
  function void display();
    // `$display` prints the value stored in the parent member.
    $display("Parent a = %0d", a);
  endfunction

endclass

// `class child extends parent;` creates a derived class from the parent.
// The child inherits the `a` variable and the `display()` method.
class child extends parent;

  // `b` is a new member added only to the child class.
  protected int b;

  // Constructor of the child class.
  // It calls the parent constructor using `super.new(a);`.
  function new(int a, int b);
    // `super.new(a);` initializes the inherited parent variable.
    super.new(a);

    // `this.b = b;` stores the child-specific value.
    this.b = b;
  endfunction

  // `function void display_child();` shows that child can access inherited data.
  function void display_child();
    // `a` is protected and inherited from the parent.
    // The child can access it directly.
    $display("Child a = %0d, b = %0d", a, b);
  endfunction

  // `function void add();` demonstrates a child-specific operation.
  function void add();
    // `a` and `b` are both available inside the child class.
    $display("Sum = %0d", a + b);
  endfunction

endclass

// Testbench module
module tb;

  // `child c;` creates an object of the derived class.
  child c;

  initial begin
    // `c = new(10, 20);` creates the child object and initializes both variables.
    c = new(10, 20);

    // Calling parent method through the child object.
    c.display();

    // Calling the child-specific method.
    c.display_child();

    // Calling another child method that uses inherited data.
    c.add();

  end

endmodule

// -----------------------------------------------------------------------------
// Summary:
// - A child class inherits properties and methods from the parent.
// - `protected` members are available to the child class.
// - `super.new()` initializes the parent class constructor.
// - This is the basic concept of inheritance in SystemVerilog.
// -----------------------------------------------------------------------------
