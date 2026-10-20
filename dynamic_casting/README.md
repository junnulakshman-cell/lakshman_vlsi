# SystemVerilog Dynamic Casting (`$cast`) — Downcasting

## 1. Aim

To understand dynamic casting using `$cast()` in SystemVerilog, particularly how to convert a parent-class handle into a child-class handle safely at runtime.

## 2. What Is Downcasting?

Downcasting means converting a **parent-class handle into a child-class handle**.

SystemVerilog provides `$cast()` to perform a runtime type check when assigning a class handle to a more specific derived-class handle.

### Syntax

```systemverilog
$cast(destination_handle, source_handle);
```

- `destination_handle`: The handle that receives the cast result.
- `source_handle`: The existing handle whose object type is checked.
- Return value: `1` if the cast succeeds, or `0` if it fails.

**Important:** `$cast()` does not convert a parent object into a child object. It checks whether the object already referenced by the source handle is compatible with the destination class type.

## 3. SystemVerilog Code

Save the following code as `downcasting_example.sv`.

```systemverilog
class parent_packet;
  logic [7:0] data;
endclass

class child_packet extends parent_packet;
  logic [15:0] addr;
  logic [15:0] read_data;
endclass

module tb;

  parent_packet p;
  child_packet  c;

  initial begin
    p = new();

    if ($cast(c, p))
      $display("Downcasting is successful");
    else
      $display("Downcasting has failed");
  end

endmodule
```

## 4. Expected Output

```text
Downcasting has failed
```

## 5. Step-by-Step Explanation

### Step 1: Create the parent class

```systemverilog
class parent_packet;
  logic [7:0] data;
endclass
```

The `parent_packet` class contains an 8-bit data field.

### Step 2: Create the child class

```systemverilog
class child_packet extends parent_packet;
  logic [15:0] addr;
  logic [15:0] read_data;
endclass
```

The `child_packet` class inherits the `data` member from `parent_packet` and adds two child-specific members:

- `addr`: 16-bit address.
- `read_data`: 16-bit read data.

### Step 3: Declare the class handles

```systemverilog
parent_packet p;
child_packet c;
```

Both variables are class handles. Initially, neither handle refers to an object.

### Step 4: Create a parent object

```systemverilog
p = new();
```

This creates an object whose actual type is `parent_packet`.

The handle `p` now refers to that parent object.

### Step 5: Attempt downcasting

```systemverilog
$cast(c, p)
```

SystemVerilog checks whether the object referenced by `p` is compatible with `child_packet`.

In this example, the object was created using `new()` through the `parent_packet` handle, so its actual type is `parent_packet`. It is not a `child_packet` object.

Therefore, the cast fails and the `else` branch executes.

## 6. How to Make Downcasting Successful

To make the cast succeed, create a child object and reference it through the parent handle.

```systemverilog
module tb;

  parent_packet p;
  child_packet  c;

  initial begin
    p = new child_packet();

    if ($cast(c, p)) begin
      $display("Downcasting is successful");

      c.data      = 8'hAA;
      c.addr      = 16'h1234;
      c.read_data = 16'h5678;

      $display("Data      = %0h", c.data);
      $display("Address   = %0h", c.addr);
      $display("Read Data = %0h", c.read_data);
    end
    else begin
      $display("Downcasting has failed");
    end
  end

endmodule
```

### Expected Output

```text
Downcasting is successful
Data      = aa
Address   = 1234
Read Data = 5678
```

Here, `p` is a parent-class handle, but it references an object whose actual type is `child_packet`. Therefore, `$cast(c, p)` succeeds, and the child-specific members become accessible through `c`.

## 7. Upcasting vs. Downcasting

| Feature | Upcasting | Downcasting |
|---|---|---|
| Direction | Child to parent | Parent to child |
| Typical assignment | Implicit assignment is allowed | Use `$cast()` for a runtime-checked handle assignment |
| Runtime type check | Usually unnecessary | Important |
| Example | `p = c;` | `$cast(c, p);` |
| Main purpose | Access an object through its base-class interface | Access derived-class members safely |

## 8. Why Is `$cast()` Used?

### Why not simply assign the handles?

A parent-class handle can reference either a parent object or an object of a derived class. However, the handle's declared type alone does not reveal the actual object type.

`$cast()` checks runtime compatibility before assigning the source handle to the destination handle.

### Real-time applications

- **UVM scoreboards:** Identify a specific transaction type before accessing its fields.
- **UVM monitors:** Handle different transaction types through common base-class handles.
- **Analysis ports and FIFOs:** Work with polymorphic transaction objects.
- **Factory-created objects:** Check the runtime type of an object returned through a base-class handle.
- **Polymorphic class hierarchies:** Safely access derived-class properties and methods.

## 9. Interview Questions and Answers

**Q1. What is `$cast()` in SystemVerilog?**

`$cast()` is a system task/function used for type checking and conversion. For class handles, it checks whether the source object is compatible with the destination class type at runtime.

**Q2. Why does downcasting fail in the original example?**

The cast fails because `p` refers to an object of type `parent_packet`, not `child_packet`. A parent object cannot be treated as an instance of its derived class.

**Q3. Can a parent handle refer to a child object?**

Yes. A parent-class handle can reference an object of its own class or a derived class.

**Q4. Does `$cast()` create a new object?**

No. It checks type compatibility and, on success, assigns the existing object handle to the destination.

**Q5. What happens if `$cast()` fails?**

It returns `0`, and the destination handle is not updated by that failed cast. In the example, the `else` branch executes.

**Q6. Why is downcasting important in UVM?**

UVM frequently uses base-class handles such as `uvm_object` and `uvm_sequence_item`. `$cast()` allows a verification component to check the actual transaction type before accessing derived-class-specific fields.

**Q7. What is the difference between `$cast()` and `new()`?**

`new()` constructs a class object. `$cast()` checks type compatibility and assigns a handle; it does not construct an object.

## 10. Interview-Ready Definition

**Dynamic casting using `$cast()` performs a runtime type check. It is commonly used for downcasting to verify that a parent-class handle references an object of the desired derived class before accessing child-specific properties or methods.**

### UVM-specific answer

In UVM, `$cast()` is used to convert a base-class handle, such as `uvm_object` or `uvm_sequence_item`, into a derived transaction handle after checking the actual object's type at runtime.

## 11. Conclusion

Downcasting is useful when an object is accessed through a parent-class handle but the verification code needs child-specific members.

Remember these three points:

1. A parent handle can reference a child object.
2. A parent object cannot be downcast into a child object.
3. `$cast()` checks compatibility at runtime; it does not create or transform the object.
