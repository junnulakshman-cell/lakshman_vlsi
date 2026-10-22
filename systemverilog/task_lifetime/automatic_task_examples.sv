module automatic_task_demo;

  task automatic auto_task();
    int auto_data;
    int auto_count;

    $display("======Automatic_task=======");

    for (auto_data = 0; auto_data < 5; auto_data++)
      $display("auto_count = %0d auto_data = %0d",
               auto_count, auto_data);

    auto_data = 5;
    auto_count = 5;

    for (auto_count = 0; auto_count < 5; auto_count++)
      $display("auto_count = %0d auto_data = %0d",
               auto_count, auto_data);
  endtask

  initial begin
    fork
      auto_task();
      auto_task();
    join
    $finish;
  end

endmodule

module automatic_task_with_id_demo;

  task automatic automatic_task(input int id);
    int local_data = 0;

    local_data = local_data + 1;
    #1;

    $display("AUTOMATIC | ID=%0d | local_data=%0d", id, local_data);
  endtask

  initial begin
    fork
      automatic_task(1);
      automatic_task(2);
    join
    $finish;
  end

endmodule

module automatic_vs_static_task_compare;

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

  task automatic auto_task();
    int auto_data;
    int auto_count;

    $display("======Automatic_task=======");

    for (auto_data = 0; auto_data < 5; auto_data++)
      $display("auto_count = %0d auto_data = %0d",
               auto_count, auto_data);

    auto_data = 5;
    auto_count = 5;

    for (auto_count = 0; auto_count < 5; auto_count++)
      $display("auto_count = %0d auto_data = %0d",
               auto_count, auto_data);
  endtask

  initial begin
    fork
      auto_task();
      auto_task();
    join

    fork
      normal_task();
      normal_task();
    join

    $finish;
  end

endmodule
