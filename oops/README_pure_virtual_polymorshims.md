# Pure Virtual Polymorphism in SystemVerilog

## Overview

This example demonstrates runtime polymorphism using a pure virtual base class in SystemVerilog.

The design shows how a generic base-class handle can point to different derived transaction objects and call the correct overridden method dynamically.

The key concepts used are:

- `virtual class` for abstract base types
- `pure virtual function` to enforce implementation in child classes
- inheritance with `extends`
- method overriding
- dynamic binding via a base-class handle
- safe handle assignment using `$cast()`

---

## Class Hierarchy

```text
                    Base_Transactions
                        (virtual class)
                              |
                  ---------------------------
                  |                         |
                  |                         |
        Axi_write_transactions     Axi_read_transactions
```

### Runtime Polymorphism Diagram

```text
                         tr_b
                          |
                          |
            +-----------------+-----------------+
            |                                   |
            v                                   v
   Axi_write_transactions               Axi_read_transactions
            |                                   |
            |                                   |
        axi_txn()                           axi_txn()
            |                                   |
            v                                   v
      WRITE display                       READ display
```

---

## Why a pure virtual function is used

A pure virtual function is a function declaration without a body. It acts like a contract.

Example:

```systemverilog
virtual class Base_Transactions;
  pure virtual function void axi_txn();
endclass
```

This means:

- `Base_Transactions` cannot be instantiated directly
- all derived classes must implement `axi_txn()`
- the base class defines a common interface for all transaction types

---

## Base class definition

```systemverilog
virtual class Base_Transactions;
  logic [15:0] data;
  logic [31:0] addr;
  logic [2:0]  id;
  logic [2:0]  burst_len;
  logic [2:0]  burst_size;

  function new(logic [15:0] data,
               logic [31:0] addr,
               logic [2:0]  id,
               logic [2:0]  burst_len,
               logic [2:0]  burst_size);
    this.data      = data;
    this.addr      = addr;
    this.id        = id;
    this.burst_len = burst_len;
    this.burst_size = burst_size;
  endfunction

  pure virtual function void axi_txn();
endclass
```

The base class stores the common AXI transaction properties while leaving the exact display or processing behavior to derived classes.

---

## Write transaction class

```systemverilog
class Axi_write_transactions extends Base_Transactions;
  logic [15:0] w_data;
  logic [31:0] aw_addr;
  logic [1:0]  b_resp;

  function new(...);
    super.new(...);
    this.w_data  = w_data;
    this.aw_addr = aw_addr;
    this.b_resp  = b_resp;
  endfunction

  function void axi_txn();
    $display("AXI-WRITE_TRANS->");
    $display("WRITE_DATA = %0d", w_data);
    $display("WRITE_ADDR = %0d", aw_addr);
    $display("ID = %0d", id);
    $display("BURST_LEN = %0d", burst_len);
    $display("WRITE_RESP = %0d", b_resp);
  endfunction
endclass
```

This class adds write-specific signals and implements `axi_txn()` for a write transaction.

---

## Read transaction class

```systemverilog
class Axi_read_transactions extends Base_Transactions;
  logic [15:0] r_data;
  logic [31:0] ar_addr;
  logic [1:0]  r_resp;

  function new(...);
    super.new(...);
    this.r_data  = r_data;
    this.ar_addr = ar_addr;
    this.r_resp  = r_resp;
  endfunction

  function void axi_txn();
    $display("READ_TRAN->");
    $display("READ_DATA = %0d", r_data);
    $display("READ_ADDR = %0d", ar_addr);
    $display("ID = %0d", id);
    $display("BURST_LEN = %0d", burst_len);
    $display("READ_RESP = %0d", r_resp);
  endfunction
endclass
```

This class adds read-specific signals and implements the same interface for a read transaction.

---

## Polymorphism example

```systemverilog
Base_Transactions tr_b;
Axi_write_transactions tr_w;
Axi_read_transactions  tr_r;

tr_w = new(...);
if ($cast(tr_b, tr_w))
  $display("casting is success");
tr_b.axi_txn();

tr_r = new(...);
if ($cast(tr_b, tr_r))
  $display("casting is success");
tr_b.axi_txn();
```

The important part is that the same base handle `tr_b` points to different child objects at different times.

Because the method is virtualized by the inheritance model, the correct implementation is called based on the actual object instance.

---

## Why `$cast()` is used

`$cast()` is used to safely assign a child-class object to a base-class handle.

