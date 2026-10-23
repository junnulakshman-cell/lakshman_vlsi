`timescale 1ns/1ps

module uvm_style_synchronization_tb;
  event response_done;

  initial begin
    fork
      begin
        $display("[%0t] MONITOR: waiting for response", $time);
        wait(response_done.triggered);
        $display("[%0t] MONITOR: response received", $time);
      end

      begin
        #100;
        $display("[%0t] TIMEOUT: response missing", $time);
      end
    join_any

    disable fork;
    $display("[%0t] CLEANUP: ended monitor/timeout process", $time);
  end

  initial begin
    #20;
    $display("[%0t] DRIVER: sending response", $time);
    -> response_done;
  end

endmodule
