# Associative Queue Example

This example combines the behavior of an associative array and a queue in a SystemVerilog testbench.

## Aim

- Demonstrate associative array indexing and lookup
- Show queue insertion and removal methods
- Build a simple verification model for transaction ordering and storage

## Example

```systemverilog
module associative_queue_array;
  logic [7:0] tr_id[int];
  int tr_order[$];
  int axi_id;
  int removed_id;

  initial begin
    $display("Initial entries = %0d", tr_id.num());
    $display("Initial queue size = %0d", tr_order.size());

    tr_id[5] = 9;
    tr_id[8] = 10;
    tr_id[6] = 45;
    tr_id[4] = 67;
    tr_order = {5, 8, 6, 4};
    $display("Queue size = %0d", tr_order.size());

    foreach (tr_id[id])
      $display("tr_id[%0d] = %0d", id, tr_id[id]);

    if (tr_id.first(axi_id))
      $display("First: ID=%0d DATA=%0d", axi_id, tr_id[axi_id]);
    if (tr_id.last(axi_id))
      $display("Last: ID=%0d DATA=%0d", axi_id, tr_id[axi_id]);
    if (tr_id.prev(axi_id))
      $display("Previous: ID=%0d DATA=%0d", axi_id, tr_id[axi_id]);
    if (tr_id.next(axi_id))
      $display("Next: ID=%0d DATA=%0d", axi_id, tr_id[axi_id]);

    tr_id.delete(8);
    if (tr_id.exists(8))
      $display("ID 8 is not deleted");
    else
      $display("ID 8 is deleted");

    tr_order.insert(1, 78);
    $display("Insert: %p size=%0d", tr_order, tr_order.size());
    tr_order.push_front(100);
    $display("Push front: %p size=%0d", tr_order, tr_order.size());
    removed_id = tr_order.pop_back();
    $display("Pop back: removed=%0d queue=%p size=%0d",
             removed_id, tr_order, tr_order.size());
    tr_order.push_back(50);
    $display("Push back: %p size=%0d", tr_order, tr_order.size());
    removed_id = tr_order.pop_front();
    $display("Pop front: removed=%0d queue=%p size=%0d",
             removed_id, tr_order, tr_order.size());
    $finish;
  end
endmodule
```

## Key concepts

- Associative arrays provide sparse indexing by key
- Queues provide ordered dynamic storage
- Together they are useful for transaction scheduling and matching logic

## File

- `associative_queue_array.sv`
