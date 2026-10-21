// File: oops/virtual_class_runtime_polymorphism_dynamic_casting.sv
// -----------------------------------------------------------------------------
// Topic: SystemVerilog OOP - Abstraction, Inheritance, Runtime Polymorphism,
//        and Dynamic Casting using $cast()
// -----------------------------------------------------------------------------
// This example demonstrates the following OOP concepts:
// 1) An abstract base class using `virtual class`
// 2) A pure virtual method using `pure virtual function`
// 3) Inheritance using `extends`
// 4) Encapsulation using protected/local members
// 5) Runtime polymorphism using a parent handle pointing to a child object
// 6) Dynamic casting using `$cast()`
// -----------------------------------------------------------------------------

// `virtual class parent;` declares an abstract base class.
// A virtual class cannot be instantiated directly.
// It defines a common interface that derived classes must implement.
virtual class parent;

  // `protected int status;` stores the status value.
  // This member is visible to the parent and child classes, but not to the testbench.
  protected int status;

  // `pure virtual function void display();` is an abstract method.
  // The child class must provide a body for this method.
  pure virtual function void display();

endclass

// `class child extends parent;` creates a derived class from the parent.
// The child inherits the status variable and implements the abstract display() method.
class child extends parent;

  // `local int retry_count;` stores the retry state internally.
  // It is only accessible inside this class.
  local int retry_count;

  // `function new();` is the constructor.
  // `super.new();` calls the parent class constructor.
  function new();
    super.new();
  endfunction

  // `function void set_status(int status);` updates the inherited status variable.
  // The parameter name matches the property name, so `this.status` is used to avoid ambiguity.
  function void set_status(int status);

    // `this.status = status;` assigns the argument value to the class property.
    this.status = status;

    // `$display` prints the status in binary form.
    $display("Status = %0b", status);

  endfunction

  // `function void display();` is the required implementation of the pure virtual method.
  // This method decides whether the retry counter is enabled or disabled based on the status.
  function void display();

    // `if(status == 1)` checks whether the status flag is enabled.
    // If enabled, retry mode is active.
    if(status == 1)
      // `retry_count = 1'b1;` sets the retry count to 1 when status is ON.
      retry_count = 1'b1;
    else
      // `retry_count = 1'b0;` sets the retry count to 0 when status is OFF.
      retry_count = 1'b0;

    // `if(retry_count == 1)` prints the restart message when retry is enabled.
    if(retry_count == 1)
      // The display message tells the user that the retry counter is restarted.
      $display(
       "COUNT IS RESTARTED\nStatus = %0b Count = %0b",
        retry_count,status
      );
    else
      // The display message tells the user that retry is not restarted.
      $display(
       "COUNT IS NOT RESTARTED\nStatus = %0b Count = %0b",
        retry_count,status
      );

  endfunction

endclass

// `module tb;` defines the testbench module.
module tb;

  // `parent p;` declares a parent-class handle.
  // The handle can reference any child object of this parent type.
  parent p;

  // `child c;` declares a child object handle.
  child  c;

  // `initial begin` marks the start of simulation-time behavior.
  initial begin

    // `c = new();` creates a new child object in memory.
    c = new();

    // `p = c;` assigns the child object to the parent handle.
    // This is the standard example of runtime polymorphism.
    p = c;

    // `c.set_status(1);` enables the retry mechanism by setting status to 1.
    c.set_status(1);

    // `p.display();` calls the child implementation of display() through the parent handle.
    // This is runtime polymorphism: the method chosen depends on the actual object type.
    p.display();

    // `c.set_status(0);` disables the retry mechanism by setting status to 0.
    c.set_status(0);

    // `p.display();` invokes the overridden method again with the updated status.
    p.display();

    // `c.set_status(1);` sets the status back to enabled for the final check.
    c.set_status(1);

    // `p.display();` executes the child version of display() once more.
    p.display();

    // `$cast(p,c)` performs a safe type conversion from child to parent.
    // Since every child is also a parent, this cast succeeds.
    if($cast(p,c))
      // If the cast succeeds, the message is printed.
      $display("Casting is success");
    else
      // If the cast fails, this message is printed.
      $display("Casting is failed");

  end

endmodule

// -----------------------------------------------------------------------------
// Summary of the example:
// - `parent` is a virtual abstract class.
// - `display()` is a pure virtual method that must be implemented in the child.
// - `child` inherits `status` and adds retry logic.
// - `p = c` shows runtime polymorphism.
// - `p.display()` calls the child implementation at runtime.
// - `$cast(p, c)` demonstrates dynamic casting with safe type conversion.
// -----------------------------------------------------------------------------
