# AXI Transaction Polymorphism Using Base Class Handle

## Overview

This project demonstrates **Object-Oriented Programming (OOP)** concepts in SystemVerilog using AXI transaction classes. The example shows how a **base class handle** can reference different derived classes and how method dispatch changes depending on whether the function is virtual.

The folder named `oops/` is dedicated to learning **object-oriented verification concepts** in SystemVerilog. It focuses on how classes, inheritance, overriding, and polymorphism are used in real verification environments such as UVM.

In this design, different AXI transaction types share a common base class, but each child class implements a specialized behavior. The key idea is to understand how the base handle calls the correct implementation during runtime and when it does not.

Although the derived classes override the `axi_txn()` method, the method in the base class is **not declared as virtual**. Therefore, SystemVerilog performs **static binding**, and the base class implementation is selected.

---

## Objectives

- Understand Inheritance in SystemVerilog
- Learn Method Overriding
- Understand Upcasting using `$cast()`
- Observe Static Binding behavior
- Compare Virtual and Non-Virtual Functions
- Understand why Virtual Functions are required for Runtime Polymorphism
- Learn how the `oops/` folder organizes OOP examples

---

## OOP Concepts Covered in This Folder

This folder demonstrates the core concepts of OOP in SystemVerilog:

### 1. Encapsulation
The class groups related transaction data and methods together in one unit. For example, write and read transactions are represented as class objects containing their own fields and display logic.

### 2. Inheritance
A common base class, `Base_Transactions`, defines shared AXI fields such as `data`, `addr`, and `id`. The derived classes `Axi_write_transactions` and `Axi_read_transactions` extend this class and add specialized members like write/read addresses and responses.

### 3. Method Overriding
Both child classes define their own `axi_txn()` method. This allows the derived class to customize the way transaction data is displayed.

### 4. Upcasting
The child handle is assigned to a base class handle using `$cast()`. This is a very common pattern in object-oriented design and is used to generalize references to a common interface.

### 5. Static Binding vs Dynamic Binding
When the base method is non-virtual, the compiler chooses the method based on the handle type, not the actual object type. This is called **static binding**.

When the method is declared as `virtual`, the method is resolved based on the actual object type at runtime. This is called **dynamic binding** and is the basis for true polymorphism.

### 6. Runtime Polymorphism
Polymorphism means that the same method name can behave differently based on the actual object being referenced. In this folder, runtime polymorphism is shown by using a base handle to point to different derived objects and by changing the method to `virtual`.

### 7. Abstraction
The base class hides the internal differences between write and read transactions while exposing a common interface (`axi_txn()`). This allows the testbench to interact with transaction objects using a common abstraction.

---

## Folder Overview: `oops/`

The `oops/` folder is intended to teach and practice OOP concepts in SystemVerilog using real verification-style examples. Its purpose is to help learners understand how object-oriented modeling is applied in protocol classes, transaction classes, and reusable testbench components.

This folder contains examples that highlight:

- object creation and initialization
- inheritance and specialization
- overriding methods
- base-to-derived handle relationships
- runtime behavior of `virtual` methods
- how OOP concepts map to UVM design patterns

The design is intentionally simple so that the behavior is easy to understand before moving to larger verification environments like UVM.

---

## Class Hierarchy

```text
                    Base_Transactions
                           |
        -------------------------------------
        |                                   |
        |                                   |
Axi_write_transactions         Axi_read_transactions
```

---

## Signal Description

### Base_Transactions

Common transaction parameters shared by all AXI transaction types.

| Signal | Width | Description |
|----------|----------|-------------|
| data | 16-bit | Generic transaction data |
| addr | 32-bit | Transaction address |
| id | 3-bit | Transaction ID |
| burst_len | 3-bit | AXI burst length |
| burst_size | 3-bit | AXI burst size |

---

### Axi_write_transactions

Additional fields specific to AXI Write operations.

| Signal | Width | Description |
|----------|----------|-------------|
| w_data | 16-bit | Write data |
| aw_addr | 32-bit | Write address |
| b_resp | 2-bit | Write response |

---

### Axi_read_transactions

Additional fields specific to AXI Read operations.

| Signal | Width | Description |
|----------|----------|-------------|
| r_data | 16-bit | Read data |
| ar_addr | 32-bit | Read address |
| r_resp | 2-bit | Read response |

---

## Base Class

```systemverilog
class Base_Transactions;

  function void axi_txn();
    ...
  endfunction

endclass
```

### Responsibilities

- Holds common AXI transaction fields.
- Provides a default implementation of `axi_txn()`.
- Serves as the parent class for read and write transactions.

---

## Derived Classes

### Write Transaction

```systemverilog
class Axi_write_transactions extends Base_Transactions;
```

Overrides:

```systemverilog
function void axi_txn();
```

Used for displaying AXI write transaction information.

---

### Read Transaction

```systemverilog
class Axi_read_transactions extends Base_Transactions;
```

Overrides:

```systemverilog
function void axi_txn();
```

Used for displaying AXI read transaction information.

---

## Testbench Execution Flow

### Step 1: Create Write Transaction Object

```systemverilog
tr_w = new(
    'd23,
    'd34,
    'd1,
    'd23,
    'd34,
    'd3,
    'd2,
    'd3
);
```

