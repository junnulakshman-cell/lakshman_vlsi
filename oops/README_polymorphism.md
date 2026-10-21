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
