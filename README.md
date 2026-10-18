# SystemVerilog OOP: Shallow Copy, Deep Copy & Handle Assignment

## Overview

This project demonstrates three important SystemVerilog class concepts:

1. Shallow copy
2. Deep copy
3. Class handle assignment

The example uses an outer transaction class (`axi_txn_t`) containing a nested transaction object (`axi_txn`).

## 1. Class Structure

```systemverilog
class axi_txn;
  logic [15:0] data;
endclass

class axi_txn_t;
  axi_txn tr;
  logic [15:0] addr;
endclass
```

- `addr` is a normal value property.
- `tr` is a class handle.
- `tr.data` is a property of the nested class object.

## 2. Shallow Copy

```systemverilog
function void shallow_copy(axi_txn_t rhs);
  addr = rhs.addr;
  tr   = rhs.tr;
endfunction
```

### Explanation

- `addr = rhs.addr` copies the address value.
- `tr = rhs.tr` copies the nested class handle.
- The two outer objects have independent address properties.
- Both outer objects refer to the same nested object.

### Example

```systemverilog
tr1.shallow_copy(tr2);

tr1.addr = 'hFE;
tr2.tr.data = 'hFC;
```

Expected values:

| Property | Value |
|---|---|
| `tr1.addr` | `FE` |
| `tr2.addr` | `AF` |
| `tr1.tr.data` | `FC` |
| `tr2.tr.data` | `FC` |

## 3. Deep Copy

```systemverilog
function void deep_copy(axi_txn_t rhs);
  addr = rhs.addr;
  tr = new();
  tr.data = rhs.tr.data;
endfunction
```

### Explanation

- The address value is copied.
- A new nested `axi_txn` object is created.
- The nested data is copied into the new object.
- Changes to one nested object do not affect the other.

This implementation assumes `rhs` and `rhs.tr` are valid handles.

## 4. Class Handle Assignment

```systemverilog
tr1 = tr2;
```

This does not create a new outer object. It makes both variables refer to the same outer object.

Therefore, changes made through either handle are visible through the other.

## 5. Comparison

| Feature | Shallow Copy | Deep Copy | Handle Assignment |
|---|---|---|---|
| New outer object | Yes, if copying into an existing separate object | Yes, if copying into an existing separate object | No |
| Address value | Copied | Copied | Same outer object |
| Nested object | Shared | Separate | Same outer object and nested object |
| Nested data modification | Visible through both handles | Independent | Visible through both handles |

## 6. Important Interview Point

**Value copy:** copies a value into a separate property.

**Handle copy:** copies a reference to an object.

**Shallow copy:** copies value properties and shares nested objects through copied handles.

**Deep copy:** creates independent copies of nested objects as well.

## 7. Interview Questions

1. What is a class handle in SystemVerilog?
2. What is the difference between shallow copy and deep copy?
3. Why does changing `tr1.addr` not change `tr2.addr` after shallow copy?
4. Why does changing `tr2.tr.data` affect `tr1.tr.data` after shallow copy?
5. What happens when we execute `tr1 = tr2`?
6. Why do we use `new()` inside a deep-copy method?
7. What can happen if a nested class handle is null?
8. How would you extend deep copy if the nested class contained another class handle?

## 8. Running the Code

Save the testbench as `shallow_deep_copy.sv`.

Compile and run it using a SystemVerilog-compatible simulator, such as Questa, Xcelium, VCS, or a compatible online simulator.

Always compare the actual simulator output with the expected behavior described above.

---

