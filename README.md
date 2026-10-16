# lakshman_vlsi
# AXI Transaction Tracker using SystemVerilog Associative Arrays

## Overview

This project demonstrates the implementation of an **AXI Outstanding Transaction Tracker** using **SystemVerilog Associative Arrays**.

Associative arrays are widely used in VLSI Verification environments such as:

- UVM Scoreboards
- AXI Transaction Tracking
- Memory Models
- Cache Models
- Register Databases
- Reference Models

In this example, AXI Transaction IDs are used as associative array indexes, and transaction types are stored as values.

---

## Problem Statement

An AXI protocol allows multiple outstanding transactions to exist simultaneously. Verification environments must track these transactions until their corresponding responses are received.

Implement an Associative Array-based database to:

- Store transactions using Transaction ID as the key.
- Search transactions efficiently.
- Navigate through stored transactions.
- Remove completed transactions.
- Monitor the number of active transactions.

---

## Features Demonstrated

| Method | Description |
|----------|-------------|
| `num()` | Returns number of entries |
| `foreach` | Iterates through all entries |
| `first()` | Returns first index |
| `last()` | Returns last index |
| `next()` | Returns next valid index |
| `prev()` | Returns previous valid index |
| `exists()` | Checks whether an index exists |
| `delete(index)` | Removes a specific entry |

---

## Associative Array Declaration

```systemverilog
typedef logic [15:0] transaction_t[int];
transaction_t transaction_types;
```

### Key

```text
AXI Transaction ID (int)
```

### Value

```text
Transaction Type (16-bit Logic Data)
```

---

## Transaction Database

| Transaction ID | Transaction Type |
|---------------|------------------|
| 101 | 0xAA |
| 105 | 0xBB |
| 106 | 0xDD |
| 109 | 0xCC |

---

## Source Code

```systemverilog
module axi_transaction_order;

  typedef logic [15:0] transaction_t[int];
  transaction_t transaction_types;

  int axi_id;

  initial begin

    $display(" INTIAL_TRANSACTION = %0h",
             transaction_types.num());

    transaction_types[101] = 'hAA;
    transaction_types[105] = 'hBB;
    transaction_types[109] = 'hCC;
    transaction_types[106] = 'hDD;

    $display(" AFTER_TRANSACTION = %0h",
             transaction_types.num());

    foreach(transaction_types[axi_id])
      $display(" FOR_TRANSACTION[%0d] = %0h",
                axi_id,
                transaction_types[axi_id]);

    transaction_types.first(axi_id);
    $display("FIRST_ID = %0d TRANS_TY = %0h",
              axi_id,
              transaction_types[axi_id]);

    transaction_types.last(axi_id);
    $display("LAST_ID = %0d TRANS_TY = %0h",
              axi_id,
              transaction_types[axi_id]);

    transaction_types.next(axi_id);
    $display("NEXT_ID = %0d TRANS_TY = %0h",
              axi_id,
              transaction_types[axi_id]);

    transaction_types.prev(axi_id);
    $display("PREV_ID = %0d TRANS_TY = %0h",
              axi_id,
              transaction_types[axi_id]);

    if(transaction_types.exists(107))
      $display("Read transaction found");
    else
      $display("Read transaction not found");

    if(transaction_types.exists(106))
      $display("Transaction 106 found");

    if(transaction_types.exists(105))
      $display("Write transaction found");

    transaction_types.delete(105);

    if(transaction_types.exists(105))
      $display("Transaction still exists");
    else
      $display("Transaction deleted successfully");

    foreach(transaction_types[axi_id])
      $display("After Deletion [%0d] = %0h",
                axi_id,
                transaction_types[axi_id]);

  end

endmodule
```

---

## Expected Output

```text
INTIAL_TRANSACTION = 0

AFTER_TRANSACTION = 4

FOR_TRANSACTION[101] = aa
FOR_TRANSACTION[105] = bb
FOR_TRANSACTION[106] = dd
FOR_TRANSACTION[109] = cc

FIRST_ID = 101 TRANS_TY = aa

LAST_ID = 109 TRANS_TY = cc

Read transaction not found

Transaction 106 found

Write transaction found

Transaction deleted successfully

After Deletion [101] = aa
After Deletion [106] = dd
After Deletion [109] = cc
```

---

## Learning Outcomes

After completing this project, you will understand:

- Associative Array declaration
- Integer-indexed arrays
- Transaction database modeling
- Runtime lookup operations
- Transaction existence checking
- Dynamic transaction deletion
- Traversing associative arrays
- Scoreboard-style transaction management

---

## Verification Use Cases

### AXI Scoreboards

```systemverilog
if(txn_db.exists(id))
```

Verify outstanding transaction existence.

---

### Memory Models

```systemverilog
memory[address] = data;
```

Store only valid addresses to save memory.

---

### Cache Verification

```systemverilog
cache[tag] = cache_line;
```

Implement sparse cache storage.

---

### Register Databases

```systemverilog
reg_db[address] = reg_value;
```

Track programmed register values.

---

## Key Interview Questions

### Why use Associative Arrays instead of Dynamic Arrays?

**Answer:**

Associative Arrays are preferred when indexes are sparse or non-sequential.

Example:

```text
101
105
106
109
```

Using Dynamic Arrays would waste memory because intermediate locations must be allocated. Associative Arrays allocate memory only for the used indexes.

---

### What is the advantage of `exists()`?

**Answer:**

It prevents access to non-existent entries.

```systemverilog
if(txn_db.exists(id))
  data = txn_db[id];
```

This avoids runtime warnings and improves verification robustness.

---

## Author

**Lakshman Junnu**  
VLSI Design & Verification Engineer  
SystemVerilog | UVM | AXI | APB | FIFO | SRAM | Protocol Verification
