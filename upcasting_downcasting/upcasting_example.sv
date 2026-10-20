class parent_packet;
  logic [7:0] data;
endclass

class child_packet extends parent_packet;
  logic [15:0] addr;
  logic [15:0] read_data;
endclass

module tb;

  parent_packet p;
  child_packet  c;

  initial begin
    c = new();

    c.data      = 8'hAA;
    c.addr      = 16'h1234;
    c.read_data = 16'h5678;

    p = c;

    $display("Upcasting is successful");
    $display("Data = %0h", p.data);
  end

endmodule
