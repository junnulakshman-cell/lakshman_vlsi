# SystemVerilog OOP: Encapsulation Using Protected and Local Access Specifiers

## Overview

This project demonstrates encapsulation in SystemVerilog using protected and local members. It shows how a parent class stores sensitive data, a child class inherits it, and public methods control access to that data.

The example covers:

- Encapsulation
- Inheritance
- Data hiding
- Controlled access via methods
- Protected and local access specifiers

## File added

- `encapsulation_protected_local_access.sv` — commented SystemVerilog source code

## Class hierarchy

```text
             +----------------+
             |     parent     |
             +----------------+
             | # status       |
             +----------------+
                       ^
                       |
                       |
             +----------------+
             |     child      |
             +----------------+
             | - retry_count  |
             +----------------+
             | set_status()   |
             | set_retry_count() |
             | get_retry_count() |
             +----------------+
```

Legend:

```text
# = protected member
- = local member
```

## Key concept: Encapsulation

Encapsulation means hiding the internal implementation and exposing only what is needed through methods.

```systemverilog
protected int status;
local int retry_count;
```

These members are not directly exposed to the outside world.

## Protected member

`status` is declared as protected in the parent class.

```systemverilog
protected int status;
```

This makes it available inside the class hierarchy, but not to external modules.

### Access behavior

| Location | Access |
|----------|--------|
| Parent class | Yes |
| Child class | Yes |
| Testbench | No |

## Local member

`retry_count` is declared as local inside the child class.

```systemverilog
local int retry_count;
```

This means it is hidden from the parent class and the testbench.

### Access behavior

| Location | Access |
|----------|--------|
| Child class | Yes |
| Parent class | No |
| Testbench | No |

## Program behavior

The `set_status()` method updates the inherited status value.

```systemverilog
c.set_status(1);
```

Then `set_retry_count()` decides whether retry is enabled:

```systemverilog
if(status == 1)
  retry_count = 1'b1;
else
  retry_count = 1'b0;
```

Finally, `get_retry_count()` prints the result:

```systemverilog
if(retry_count == 1)
  $display("Status = %0b Count = %0b", retry_count, status);
else
  $display("COUNT IS NOT RESTARTED");
```

## Expected output

```text
Status = 1
Status = 1 Count = 1
Status = 0
COUNT IS NOT RESTARTED
Status = 1
Status = 1 Count = 1
```

## Why this matters

This example demonstrates how encapsulation protects internal state while still allowing controlled interaction through methods. It is a common style used in design verification and object-oriented modeling.

## How to run

Use any SystemVerilog simulator such as Questa, VCS, or Xcelium.

1. Add `encapsulation_protected_local_access.sv` to the project.
2. Compile the design.
3. Run the simulation.
4. Compare the transcript output with the expected result above.

## Interview notes

1. What is the difference between protected and local?
   - `protected` allows access in the class hierarchy.
   - `local` restricts access to the defining class only.

2. Why is encapsulation useful?
   - It hides internal data and prevents accidental modification.

3. Why are methods used instead of direct variable access?
   - It keeps the internal state controlled and valid.

4. What happens when `status = 0`?
   - `retry_count` becomes `0`, and the result prints `COUNT IS NOT RESTARTED`.

## Conclusion

This example shows a practical use of encapsulation in SystemVerilog. The parent class owns the status, the child class protects its internal retry state, and class methods provide safe access to the data.
