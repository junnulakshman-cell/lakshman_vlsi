`timescale 1ns/1ps

module shared_bus_arbitration_tb;
  semaphore bus_lock;
  event transaction_ready;

  task automatic bus_driver(input string name, input time hold_time);
    begin
      wait(transaction_ready.triggered);
      $display("[%0t] %s waiting for bus", $time, name);
      bus_lock.get(1);
      $display("[%0t] %s acquired bus", $time, name);
      #(hold_time);
      $display("[%0t] %s released bus", $time, name);
      bus_lock.put(1);
    end
  endtask

  initial begin
    bus_lock = new(1);

    fork
      begin
        #10;
        $display("[%0t] GENERATOR: creating transaction", $time);
        ->> transaction_ready;
      end

      bus_driver("DRIVER_1", 10ns);
      bus_driver("DRIVER_2", 15ns);
      bus_driver("DRIVER_3", 20ns);
    join
  end

endmodule

// Expected output (one valid scheduling order):
// [10] GENERATOR: creating transaction
// [10] DRIVER_1 waiting for bus
// [10] DRIVER_1 acquired bus
// [20] DRIVER_1 released bus
// [20] DRIVER_2 waiting for bus
// [20] DRIVER_2 acquired bus
// [35] DRIVER_2 released bus
// [35] DRIVER_3 waiting for bus
// [35] DRIVER_3 acquired bus
// [55] DRIVER_3 released bus
