# SystemVerilog Shallow Copy Using Class Handles

## 📌 Overview

This project demonstrates **shallow copy in SystemVerilog** using class handles.

Shallow copy copies the handle of an object rather than creating a new object. As a result, both handles refer to the same memory location.

This example contains:

- A `packet` class with a `count` property.
- A `vlsi` class with `a`, `b`, and a nested `packet` handle.
- A shallow-copy operation using `v1 = v2`.
- A custom deep-copy method for comparison.

## 🖼️ Concept Diagram

![SystemVerilog Shallow Copy Diagram](images/shallow_copy_diagram.png)

## 🎯 Objective

- Understand class handles in SystemVerilog.
- Understand shallow copy and deep copy.
- Observe how modifying one handle affects another.
- Understand nested class handles.

## 💻 SystemVerilog Code

### File: `shallow_copy.sv`

```systemverilog
class packet;
  int count;
endclass

class vlsi;
  int a;
  int b;
  packet pck = new();

  function void print();
    $display("a=%0d", a);
    $display("b=%0d", b);
    $display("packet count=%0d", pck.count);
  endfunction

  // Deep copy method
  function void copy(output vlsi v);
    v = new();

    v.a = this.a;
    v.b = this.b;

    v.pck = new();
    v.pck.count = this.pck.count;
  endfunction
endclass

module top;
  vlsi v1, v2;

  initial begin
    v1 = new();
    v2 = new();

    v2.a = 14;
    v2.b = 42;
    v2.pck.count = 500;

    // Shallow copy
    v1 = v2;

    $display("\n--- After Shallow Copy ---");
    $display("Object v1:");
    v1.print();

    $display("Object v2:");
    v2.print();

    // Modify v2
    v2.a = 40;
    v2.b = 50;
    v2.pck.count = 600;

    $display("\n--- After Modifying v2 ---");
    $display("Object v1:");
    v1.print();

    $display("Object v2:");
    v2.print();
  end
endmodule
```

## 🔍 Explanation

### 1. Object Creation

```systemverilog
v1 = new();
v2 = new();
```

Two class objects are initially created.

### 2. Initialize the Source Object

```systemverilog
v2.a = 14;
v2.b = 42;
v2.pck.count = 500;
```

The values of `v2` are initialized.

### 3. Perform Shallow Copy

```systemverilog
v1 = v2;
```

This copies the object handle.

Both `v1` and `v2` refer to the same `vlsi` object.

### 4. Modify the Object

```systemverilog
v2.a = 40;
v2.b = 50;
v2.pck.count = 600;
```

Since both handles refer to the same object, the updated values are visible through both handles.

## 📟 Expected Output

```text
--- After Shallow Copy ---
Object v1:
a=14
b=42
packet count=500

Object v2:
a=14
b=42
packet count=500

--- After Modifying v2 ---
Object v1:
a=40
b=50
packet count=600

Object v2:
a=40
b=50
packet count=600
```

## 🧠 Shallow Copy vs Deep Copy

| Feature | Shallow Copy | Deep Copy |
|---|---|---|
| Operation | `v1 = v2;` | `v2.copy(v1);` |
| Outer object | Shared | Separate |
| Nested object | Shared | Separate when explicitly recreated |
| Modification effect | Visible through both handles | Independent values |
| Memory allocation | No new object | New object(s) created |

### Shallow Copy

```systemverilog
v1 = v2;
```

Both handles refer to the same object.

### Deep Copy

```systemverilog
v2.copy(v1);
```

The custom method creates a new outer object and a new nested `packet` object.

## 🎓 Interview Questions

**Q1. What is shallow copy?**

Shallow copy copies a class handle. Both handles refer to the same object.

**Q2. What happens when we modify `v2.a` after `v1 = v2`?**

The value observed through `v1.a` also changes because both handles point to the same object.

**Q3. Does shallow copy allocate a new object?**

No. Handle assignment does not create a new class object.

**Q4. How do you perform deep copy in SystemVerilog?**

Use a custom copy method that creates a new object and explicitly copies its properties and nested class objects.

## ✅ Conclusion

Shallow copy in SystemVerilog copies the object handle, not the object itself.

```systemverilog
v1 = v2;
```

Both handles refer to the same object. Therefore, modifying the object through one handle affects the other.

For independent objects, use a custom deep-copy method.

**Key takeaway:** Shallow copy shares an object; deep copy creates independent object instances.
<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/ea3a3044-d4d8-488e-b00d-b130e490a3c1" />