```systemverilog
if ($cast(tr_b, tr_w))
  $display("casting is success");
```

It checks whether the assignment is valid before performing it. This avoids unsafe or invalid type conversions.

---

## Simulation output

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

## Key learning points

- A `virtual class` is abstract and cannot be instantiated.
- A `pure virtual function` forces all child classes to provide the method.
- A derived class can override the base-class interface.
- A common base handle can point to different child objects.
- The runtime object decides which implementation is called.
- This is the foundation of runtime polymorphism in SystemVerilog.

---

## Application in UVM and verification

This concept is heavily used in UVM and object-oriented verification:

- `uvm_sequence_item`
- `uvm_object`
- transaction classes
- reusable verification components
- scoreboard and monitor design

In real verification environments, many objects share a common interface but behave differently depending on the transaction type.

---

## Additional AXI Transaction Polymorphism summary

This project demonstrates Runtime Polymorphism in SystemVerilog using:

- Virtual Class (Abstract Class)
- Pure Virtual Function
- Inheritance
- Method Overriding
- Dynamic Binding
- `$cast()`-based upcasting

### Class Hierarchy

```text
              Base_Transactions
               (Virtual Class)
                      |
        -----------------------------
        |                           |
        |                           |
Axi_write_transactions   Axi_read_transactions
```

### Signals

#### Base_Transactions

| Signal | Width | Description |
|---------|---------|-------------|
| data | 16-bit | Transaction Data |
| addr | 32-bit | Address |
| id | 3-bit | Transaction ID |
| burst_len | 3-bit | Burst Length |
| burst_size | 3-bit | Burst Size |

#### AXI Write Transaction

| Signal | Width |
|---------|---------|
| w_data | 16-bit |
| aw_addr | 32-bit |
| b_resp | 2-bit |

#### AXI Read Transaction

| Signal | Width |
|---------|---------|
| r_data | 16-bit |
| ar_addr | 32-bit |
| r_resp | 2-bit |

### Abstract Base Class

```systemverilog
virtual class Base_Transactions;

  pure virtual function void axi_txn();

endclass
```

- Cannot be instantiated.
- Defines a common interface for all transaction types.
- Forces derived classes to implement `axi_txn()`.

### Polymorphism Example

```systemverilog
$cast(tr_b, tr_w);
tr_b.axi_txn();   // Calls Write Transaction Method

$cast(tr_b, tr_r);
tr_b.axi_txn();   // Calls Read Transaction Method
```

Runtime method selection depends on the object assigned to `tr_b`.

### Simulation Output

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
READ_RESP = 1
```

### Virtual Class vs Normal Class

| Feature | Normal Class | Virtual Class |
|----------|-------------|-------------|
| Object Creation | ✅ Yes | ❌ No |
| Abstract Behavior | ❌ No | ✅ Yes |
| Pure Virtual Functions | ❌ No | ✅ Yes |
| Used as Base Template | ❌ No | ✅ Yes |

### Virtual Function vs Pure Virtual Function

| Feature | Virtual Function | Pure Virtual Function |
|----------|-----------------|----------------------|
| Has Implementation | ✅ Yes | ❌ No |
| Function Body | ✅ Yes | ❌ No |
| Override Required | ❌ No | ✅ Yes |
| Makes Class Abstract | ❌ No | ✅ Yes |

#### Virtual Function

```systemverilog
virtual function void axi_txn();
  $display("Base Transaction");
endfunction
```

#### Pure Virtual Function

```systemverilog
pure virtual function void axi_txn();
```

### Key Points

✅ `virtual class` creates an abstract base class.

✅ `pure virtual function` acts as a contract for child classes.

✅ Derived classes must implement all pure virtual functions.

✅ `$cast()` safely assigns child objects to a parent handle.

✅ Runtime polymorphism enables one handle to access multiple transaction types.

✅ This concept is widely used in UVM (`uvm_object`, `uvm_sequence_item`, `uvm_driver`, `uvm_monitor`).

### Repository Structure

```text
polymorphismsa/
├── polymorphismsa.sv
└── README.md
```

---

## Related files

- `oops/pure_virtual_polymorshims.sv` — complete SystemVerilog implementation
- `oops/README_polymorphism.md` — related polymorphism documentation
- `oops/README_constructor_inheritance.md` — related constructor and inheritance documentation

---

## Author

**Lakshman Junnu**

VLSI Design & Verification Engineer
