# SystemVerilog OOP: Virtual Class, Runtime Polymorphism, and Dynamic Casting

## Overview

This project demonstrates the core concepts of object-oriented programming in SystemVerilog using a virtual parent class, a child class, and a parent handle that points to a child object.

The example covers:

- Abstraction
- Inheritance
- Encapsulation
- Virtual classes
- Pure virtual methods
- Runtime polymorphism
- Dynamic casting using `$cast()`

The parent class defines a pure virtual `display()` method, and the child class provides the implementation. The `status` variable controls whether retry logic is enabled or disabled.

## File added

- `virtual_class_runtime_polymorphism_dynamic_casting.sv` — commented SystemVerilog source code

## Class structure

```text
          +------------------+
          |      parent      |
          +------------------+
          | protected status |
          +------------------+
          | display()        |
          +------------------+
                    ^
                    |
                    |
          +------------------+
          |      child       |
          +------------------+
          | local retry_count|
          +------------------+
          | set_status()     |
          | display()       |
          +------------------+
```

## Key concepts

### 1. Virtual class

A virtual class is an abstract class that cannot be instantiated directly. It acts as a template for the derived class.

```systemverilog
virtual class parent;
  protected int status;
  pure virtual function void display();
endclass
```

### 2. Pure virtual method

A pure virtual function has no implementation and must be implemented by every child class.

```systemverilog
pure virtual function void display();
```

### 3. Inheritance

The child inherits the protected variable `status` from the parent.

```systemverilog
class child extends parent;
```

### 4. Runtime polymorphism

A parent handle can point to a child object. When `p.display()` is called, the child implementation executes.

```systemverilog
parent p;
child  c;

c = new();
p = c;
p.display();
```

### 5. Dynamic casting

`$cast()` safely converts a child handle to a parent handle. Since a child is also a parent, the cast succeeds.

```systemverilog
if ($cast(p, c))
  $display("Casting is success");
```

## Program behavior

- If `status == 1`, retry count becomes `1` and the message prints:

```text
COUNT IS RESTARTED
Status = 1 Count = 1
```

- If `status == 0`, retry count becomes `0` and the message prints:

```text
COUNT IS NOT RESTARTED
Status = 0 Count = 0
```

## Expected output

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

## Why this example matters

This design shows how object-oriented programming in SystemVerilog supports abstraction and reuse. A base class defines a common contract, the child class implements it, and the base handle allows polymorphic behavior without knowing the exact object type at compile time.

## How to run

Use any SystemVerilog simulator such as Questa, VCS, or Xcelium.

1. Create a new project or compile the source file.
2. Add `virtual_class_runtime_polymorphism_dynamic_casting.sv`.
3. Run the simulation.
4. Compare the transcript output with the expected output shown above.

## Interview notes

1. Why is the parent class virtual?
   - Because it is an abstract class and cannot be instantiated directly.

2. What is a pure virtual method?
   - A method declared without implementation and forced to be implemented by derived classes.

3. What is runtime polymorphism?
   - A parent handle invoking an overridden child method at runtime.

4. Why is `$cast()` used?
   - To perform a safe type conversion between class handles.

5. What concept is shown by `p = c`?
   - A parent handle pointing to a child object.

## Conclusion

This example demonstrates a clean and practical SystemVerilog OOP workflow using abstraction, inheritance, encapsulation, runtime polymorphism, and dynamic casting. It is a useful reference for interview preparation, class design, and verification modeling tasks.
