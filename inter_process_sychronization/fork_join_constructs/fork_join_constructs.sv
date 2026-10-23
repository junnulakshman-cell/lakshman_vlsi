`timescale 1ns/1ps

module fork_join_constructs_tb;

  task automatic read_operation();
    begin
      #10;
      $display("[%0t] READ: operation complete", $time);
    end
  endtask

  task automatic wait_operation();
    begin
      #20;
      $display("[%0t] WAIT: operation complete", $time);
    end
  endtask

  task automatic write_operation();
    begin
      #30;
      $display("[%0t] WRITE: operation complete", $time);
    end
  endtask

  initial begin
    $display("[%0t] Example: fork...join", $time);
    fork
      read_operation();
      wait_operation();
      write_operation();
    join
    $display("[%0t] Parent resumes after fork...join", $time);
  end

  initial begin
    #100;
    $display("[%0t] Example: fork...join_any", $time);
    fork
      read_operation();
      wait_operation();
      write_operation();
    join_any
    $display("[%0t] Parent resumes after first child finishes", $time);
  end

  initial begin
    #200;
    $display("[%0t] Example: fork...join_none", $time);
    fork
      read_operation();
      wait_operation();
      write_operation();
    join_none
    $display("[%0t] Parent continues immediately", $time);
    #100;
    wait fork;
    $display("[%0t] All child processes completed", $time);
  end

endmodule

// Expected output:
// [0] Example: fork...join
// [30] READ: operation complete
// [30] WAIT: operation complete
// [30] WRITE: operation complete
// [30] Parent resumes after fork...join
//
// [100] Example: fork...join_any
// [110] READ: operation complete
// [110] Parent resumes after first child finishes
//
// [200] Example: fork...join_none
// [200] Parent continues immediately
// [300] All child processes completed
