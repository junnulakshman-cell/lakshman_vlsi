//------------------------------------------------------------------------------
// Project      : AXI Transaction Tracker using Associative Array
// Language     : SystemVerilog
// Description  : Demonstrates Associative Array methods using an
//                AXI Outstanding Transaction Database.
//
// Methods Used :
// 1. num()
// 2. foreach
// 3. first()
// 4. last()
// 5. next()
// 6. prev()
// 7. exists()
// 8. delete(index)
//
// Use Case :
// Associative arrays are commonly used in UVM Scoreboards,
// AXI Transaction Tracking, Memory Models, and Cache Verification.
//
//------------------------------------------------------------------------------

module axi_transaction_order;

  // Associative array declaration
  // Key   : AXI Transaction ID (int)
  // Value : Transaction Type (16-bit data)
  typedef logic [15:0] transaction_t[int];

  transaction_t transaction_types;

  // Variable used as associative-array index
  int axi_id;

  initial begin

    //----------------------------------------------------------------------
    // Display number of transactions before insertion
    //----------------------------------------------------------------------
    $display("INITIAL_TRANSACTION = %0d",
              transaction_types.num());

    //----------------------------------------------------------------------
    // Insert AXI transactions
    //----------------------------------------------------------------------
    transaction_types[101] = 'hAA; // READ
    transaction_types[105] = 'hBB; // WRITE
    transaction_types[109] = 'hCC; // BURST_READ
    transaction_types[106] = 'hDD; // BURST_WRITE

    //----------------------------------------------------------------------
    // Display number of active transactions
    //----------------------------------------------------------------------
    $display("AFTER_TRANSACTION = %0d",
              transaction_types.num());

    //----------------------------------------------------------------------
    // Display all transactions using foreach
    //----------------------------------------------------------------------
    foreach(transaction_types[axi_id])
      $display("FOR_TRANSACTION[%0d] = %0h",
               axi_id,
               transaction_types[axi_id]);

    //----------------------------------------------------------------------
    // first()
    // Returns the lowest transaction ID
    //----------------------------------------------------------------------
    transaction_types.first(axi_id);

    $display("FIRST_ID = %0d TRANS_TY = %0h",
              axi_id,
              transaction_types[axi_id]);

    //----------------------------------------------------------------------
    // last()
    // Returns the highest transaction ID
    //----------------------------------------------------------------------
    transaction_types.last(axi_id);

    $display("LAST_ID = %0d TRANS_TY = %0h",
              axi_id,
              transaction_types[axi_id]);

    //----------------------------------------------------------------------
    // next()
    // Finds the next valid transaction ID
    //----------------------------------------------------------------------
    transaction_types.next(axi_id);

    $display("NEXT_ID = %0d TRANS_TY = %0h",
              axi_id,
              transaction_types[axi_id]);

    //----------------------------------------------------------------------
    // prev()
    // Finds the previous valid transaction ID
    //----------------------------------------------------------------------
    transaction_types.prev(axi_id);

    $display("PREV_ID = %0d TRANS_TY = %0h",
              axi_id,
              transaction_types[axi_id]);

    //----------------------------------------------------------------------
    // exists()
    // Check if transaction ID 107 exists
    //----------------------------------------------------------------------
    if(transaction_types.exists(107))
      $display("READ Transaction Found");
    else
      $display("READ Transaction Not Found");

    //----------------------------------------------------------------------
    // exists()
    // Check if transaction ID 106 exists
    //----------------------------------------------------------------------
    if(transaction_types.exists(106))
      $display("BURST_WRITE Transaction Found");
    else
      $display("BURST_WRITE Transaction Not Found");

    //----------------------------------------------------------------------
    // exists()
    // Check if transaction ID 105 exists
    //----------------------------------------------------------------------
    if(transaction_types.exists(105))
      $display("WRITE Transaction Found");
    else
      $display("WRITE Transaction Not Found");

    //----------------------------------------------------------------------
    // delete(index)
    // Remove transaction ID 105
    //----------------------------------------------------------------------
    transaction_types.delete(105);

    //----------------------------------------------------------------------
    // Verify deletion of transaction ID 105
    //----------------------------------------------------------------------
    if(transaction_types.exists(105))
      $display("WRITE Transaction Still Exists");
    else
      $display("WRITE Transaction Successfully Deleted");

    //----------------------------------------------------------------------
    // Display remaining transactions
    //----------------------------------------------------------------------
    $display("\nRemaining Transactions After Deletion");

    foreach(transaction_types[axi_id])
      $display("TRANSACTION[%0d] = %0h",
                axi_id,
                transaction_types[axi_id]);

  end

endmodule
