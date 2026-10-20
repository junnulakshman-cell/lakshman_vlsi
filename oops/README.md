# SystemVerilog Inheritance and Method Overriding --- AXI Transactions

## Overview

This example demonstrates object-oriented programming (OOP) in
SystemVerilog using an AXI-style transaction class hierarchy. It covers:

-   Class inheritance with `extends`
-   Multilevel inheritance
-   Hierarchical inheritance
-   Virtual methods and method overriding
-   Calling a parent implementation with `super`
-   The `this` keyword
-   Class handles and object construction using `new()`

## Files

-   `axi_inheritance_polymorphism.sv` --- complete SystemVerilog source
    and testbench.

## Class hierarchy

``` text
base_transactions
        |
        v
 axi_transaction
      /     \
     v       v
axi_write  axi_read
_transaction _transaction
```

`axi_transaction` inherits from `base_transactions`. Both
`axi_write_transaction` and `axi_read_transaction` inherit from
`axi_transaction`.

This is **multilevel inheritance** along the path
`base_transactions → axi_transaction → axi_write_transaction` (or
`axi_read_transaction`). It is also **hierarchical inheritance** because
two classes inherit from the same parent, `axi_transaction`.

## Class-by-class explanation

### 1. `base_transactions`

This is the base class. It declares common transaction fields:

-   `data`: 16-bit data field.
-   `addr`: 16-bit address field.

Its `virtual function void display()` prints those common fields.
Declaring the method `virtual` allows a derived class's overridden
`display()` implementation to be selected when the method is called
through a base-class handle.

### 2. `axi_transaction`

This class extends `base_transactions`, so it inherits `data`, `addr`,
and `display()`.

It adds:

-   `id`: 4-bit transaction ID.
-   `burst_length`: 4-bit burst-length field.

`set_axi_fields()` assigns the AXI fields. In statements such as
`this.id = id`, `this.id` refers to the class property while the
unqualified `id` on the right refers to the function argument. This
avoids ambiguity when argument names match property names.

Its overridden `display()` prints AXI-specific information and calls
`super.display()` to execute the base-class display method as well.

### 3. `axi_write_transaction`

This class extends `axi_transaction`, inheriting its fields and methods.
It adds:

-   `aw_addr`: write address field.
-   `aw_data`: write data field.

`set_write_fields()` assigns these fields. Its `display()` first prints
write-specific information and then calls `super.display()`, which
invokes the implementation in `axi_transaction`. That implementation, in
turn, calls `super.display()` from `base_transactions`.

### 4. `axi_read_transaction`

This class also extends `axi_transaction`. It adds:

-   `ar_addr`: read address field.
-   `ar_data`: read data field.

Its display method prints read-specific information and then calls the
parent display method through `super.display()`.

## Key concepts

  -----------------------------------------------------------------------
  Concept                             Meaning in this example
  ----------------------------------- -----------------------------------
  `extends`                           Declares that a class inherits from
                                      another class.

  `virtual function`                  Allows runtime method dispatch when
                                      a method is overridden.

  Method overriding                   A derived class supplies its own
                                      implementation of `display()`.

  `super.display()`                   Calls the parent class's
                                      implementation of `display()`.

  `this.field`                        Refers to the current object's
                                      property.

  `new()`                             Constructs an object and returns a
                                      class handle to it.

  `logic [3:0]`                       A 4-bit 4-state field.

  `logic [15:0]`                      A 16-bit 4-state field.
  -----------------------------------------------------------------------

## Expected output

``` text
AXI_TRANSACTION: ID=3 BURST=5 DATA=23 ADDR=34
BASE_TRANSACTION: DATA=23 ADDR=34
AXI_READ: AR_ADDR=12 AR_DATA=13 ID=4 BURST=5
AXI_TRANSACTION: ID=4 BURST=5 DATA=23 ADDR=34
BASE_TRANSACTION: DATA=23 ADDR=34
AXI_WRITE: AW_ADDR=23 AW_DATA=45 ID=5 BURST=1
AXI_TRANSACTION: ID=5 BURST=1 DATA=23 ADDR=34
BASE_TRANSACTION: DATA=23 ADDR=34
```

The `$finish` statement ends the simulation after the three objects are
displayed.

## How to run

Use a SystemVerilog simulator such as Questa, VCS, Xcelium, or a
compatible online simulator.

1.  Create a new SystemVerilog simulation.
2.  Add `axi_inheritance_polymorphism.sv`.
3.  Compile and run the testbench. The top-level module is `tb`.
4.  Compare the transcript with the expected output above.

## Interview notes

1.  **Why use inheritance?** To reuse common transaction fields and
    behavior rather than redefining them in every class.
2.  **Why declare `display()` virtual?** To support polymorphic dispatch
    when the method is called through a base-class handle.
3.  **What does `super.display()` do?** It calls the parent class's
    version of `display()`.
4.  **What is the difference between multilevel and hierarchical
    inheritance?** Multilevel inheritance forms a chain of parent and
    child classes; hierarchical inheritance has multiple child classes
    sharing the same parent.
5.  **Why use `this.id = id`?** It distinguishes the object's property
    from the method argument with the same name.
6.  **Are `aw_addr` and `ar_addr` standard AXI signal names?** They are
    illustrative class-property names inspired by AXI write/read address
    channels. This is an OOP demonstration, not a complete AXI protocol
    model.

## Important clarification

The example uses AXI-inspired field names, but it does not implement AXI
handshaking, timing, channels, or protocol rules. It is intended to
demonstrate SystemVerilog class inheritance and method overriding.
