# Abstract Class and Pure Virtual Methods in SystemVerilog

## Overview

This project demonstrates the concept of abstraction in SystemVerilog using an abstract base class and a pure virtual method.

The key idea is that a base class defines a common interface, while derived classes provide the actual implementation.

---

## Topic covered

- abstract class
- virtual class
- pure virtual method
- inheritance
- runtime polymorphism

---

## File added

- `abstract_class_pure_virtual_methods.sv` — commented SystemVerilog example

---

## Why abstraction is important

Abstraction is used to hide implementation details and expose only the required behavior.

In SystemVerilog, this is commonly done with:

```systemverilog
virtual class vehicle;
  pure virtual function void start();
endclass
```

A pure virtual method has no body. It forces the child classes to implement it.

---

## Class hierarchy

```text
          +-------------------+
          |      vehicle      |
          +-------------------+
          | # speed           |
          +-------------------+
          | set_speed()       |
          | start() (pure)    |
          +-------------------+
                    ^
                    |
          +-------------------+
          |        car        |
          +-------------------+
          | start() override  |
          +-------------------+

          +-------------------+
          |        bike       |
          +-------------------+
          | start() override  |
          +-------------------+
```

Legend:

```text
# = protected member
```

---

## Key concepts

### 1. Abstract base class

A virtual class cannot be instantiated directly.

```systemverilog
virtual class vehicle;
```

This means something like this is invalid:

```systemverilog
vehicle v = new();
```

---

### 2. Pure virtual method

A pure virtual function has no body.

```systemverilog
pure virtual function void start();
```

Any child class must implement it.

---

### 3. Inheritance

The child classes inherit the common `speed` field and the `set_speed()` method.

```systemverilog
class car extends vehicle;
```

---

### 4. Runtime polymorphism

A parent handle can point to different child objects.

```systemverilog
vehicle v;
car c;
bike b;

c = new();
v = c;
v.start();
```

The chosen method depends on the actual object assigned to the handle.

---

## Working example

```systemverilog
virtual class vehicle;
  protected int speed;

  pure virtual function void start();

  function void set_speed(int speed);
    this.speed = speed;
  endfunction
endclass

class car extends vehicle;
  function void start();
    $display("Car started. Speed = %0d", speed);
  endfunction
endclass

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

    v = c;
    c.set_speed(80);
    v.start();

    v = b;
    b.set_speed(50);
    v.start();
  end
endmodule
```

---

## Expected output

```text
Car started. Speed = 80
Bike started. Speed = 50
```

---

## Why this matters

Abstract classes are useful when multiple classes share the same interface but implement behavior differently.

This is a common pattern in object-oriented design, especially when building reusable verification components or structured class libraries.

---

## Interview notes

1. What is an abstract class?
   - It is a class that cannot be instantiated directly.

2. What is a pure virtual function?
   - A function declared without body, forcing subclasses to implement it.

3. Why use a virtual class?
   - To define a common contract for a family of related classes.

4. What is the advantage of abstraction?
   - It reduces implementation detail and encourages reusable design.

---

## Conclusion

This example shows how a virtual base class and a pure virtual method create a clear, reusable interface in SystemVerilog. The child classes provide the actual implementations, while the base handle can work with any derived object through polymorphism.