```systemverilog
class axi_txn;
  // Nested class containing transaction data
  logic [15:0] data;
endclass

class axi_txn_t;

  // Class handle: points to an axi_txn object
  axi_txn tr;

  // Normal value property: stores a 16-bit address
  logic [15:0] addr;

  // ==========================================
  // SHALLOW COPY
  // ==========================================
  function void shallow_copy(axi_txn_t rhs);

    // Copy the address VALUE.
    // The source and destination have independent addr properties.
    addr = rhs.addr;

    // Copy the class HANDLE, not the nested object itself.
    // Both outer objects now point to the same axi_txn object.
    tr = rhs.tr;

  endfunction

  // ==========================================
  // DEEP COPY
  // ==========================================
  function void deep_copy(axi_txn_t rhs);

    // Copy the address value into this outer object.
    addr = rhs.addr;

    // Allocate a NEW nested axi_txn object.
    // This prevents sharing the nested object with rhs.
    tr = new();

    // Copy the data value into the newly created object.
    tr.data = rhs.tr.data;

  endfunction

endclass

module tb;

  // Declare two handles to outer transaction objects
  axi_txn_t tr1, tr2;

  initial begin

    // ==========================================
    // TEST 1: SHALLOW COPY
    // ==========================================

    // Create two independent outer objects
    tr1 = new();
    tr2 = new();

    // Create a nested object for tr2
    tr2.tr = new();

    // Initialize the source transaction
    tr2.addr = 'hAF;
    tr2.tr.data = 'hBD;

    // Copy tr2's address value and nested class handle into tr1
    tr1.shallow_copy(tr2);

    // Modify only tr1's address property
    tr1.addr = 'hFE;

    // Modify the shared nested object's data through tr2
    tr2.tr.data = 'hFC;

    $display("=== SHALLOW COPY ===");

    // tr1 has its own address but shares the nested object
    $display("tr1 addr=%h data=%h",
             tr1.addr, tr1.tr.data);

    // tr2's address remains AF; shared data is now FC
    $display("tr2 addr=%h data=%h",
             tr2.addr, tr2.tr.data);

    // Expected:
    // tr1 addr=00fe data=00fc
    // tr2 addr=00af data=00fc

    // ==========================================
    // TEST 2: DEEP COPY
    // ==========================================

    // Create fresh outer objects for an independent test
    tr1 = new();
    tr2 = new();

    // Allocate separate nested objects initially
    tr1.tr = new();
    tr2.tr = new();

    // Initialize the source transaction
    tr2.addr = 'hAF;
    tr2.tr.data = 'hBD;

    // Copy the address and create a separate nested object in tr1
    tr1.deep_copy(tr2);

    // Modify tr1's address
    tr1.addr = 'hFE;

    // Modify only tr2's nested object
    tr2.tr.data = 'hFC;

    $display("=== DEEP COPY ===");

    // tr1's nested data remains BD because it is independent
    $display("tr1 addr=%h data=%h",
             tr1.addr, tr1.tr.data);

    // tr2 contains the updated values
    $display("tr2 addr=%h data=%h",
             tr2.addr, tr2.tr.data);

    // Expected:
    // tr1 addr=00fe data=00bd
    // tr2 addr=00af data=00fc

    // ==========================================
    // TEST 3: CLASS HANDLE ASSIGNMENT
    // ==========================================

    // Create one outer object and its nested object
    tr1 = new();
    tr1.tr = new();

    // Initialize the object accessed through tr1
    tr1.addr = 'hAF;
    tr1.tr.data = 'hBD;

    // Copy the outer class handle.
    // No new outer object is created.
    // tr1 and tr2 now refer to the SAME outer object.
    tr2 = tr1;

    // Modify the shared outer object's address through tr2
    tr2.addr = 'h23;

    // Modify the nested object's data through tr2
    tr2.tr.data = 'h12;

    $display("=== HANDLE ASSIGNMENT ===");

    // Both handles see the same outer object and nested data
    $display("tr1 addr=%h data=%h",
             tr1.addr, tr1.tr.data);

    $display("tr2 addr=%h data=%h",
             tr2.addr, tr2.tr.data);

    // Expected:
    // tr1 addr=0023 data=0012
    // tr2 addr=0023 data=0012

    // End simulation
    $finish;

  end

endmodule
```
