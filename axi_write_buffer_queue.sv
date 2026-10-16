//==============================================================================
// Project      : AXI Write Buffer Using SystemVerilog Queue
// File Name    : axi_write_buffer_queue.sv
// Author       : Lakshman Junnu
//
// Description:
// This SystemVerilog example demonstrates the use of Queue data structures
// for modeling an AXI Write Transaction Buffer.
//
// Queue Methods Demonstrated:
// 1. size()        - Returns the queue size
// 2. push_front()  - Insert element at the beginning
// 3. push_back()   - Insert element at the end
// 4. pop_front()   - Remove element from the beginning
// 5. pop_back()    - Remove element from the end
// 6. insert()      - Insert element at a specified index
// 7. delete(index) - Delete a specific element
// 8. delete()      - Delete the complete queue
// 9. foreach()     - Traverse queue contents
//
// Verification Use Cases:
// - AXI Transaction Buffer
// - UVM Scoreboard Storage
// - FIFO Modeling
// - Packet Queues
// - Driver/Monitor Transaction Storage
//
// Initial Queue:
// {23, 45, 67, 38, 90}
//
//==============================================================================

module axi_write_buffer;

  // Queue Declaration
  int write_transaction[$];

  // Loop Variable
  int axi_id;

  initial begin

    // Display initial queue size
    $display("Size of the write_trans is %0d",
              write_transaction.size());

    // Initialize queue
    write_transaction = {23,45,67,38,90};

    // Display queue size after initialization
    $display("Size of the write_trans is %0d",
              write_transaction.size());

    // Traverse queue contents
    foreach(write_transaction[axi_id])
      $display("write_transaction[%0d] %0d",
                axi_id,
                write_transaction[axi_id]);

    // Insert element at front
    write_transaction.push_front(20);

    $display("Push_front is %0p size of the transaction is %0d",
              write_transaction,
              write_transaction.size());

    // Insert element at back
    write_transaction.push_back(50);

    $display("Push_back is %0p size of the transaction is %0d",
              write_transaction,
              write_transaction.size());

    // Remove element from back
    write_transaction.pop_back();

    $display("Pop_back is %0p size of the transaction is %0d",
              write_transaction,
              write_transaction.size());

    // Remove element from front
    write_transaction.pop_front();

    $display("Pop_front is %0p size of the transaction is %0d",
              write_transaction,
              write_transaction.size());

    // Insert element at index 1
    write_transaction.insert(1,100);

    $display("Insert(1,100) = %0p size = %0d",
              write_transaction,
              write_transaction.size());

    // Insert element at index 5
    write_transaction.insert(5,99);

    $display("Insert(5,99) = %0p size = %0d",
              write_transaction,
              write_transaction.size());

    // Delete element at index 3
    write_transaction.delete(3);

    $display("Delete(3) = %0p size = %0d",
              write_transaction,
              write_transaction.size());

    // Delete entire queue
    write_transaction.delete();

    $display("Delete() = %0p size = %0d",
              write_transaction,
              write_transaction.size());

  end

endmodule
