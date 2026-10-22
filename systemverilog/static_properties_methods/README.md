# Static Properties and Methods

## Overview

This project demonstrates the usage of **static properties** and **static methods** in SystemVerilog.

Static members belong to the **class itself** rather than individual objects. Therefore, all objects share the same copy of static variables and methods.

---

## Source Code

```systemverilog
class static_example;

  parameter DATA_WIDTH  = 16;
  parameter COUNT_WIDTH = 4;

  static logic [DATA_WIDTH-1:0] DATA;
  static logic [COUNT_WIDTH-1:0] COUNT = 0;

  static function void display(
      logic [DATA_WIDTH-1:0] S_DATA,
      logic [COUNT_WIDTH-1:0] S_COUNT
  );

    S_DATA  = DATA;
    S_COUNT = COUNT;

    $display(" PACKET = %0D COUNT = %0D ", S_DATA, S_COUNT);

    S_COUNT++;

    $display(" PACKET = %0D COUNT = %0D ", S_DATA, S_COUNT);

  endfunction

endclass

module tb;

  static_example se1, se2;

  initial begin

    se1 = new();
    se2 = new();

    se2.DATA  = 4;
    se1.COUNT = 5;

    $display(" PACKET = %0D COUNT = %0D ",
              se1.DATA, se1.COUNT);

    se2.COUNT = 6;

    $display(" PACKET = %0D COUNT = %0D ",
              se2.DATA, se2.COUNT);

    se1.COUNT = 8;

    $display(" PACKET = %0D COUNT = %0D ",
              se1.DATA, se1.COUNT);

    static_example::display(2,3);

    $display(" Total Object_count = %0d",
              static_example::COUNT);

    $display(" DATA_WIDTH = %0d",
              static_example::DATA_WIDTH);

  end

endmodule
```

---

## Output

```text
PACKET = 4 COUNT = 5
PACKET = 4 COUNT = 6
PACKET = 4 COUNT = 8
PACKET = 4 COUNT = 8
PACKET = 4 COUNT = 9
Total Object_count = 8
DATA_WIDTH = 16
```

---

# Static Properties

## Definition

A static property is a class variable that belongs to the class rather than individual objects.

```systemverilog
static logic [DATA_WIDTH-1:0] DATA;
static logic [COUNT_WIDTH-1:0] COUNT;
```

Only one copy exists regardless of how many objects are created.

---

## Class Variables

| Variable | Description |
|-----------|------------|
| DATA | Shared packet data |
| COUNT | Shared counter |
| DATA_WIDTH | Width of DATA |
| COUNT_WIDTH | Width of COUNT |

---

## Accessing Static Variables

### Through Object

```systemverilog
se1.DATA
se2.COUNT
```

### Through Class Name

```systemverilog
static_example::DATA
static_example::COUNT
```

Recommended:

```systemverilog
static_example::COUNT
```

---

# Static Methods

## Definition

A static method belongs to the class and can be called without creating an object.

```systemverilog
static function void display(...);
```

---

## Calling Static Methods

```systemverilog
static_example::display(2,3);
```

No object handle is required.

---

## Advantages

- Reduces dependency on objects
- Direct access to static members
- Useful for utility/helper functions
- Better memory utilization

---

# Output Explanation

## Step 1

```systemverilog
se2.DATA = 4;
se1.COUNT = 5;
```

Output:

```text
PACKET = 4 COUNT = 5
```

Both values are stored in shared static variables.

---

## Step 2

```systemverilog
se2.COUNT = 6;
```

Output:

```text
PACKET = 4 COUNT = 6
```

Updating through one object updates the shared variable.

---

## Step 3

```systemverilog
se1.COUNT = 8;
```

Output:

```text
PACKET = 4 COUNT = 8
```

Again, all objects observe the same value.

---

## Step 4

```systemverilog
static_example::display(2,3);
```

Inside function:

```systemverilog
S_DATA = DATA;
S_COUNT = COUNT;
```

Output:

```text
PACKET = 4 COUNT = 8
PACKET = 4 COUNT = 9
```

