module inter_process_sychronization;

  // ---------------------------
  // Event + Semaphore Example
  // ---------------------------
  event transaction_ready;
  semaphore bus_lock;

  // ---------------------------
  // Fork-Join Example Tasks
  // ---------------------------
  task automatic read_operation();
    #10;
    $display("[%0t] SRAM PERFORM THE READ OPERTION", $time);
    #15;
    $display("[%0t] SRAM COMPLETED THE READ OPERTION", $time);
  endtask

  task automatic wait_operation();
    #20;
    $display("[%0t] SRAM STORE THE DATA FOR SOME TIME", $time);
    #25;
    $display("[%0t] SRAM RELEASED AFTER THE [%0t] NS", $time, $time);
  endtask

  task automatic write_operation();
    #30;
    $display("[%0t] SRAM WENT INTO THE WRITE OPERATION", $time);
    #40;
    $display("[%0t] SRAM COMPLETED THE WRITE OPERATION", $time);
  endtask

  // ---------------------------
  // Event Chaining Example
  // ---------------------------
  event e1, e2, e3;

  // ---------------------------
  // Main Inter-Process Synchronization Example
  // ---------------------------
  initial begin
    bus_lock = new(1);

    $display("[%0t] STARTING INTER-PROCESS SYNCHRONIZATION EXAMPLE", $time);

    fork
      begin : generator
        $display("[%0t] GENERATOR : Creating Transaction", $time);
        #10;
        $display("[%0t] GENERATOR : Transaction Completed", $time);
        ->> transaction_ready;
      end

      begin : driver_1
        wait(transaction_ready.triggered);
        $display("[%0t] DRIVER1 : Waiting For Bus", $time);
        bus_lock.get(1);
        $display("[%0t] DRIVER1 : Acquired Bus", $time);
        #10;
        $display("[%0t] DRIVER1 : Released Bus", $time);
        bus_lock.put(1);
      end

      begin : driver_2
        wait(transaction_ready.triggered);
        $display("[%0t] DRIVER2 : Waiting For Bus", $time);
        bus_lock.get(1);
        $display("[%0t] DRIVER2 : Acquired Bus", $time);
        #15;
        $display("[%0t] DRIVER2 : Released Bus", $time);
        bus_lock.put(1);
      end

      begin : driver_3
        wait(transaction_ready.triggered);
        $display("[%0t] DRIVER3 : Waiting For Bus", $time);
        bus_lock.get(1);
        $display("[%0t] DRIVER3 : Acquired Bus", $time);
        #20;
        $display("[%0t] DRIVER3 : Released Bus", $time);
        bus_lock.put(1);
      end
    join

    $display("[%0t] END OF SEMAPHORE-EVENT EXAMPLE", $time);
  end

  // ---------------------------
  // Event Chain Example
  // ---------------------------
  initial begin
    @(e1)
    $display("[%0t] Process 1 is completed", $time);
    -> e3;
  end

  initial begin
    @(e3)
    $display("[%0t] Process 3 is completed", $time);
    -> e2;
  end

  initial begin
    @(e2)
    $display("[%0t] Process 2 is completed", $time);
  end

  initial begin
    $display("[%0t] Process 4 is completed", $time);
    -> e1;
  end

  // ---------------------------
  // Fork Join Examples
  // ---------------------------
  initial begin
    fork
      read_operation();
      wait_operation();
      write_operation();
    join

    $display("[%0t] Parent Released By join", $time);
  end

  initial begin
    #100;
    fork
      read_operation();
      wait_operation();
      write_operation();
    join_any

    $display("[%0t] Parent Released By join_any", $time);
  end

  initial begin
    #200;
    fork
      read_operation();
      wait_operation();
      write_operation();
    join_any

    disable fork;
    $display("[%0t] Parent Released By join_any + disable fork", $time);
  end

  initial begin
    #300;
    fork
      read_operation();
      wait_operation();
      write_operation();
    join_none

    $display("[%0t] Parent Released By join_none", $time);
  end

  initial begin
    #400;
    fork
      read_operation();
      wait_operation();
      write_operation();
    join_none

    disable fork;
    $display("[%0t] Parent Released By join_none + disable fork", $time);
  end

  initial begin
    #500;
    fork
      read_operation();
      wait_operation();
      write_operation();
    join_none;

    $display("[%0t] Parent Running", $time);
    wait fork;
    $display("[%0t] All Tasks Completed", $time);
  end

endmodule

// Expected output (one valid schedule):
// [0] STARTING INTER-PROCESS SYNCHRONIZATION EXAMPLE
// [0] GENERATOR : Creating Transaction
// [10] GENERATOR : Transaction Completed
// [10] DRIVER1 : Waiting For Bus
// [10] DRIVER1 : Acquired Bus
// [20] DRIVER1 : Released Bus
// [20] DRIVER2 : Waiting For Bus
// [20] DRIVER2 : Acquired Bus
// [35] DRIVER2 : Released Bus
// [35] DRIVER3 : Waiting For Bus
// [35] DRIVER3 : Acquired Bus
// [55] DRIVER3 : Released Bus
// [55] END OF SEMAPHORE-EVENT EXAMPLE
// [0] Process 4 is completed
// [0] Process 1 is completed
// [0] Process 3 is completed
// [0] Process 2 is completed
// [30] SRAM PERFORM THE READ OPERTION
// [30] SRAM STORE THE DATA FOR SOME TIME
// [45] SRAM COMPLETED THE READ OPERTION
// [45] SRAM RELEASED AFTER THE [45] NS
// [30] SRAM WENT INTO THE WRITE OPERATION
// [70] SRAM COMPLETED THE WRITE OPERTION
// [70] Parent Released By join
// [100] Parent Released By join_any
// [200] Parent Released By join_any + disable fork
// [300] Parent Released By join_none
// [400] Parent Released By join_none + disable fork
// [500] Parent Running
// [500] All Tasks Completed
