# AXI Transaction Polymorphism in SystemVerilog

## Overview

This project demonstrates runtime polymorphism in SystemVerilog using AXI read and write transactions.

A base transaction class, `Base_Transactions`, is used as a common handle to access different derived transaction types:

- AXI write transaction
- AXI read transaction

The example shows how a parent-class handle can dynamically point to child-class objects and invoke the appropriate overridden method at runtime.

---

## OOP concepts demonstrated

- Inheritance
- Virtual functions
- Method overriding
- Dynamic binding
- Polymorphism
- Upcasting using `$cast`
- `this` keyword usage
- `super` keyword usage
- `extends` keyword usage

---

## Class hierarchy

```text
                   Base_Transactions
                          |
             --------------------------
             |                        |
             |                        |
     Axi_write_transactions   Axi_read_transactions
```

---

## Base transaction class

```systemverilog
class Base_Transactions;
```

### Common AXI fields

| Signal | Width | Description |
|--------|-------|-------------|
| data | 16-bit | Transaction data |
| addr | 32-bit | Address |
| id | 3-bit | Transaction ID |
| burst_len | 3-bit | Burst length |
| burst_size | 3-bit | Burst size |

### Virtual method

```systemverilog
virtual function void axi_txn();
```

This method is overridden in derived classes to provide transaction-specific behavior.

---

## AXI write transaction

```systemverilog
class Axi_write_transactions extends Base_Transactions;
```

### Additional signals

| Signal | Width | Description |
|--------|-------|-------------|
| w_data | 16-bit | Write data |
| aw_addr | 32-bit | Write address |
| b_resp | 2-bit | Write response |

### Overridden method

```systemverilog
function void axi_txn();
```

Displays AXI write transaction information.

---

## AXI read transaction

```systemverilog
class Axi_read_transactions extends Base_Transactions;
```

### Additional signals

| Signal | Width | Description |
|--------|-------|-------------|
| r_data | 16-bit | Read data |
| ar_addr | 32-bit | Read address |
| r_resp | 2-bit | Read response |

### Overridden method

```systemverilog
function void axi_txn();
```

Displays AXI read transaction information.

---

## Testbench flow

### Step 1: Create AXI write object

```systemverilog
tr_w = new(...);
```

### Step 2: Cast child object to parent handle

```systemverilog
$cast(tr_b, tr_w);
```

The parent handle now points to the AXI write transaction.

### Step 3: Invoke method

```systemverilog
tr_b.axi_txn();
```

At runtime, polymorphism calls:

```systemverilog
Axi_write_transactions::axi_txn()
```

---

### Step 4: Create AXI read object

```systemverilog
tr_r = new(...);
```

### Step 5: Cast child object to parent handle

```systemverilog
$cast(tr_b, tr_r);
```

The parent handle now points to the AXI read transaction.

### Step 6: Invoke method

```systemverilog
tr_b.axi_txn();
```

At runtime, polymorphism calls:

```systemverilog
Axi_read_transactions::axi_txn()
```

---

## Polymorphism flow

```text
                    tr_b
                      |
                      |
            Base_Transactions
                      |
         -------------------------
         |                       |
         |                       |
    tr_w Object             tr_r Object
         |                       |
         |                       |
AXI Write Method         AXI Read Method
         |                       |
         |                       |
     Display                Display
   Write Info             Read Info
```

---

## Expected output

```text
casting is success

AXI-WRITE_TRANS->
WRITE_DATA = 23
WRITE_ADDR = 34
ID = 3
BURST_LEN = 2
WRITE_RESP = 1

casting is success

READ_TRAN->
READ_DATA = 24
READ_ADDR = 33
ID = 3
BURST_LEN = 4
READ_RESP = 5
```

---

## Why a virtual function is required

The base class method is declared as:

```systemverilog
virtual function void axi_txn();
```

Without the `virtual` keyword:

- Static binding occurs
- The base class method is called

With the `virtual` keyword:

- Dynamic binding occurs
- The appropriate child method is called
- Runtime polymorphism is achieved

---

## `extends` keyword in SystemVerilog

### What is `extends`?

`extends` is the keyword used to create a derived class from a base class.

It means:

