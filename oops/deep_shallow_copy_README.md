# Shallow Copy vs Deep Copy in SystemVerilog

## Objective

This example explains the difference between:

1. Shallow copy
2. Deep copy
3. Class handle assignment

The code below uses an outer class `axi_txn_t` with a nested handle `tr` that points to an `axi_txn` object.

## Class structure

```text
axi_txn_t
|-- addr : logic [15:0]
|-- tr   : axi_txn handle
           |-- data : logic [15:0]
```

- `addr` is a value member.
- `tr` is a class handle.
- `tr.data` is stored in a separate object.

## Complete example

```systemverilog
class axi_txn;
  logic [15:0] data;
endclass

class axi_txn_t;
  axi_txn tr;
  logic [15:0] addr;

  function void shallow_copy(axi_txn_t rhs);
    addr = rhs.addr;
    tr = rhs.tr;
  endfunction

  function void deep_copy(axi_txn_t rhs);
    addr = rhs.addr;
    tr = new();
    tr.data = rhs.tr.data;
  endfunction
endclass

module tb;
  axi_txn_t tr1, tr2;

  initial begin
    tr1 = new();
    tr2 = new();
    tr2.tr = new();

    tr2.addr = 'hAF;
    tr2.tr.data = 'hBD;
    tr1.shallow_copy(tr2);

    tr1.addr = 'hFE;
    tr2.tr.data = 'hFC;

    $display("=== SHALLOW COPY ===");
    $display("tr1 addr=%h data=%h", tr1.addr, tr1.tr.data);
    $display("tr2 addr=%h data=%h", tr2.addr, tr2.tr.data);

    tr1 = new();
    tr2 = new();
    tr1.tr = new();
    tr2.tr = new();

    tr2.addr = 'hAF;
    tr2.tr.data = 'hBD;
    tr1.deep_copy(tr2);

    tr1.addr = 'hFE;
    tr2.tr.data = 'hFC;

    $display("=== DEEP COPY ===");
    $display("tr1 addr=%h data=%h", tr1.addr, tr1.tr.data);
    $display("tr2 addr=%h data=%h", tr2.addr, tr2.tr.data);

    tr1 = new();
    tr1.tr = new();
    tr1.addr = 'hAF;
    tr1.tr.data = 'hBD;

    tr2 = tr1;

    tr2.addr = 'h23;
    tr2.tr.data = 'h12;

    $display("=== HANDLE ASSIGNMENT ===");
    $display("tr1 addr=%h data=%h", tr1.addr, tr1.tr.data);
    $display("tr2 addr=%h data=%h", tr2.addr, tr2.tr.data);

    $finish;
  end
endmodule
```

## Expected output

```text
=== SHALLOW COPY ===
tr1 addr=00fe data=00fc
tr2 addr=00af data=00fc

=== DEEP COPY ===
tr1 addr=00fe data=00bd
tr2 addr=00af data=00fc

=== HANDLE ASSIGNMENT ===
tr1 addr=0023 data=0012
tr2 addr=0023 data=0012
```

## Explanation

### Shallow copy

```systemverilog
addr = rhs.addr;
tr = rhs.tr;
```

This copies the address value and also copies the nested handle. Both objects share the same `axi_txn` object.

Result:
- Outer object values are separate.
- Nested object is shared.

### Deep copy

```systemverilog
addr = rhs.addr;
tr = new();
tr.data = rhs.tr.data;
```

This creates a new nested object and copies the data into it.

Result:
- Outer object values are independent.
- Nested object is independent.

### Handle assignment

```systemverilog
tr2 = tr1;
```

This does not create a new outer object. Both handles point to the same object.

Result:
- Same outer object.
- Same nested object.

## Key takeaway

- Shallow copy shares nested class objects.
- Deep copy creates a new nested object.
- Handle assignment copies only the handle, not the object.

## Diagrams

See the SVG diagrams in this folder:
- `deep_copy_diagram.svg`
- `handle_assignment_diagram.svg`
