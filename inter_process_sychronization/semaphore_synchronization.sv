`timescale 1ns/1ps

module semaphore_synchronization_tb;
  semaphore bus_lock;

  initial begin
    bus_lock = new(1);
    $display("[%0t] Initial semaphore count = %0d", $time, bus_lock.get(1));
    bus_lock.get(1);
    $display("[%0t] Critical section entered", $time);
    #10;
    $display("[%0t] Critical section finished", $time);
    bus_lock.put(1);
  end

endmodule

// Expected output:
// [0] Initial semaphore count = 1
// [0] Critical section entered
// [10] Critical section finished