- the child class inherits all the properties and methods of the parent class
- the child class can add new members or override existing methods
- the child class can be treated as a specialized version of the parent

### Where is `extends` used?

`extends` is used when declaring a class hierarchy:

```systemverilog
class Axi_write_transactions extends Base_Transactions;
endclass
```

This means `Axi_write_transactions` is a child of `Base_Transactions`.

### Why is `extends` used?

It is used to:

1. reuse common transaction logic
2. create specialized behavior for different transaction types
3. model inheritance in OOP
4. support polymorphism through a common base handle

### When to use `extends`

Use `extends` when:

- multiple classes share common signals and methods
- you want to model a generic concept and then different specialized versions
- you want to reuse code without duplicating it
- you want to build a class hierarchy for verification infrastructure like UVM objects and components

### Example: base + child transaction

```systemverilog
class Base_Transactions;
  bit [31:0] addr;
  bit [2:0]  id;

  virtual function void axi_txn();
    $display("Base transaction");
  endfunction
endclass

class Axi_write_transactions extends Base_Transactions;
  bit [15:0] w_data;

  virtual function void axi_txn();
    $display("Write transaction: addr=%0d, id=%0d, data=%0d", addr, id, w_data);
  endfunction
endclass
```

Here, the write transaction inherits base properties such as `addr` and `id`, and adds its own property `w_data`.

### Important point

`extends` enables inheritance, but for polymorphism to work properly, the base method must usually be declared as `virtual` and the child method should override it.

---

## `this` keyword in SystemVerilog

### What is `this`?

`this` is a built-in handle that points to the current instance of the class. It is used inside a class to refer to the object that is currently executing the method or constructor.

In other words, when you write `this`, you mean:

- "the current object"
- "the instance of the class I am inside right now"

### Where is `this` used?

`this` is typically used inside:

- constructors (`new`)
- member functions
- overridden methods
- class methods when there is variable name conflict

### Why is `this` used?

It is mainly used to remove ambiguity when:

- a local variable or input argument has the same name as a class member
- you explicitly want to refer to the current object instead of a local variable

### When to use `this`

Use `this` when you want to access the current class instance clearly, especially in these situations:

1. Parameter passing to constructor
2. Assigning arguments to class members
3. Calling methods on the current object
4. Avoiding confusion between local variables and class properties

### Example 1: Distinguishing member variable and argument

```systemverilog
class Base_Transactions;
  bit [15:0] data;

  function new(bit [15:0] data);
    this.data = data;   // assigns argument to the class member
  endfunction
endclass
```

Here:

- `data` on the right side is the constructor argument
- `this.data` is the class property
- `this` makes the distinction explicit

### Example 2: Accessing current object

```systemverilog
class Axi_write_transactions extends Base_Transactions;
  function void print_txn();
    $display("Current object data = %0d", this.data);
  endfunction
endclass
```

This helps you clearly refer to the current transaction instance.

### Key idea

`this` is usually used to represent the current object. It does not refer to the parent class; it refers to the object that is currently active.

---

## `super` keyword in SystemVerilog

### What is `super`?

`super` is a special keyword that refers to the parent class (base class) of the current class (derived class).

It is used to access:

- base class members
- base class methods
- base class constructors
- functionality inherited from the parent class

### Where is `super` used?

`super` is used inside:

- derived class constructors
- derived class methods
- overridden methods
- inherited method chaining

### Why is `super` used?

It is used to:

1. initialize base class members
2. reuse common logic from the parent class
3. call the parent implementation of a method before or after adding child-specific logic
4. maintain clean and structured inheritance behavior

### When to use `super`

Use `super` in these scenarios:

1. When you need to call the base class constructor using `super.new()`
2. When you want to call the parent version of a virtual method
3. When you want to reuse inherited initialization logic
4. When you need to combine parent behavior and child-specific behavior

### Example 1: Calling base constructor

```systemverilog
class Base_Transactions;
  bit [31:0] addr;

  function new(bit [31:0] addr);
    this.addr = addr;
  endfunction
endclass

class Axi_write_transactions extends Base_Transactions;
  bit [15:0] w_data;

  function new(bit [31:0] addr, bit [15:0] w_data);
    super.new(addr);      // calls Base_Transactions::new()
    this.w_data = w_data;
  endfunction
endclass
```

