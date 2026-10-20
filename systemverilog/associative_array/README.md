//=======================================================================
// Associative Array Example for AXI Transaction Tracking
//=======================================================================

module axi_transaction_order;

  typedef logic [15:0] transaction_t[int];
  transaction_t transaction_types;
  int axi_id;

  initial begin
    $display("INITIAL_TRANSACTION = %0d", transaction_types.num());

    // Insert sparse transaction IDs and their transaction type values
    transaction_types[101] = 16'hAA; // READ
    transaction_types[105] = 16'hBB; // WRITE
    transaction_types[109] = 16'hCC; // BURST_READ
    transaction_types[106] = 16'hDD; // BURST_WRITE

    $display("AFTER_TRANSACTION = %0d", transaction_types.num());

    // Iterate through all entries
    foreach (transaction_types[axi_id])
      $display("FOR_TRANSACTION[%0d] = %0h", axi_id, transaction_types[axi_id]);

    // Get first and last entries
    transaction_types.first(axi_id);
    $display("FIRST_ID = %0d TRANS_TY = %0h", axi_id, transaction_types[axi_id]);

    transaction_types.last(axi_id);
    $display("LAST_ID = %0d TRANS_TY = %0h", axi_id, transaction_types[axi_id]);

    // Navigate to next and previous keys
    transaction_types.next(axi_id);
    $display("NEXT_ID = %0d TRANS_TY = %0h", axi_id, transaction_types[axi_id]);

    transaction_types.prev(axi_id);
    $display("PREV_ID = %0d TRANS_TY = %0h", axi_id, transaction_types[axi_id]);

    // Check existence
    if (transaction_types.exists(107))
      $display("READ Transaction Found");
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

    // Delete a completed transaction
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
