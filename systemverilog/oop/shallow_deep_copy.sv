# Shallow and Deep Copy in SystemVerilog

This example demonstrates shallow copy, deep copy, and class-handle assignment in SystemVerilog classes.

## Aim

- Understand the difference between copying a class handle and copying the underlying object
- Show how `deep_copy()` avoids sharing nested objects
- Show how `shallow_copy()` shares nested object references

## Example

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

## Key concepts

- Shallow copy copies the class handle reference, not the underlying object
- Deep copy creates a new object for nested members
- `tr2 = tr1;` makes two handles point to the same object

## Typical usage

This is important for:

- Transaction object cloning
- UVM object copying
- Avoiding accidental sharing of data between testbench components

## File

- `shallow_deep_copy.sv`
