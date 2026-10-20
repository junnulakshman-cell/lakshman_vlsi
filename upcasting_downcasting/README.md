# SystemVerilog Upcasting and Downcasting

## 1. Aim

To understand upcasting and downcasting in SystemVerilog using parent and child classes, class handles, and the `$cast()` system function.

## 2. SystemVerilog Code

Save the code as `upcasting_example.sv`.

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
    c = new();

    if ($cast(c, p))
      $display("Up Casting is successful");
    else
      $display("Up Casting has failed");
  end

endmodule
```

## 3. Expected Output

```text
Up Casting has failed
```

## 4. Explanation of the Original Code

### Step 1: Parent class

```systemverilog
class parent_packet;
  logic [7:0] data;
endclass
```

The parent class contains an 8-bit `data` member.

### Step 2: Child class

```systemverilog
class child_packet extends parent_packet;
  logic [15:0] addr;
  logic [15:0] read_data;
endclass
```

The child inherits `data` from the parent and adds two members: `addr` and `read_data`.

### Step 3: Create a child object

```systemverilog
c = new();
```

This creates an object whose actual type is `child_packet`.

### Step 4: Understand the cast

```systemverilog
$cast(c, p)
```

The first argument is the destination handle, and the second argument is the source handle.

- Destination: `c` — child-class handle.
- Source: `p` — parent-class handle.

This is a downcast attempt, not an upcast.

Because `p` has not been assigned an object, it is `null`. The cast fails.

## 5. Correct Upcasting Example

Upcasting means assigning a child-class object to a parent-class handle.

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
    c = new();

    c.data      = 8'hAA;
    c.addr      = 16'h1234;
    c.read_data = 16'h5678;

    p = c;

    $display("Upcasting is successful");
    $display("Data = %0h", p.data);
  end

endmodule
```

### Expected Output

```text
Upcasting is successful
Data = aa
```

### Why does this work?

The child object contains all the members inherited from the parent, so a parent-class handle can reference that child object.

```systemverilog
p = c;
```

This is an ordinary upcast and does not require `$cast()`.

The parent handle `p` can access `data`, but it cannot directly access `addr` or `read_data`, because those members are not declared in `parent_packet`.

## 6. Upcasting vs. Downcasting

| Feature | Upcasting | Downcasting |
|---|---|---|
| Direction | Child → Parent | Parent → Child |
| Assignment | `p = c;` | `$cast(c, p);` |
| Runtime check | Usually unnecessary | Required for safe handle conversion |
| Child-specific members | Not accessible through parent handle | Accessible after successful cast |
| Object creation | Does not create an object | Does not create an object |

## 7. Real-Time Applications in VLSI and UVM

### Upcasting

Useful when different transaction classes must be handled through a common parent-class interface.

Examples:
- Passing derived transaction objects to generic verification components.
- Storing different packet types in a common collection.
- Using polymorphism in reusable testbench components.

### Downcasting

Useful when a generic base-class handle needs to be checked before accessing fields belonging to a particular derived transaction.

Examples:
- UVM scoreboards.
- UVM monitors.
- Factory-created objects.
- Polymorphic transaction processing.

## 8. Interview Questions

**Q1. What is upcasting?**

Upcasting is assigning a derived-class object handle to a base-class handle.

**Q2. Is `$cast()` required for upcasting?**

No. A compatible child-class handle can ordinarily be assigned to a parent-class handle directly.

**Q3. What is downcasting?**

Downcasting converts a base-class handle to a derived-class handle after checking runtime type compatibility, commonly using `$cast()`.

**Q4. Why does the original code fail?**

The source handle `p` is uninitialized and therefore `null`. Additionally, `$cast(c, p)` is a downcast attempt, despite the message saying upcasting.

**Q5. Can a parent handle access child-specific members?**

No. A parent handle can directly access only members declared in its class and inherited members available through that class's interface.

**Q6. Does upcasting create a new object?**

No. It changes which class handle refers to the existing object; it does not construct another object.

## 9. Interview-Ready Definition

**Upcasting** is the process of assigning a child-class object handle to a parent-class handle. It supports polymorphism and allows derived objects to be processed through a common base-class interface.

**Downcasting** uses runtime type checking, typically through `$cast()`, to determine whether a parent-class handle references an object compatible with a particular child class.

## 10. Conclusion

Remember the correct direction:

```systemverilog
p = c;          // Upcasting
$cast(c, p);    // Downcasting attempt
```

Upcasting is generally straightforward because a child object includes the parent-class portion. Downcasting requires runtime compatibility checking because not every parent object is a child object.
