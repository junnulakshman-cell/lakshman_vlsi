# AXI Write Buffer Using SystemVerilog Queues

https://img.shields.io/badge/SystemVerilog-Verification-blue
https://img.shields.io/badge/Data%20Structure-Queue-green
https://img.shields.io/badge/VLSI-Verification-orange
https://img.shields.io/badge/License-MIT-lightgrey

## Overview

This project demonstrates the implementation of an **AXI Write Transaction Buffer** using **SystemVerilog Queues**.

Queues are one of the most commonly used dynamic data structures in verification environments. They provide efficient insertion and deletion of transactions and are widely used in:

- AXI/UVM Drivers
- UVM Scoreboards
- Transaction Buffers
- FIFO Modeling
- Monitor Data Collection
- Protocol Verification

This example showcases all commonly used queue methods through a practical AXI write-buffer use case.

---

## Problem Statement

An AXI Master generates write transactions that must be temporarily stored before being sent to a slave device.

Implement an AXI Write Buffer using a SystemVerilog Queue and demonstrate queue operations such as:

- Insertion at the front and back
- Removal from the front and back
- Queue traversal
- Element insertion at specific positions
- Element deletion
- Complete queue reset

---

## Queue Declaration

```systemverilog
int write_transaction[$];
```

### Explanation

```text
int  -> Queue element datatype
$    -> Unbounded queue
```

---

## Initial Queue

```systemverilog
write_transaction = {23,45,67,38,90};
```

### Queue Content

```text
Front                                 Back
------------------------------------------------
23 -> 45 -> 67 -> 38 -> 90
------------------------------------------------
```

---

# Queue Operations Demonstrated

## 1. Queue Size

```systemverilog
write_transaction.size();
```

### Output

```text
Size = 5
```

---

## 2. Traverse Queue

```systemverilog
foreach(write_transaction[i])
```

### Output

```text
23
45
67
38
90
```

---

## 3. push_front()

Adds a transaction at the beginning of the queue.

```systemverilog
write_transaction.push_front(20);
```

### Queue State

```text
20 -> 23 -> 45 -> 67 -> 38 -> 90
```

### Size

```text
6
```

---

## 4. push_back()

Adds a transaction at the end of the queue.

```systemverilog
write_transaction.push_back(50);
```

### Queue State

```text
20 -> 23 -> 45 -> 67 -> 38 -> 90 -> 50
```

### Size

```text
7
```

---

## 5. pop_back()

Removes the last transaction.

```systemverilog
write_transaction.pop_back();
```

### Removed Value

```text
50
```

### Queue State

```text
20 -> 23 -> 45 -> 67 -> 38 -> 90
```

---

## 6. pop_front()

Removes the first transaction.

```systemverilog
write_transaction.pop_front();
```

### Removed Value

```text
20
```

### Queue State

```text
23 -> 45 -> 67 -> 38 -> 90
```

---

## 7. insert()

Insert a transaction at a specific position.

```systemverilog
write_transaction.insert(1,100);
```

### Queue State

```text
23 -> 100 -> 45 -> 67 -> 38 -> 90
```

---

### Insert Another Transaction

```systemverilog
write_transaction.insert(5,99);
```

### Queue State

```text
23 -> 100 -> 45 -> 67 -> 38 -> 99 -> 90
```

---

## 8. delete(index)

Delete an element using its index.

```systemverilog
write_transaction.delete(3);
```

### Queue Before

```text
23 -> 100 -> 45 -> 67 -> 38 -> 99 -> 90
```

### Deleted Element

```text
67
```

### Queue After

```text
23 -> 100 -> 45 -> 38 -> 99 -> 90
```

---

## 9. delete()

Remove all queue contents.

```systemverilog
write_transaction.delete();
```

### Queue State

```text
{}
```

### Size

```text
0
```

---

# Queue Operation Flow

```text
Initial Queue
----------------------------------
23 45 67 38 90
----------------------------------

push_front(20)
----------------------------------
20 23 45 67 38 90
----------------------------------

push_back(50)
----------------------------------
20 23 45 67 38 90 50
----------------------------------

pop_back()
----------------------------------
20 23 45 67 38 90
----------------------------------

pop_front()
----------------------------------
23 45 67 38 90
----------------------------------

insert(1,100)
----------------------------------
23 100 45 67 38 90
----------------------------------

insert(5,99)
----------------------------------
23 100 45 67 38 99 90
----------------------------------

delete(3)
----------------------------------
23 100 45 38 99 90
----------------------------------

delete()
----------------------------------
{}
----------------------------------
```

---

# Simulation Output

```text
Size of the write_trans is 0

Size of the write_trans is 5

write_transaction[0] 23
write_transaction[1] 45
write_transaction[2] 67
write_transaction[3] 38
write_transaction[4] 90

Push_front is 20 23 45 67 38 90
size of the transaction is 6

Push_back is 20 23 45 67 38 90 50
size of the transaction is 7

Pop_back is 20 23 45 67 38 90
size of the transaction is 6

Pop_front is 23 45 67 38 90
size of the transaction is 5

Insert is 23 100 45 67 38 90
size of the transaction is 6

Insert is 23 100 45 67 38 99 90
size of the transaction is 7

Deleted value is 23 100 45 38 99 90
size of the transaction is 6

Deleted queue is {}
size of the transaction is 0
```

---

# Queue Methods Summary

| Method | Description |
|----------|------------|
| `size()` | Returns queue size |
| `push_front()` | Insert at front |
| `push_back()` | Insert at back |
| `pop_front()` | Remove from front |
| `pop_back()` | Remove from back |
| `insert()` | Insert at index |
| `delete(index)` | Remove specific element |
| `delete()` | Clear complete queue |
| `foreach` | Iterate through queue |

---

# Verification Use Cases

## AXI Driver

```text
push_back()  → Store incoming transactions
pop_front()  → Send transactions to DUT
```

## FIFO Modeling

```text
push_back()  → Write operation
pop_front()  → Read operation
```

## UVM Scoreboard

```text
push_back()  → Store expected results
delete()     → Remove matched transactions
```

## Monitor Buffers

```text
push_back()  → Capture observed transactions
```

---

# Learning Outcomes

After completing this example, you will understand:

✅ Queue Declaration

✅ Queue Traversal

✅ Dynamic Data Storage

✅ Front and Back Insertions

✅ Front and Back Removals

✅ Position-Based Insertion

✅ Position-Based Deletion

✅ Queue Size Management

✅ Complete Queue Reset

✅ Verification-Oriented Queue Usage

---

# Repository Structure

```text
lakshman_vlsi/
│
└── SystemVerilog_Basics/
    │
    └── Queue/
        │
        ├── axi_write_buffer_queue.sv
        └── README.md
```

---

## Author

**Lakshman Junnu**

**VLSI Design & Verification Engineer**

**Skills:** SystemVerilog • UVM • AXI • APB • FIFO • SRAM Controller • Verification Methodologies
