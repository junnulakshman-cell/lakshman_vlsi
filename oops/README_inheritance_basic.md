# SystemVerilog Inheritance: Parent and Child Class Example

## Overview

This project demonstrates the basic concept of inheritance in SystemVerilog.

Inheritance allows a child class to reuse the properties and methods of a parent class while also adding new behavior.

## Topic covered

- Inheritance
- Base class and derived class
- Protected member access
- `super.new()` constructor call
- Reuse of parent behavior in child class

## File added

- `inheritance_basic.sv` — commented SystemVerilog example

## Class hierarchy

```text
          +------------------+
          |      parent      |
          +------------------+
          | # a              |
          +------------------+
          | new()            |
          | display()        |
          +------------------+
                    ^
                    |
                    |
          +------------------+
          |      child       |
          +------------------+
          | # b              |
          +------------------+
          | new()            |
          | display_child()  |
          | add()            |
          +------------------+
```

Legend:

```text
# = protected member
```

## Key concepts

### 1. Parent class

The parent class defines shared data and behavior.

```systemverilog
class parent;
  protected int a;

  function new(int a);
    this.a = a;
  endfunction

  function void display();
    $display("Parent a = %0d", a);
  endfunction
endclass
```

The member `a` is protected, so the child class can access it, but the testbench cannot.

### 2. Child class

The child class extends the parent class and adds its own member `b`.

```systemverilog
class child extends parent;
  protected int b;

  function new(int a, int b);
    super.new(a);
    this.b = b;
  endfunction
endclass
```

`super.new(a);` calls the parent constructor first so that inherited data is initialized.

### 3. Accessing inherited members

The child class can directly access a protected parent variable.

```systemverilog
function void display_child();
  $display("Child a = %0d, b = %0d", a, b);
endfunction
```

This is the main benefit of `protected` access.

## Working example

```systemverilog
class parent;
  protected int a;

  function new(int a);
    this.a = a;
  endfunction

  function void display();
    $display("Parent a = %0d", a);
  endfunction
endclass

class child extends parent;
  protected int b;

  function new(int a, int b);
    super.new(a);
    this.b = b;
  endfunction

  function void display_child();
    $display("Child a = %0d, b = %0d", a, b);
  endfunction

  function void add();
    $display("Sum = %0d", a + b);
  endfunction
endclass

module tb;
  child c;

  initial begin
    c = new(10, 20);
    c.display();
    c.display_child();
    c.add();
  end
endmodule
```

## Expected output

```text
Parent a = 10
Child a = 10, b = 20
Sum = 30
```

## Why inheritance matters

Inheritance allows code reuse and modular design.

It helps with:

- reducing code duplication
- organizing related classes
- creating structured class hierarchies
- improving maintainability

## Interview notes

1. What is inheritance?
   - It is the process by which a child class acquires the properties and methods of a parent class.

2. Why use `super.new()`?
   - To initialize the parent class before setting the child-specific values.

3. Why is `a` declared as protected?
   - So the child class can access it, while the outside testbench cannot.

4. What is the difference between parent and child class?
   - The parent defines common behavior, while the child extends it and adds new functionality.

## Conclusion

This example shows the simplest and most important form of SystemVerilog inheritance. The child class extends the parent class, reuses inherited data, and adds its own logic. It is the foundation for more advanced OOP features such as polymorphism and abstraction.