The local variable `S_COUNT` is incremented inside the method.

---

# Static vs Non-Static Members

| Feature | Static Member | Non-Static Member |
|-----------|--------------|-------------------|
| Ownership | Class | Object |
| Memory Allocation | One shared copy | Separate copy for each object |
| Access | Class or Object | Object only |
| Data Sharing | Shared among objects | Unique per object |
| Lifetime | Entire simulation | Until object exists |
| Memory Usage | Less | More |
| Best Use | Counters, Statistics | Transaction Data |

---

# Non-Static Example

```systemverilog
class packet;

  int data;

endclass

module tb;

  packet p1,p2;

  initial begin

    p1 = new();
    p2 = new();

    p1.data = 10;
    p2.data = 20;

    $display("P1 DATA = %0d", p1.data);
    $display("P2 DATA = %0d", p2.data);

  end

endmodule
```

### Output

```text
P1 DATA = 10
P2 DATA = 20
```

### Memory Representation

```text
Object p1
+-----------+
| data = 10 |
+-----------+

Object p2
+-----------+
| data = 20 |
+-----------+
```

Each object owns its own copy.

---

# Static Example

```systemverilog
class packet;

  static int count;

endclass

module tb;

  packet p1,p2;

  initial begin

    p1 = new();
    p2 = new();

    p1.count = 10;

    $display("P1 COUNT = %0d", p1.count);
    $display("P2 COUNT = %0d", p2.count);

    p2.count = 20;

    $display("P1 COUNT = %0d", p1.count);
    $display("P2 COUNT = %0d", p2.count);

  end

endmodule
```

### Output

```text
P1 COUNT = 10
P2 COUNT = 10

P1 COUNT = 20
P2 COUNT = 20
```

### Memory Representation

```text
          Class Memory
       +---------------+
       | count = 20    |
       +---------------+
          ^         ^
          |         |
         p1        p2
```

Both objects point to the same memory location.

---

# Visual Comparison

```text
NON-STATIC
-----------

Object-1 ---> data = 10

Object-2 ---> data = 20

Separate copies


STATIC
-------

Object-1 ---\
             > count = 20
Object-2 ---/

Shared copy
```

---

# Applications of Static Members

## Object Counter

```systemverilog
static int object_count;
```

Used to track total number of created objects.

---

## Transaction Counter

```systemverilog
static int total_transactions;
```

Used in drivers and monitors.

---

## Packet Counter

```systemverilog
static int packet_count;
```

Tracks total packets processed.

---

## Error Counter

```systemverilog
static int error_count;
```

Tracks total protocol violations.

---

## Coverage Statistics

```systemverilog
static int coverage_hits;
```

Stores cumulative coverage information.

---

## Global Configuration

```systemverilog
static bit enable_checking;
```

Stores common configuration for all objects.

---

# Interview Questions

## Q1. What is a static property?

A static property belongs to the class rather than an object and is shared by all instances of the class.

---

## Q2. What is a static method?

A static method belongs to the class and can be called using the scope resolution operator (`::`) without creating an object.

---

## Q3. Why does COUNT change for both se1 and se2?

Because COUNT is declared as static:

```systemverilog
static logic [COUNT_WIDTH-1:0] COUNT;
```

All objects share the same memory location.

---

## Q4. Can a static method access non-static members directly?

No.

A static method can directly access only static members.

---

## Q5. How do you call a static method?

```systemverilog
static_example::display();
```

using the scope resolution operator (`::`).

---

# Key Takeaways

✅ Static variables belong to the class.

✅ Only one copy exists in memory.

✅ All objects share the same value.

✅ Static methods can be called without creating objects.

✅ Useful for counters, statistics, coverage, and global configurations.

✅ Non-static members create separate copies for every object.

---

## Author

**Lakshman Junnu**

VLSI Design & Verification Engineer

Skills:
- SystemVerilog
- UVM
- AXI/APB Protocols
- RTL Design
- Functional Verification
- FPGA & ASIC Design Flow
