`timescale 1ns/1ps

module event_synchronization_tb;
  event transaction_ready;

  initial begin
    #10;
    $display("[%0t] GENERATOR: Transaction is ready", $time);
    -> transaction_ready;
  end

  initial begin
    @(transaction_ready);
    $display("[%0t] RECEIVER: Transaction ready event detected", $time);
  end

  initial begin
    #20;
    $display("[%0t] CHECK: event.triggered = %0d", $time, transaction_ready.triggered);
  end

endmodule

// Expected output:
// [10] GENERATOR: Transaction is ready
// [10] RECEIVER: Transaction ready event detected
// [20] CHECK: event.triggered = 0
