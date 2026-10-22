module normal_task_static_demo;

  task normal_task();
    int normal_count;
    int normal_data;

    normal_count = 5;
    $display("=======Normal_task========");

    for (normal_count = 0; normal_count < 5; normal_count++)
      $display("normal_count = %0d data = %0d",
               normal_count, normal_data);

    normal_data = 5;

    for (normal_data = 0; normal_data < 5; normal_data++)
      $display("normal_count = %0d data = %0d",
               normal_count, normal_data);
  endtask

  initial begin
    fork
      normal_task();
      normal_task();
    join
  end

endmodule

module static_task_varying_output_demo;

  task static_task();
    int data;
    int count;

    $display("======Static_task=======");

    for (data = 0; data < 5; data++)
      $display("count = %0d data = %0d", count, data);

    data = 5;
    count = 5;

    for (count = 0; count < 5; count++)
      $display("count = %0d data = %0d", count, data);
  endtask

  initial begin
    fork
      static_task();
      static_task();
    join
    $finish;
  end

endmodule
