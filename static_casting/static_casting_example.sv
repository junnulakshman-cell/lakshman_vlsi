module static_casting_example;

  logic [7:0] data;
  logic [7:0] addr;

  int data_r;
  byte addr_r;
  byte unsigned addr_ru;

  initial begin
    data = 8'hAA;
    addr = 8'hBB;

    $display("=============== BEFORE THE CASTING ===========");
    $display("DATA = %0h (%0d) ADDR = %0h (%0d)",
             data, data, addr, addr);

    data_r = int'(data);
    addr_r = byte'(addr);

    $display("=============== AFTER THE CASTING ============");
    $display("DATA_r = %8h (%0d) ADDR_r = %0h (%0d)",
             data_r, data_r, addr_r, addr_r);
  end

  initial begin
    addr_ru = unsigned'(addr);

    $display("ADDR_ru = %0h (%0d)", addr_ru, addr_ru);
  end

endmodule
