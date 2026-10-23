`timescale 1ns/1ps

module disable_fork_tb;

  task automatic read_operation();
    begin
      #10;
      $display("[%0t] READ complete", $time);
    end
  endtask

  task automatic wait_operation();
    begin
      #30;
      $display("[%0t] WAIT complete", $time);
    end
  endtask

  task automatic write_operation();
    begin
      #50;
      $display("[%0t] WRITE complete", $time);
    end
  endtask

  initial begin
    $display("[%0t] Starting timeout example", $time);
    fork
      read_operation();
      wait_operation();
      write_operation();
    join_any

    disable fork;
    $display("[%0t] Active child processes terminated by disable fork", $time);
  end

endmodule