Here:

- `super.new(addr)` initializes the base class data
- `this.w_data` initializes write-specific data

This ensures the parent object is initialized correctly before child logic runs.

### Example 2: Calling parent method before child logic

```systemverilog
class Base_Transactions;
  virtual function void axi_txn();
    $display("Base transaction common info");
  endfunction
endclass

class Axi_write_transactions extends Base_Transactions;
  virtual function void axi_txn();
    super.axi_txn();      // call parent functionality
    $display("Write transaction specific info");
  endfunction
endclass
```

This pattern is useful when you want to:

- keep the base functionality
- then add derived functionality

### Important concept

`super` does not mean "the current object". It means "the parent class part of the current object." It is used when the derived class wants to access or extend the parent behavior.

---

## `this` vs `super`

| Keyword | Meaning | Refers to |
|---------|---------|-----------|
| `this` | current instance | the object currently running the method |
| `super` | parent instance | the base class part of the current object |

### Simple comparison

```systemverilog
class Base_Transactions;
  bit [31:0] addr;

  function new(bit [31:0] addr);
    this.addr = addr;
  endfunction
endclass

class Axi_write_transactions extends Base_Transactions;
  bit [15:0] data;

  function new(bit [31:0] addr, bit [15:0] data);
    super.new(addr);    // parent initialization
    this.data = data;   // current object initialization
  endfunction
endclass
```

- `this.data` refers to the derived class member
- `super.new(addr)` calls the base class constructor

---

## Why these keywords matter in OOP and verification

In SystemVerilog OOP and UVM, these keywords are essential because:

- `extends` creates a reusable inheritance structure
- `this` helps identify the object currently running logic
- `super` allows reuse of base-class behavior and constructor chaining
- together they support clean inheritance, modular design, and scalable verification infrastructure

This is especially useful in:

- transaction classes
- sequence items
- drivers and monitors
- scoreboard logic
- reusable UVM components

---

## Key learning points

### Inheritance

```systemverilog
extends Base_Transactions
```

Allows derived classes to reuse common AXI fields.

### Method overriding

Both child classes provide their own implementation of:

```systemverilog
axi_txn()
```

### Runtime polymorphism

```systemverilog
tr_b.axi_txn();
```

Calls different methods depending on the object assigned to `tr_b`.

### Upcasting

```systemverilog
$cast(tr_b, tr_w);
$cast(tr_b, tr_r);
```

Converts child-class handles to base-class handles safely.

### `extends` keyword

```systemverilog
class Axi_write_transactions extends Base_Transactions;
```

Creates the inheritance relationship between parent and child classes.

### `this` keyword

```systemverilog
this.data = data;
```

Refers to the current object instance and helps avoid naming conflicts.

### `super` keyword

```systemverilog
super.new(addr);
super.axi_txn();
```

Calls base-class constructor or parent method to reuse inherited behavior.

---

## Applications in UVM

This concept is widely used in:

- `uvm_sequence_item`
- `uvm_sequence`
- `uvm_driver`
- `uvm_monitor`
- `uvm_agent`
- `uvm_scoreboard`

Benefits:

- Reusability
- Scalability
- Dynamic behavior selection
- Cleaner verification architecture
- Reduced code duplication

---

## Simulation

### EDA Playground

1. Open EDA Playground
2. Select a SystemVerilog simulator
3. Paste the source code
4. Run the simulation
5. Observe the runtime polymorphic behavior

---

## Learning outcome

After completing this example, you will understand:

- Virtual functions
- Dynamic binding
- Method overriding
- Upcasting with `$cast`
- Runtime polymorphism
- AXI transaction modeling using OOP
- Use of `extends`, `this`, and `super` in inheritance-based designs

---

## Related file

- `oops/axi_transaction_polymorphism.sv` — complete SystemVerilog implementation for this example

---

## Author

**Lakshman Junnu**

VLSI Design & Verification Engineer

### Areas of interest

- SystemVerilog
- UVM
- AXI protocol verification
- RTL design
- Functional verification
- AMBA protocols
