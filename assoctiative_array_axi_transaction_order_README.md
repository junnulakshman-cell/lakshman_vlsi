# AXI Transaction Order - SystemVerilog Example

This repository file demonstrates the use of associative arrays in SystemVerilog for tracking AXI outstanding transactions.

## File

- `axi_transaction_order.sv`

## Purpose

The design shows how to use associative array methods to:

- insert transaction IDs and their types
- iterate through entries
- find the first and last valid IDs
- move to next/previous valid IDs
- check for existence
- delete specific transaction entries

This pattern is useful in:

- UVM scoreboards
- AXI transaction tracking
- memory models
- cache verification environments

## Key Concepts Demonstrated

The example uses the following associative array methods:

- `num()`
- `foreach`
- `first()`
- `last()`
- `next()`
- `prev()`
- `exists()`
- `delete(index)`

## Design Overview

The module declares:

```systemverilog
typedef logic [15:0] transaction_t[int];
transaction_t transaction_types;
```

This creates an associative array where:

- key = AXI transaction ID (`int`)
- value = transaction type (`logic [15:0]`)

## Example Transactions

The model inserts the following entries:

- `101` = `0xAA` (READ)
- `105` = `0xBB` (WRITE)
- `109` = `0xCC` (BURST_READ)
- `106` = `0xDD` (BURST_WRITE)

## What the Testbench Shows

The simulation demonstrates:

1. Initial count of transactions before insertion
2. Active transaction count after insertion
3. Full iteration through all stored entries
4. First valid ID and last valid ID
5. Next and previous valid transaction IDs
6. Existence checks for specific IDs
7. Deletion of transaction ID `105`
8. Remaining transactions after deletion

## Typical Simulation Output

```text
INITIAL_TRANSACTION = 0
AFTER_TRANSACTION = 4
FIRST_ID = 101 TRANS_TY = aa
LAST_ID = 109 TRANS_TY = cc
NEXT_ID = 105 TRANS_TY = bb
PREV_ID = 105 TRANS_TY = bb
READ Transaction Not Found
BURST_WRITE Transaction Found
WRITE Transaction Found
WRITE Transaction Successfully Deleted
```

## Notes

This file is intended as a learning example for working with associative arrays in SystemVerilog and for understanding how transaction ordering and tracking can be managed efficiently in verification environments.

## Suggested Simulation Flow

Use any SystemVerilog simulator such as:

- ModelSim
- Questa
- Vivado simulator
- Icarus Verilog (if supported)

Compile and run the module to view the associative-array behavior.

---

Created for the AXI transaction tracking example in `axi_transaction_order.sv`.
