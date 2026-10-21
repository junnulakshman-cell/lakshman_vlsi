# SystemVerilog Constructor Chaining, Inheritance, and Method Overriding in AXI Transactions

## Overview

This example explains how constructors work in SystemVerilog when classes are inherited and how method overriding enables polymorphism in a realistic AXI-style transaction hierarchy.

The design demonstrates:

- Constructors using `function new()`
- Constructor chaining with `super.new()`
- Inheritance using `extends`
- Multilevel inheritance
- Method overriding using `virtual function`
- Calling parent methods using `super.display()`
- Using `this` to distinguish current object properties from arguments
- AXI read and write transaction modeling

---

## Files

- `oops/axi_constructor_inheritance.sv` — complete SystemVerilog implementation and testbench

---

## Class hierarchy

```text
base_transactions
        |
        v
   axi_transaction
       /      \
      /        \
     v          v
axi_read_transaction  axi_write_transaction
```

This hierarchy models a reusable transaction base class and two specialized transaction types:

- `axi_read_transaction` for read transfers
- `axi_write_transaction` for write transfers

The parent class contains common fields such as address, data, and ID, while derived classes add transaction-specific fields.

---

## Why constructors are important

A constructor is a special method automatically called when an object is created using `new()`.

Its purpose is to:

- initialize class properties
- set default values
- assign incoming arguments to member variables
- prepare the object for use

Without a constructor, class members may remain uninitialized and the object may not be in a valid state.

### Example

```systemverilog
class base_transactions;
  bit [15:0] data;
  bit [15:0] addr;

  function new(bit [15:0] data, bit [15:0] addr);
    this.data = data;
    this.addr = addr;
  endfunction
endclass
```

The object is created as:

```systemverilog
base_transactions tr = new(16'h1234, 16'h000A);
```

At creation time, `new()` initializes `data` and `addr` with the passed values.

---

## Where constructors are used

Constructors are used whenever you create a class object.

Typical case:

```systemverilog
axi_transaction tr = new(16'h10, 16'h20, 4'd3, 4'd5);
```

They are especially important in:

- verification environments
- UVM components and sequence items
- reusable transaction classes
- layered object hierarchies

In a verification environment, constructor initialization helps guarantee that a transaction object is valid before it is used in a driver, monitor, or scoreboard.

---

## Why `super.new()` is required

When a derived class inherits from a base class, the base class constructor must also run to initialize the inherited fields.

This is done using:

```systemverilog
super.new(...);
```

### Example

```systemverilog
class base_transactions;
  bit [15:0] data;
  bit [15:0] addr;

  function new(bit [15:0] data, bit [15:0] addr);
    this.data = data;
    this.addr = addr;
  endfunction
endclass

class axi_transaction extends base_transactions;
  bit [3:0] id;
  bit [3:0] burst_length;

  function new(bit [15:0] data, bit [15:0] addr, bit [3:0] id, bit [3:0] burst_length);
    super.new(data, addr);   // initialize base class fields
    this.id = id;
    this.burst_length = burst_length;
  endfunction
endclass
```

`super.new()` ensures the inherited properties are initialized before the derived class adds its own fields.

If you do not call `super.new()`, the base class part of the object may be left uninitialized.

---

## When constructor chaining is needed

Constructor chaining is required when:

- a derived class extends a base class
- the base class has member variables that must be initialized
- the object has a multi-level hierarchy

It is common in:

- UVM sequence items
- scoreboard transaction objects
- driver/monitor transaction classes
- reusable verification components

---

## `this` inside constructors

The keyword `this` refers to the current object instance.

It is used when the constructor argument name matches a class member name.

### Example

```systemverilog
function new(bit [15:0] data, bit [15:0] addr);
  this.data = data;
  this.addr = addr;
endfunction
```

Here:

- `data` and `addr` on the right are constructor arguments
- `this.data` and `this.addr` refer to the class members

The keyword `this` removes ambiguity.

Without `this`, the assignment would be unclear to the reader and may accidentally refer to the local argument instead of the object field.

---

## Base constructor example

```systemverilog
class base_transactions;
  bit [15:0] data;
  bit [15:0] addr;

  function new(logic [15:0] data, logic [15:0] addr);
    this.data = data;
    this.addr = addr;
    data = $random;
    addr = $random;
  endfunction
endclass
```

This example assigns the constructor arguments into object members using `this.data` and `this.addr`.

