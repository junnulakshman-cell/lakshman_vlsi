# SystemVerilog Method Overriding and Constructor Chaining

## Overview

This project demonstrates two important object-oriented concepts in SystemVerilog:

- Method overriding
- Constructor chaining

It also shows how a base-class handle can point to a derived object and call the derived method through virtual dispatch.

---

## Topic covered

- inheritance
- method overriding
- `virtual function`
- `super.display()`
- `super.new()`
- base-class handle to child object

---

## File added

- `method_overriding_constructor_chaining.sv` — commented SystemVerilog example

---

## Class hierarchy

```text
            +----------------------+
            |       base_txn       |
            +----------------------+
            | # id                 |
            +----------------------+
            | new(id)              |
            | display()            |
            +----------------------+
                     ^
                     |
                     |
            +----------------------+ 
            |      write_txn       |
            +----------------------+
            | # data               |
            +----------------------+
            | new(id,data)         |
            | display() override   |
            +----------------------+

            +----------------------+
            |       read_txn       |
            +----------------------+
            | # address            |
            +----------------------+
            | new(id,address)      |
            | display() override   |
            +----------------------+
```

Legend:

```text
# = protected member
```

---

## Key concepts

### 1. Method overriding

A derived class can provide a new implementation of a method already defined in the parent class.

```systemverilog
virtual function void display();
  $display("BASE: id = %0d", id);
endfunction
```

Derived version:

```systemverilog
function void display();
  super.display();
  $display("WRITE: data = %0d", data);
endfunction
```

This is called method overriding.

---

### 2. `super.display()`

`super.display()` calls the parent class implementation of the method before executing the child-specific logic.

```systemverilog
super.display();
```

This helps preserve the parent behavior while extending it in the child.

---

### 3. Constructor chaining

The child constructor calls the parent constructor using `super.new()` before initializing its own fields.

```systemverilog
function new(int id, int data);
  super.new(id);
  this.data = data;
endfunction
```

This ensures the inherited data is initialized correctly.

---

### 4. Runtime dispatch

A base-class handle can point to a derived object.

```systemverilog
base_txn tx;
write_txn w;

w = new(10, 25);
tx = w;
tx.display();
```

Because `display()` is virtual, the derived method is executed at runtime.

---

## Working example

```systemverilog
class base_txn;
  protected int id;

  function new(int id);
    this.id = id;
  endfunction

  virtual function void display();
    $display("BASE: id = %0d", id);
  endfunction
endclass

class write_txn extends base_txn;
  protected int data;

  function new(int id, int data);
    super.new(id);
    this.data = data;
  endfunction

  function void display();
    super.display();
    $display("WRITE: data = %0d", data);
  endfunction
endclass

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
    w = new(10, 25);
    r = new(20, 40);

    tx = w;
    tx.display();

    tx = r;
    tx.display();
  end
endmodule
```

---

## Expected output

```text
BASE: id = 10
WRITE: data = 25
BASE: id = 20
READ: address = 40
```

---

## Why this matters

Method overriding and constructor chaining are fundamental OOP techniques used in:

- testbench class modeling
- reusable verification components
- transaction-level abstraction
- scalable object-oriented hardware description

---

## Interview notes

1. What is method overriding?
   - It is when a derived class defines a method with the same name and signature as the parent class.

2. Why use `super.display()`?
   - To reuse the parent behavior while adding more specific logic in the child.

3. Why is constructor chaining needed?
   - To initialize inherited fields before child-specific fields are assigned.

4. What happens with a base-class handle pointing to a child object?
   - The actual child method is called if the method is virtual.

---

## Conclusion

This example demonstrates how inheritance, overriding, and constructor chaining work together in SystemVerilog. It is a basic but essential pattern for building reusable, extensible class hierarchies.
