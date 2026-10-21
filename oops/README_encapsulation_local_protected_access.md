# SystemVerilog Encapsulation: Local vs Protected Access Specifiers

## Overview

This project demonstrates the concept of encapsulation in SystemVerilog using the access specifiers `local` and `protected`.

Encapsulation means:

- hiding internal data
- controlling how data is accessed
- exposing only necessary functionality through methods

This example shows two cases:

1. `local` member access inside the same class only
2. `protected` member access inside the parent and child classes

## Topic in focus

- Encapsulation
- Data hiding
- Access control
- Inheritance

## File added

- `encapsulation_local_protected_access.sv` — SystemVerilog source code

## Explanation of the example

### Case 1: `local` member

```systemverilog
class parent;
   local int a=3;
   int b=6;

   function void print();
     $display("a=%0d,b=%0d",a,b);
   endfunction
endclass
```

Here, `a` is declared as `local`.

- It is accessible only inside the `parent` class.
- It cannot be accessed from the child class.
- It cannot be accessed directly from the testbench.

This is the strongest form of data hiding.

### Case 2: `protected` member

```systemverilog
class parent;
   protected int a=3;
   int b=6;

   function void print();
     $display("a=%0d,b=%0d",a,b);
   endfunction
endclass
```

Here, `a` is declared as `protected`.

- The parent class can access it.
- The child class can access it.
- The testbench cannot access it directly.

This enables inheritance while still protecting the data from outside access.

## Why the `local` version gives an error

The following code is invalid:

```systemverilog
class child extends parent;
  int c;

  function void sub();
      c = a - b;
      $display("c=%0d", c);
  endfunction
endclass
```

This fails because `a` is `local` in the parent, and local members are only visible inside the same class where they are declared.

Compiler error:

```text
ERROR VCP5248 "Cannot access local/protected member ""a"" from this scope."
```

### Correct idea

Use `protected` when the child class needs access to the inherited data.

```systemverilog
class parent;
   protected int a=3;
   int b=6;

   function void print();
     $display("a=%0d,b=%0d",a,b);
   endfunction
endclass
```

Then the child can access it:

```systemverilog
class child extends parent;
  int c;

  function void sub();
      c = a - b;
      $display("c=%0d", c);
  endfunction
endclass
```

## Working example

```systemverilog
class parent;
   protected int a=3;
   int b=6;

   function void print();
     $display("a=%0d,b=%0d",a,b);
   endfunction
endclass

class child extends parent;
  int c;

  function void sub();
      c = a - b;
      $display("c=%0d", c);
  endfunction
endclass

module tb;
  child c;
  initial begin
    c = new();
    c.print();
    c.sub();
  end
endmodule
```

## Output

```text
a=3,b=6
c=-3
```

## Access Specifier Comparison

| Access Specifier | Same Class | Derived Class | Outside Class |
|------------------|------------|---------------|---------------|
| `local`          | Yes        | No            | No            |
| `protected`      | Yes        | Yes           | No            |
| public (default) | Yes        | Yes           | Yes           |

## Why encapsulation matters

Encapsulation is important because it:

- prevents accidental modification of important data
- hides internals from outside code
- keeps class behavior controlled through methods
- supports better software design and maintainability

## Key takeaway

- Use `local` when data should be completely hidden inside the class.
- Use `protected` when derived classes must access the data.
- Use methods to provide controlled access instead of direct data access.

## Conclusion

This example clearly shows the difference between `local` and `protected` access in SystemVerilog. The `local` version is not visible in the child class, while the `protected` version is inherited and can be used by the child class. This is the core idea behind encapsulation and controlled visibility in object-oriented design.