Then it assigns random values to local constructor arguments `data` and `addr`.

Important point:

- `data = $random;` changes the local argument, not the class property
- `this.data` remains the object value already assigned

So the real stored object state is not changed by these random assignments.

This is a common confusion in SystemVerilog OOP.

---

## Derived constructor example

```systemverilog
class axi_transaction extends base_transactions;
  bit [3:0] id;
  bit [3:0] burst_length;

  function new(
      logic [15:0] addr,
      logic [15:0] data,
      logic [3:0] id,
      logic [3:0] burst_length
  );
    super.new(data, addr);
    this.addr = addr;
    this.data = data;
    this.id = id;
    this.burst_length = burst_length;
  endfunction
endclass
```

### Why this works

- `super.new(data, addr)` initializes the parent object
- `this.addr = addr` and `this.data = data` assign derived values
- `this.id` and `this.burst_length` initialize the AXI-specific fields

This is typical constructor chaining in a hierarchy.

---

## Method overriding in SystemVerilog

Method overriding means a derived class provides its own implementation of a method already defined in the base class.

### Example

```systemverilog
class base_transactions;
  virtual function void display();
    $display("Base transaction");
  endfunction
endclass

class axi_transaction extends base_transactions;
  virtual function void display();
    $display("AXI transaction");
  endfunction
endclass
```

Here, `axi_transaction.display()` overrides `base_transactions.display()`.

---

## Why method overriding is used

It is used when:

- the base class defines a generic behavior
- each child class has a more specific implementation
- you want a base handle to call the correct child method dynamically

In AXI verification, a generic transaction object may hold a read or write transaction, but the actual display or data-processing logic should depend on the actual object type.

---

## Where overriding is used

It is used in:

- transaction classes
- UVM components
- scoreboard logic
- monitor/driver interfaces
- reusable testbench architecture

Examples:

- `base_transactions.display()`
- `axi_read_transaction.display()`
- `axi_write_transaction.display()`

Each child class may print different details based on read or write fields.

---

## When to override a method

Override a method when:

- the child class needs specialized behavior
- the parent class method is generic but not enough for the child
- the same method name must behave differently depending on the object type

This is the foundation of runtime polymorphism.

---

## `virtual` keyword and polymorphism

For method overriding to work properly through a base-class handle, the base method must be declared `virtual`.

### Example

```systemverilog
class base_transactions;
  virtual function void display();
    $display("Base");
  endfunction
endclass

class axi_read_transaction extends base_transactions;
  virtual function void display();
    $display("Read");
  endfunction
endclass

class axi_write_transaction extends base_transactions;
  virtual function void display();
    $display("Write");
  endfunction
endclass
```

Then the code can do:

```systemverilog
base_transactions tr;
axi_read_transaction read_tr = new();
axi_write_transaction write_tr = new();

tr = read_tr;
tr.display();     // calls read version

tr = write_tr;
tr.display();     // calls write version
```

This is dynamic binding, and it is the core of runtime polymorphism.

---

## `super.display()` in overriding

A derived class may want to reuse the parent method before or after adding child-specific behavior.

### Example

```systemverilog
class base_transactions;
  virtual function void display();
    $display("Base data = %0d", data);
  endfunction
endclass

class axi_transaction extends base_transactions;
  virtual function void display();
    super.display();
    $display("AXI ID = %0d", id);
  endfunction
endclass
```

`super.display()` calls the parent implementation of `display()`, and then the child adds extra details.

This is useful when you want:

- common data printed first
- derived data printed after
- a clean inheritance-based workflow

---

## Why method overriding is important in AXI verification

In a real verification environment, all transactions may share a common base class but have different fields and behavior.

For example:

- read transaction contains `read_data`, `read_addr`, `read_resp`
- write transaction contains `write_data`, `write_addr`, `write_resp`

The base class may define a generic `display()` or `print_txn()`, but each transaction type must print its own unique data. This is exactly what method overriding does.

---

## Full example flow

