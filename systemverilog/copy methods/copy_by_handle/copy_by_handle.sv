//====================================================
// SystemVerilog - Copy by Handle
//====================================================

class vlsi;

  int a;
  int b;

  // Display object properties
  function void print(string name = "");
    $display("%s: a=%0d, b=%0d", name, a, b);
  endfunction

endclass


module tb;

  vlsi v1, v2;

  initial begin

    // Create two objects
    v1 = new();
    v2 = new();

    // Initialize v2
    v2.a = 30;
    v2.b = 40;

    $display("\n--- Before Copy by Handle ---");
    v1.print("v1");
    v2.print("v2");

    // Copy the object handle
    v1 = v2;

    $display("\n--- After Copy by Handle ---");
    v1.print("v1");
    v2.print("v2");

    // Modify the object through v2
    v2.a = 20;
    v2.b = 59;

    $display("\n--- After Modifying v2 ---");
    v1.print("v1");
    v2.print("v2");

  end

endmodule
