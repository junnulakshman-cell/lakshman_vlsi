# SystemVerilog Copy by Handle

## 1. Overview

This project demonstrates **Copy by Handle** in SystemVerilog using class objects.

In SystemVerilog, a class variable stores a handle that refers to an object in memory. When one class handle is assigned to another, the handle is copied—not the object itself.

As a result, both handles refer to the same object.

This example uses a class named `vlsi` with two integer properties:

- `a`
- `b`

The testbench demonstrates how modifying an object through one handle affects the values observed through another handle.

---

## 2. Objective

- Understand class handles in SystemVerilog.
- Understand object creation using `new()`.
- Understand handle assignment.
- Observe how two handles can refer to the same object.
- Differentiate copy by handle from shallow copy and deep copy.

---

## 3. Concept Diagram

### Before Handle Assignment

```text
v1 ─────► Object A
          a = 0
          b = 0

v2 ─────► Object B
          a = 30
          b = 40
```

Initially, `v1` and `v2` refer to separate objects.

### After Handle Assignment

```systemverilog
v1 = v2;
```

```text
v1 ─────┐
        │
        ├────► Same Object
        │       a = 30
v2 ─────┘       b = 40
```

Both handles refer to the same object.

---

## 4. SystemVerilog Code

### File: `copy_by_handle.sv`

```systemverilog
class vlsi;

  int a;
  int b;

  function void print(string name = "");
    $display("%s: a=%0d, b=%0d", name, a, b);
  endfunction

endclass


module tb;

  vlsi v1, v2;

  initial begin

    // Create objects
    v1 = new();
    v2 = new();

    // Initialize v2
    v2.a = 30;
    v2.b = 40;

    $display("\n--- Before Copy by Handle ---");
    v1.print("v1");
    v2.print("v2");

    // Copy the object handle
    v1 = v2;

    $display("\n--- After Copy by Handle ---");
    v1.print("v1");
    v2.print("v2");

    // Modify the object through v2
    v2.a = 20;
    v2.b = 59;

    $display("\n--- After Modifying v2 ---");
    v1.print("v1");
    v2.print("v2");

  end

endmodule
```

---

## 5. Explanation

### Step 1: Declare class handles

```systemverilog
vlsi v1, v2;
```

The variables `v1` and `v2` are class handles. They can refer to objects of class `vlsi`.

### Step 2: Create objects

```systemverilog
v1 = new();
v2 = new();
```

Two separate objects are created.

### Step 3: Initialize object properties

```systemverilog
v2.a = 30;
v2.b = 40;
```

The properties of the object referenced by `v2` are initialized.

### Step 4: Copy the handle

```systemverilog
v1 = v2;
```

This statement copies the handle stored in `v2` into `v1`.

It does not create a new object.

After this statement, both handles refer to the same object.

### Step 5: Modify the object

```systemverilog
v2.a = 20;
v2.b = 59;
```

The object is modified through `v2`.

Since `v1` and `v2` refer to the same object, the updated values are also visible through `v1`.

---

## 6. Expected Output

```text
--- Before Copy by Handle ---
v1: a=0, b=0
v2: a=30, b=40

--- After Copy by Handle ---
v1: a=30, b=40
v2: a=30, b=40

--- After Modifying v2 ---
v1: a=20, b=59
v2: a=20, b=59
```

### Output Analysis

| Operation | `v1.a` | `v1.b` | `v2.a` | `v2.b` |
|---|---:|---:|---:|---:|
| Initial state | 0 | 0 | 30 | 40 |
| After `v1 = v2` | 30 | 40 | 30 | 40 |
| After modifying `v2` | 20 | 59 | 20 | 59 |

The final values are identical because both handles refer to the same object.

---

## 7. Important SystemVerilog Concept

### Does handle assignment create a new object?

No.

```systemverilog
v1 = v2;
```

This copies the handle.

A new object is created only when the constructor is called:

```systemverilog
v1 = new();
```

### What happens to the original `v1` object?

Before the handle assignment, `v1` refers to its own object.

When the statement below executes:

```systemverilog
v1 = v2;
```

The handle stored in `v1` is overwritten.

The original object referenced by `v1` becomes unreachable unless another handle refers to it. SystemVerilog's garbage collection can reclaim unreachable objects.

---

## 8. Copy by Handle vs Shallow Copy vs Deep Copy

| Feature | Copy by Handle | Shallow Copy | Deep Copy |
|---|---|---|---|
| Example | `v1 = v2;` | User-defined field copy | User-defined recursive/object copy |
| New outer object | No | Yes | Yes |
| Nested handles | Shared | Usually shared | Recreated as needed |
| Independent outer objects | No | Yes | Yes |
| Independent nested objects | No | Not necessarily | Yes, when recreated |

**Important:** Copy by handle is a class-handle assignment operation. Shallow copy and deep copy are commonly implemented using user-defined copy methods.

---

## 9. Interview Questions

### Q1. What is copy by handle in SystemVerilog?

Copy by handle copies a class handle from one variable to another. Both handles refer to the same object.

### Q2. Does `v1 = v2` create a new object?

No. It copies the handle, not the object.

### Q3. Why does modifying `v2.a` also affect `v1.a`?

Because both handles refer to the same object.

### Q4. What is the difference between object and handle?

An object is the actual class instance in memory. A handle is a variable that refers to that object.

### Q5. How can independent objects be created?

Use the constructor:

```systemverilog
v1 = new();
v2 = new();
```

Then copy the required property values separately.

---

## 10. Conclusion

Copy by handle is one of the fundamental concepts in SystemVerilog object-oriented programming.

The statement:

```systemverilog
v1 = v2;
```

copies the handle, causing both variables to refer to the same object.

Therefore, changes made through one handle are visible through the other.

**Key takeaway:** Copy by handle shares an object; it does not create an independent copy.
