# Queue Example for AXI Write Buffer

This example demonstrates the use of a SystemVerilog queue for an AXI write transaction buffer.

## Aim

- Store transactions in order using a queue
- Add items at the front and back using `push_front()` and `push_back()`
- Remove items from the front and back using `pop_front()` and `pop_back()`
- Insert or delete items at arbitrary indices
- Clear the queue using `delete()`

## Example

```systemverilog
module axi_write_buffer;

  int write_transaction[$];
  int axi_id;

  initial begin
    $display("Size of the write_trans is %0d", write_transaction.size());

    write_transaction = {23,45,67,38,90};
    $display("Size of the write_trans is %0d", write_transaction.size());

    foreach (write_transaction[axi_id])
      $display("write_transaction[%0d] %0d", axi_id, write_transaction[axi_id]);

    write_transaction.push_front(20);
    $display("Push_front is %0p size of the transaction is %0d",
             write_transaction, write_transaction.size());

    write_transaction.push_back(50);
    $display("Push_back is %0p size of the transaction is %0d",
             write_transaction, write_transaction.size());

    write_transaction.pop_back();
    $display("Pop_back is %0p size of the transaction is %0d",
             write_transaction, write_transaction.size());

    write_transaction.pop_front();
    $display("Pop_front is %0p size of the transaction is %0d",
             write_transaction, write_transaction.size());

    write_transaction.insert(1,100);
    $display("Insert(1,100) = %0p size = %0d",
             write_transaction, write_transaction.size());

    write_transaction.insert(5,99);
    $display("Insert(5,99) = %0p size = %0d",
             write_transaction, write_transaction.size());

    write_transaction.delete(3);
    $display("Delete(3) = %0p size = %0d",
             write_transaction, write_transaction.size());

    write_transaction.delete();
    $display("Delete() = %0p size = %0d",
             write_transaction, write_transaction.size());
  end

endmodule
```

## Key concepts

- `write_transaction[$]` declares an unbounded queue
- `size()` returns the current number of elements
- `push_front()` and `push_back()` insert at the start or end
- `pop_front()` and `pop_back()` remove from the start or end
- `insert(index, value)` inserts at a specific position
- `delete(index)` removes one element; `delete()` clears the full queue

## Typical usage

Queues are useful for:

- Packet buffers
- Driver/monitor transaction storage
- FIFO models
- AXI write buffer implementations

## File

- `axi_write_buffer_queue.sv`
