// File: oops/encapsulation_local_protected_access.sv
// -----------------------------------------------------------------------------
// Topic: SystemVerilog Encapsulation - local vs protected access
// -----------------------------------------------------------------------------
// This example demonstrates the difference between:
// 1) `local` access - visible only in the same class
// 2) `protected` access - visible in the parent and child classes
// 3) data hiding and controlled access in OOP
// -----------------------------------------------------------------------------

// This parent class demonstrates the `local` version.
// `a` is local to this class only.
// It is NOT accessible to the child class.
class parent_local;
  local int a = 3;
  int b = 6;

  // `print()` can access both `a` and `b` because it is inside the same class.
  function void print();
    $display("a=%0d,b=%0d", a, b);
  endfunction
endclass

// This child class tries to access `a` from the parent_local class.
// This will fail because `a` is local to parent_local.
class child_local extends parent_local;
  int c;

  function void sub();
    // ERROR: c = a - b;  // `a` is not accessible here because it is local.
    c = b - 1;
    $display("c=%0d", c);
  endfunction
endclass

// This parent class demonstrates the `protected` version.
// `a` is visible to the child class but hidden from the testbench.
class parent_protected;
  protected int a = 3;
  int b = 6;

  function void print();
    $display("a=%0d,b=%0d", a, b);
  endfunction
endclass

// This child class can access the protected `a` inherited from the parent.
class child_protected extends parent_protected;
  int c;

  function void sub();
    c = a - b;
    $display("c=%0d", c);
  endfunction
endclass

module tb;
  parent_local p1;
  child_local  c1;
  parent_protected p2;
  child_protected c2;

  initial begin
    // Create objects
    p1 = new();
    c1 = new();
    p2 = new();
    c2 = new();

    // Example 1: `local` access is not allowed from child
    // c1.sub();  // This would fail if it tried to use `a` directly.
    p1.print();
    c1.sub();

    // Example 2: `protected` access works in child
    p2.print();
    c2.sub();

  end
endmodule

// -----------------------------------------------------------------------------
// Summary:
// - `local` members are only accessible within the same class.
// - `protected` members are accessible in the parent and derived classes.
// - This demonstrates the core idea of encapsulation in SystemVerilog.
// -----------------------------------------------------------------------------
