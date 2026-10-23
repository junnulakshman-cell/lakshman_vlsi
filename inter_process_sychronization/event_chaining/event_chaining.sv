`timescale 1ns/1ps

module event_chaining_tb;
  event e1, e2, e3;

  initial begin
    @(e1);
    $display("[%0t] Process 1 complete", $time);
    -> e3;
  end

  initial begin
    @(e3);
    $display("[%0t] Process 3 complete", $time);
    -> e2;
  end

  initial begin
    @(e2);
    $display("[%0t] Process 2 complete", $time);
  end

  initial begin
    $display("[%0t] Process 4 complete", $time);
    -> e1;
  end

endmodule

// Expected output:
// [0] Process 4 complete
// [0] Process 1 complete
// [0] Process 3 complete
// [0] Process 2 complete
