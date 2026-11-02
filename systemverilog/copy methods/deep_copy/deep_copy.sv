// Deep Copy Using Nested Class Handles

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

  function void copy(output vlsi v);
    v = new();

    v.a = this.a;
    v.b = this.b;

    v.pck = new();
    v.pck.count = this.pck.count;
  endfunction
endclass

module top;
  vlsi v1, v2;

  initial begin
    v2 = new();

    v2.a = 14;
    v2.b = 42;
    v2.pck.count = 500;

    $display("\n--- Before Deep Copy ---");
    v2.print();

    // Deep copy into v1
    v2.copy(v1);

    $display("\n--- After Deep Copy ---");
    $display("Object v1:");
    v1.print();

    $display("Object v2:");
    v2.print();

    // Modify source object
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
