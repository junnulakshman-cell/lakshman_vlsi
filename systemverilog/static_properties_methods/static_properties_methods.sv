class static_example;

  parameter DATA_WIDTH  = 16;
  parameter COUNT_WIDTH = 4;

  static logic [DATA_WIDTH-1:0] DATA;
  static logic [COUNT_WIDTH-1:0] COUNT = 0;

  static function void display();
    $display("DATA = %0d, COUNT = %0d", DATA, COUNT);
  endfunction

  static function void increment_count();
    COUNT = COUNT + 1;
    $display("COUNT incremented to %0d", COUNT);
  endfunction

endclass

module tb;

  static_example se1;
  static_example se2;

  initial begin
    se1 = new();
    se2 = new();

    // Static variables are shared across all objects of the class.
    se1.DATA = 16'd4;
    se1.COUNT = 4'd5;

    $display("Before update: se1.DATA = %0d, se1.COUNT = %0d", se1.DATA, se1.COUNT);
    $display("Before update: se2.DATA = %0d, se2.COUNT = %0d", se2.DATA, se2.COUNT);

    // Both objects refer to the same static memory.
    se2.DATA = 16'd7;
    se2.COUNT = 4'd6;

    $display("After update: se1.DATA = %0d, se1.COUNT = %0d", se1.DATA, se1.COUNT);
    $display("After update: se2.DATA = %0d, se2.COUNT = %0d", se2.DATA, se2.COUNT);

    static_example::display();
    static_example::increment_count();

    // Access through class name is also valid.
    static_example::DATA = 16'd12;
    static_example::COUNT = 4'd9;
    static_example::display();
  end

endmodule