```systemverilog
class base_transactions;
  bit [15:0] data;
  bit [15:0] addr;

  function new(bit [15:0] data, bit [15:0] addr);
    this.data = data;
    this.addr = addr;
  endfunction

  virtual function void display();
    $display("Base_Transaction :-");
    $display(" DATA = %0d", data);
    $display(" ADDR = %0d", addr);
  endfunction
endclass

class axi_transaction extends base_transactions;
  bit [3:0] id;
  bit [3:0] burst_length;

  function new(bit [15:0] data, bit [15:0] addr, bit [3:0] id, bit [3:0] burst_length);
    super.new(data, addr);
    this.id = id;
    this.burst_length = burst_length;
  endfunction

  virtual function void display();
    $display("Axi_transaction :-");
    $display(" ID = %0d", id);
    $display(" Burst_Length = %0d", burst_length);
    $display(" DATA = %0d", data);
    $display(" ADDR = %0d", addr);
    super.display();
  endfunction
endclass

class axi_read_transaction extends axi_transaction;
  bit [15:0] read_addr;
  bit [15:0] read_data;

  function new(bit [15:0] data, bit [15:0] addr, bit [3:0] id, bit [3:0] burst_length,
               bit [15:0] read_addr, bit [15:0] read_data);
    super.new(data, addr, id, burst_length);
    this.read_addr = read_addr;
    this.read_data = read_data;
  endfunction

  virtual function void display();
    $display("AXI_READ_Transaction :-");
    $display(" READ_ADDR = %0d", read_addr);
    $display(" READ_DATA = %0d", read_data);
    super.display();
  endfunction
endclass

class axi_write_transaction extends axi_transaction;
  bit [15:0] write_addr;
  bit [15:0] write_data;

  function new(bit [15:0] data, bit [15:0] addr, bit [3:0] id, bit [3:0] burst_length,
               bit [15:0] write_addr, bit [15:0] write_data);
    super.new(data, addr, id, burst_length);
    this.write_addr = write_addr;
    this.write_data = write_data;
  endfunction

  virtual function void display();
    $display("AXI_WRITE_Transaction :-");
    $display(" WRITE_ADDR = %0d", write_addr);
    $display(" WRITE_DATA = %0d", write_data);
    super.display();
  endfunction
endclass
```

This is a clean example of:

- constructor chaining
- inheritance
- method overriding
- parent method reuse via `super`
- runtime polymorphism via `virtual`

---

## Expected output pattern

```text
Axi_transaction :-
 ID = 3
 Burst_Length = 5
 DATA = 34
 ADDR = 23

Base_Transaction :-
 DATA = 34
 ADDR = 23

AXI_READ_Transaction :-
 READ_ADDR = 12
 READ_DATA = 13
 ID = 6
 BURST = 7

Axi_transaction :-
 ID = 6
 Burst_Length = 7
 DATA = 13
 ADDR = 12

Base_Transaction :-
 DATA = 13
 ADDR = 12

AXI_WRITE_Transaction :-
 WRITE_ADDR = 45
 WRITE_DATA = 67
 ID = 1
 BURST = 2
```

The exact formatting may vary slightly across simulators, but the logic remains the same.

---

## Important concepts summary

- `new()` creates an object and initializes it
- `super.new()` calls the parent constructor
- `this` refers to the current object
- `extends` creates a child class from a parent
- `virtual` enables runtime dispatch
- overriding lets child classes provide specialized methods
- `super.method()` reuses the parent implementation

---

## Why this matters in SystemVerilog and UVM

These concepts are foundational for:

- reusable verification classes
- transaction modeling
- object-oriented testbench architecture
- UVM sequence items and components
- dynamic behavior based on object type

Without constructor chaining and method overriding, the verification infrastructure becomes rigid and repetitive.

---

## Interview-style explanation

### Q1: What is a constructor in SystemVerilog?
A constructor is a special method named `new()` that is called when an object is created. It initializes the member variables.

### Q2: Why is `super.new()` used?
Because the derived class needs to initialize inherited member variables by calling the parent constructor.

### Q3: What is method overriding?
It is when a derived class provides a different implementation of a method already defined in a base class.

### Q4: Why use `virtual`?
To support polymorphism so the correct overridden method is called based on the actual object type.

### Q5: What is the purpose of `this`?
It refers to the current object instance and is used to distinguish object members from local arguments.

### Q6: Why is `super.display()` useful?
It lets the child method reuse the parent behavior before or after adding child-specific logic.

---

## Practical takeaway

In a class hierarchy, the constructor builds the object from the parent down to the child. Then method overriding lets the same method name do different work depending on which class instance is active. This is the key idea behind object-oriented verification and polymorphism.

---

## Related concept

This README is closely related to the OOP topics covered in:

- `oops/README_polymorphism.md`
- `oops/README_constructor_inheritance.md`

---

## Author

**Lakshman Junnu**

VLSI Design & Verification Engineer

