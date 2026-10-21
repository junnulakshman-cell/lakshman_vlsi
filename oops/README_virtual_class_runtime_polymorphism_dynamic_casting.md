# SystemVerilog OOP: Abstraction, Inheritance, Runtime Polymorphism, and Dynamic Casting

## Overview

This project demonstrates the following Object-Oriented Programming (OOP) concepts in SystemVerilog:

- Abstraction
- Inheritance
- Runtime Polymorphism
- Dynamic Casting (`$cast`)
- Virtual Classes
- Pure Virtual Methods

A virtual parent class defines a pure virtual method named `display()`. The child class implements the method and controls a retry mechanism based on a status flag.

A parent class handle is used to access a child object, demonstrating runtime polymorphism.

---

# Problem Statement

Design a SystemVerilog program that demonstrates:

- A virtual base class with a pure virtual method
- A derived class implementing the pure virtual method
- Retry logic based on status information
- Runtime polymorphism using a parent class handle
- Dynamic casting using `$cast()`

The retry count should:

- Be enabled when `status = 1`
- Be disabled when `status = 0`

---

# Source Code

```systemverilog
virtual class parent;

  protected int status;

  pure virtual function void display();

endclass

class child extends parent;

  local int retry_count;

  function new();
    super.new();
  endfunction

  function void set_status(int status);
    this.status = status;
    $display("Status = %0b", status);
  endfunction

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
  child c;

  initial begin
    c = new();
    p = c;

    c.set_status(1);
    p.display();

    c.set_status(0);
    p.display();

    c.set_status(1);
    p.display();

    if($cast(p, c))
      $display("Casting is success");
    else
      $display("Casting is failed");
  end

endmodule
```

---

# Class Hierarchy

```text
                 +----------------+
                 |    parent      |
                 +----------------+
                 | # status       |
                 +----------------+
                 | display()      |
                 +----------------+
                         ▲
                         │
                         │ extends
                         │
                 +----------------+
                 |     child      |
                 +----------------+
                 | retry_count    |
                 +----------------+
                 | set_status()   |
                 | display()      |
                 +----------------+
```

Legend:

```text
# = protected
```

---

# OOP Concepts Demonstrated

## 1. Abstraction

Abstraction is the process of hiding implementation details and exposing only the required functionality.

This is implemented using:

```systemverilog
virtual class parent;
pure virtual function void display();
```

The parent class specifies what should be done, but not how it should be done.

---

## 2. Virtual Class

A virtual class cannot be instantiated directly.

Example:

```systemverilog
virtual class parent;
  protected int status;
  pure virtual function void display();
endclass
```

This class acts like a template for all derived classes.

---

## 3. Pure Virtual Function

A pure virtual function is declared without implementation:

```systemverilog
pure virtual function void display();
```

The child class must provide a definition.

---

## 4. Inheritance

Inheritance allows a child class to acquire features from the parent class:

```systemverilog
class child extends parent;
```

The child inherits the `status` variable.

---

## 5. Encapsulation

Encapsulation hides internal data and provides controlled access through methods.

This example uses:

```systemverilog
protected int status;
local int retry_count;
```

`status` is visible to the child class but hidden from the testbench.
`retry_count` is hidden inside the child class.

---

# Runtime Polymorphism

Runtime polymorphism occurs when a parent handle points to a child object and invokes an overridden method.

Example:

```systemverilog
parent p;
child c;

c = new();
p = c;
p.display();
```

Even though `p` is a parent handle, the child implementation of `display()` runs.

---

# Dynamic Casting

`$cast()` performs safe runtime type conversion.

```systemverilog
if($cast(p, c))
  $display("Casting is success");
```

This is an upcast from child to parent, and it succeeds because every child is also a parent.

---

# Expected Output

```text
Status = 1
COUNT IS RESTARTED
Status = 1 Count = 1

Status = 0
COUNT IS NOT RESTARTED
Status = 0 Count = 0

Status = 1
COUNT IS RESTARTED
Status = 1 Count = 1

Casting is success
```

---

# Interview Questions

## Q1. Why is the parent class declared virtual?

Because it is an abstract class and cannot be instantiated directly.

## Q2. What is a pure virtual method?

A method declared without implementation and required in all derived classes.

## Q3. What is runtime polymorphism?

A parent handle invoking the child implementation of an overridden method at runtime.

## Q4. What is the purpose of `$cast()`?

It performs safe runtime type conversion between class handles.

## Q5. What OOP concepts are demonstrated?

- Abstraction
- Encapsulation
- Inheritance
- Runtime Polymorphism
- Dynamic Casting

---

# Conclusion

This project demonstrates a complete SystemVerilog OOP workflow using a virtual class, pure virtual function, inheritance, encapsulation, runtime polymorphism, and dynamic casting. A parent handle references a child object and executes the child implementation of `display()` at runtime, while the retry mechanism is controlled by the inherited status variable.
