module enum_casting;

  typedef enum logic [2:0] {
    APPLE,
    ORANGE,
    BANANA,
    MANGO
  } fruits_names;

  fruits_names fruits_order;

  initial begin
    fruits_order = fruits_names'(2);
    $display("fruits_order = %s", fruits_order.name());
  end

  initial begin
    int i;

    for (i = 0; i < 4; i++) begin
      fruits_order = fruits_names'(i);

      $display("num = %0d fruits_order = %s",
               i, fruits_order.name());
    end
  end

endmodule
