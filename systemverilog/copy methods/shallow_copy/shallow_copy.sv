// Shallow Copy Using Class Handles

class packet;
  int count;
endclass

class vlsi;
  int a;
  int b;
  packet pck = new();

  function void print();
    $display("a=%0d", a);
    $display("b=%0d", b);
    $display("packet count=%0d", pck.count);
  endfunction
endclass

module top;
  vlsi v1, v2;

  initial begin
    v1 = new();
    v2 = new();

    v2.a = 14;
    v2.b = 42;
    v2.pck.count = 500;

    // Shallow copy: copies the handle, not the object
    v1 = v2;

    $display("\n--- After Shallow Copy ---");
    $display("Object v1:");
    v1.print();

    $display("Object v2:");
    v2.print();

    // Modify v2
    v2.a = 40;
    v2.b = 50;
    v2.pck.count = 600;

    $display("\n--- After Modifying v2 ---");
    $display("Object v1:");
    v1.print();

    $display("Object v2:");
    v2.print();
  end
endmodule
