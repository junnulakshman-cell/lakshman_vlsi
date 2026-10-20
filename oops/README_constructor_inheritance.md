# SystemVerilog Constructor Chaining and Inheritance --- AXI Transactions

## Overview

This example builds an AXI-inspired transaction class hierarchy and
demonstrates:

-   Constructors using `function new()`
-   Constructor chaining with `super.new()`
-   Inheritance using `extends`
-   Multilevel and hierarchical inheritance
-   Method overriding with `virtual function`
-   Calling a parent method with `super.display()`
-   Using `this` to distinguish class properties from arguments
-   Transaction-specific read and write fields

## Files

-   `axi_constructor_inheritance.sv` --- complete SystemVerilog source
    and testbench.

## Class hierarchy

``` text
base_transactions
        |
        v
  axi_transaction
      /       \
     v         v
axi_write    axi_read
_transaction _transaction
```

`axi_transaction` inherits from `base_transactions`. The read and write
classes both inherit from `axi_transaction`.

## How the constructors work

### 1. Base constructor

``` systemverilog
function new(logic [15:0] data, logic [15:0] addr);
  this.data = data;
  this.addr = addr;
  data = $random;
  addr = $random;
endfunction
```

The first two statements copy the constructor arguments into the
object's properties. Because the argument names match the property
names, `this.data` and `this.addr` explicitly refer to the current
object's fields.

The later `$random` assignments change the local constructor arguments,
not the object properties. They do not change the values already copied
into `this.data` and `this.addr`. If random values are not needed,
remove those two statements.

### 2. AXI transaction constructor

``` systemverilog
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
```

`super.new(data, addr)` invokes the parent constructor. Notice that the
arguments are passed in the order `data, addr`, because that is the
order expected by `base_transactions.new()`.

The derived constructor then assigns the inherited fields and the
AXI-specific fields. The repeated assignments to `this.data` and
`this.addr` are redundant in this example, because the parent
constructor has already assigned them, but they are legal.

### 3. Read and write constructors

The read and write classes call `super.new()` to initialize the
inherited transaction fields, then initialize their own fields
(`ar_addr`, `ar_data`, `aw_addr`, and `aw_data`).

## Method overriding and `super.display()`

Each class provides its own `display()` implementation. This is method
overriding.

-   `base_transactions.display()` prints common data and address fields.
-   `axi_transaction.display()` prints ID, burst length, data, and
    address, then calls `super.display()`.
-   `axi_read_transaction.display()` prints read-specific fields and
    then calls the parent display implementation.
-   `axi_write_transaction.display()` prints write-specific fields. In
    the supplied example it does not call `super.display()`, so it does
    not print the parent fields.

`virtual` enables polymorphic dispatch when an overridden method is
called through a base-class handle. It is good practice to keep the
method virtual in the class hierarchy when polymorphic behavior is
intended.

## Expected output

``` text
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

Whitespace and capitalization may vary slightly by simulator. The write
transaction prints only its own display message because its `display()`
does not call `super.display()`.

## Important concepts

  -----------------------------------------------------------------------
  Concept                             Explanation
  ----------------------------------- -----------------------------------
  `new()`                             Constructor called when creating a
                                      class object.

  `super.new(...)`                    Calls the parent class constructor
                                      to initialize inherited state.

  `this.data`                         Refers to the current object's
                                      `data` property.

  `extends`                           Creates a derived class from a
                                      parent class.

  `virtual function`                  Supports polymorphic dispatch for
                                      overridden methods.

  `super.display()`                   Calls the parent class's
                                      implementation of `display()`.

  Method overriding                   A derived class provides its own
                                      implementation of a parent method.
  -----------------------------------------------------------------------

## Interview questions

1.  **What is constructor chaining?** Calling a parent constructor from
    a derived constructor, commonly using `super.new(...)`.
2.  **Why is `super.new()` used?** To initialize fields and state
    defined by the parent class.
3.  **Why does argument order matter in `super.new(data, addr)`?**
    Arguments are assigned according to the parent constructor's
    parameter order.
4.  **What is the purpose of `this`?** It explicitly refers to the
    current object's property or method.
5.  **Does `data = $random` update `this.data`?** No. In this
    constructor, `data` is a local argument that shadows the property
    name.
6.  **What does `super.display()` do?** It calls the parent
    implementation of `display()`.
7.  **Why doesn't the write output show the base transaction?** Its
    overridden `display()` does not call `super.display()`.
8.  **Is this a complete AXI protocol model?** No. The fields are
    AXI-inspired; the example focuses on SystemVerilog OOP.

## Running the example

1.  Open EDA Playground or another SystemVerilog simulator.
2.  Create a SystemVerilog source file.
3.  Paste or upload `axi_constructor_inheritance.sv`.
4.  Select `tb` as the top-level module and run.
5.  Compare the transcript with the expected output.

## Note

This is a learning example for SystemVerilog OOP. It does not model AXI
channel handshakes, timing, or protocol compliance.
