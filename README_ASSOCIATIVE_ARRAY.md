# Associative Array in SystemVerilog

This example explains the difference between a fixed array and an associative array in SystemVerilog, and shows how associative arrays are useful for sparse or dynamic transaction IDs such as AXI transaction tracking.

## Fixed Array vs Associative Array

A fixed array has a constant size defined at compile time.

![Fixed Array](associative_array_fixed_array.svg)

### Fixed array

```systemverilog
int arr[5] = '{10, 20, 30, 40, 50};
```

- size is fixed at compile time
- memory is contiguous
- indexing is fast and predictable
- best when the index range is known and dense

### Associative array

```systemverilog
typedef logic [15:0] transaction_t[int];
transaction_t transaction_types;

transaction_types[101] = 16'hAA;
transaction_types[105] = 16'hBB;
transaction_types[109] = 16'hCC;
```

An associative array is different:

- keys are not required to be sequential
- memory grows only for used entries
- ideal for sparse IDs such as AXI transaction numbers
- useful for lookup, insertion, deletion, and iteration

## Why associative arrays matter in AXI verification

In AXI-based testbenches, transaction IDs are often sparse and dynamic. For example:

- 101
- 105
- 106
- 109

A fixed array would waste memory because the index range is not continuous, while an associative array stores only the actual entries.

## Core associative array operations

```systemverilog
transaction_types.num();
transaction_types.exists(id);
transaction_types.first(id);
transaction_types.last(id);
transaction_types.next(id);
transaction_types.prev(id);
transaction_types.delete(id);
```

## Example: AXI transaction tracking

```systemverilog
module axi_transaction_order;

  typedef logic [15:0] transaction_t[int];
  transaction_t transaction_types;
  int axi_id;

  initial begin
    $display("INITIAL_TRANSACTION = %0d", transaction_types.num());

    transaction_types[101] = 'hAA; // READ
    transaction_types[105] = 'hBB; // WRITE
    transaction_types[109] = 'hCC; // BURST_READ
    transaction_types[106] = 'hDD; // BURST_WRITE

    $display("AFTER_TRANSACTION = %0d", transaction_types.num());

    foreach (transaction_types[axi_id])
      $display("FOR_TRANSACTION[%0d] = %0h", axi_id, transaction_types[axi_id]);

    transaction_types.first(axi_id);
    $display("FIRST_ID = %0d TRANS_TY = %0h", axi_id, transaction_types[axi_id]);

    transaction_types.last(axi_id);
    $display("LAST_ID = %0d TRANS_TY = %0h", axi_id, transaction_types[axi_id]);

    if (transaction_types.exists(105))
      $display("WRITE Transaction Found");

    transaction_types.delete(105);

    if (transaction_types.exists(105))
      $display("WRITE Transaction Still Exists");
    else
      $display("WRITE Transaction Successfully Deleted");
  end
endmodule
```

## Representative output

```text
INITIAL_TRANSACTION = 0
AFTER_TRANSACTION = 4
FOR_TRANSACTION[101] = aa
FOR_TRANSACTION[105] = bb
FOR_TRANSACTION[106] = dd
FOR_TRANSACTION[109] = cc
FIRST_ID = 101 TRANS_TY = aa
LAST_ID = 109 TRANS_TY = cc
WRITE Transaction Found
WRITE Transaction Successfully Deleted
```

## Summary

- fixed arrays are good for dense, known index ranges
- associative arrays are good for sparse, dynamic, or transaction-based IDs
- associative arrays are widely used in scoreboards, caches, and AXI verification

This is a practical foundation for using associative arrays in SystemVerilog verification environments.
