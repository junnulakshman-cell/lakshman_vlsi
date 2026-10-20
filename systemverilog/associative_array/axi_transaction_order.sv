# Associative Array Example for AXI Transaction Tracking

This example shows how to use a SystemVerilog associative array to track AXI transaction IDs and their metadata.

## Aim

- Use `int` keys to store sparse transaction IDs
- Check whether a transaction exists using `exists()`
- Traverse entries using `first()`, `last()`, `next()`, and `prev()`
- Remove completed transactions using `delete()`

## Example

```systemverilog
module axi_transaction_order;

  typedef logic [15:0] transaction_t[int];
  transaction_t transaction_types;
  int axi_id;

  initial begin
    $display("INITIAL_TRANSACTION = %0d", transaction_types.num());

    transaction_types[101] = 16'hAA; // READ
    transaction_types[105] = 16'hBB; // WRITE
    transaction_types[109] = 16'hCC; // BURST_READ
    transaction_types[106] = 16'hDD; // BURST_WRITE

    $display("AFTER_TRANSACTION = %0d", transaction_types.num());

    foreach (transaction_types[axi_id])
      $display("FOR_TRANSACTION[%0d] = %0h", axi_id, transaction_types[axi_id]);

    transaction_types.first(axi_id);
    $display("FIRST_ID = %0d TRANS_TY = %0h", axi_id, transaction_types[axi_id]);

    transaction_types.last(axi_id);
    $display("LAST_ID = %0d TRANS_TY = %0h", axi_id, transaction_types[axi_id]);

    transaction_types.next(axi_id);
    $display("NEXT_ID = %0d TRANS_TY = %0h", axi_id, transaction_types[axi_id]);

    transaction_types.prev(axi_id);
    $display("PREV_ID = %0d TRANS_TY = %0h", axi_id, transaction_types[axi_id]);

    if (transaction_types.exists(107))
      $display("READ Transaction Not Found");
    else
      $display("READ Transaction Not Found");

    if (transaction_types.exists(106))
      $display("BURST_WRITE Transaction Found");
    else
      $display("BURST_WRITE Transaction Not Found");

    if (transaction_types.exists(105))
      $display("WRITE Transaction Found");
    else
      $display("WRITE Transaction Not Found");

    transaction_types.delete(105);

    if (transaction_types.exists(105))
      $display("WRITE Transaction Still Exists");
    else
      $display("WRITE Transaction Successfully Deleted");

    $display("\nRemaining Transactions After Deletion");
    foreach (transaction_types[axi_id])
      $display("TRANSACTION[%0d] = %0h", axi_id, transaction_types[axi_id]);
  end
endmodule
```

## Key concepts

- `typedef logic [15:0] transaction_t[int];` creates an associative array of sparse keys
- `transaction_types.num()` returns the number of populated entries
- `exists()` checks whether a key is present
- `first()`, `last()`, `next()`, and `prev()` are used to traverse keys
- `delete(index)` removes a transaction from the map

## Typical usage

Associative arrays are useful for:

- AXI transaction tracking
- Outstanding response queues
- UVM scoreboard lookup tables
- Sparse memory or ID-based models

## File

- `axi_transaction_order.sv`
