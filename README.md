# SystemVerilog Associative Array and Queue

A simulation example demonstrating associative-array methods and queue operations for verification interviews and practice.

## Objective

Store 8-bit transaction data by integer ID in an associative array, and demonstrate how a queue can record transaction arrival order.

| Declaration | Purpose |
| --- | --- |
| `logic [7:0] tr_id[int];` | Associative array: integer keys, 8-bit data values |
| `int tr_order[$];` | Unbounded queue of integer transaction IDs |
| `int axi_id;` | Variable used for key navigation |

The queue uses `int` to match the associative-array key type. The original 8-bit queue works for the small IDs shown, but truncates IDs outside its unsigned 8-bit range.

## Corrected Method Demonstration

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

Save the code as `associative_queue_array.sv` and select `associative_queue_array` as the simulation top in a SystemVerilog simulator supporting associative arrays and queues. This is a testbench example, intended for simulation.

## Expected Results

The following results are derived from the code; they are not a captured simulator log. Queue formatting with `%p` can vary by simulator.

```text
Initial entries = 0
Initial queue size = 0
Queue size = 4
tr_id[4] = 67
tr_id[5] = 9
tr_id[6] = 45
tr_id[8] = 10
First: ID=4 DATA=67
Last: ID=8 DATA=10
Previous: ID=6 DATA=45
Next: ID=8 DATA=10
ID 8 is deleted
```

| Operation | Queue after operation | Size | Removed ID |
| --- | --- | --- | --- |
| Initial assignment | `{5, 8, 6, 4}` | 4 | — |
| `insert(1, 78)` | `{5, 78, 8, 6, 4}` | 5 | — |
| `push_front(100)` | `{100, 5, 78, 8, 6, 4}` | 6 | — |
| `pop_back()` | `{100, 5, 78, 8, 6}` | 5 | 4 |
| `push_back(50)` | `{100, 5, 78, 8, 6, 50}` | 6 | — |
| `pop_front()` | `{5, 78, 8, 6, 50}` | 5 | 100 |

## How the Methods Work

| Method | Behavior |
| --- | --- |
| `tr_id.num()` | Number of existing associative-array entries |
| `tr_id.exists(id)` | Returns 1 if the key exists, otherwise 0 |
| `tr_id.first(id)` | Writes the smallest integer key to `id` on success |
| `tr_id.last(id)` | Writes the largest integer key to `id` on success |
| `tr_id.prev(id)` | Moves to the next smaller existing key on success |
| `tr_id.next(id)` | Moves to the next larger existing key on success |
| `tr_id.delete(id)` | Removes one associative-array entry |
| `tr_order.size()` | Number of queue elements |
| `tr_order.insert(index, value)` | Inserts a value at the given queue index |
| `push_front(value)` / `push_back(value)` | Adds an element at the front / back |
| `pop_front()` / `pop_back()` | Removes and returns the front / back element |

Navigation methods return a success status. Check it before using the resulting key. Check queue size before popping when the queue may be empty.

## Corrections to the Original Code

1. Reverse the deletion messages: `exists(8)` being true means ID 8 is still present.
2. Capture the values returned by `pop_front()` and `pop_back()`, or explicitly discard them using `void'(...)`.
3. Check navigation return values instead of ignoring possible failure.
4. Use integer queue elements when they represent integer associative-array keys.
5. Remember that changing either structure does not automatically update the other.

The method demonstration intentionally manipulates the queue independently. After deleting associative-array key 8, ID 8 remains in the queue. IDs 78, 100, and 50 also have no associated data entry. This is useful for learning methods but is not a synchronized transaction tracker.

## Practical Example: Process in Arrival Order

This version connects the two structures. Each insertion adds both the transaction data and its ID; each processing step removes both.

```systemverilog
module transaction_tracking_example;
  logic [7:0] tr_id[int];
  int tr_order[$];
  int axi_id;

  initial begin
    tr_id[5] = 9;  tr_order.push_back(5);
    tr_id[8] = 10; tr_order.push_back(8);
    tr_id[6] = 45; tr_order.push_back(6);
    tr_id[4] = 67; tr_order.push_back(4);

    while (tr_order.size() > 0) begin
      axi_id = tr_order.pop_front();
      if (tr_id.exists(axi_id)) begin
        $display("Processing ID=%0d DATA=%0d", axi_id, tr_id[axi_id]);
        tr_id.delete(axi_id);
      end
      else
        $error("Missing transaction for ID=%0d", axi_id);
    end
    $display("Remaining entries=%0d queue size=%0d",
             tr_id.num(), tr_order.size());
    $finish;
  end
endmodule
```

Expected output:

```text
Processing ID=5 DATA=9
Processing ID=8 DATA=10
Processing ID=6 DATA=45
Processing ID=4 DATA=67
Remaining entries=0 queue size=0
```

## Interview Explanation

> I use an associative array to store transaction data indexed by transaction ID, and a queue to preserve arrival order. The associative array supports lookup by ID, while popping the queue selects the next transaction to process. I explicitly update both structures to keep them consistent.

### Common Questions

**Does an associative array preserve insertion order?**  
For integer keys, traversal follows numerical key order. In this example it visits 4, 5, 6, 8 even though insertion was 5, 8, 6, 4.

**Does deleting a key remove its ID from the queue?**  
No. They are separate variables and require separate updates.

**What happens if the same ID is assigned again?**  
Its existing data is overwritten. This design assumes one outstanding stored transaction per ID.

**Is this a complete AXI scoreboard?**  
No. It demonstrates storage and ordering concepts. AXI responses can complete out of order across IDs, so a scoreboard should match responses using the appropriate ID. Multiple outstanding transactions sharing an ID need per-ID queues or another suitable representation; one global FIFO cannot model every AXI ordering case.

**Why use both structures?**  
The associative array answers “What data belongs to this ID?” The queue answers “Which ID arrived next?”

## GitHub Use

Create a repository and upload this file as `README.md`. Optionally save the two code blocks as separate `.sv` files. Run each module as its own simulation top because each calls `$finish`.
