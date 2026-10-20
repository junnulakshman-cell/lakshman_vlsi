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
    p = new child_packet();

    if ($cast(c, p)) begin
      $display("Downcasting is successful");

      c.data      = 8'hAA;
      c.addr      = 16'h1234;
      c.read_data = 16'h5678;

      $display("Data      = %0h", c.data);
      $display("Address   = %0h", c.addr);
      $display("Read Data = %0h", c.read_data);
    end
    else begin
      $display("Downcasting has failed");
    end
  end

endmodule
