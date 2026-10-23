module inter_process_syncrospthons;

  semaphore bus_lock;
  event transaction_ready;

  initial begin
    bus_lock = new(1);

    fork
      begin : generator
        $display("[%0t] GENERATOR: Creating transaction", $time);
        #10;
        $display("[%0t] GENERATOR: Transaction completed", $time);
        ->> transaction_ready;
      end

      begin : driver_1
        wait(transaction_ready.triggered);
        $display("[%0t] DRIVER1: Waiting for bus", $time);
        bus_lock.get(1);
        $display("[%0t] DRIVER1: Acquired bus", $time);
        #10;
        $display("[%0t] DRIVER1: Released bus", $time);
        bus_lock.put(1);
      end

      begin : driver_2
        wait(transaction_ready.triggered);
        $display("[%0t] DRIVER2: Waiting for bus", $time);
        bus_lock.get(1);
        $display("[%0t] DRIVER2: Acquired bus", $time);
        #15;
        $display("[%0t] DRIVER2: Released bus", $time);
        bus_lock.put(1);
      end

      begin : driver_3
        wait(transaction_ready.triggered);
        $display("[%0t] DRIVER3: Waiting for bus", $time);
        bus_lock.get(1);
        $display("[%0t] DRIVER3: Acquired bus", $time);
        #20;
        $display("[%0t] DRIVER3: Released bus", $time);
        bus_lock.put(1);
      end
    join
  end

endmodule