---

### Step 2: Upcast Child Handle to Parent Handle

```systemverilog
$cast(tr_b, tr_w);
```

After casting:

```text
tr_b --> Axi_write_transactions Object
```

---

### Step 3: Invoke Method

```systemverilog
tr_b.axi_txn();
```

Since `axi_txn()` is non-virtual:

```text
Base_Transactions::axi_txn()
```

is executed.

---

### Step 4: Create Read Transaction Object

```systemverilog
tr_r = new(
    'd24,
    'd33,
    'd5,
    'd2,
    'd1,
    'd3,
    'd4,
    'd7
);
```

---

### Step 5: Cast to Parent Handle

```systemverilog
$cast(tr_b, tr_r);
```

After casting:

```text
tr_b --> Axi_read_transactions Object
```

---

### Step 6: Invoke Method Again

```systemverilog
tr_b.axi_txn();
```

Output still comes from:

```systemverilog
Base_Transactions::axi_txn()
```

because the function is not virtual.

---

## Simulation Output

```text
casting is sucees

Base-TRANS->
WRITE_DATA =23
WRITE_ADDR =34
ID =3
BURST_LEN =2
BURST_SIZE =3

casting is sucees

Base-TRANS->
WRITE_DATA =2
WRITE_ADDR =1
ID =3
BURST_LEN =4
BURST_SIZE =7
```

---

## Understanding the Result

Most beginners expect the output to be:

```text
AXI-WRITE_TRANS
READ_TRAN
```

because the child classes override `axi_txn()`.

However, the output comes from the base class because:

```systemverilog
function void axi_txn();
```

is a **non-virtual function**.

SystemVerilog therefore chooses the function based on the **handle type** rather than the **actual object type**.

---

## Static Binding Flow

```text
tr_b (Base Handle)
        |
        v
Axi_write_transactions
        |
        v
Base_Transactions::axi_txn()

--------------------------------

tr_b (Base Handle)
        |
        v
Axi_read_transactions
        |
        v
Base_Transactions::axi_txn()
```

---

## How to Enable True Polymorphism?

Modify the base class function:

```systemverilog
virtual function void axi_txn();

  $display(...);

endfunction
```

Now SystemVerilog performs **dynamic binding**.

---

## Expected Output with Virtual Function

```text
casting is sucees

AXI-WRITE_TRANS->
WRITE_DATA =23
WRITE_ADDR =34
ID =3
BURST_LEN =2
WRITE_RESP =1

casting is sucees

READ_TRAN->
READ_DATA =24
READ_ADDR =33
ID =3
BURST_LEN =4
READ_RESP =5
```

---

## Virtual vs Non-Virtual Function

| Feature | Non-Virtual Function | Virtual Function |
|----------|---------------------|------------------|
| Binding Type | Compile Time | Run Time |
| Polymorphism | ❌ No | ✅ Yes |
| Method Selection | Handle Type | Object Type |
| Dynamic Dispatch | ❌ No | ✅ Yes |
| Runtime Resolution | ❌ No | ✅ Yes |
| Child Method Invocation | ❌ No | ✅ Yes |

### Non-Virtual

```systemverilog
function void axi_txn();
```

Result:

```text
Base_Transactions::axi_txn()
```

---

### Virtual

```systemverilog
virtual function void axi_txn();
```

Result:

```text
Axi_write_transactions::axi_txn()
```

or

```text
Axi_read_transactions::axi_txn()
```

depending on the actual object assigned.

---

## Key Learning Points

✅ Inheritance allows derived classes to reuse common transaction fields.

✅ Method overriding alone does not create polymorphism.

✅ Non-virtual functions use static binding.

✅ `$cast()` safely converts child handles to parent handles.

✅ Function dispatch depends on the handle type when `virtual` is absent.

✅ Runtime polymorphism requires the `virtual` keyword.

✅ This behavior is frequently asked in SystemVerilog and UVM interviews.

✅ The `oops/` folder is a practical learning space for applying OOP principles in verification and design.

---

## Interview Question

### Q: Why does the base class method execute even though the child class overrides it?

**Answer:**

Because the function is declared as:

```systemverilog
function void axi_txn();
```

and not:

```systemverilog
virtual function void axi_txn();
```

Without `virtual`, SystemVerilog uses **static binding**, resolving the method based on the handle type (`Base_Transactions`) instead of the actual object type.

---

## Repository Structure

```text
oops/
├── README.md
├── polymorphismsa.sv
└── related OOP example files
```

This folder focuses on OOP and polymorphism concepts in SystemVerilog. It is a clean example of how a base class and derived transaction classes can model different AXI behaviors while still sharing a common interface.

---

## Applications in UVM

The same concept is used in:

- uvm_object
- uvm_sequence_item
- uvm_sequence
- uvm_driver
- uvm_monitor
- uvm_agent
- uvm_scoreboard

Understanding virtual methods and polymorphism is essential for building reusable UVM testbenches.

---

## Author

**Lakshman Junnu**

**VLSI Design & Verification Engineer**

**Focus Areas**
- SystemVerilog
- UVM
- RTL Design
- AXI/APB Protocol Verification
- Functional Verification
- Object-Oriented Verification Methodologies
