module normal_task_static_demo;

  task normal_task(input int id);
    int local_data = 0;

    local_data = local_data + 1;
    #1;

    $display("NORMAL | ID=%0d | local_data=%0d", id, local_data);
  endtask

  initial begin
    fork
      normal_task(1);
      normal_task(2);
    join
    $finish;
  end

endmodule

module automatic_task_demo;

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

module task_lifetime_compare;

  task normal_task();
    int count;
    int data;

    count = 0;
    data = 0;

    for (count = 0; count < 3; count++) begin
      $display("NORMAL | count=%0d data=%0d", count, data);
    end

    data = 5;

    for (data = 0; data < 3; data++) begin
      $display("NORMAL | count=%0d data=%0d", count, data);
    end
  endtask

  task automatic auto_task();
    int count;
    int data;

    count = 0;
    data = 0;

    for (count = 0; count < 3; count++) begin
      $display("AUTO | count=%0d data=%0d", count, data);
    end

    data = 5;

    for (data = 0; data < 3; data++) begin
      $display("AUTO | count=%0d data=%0d", count, data);
    end
  endtask

  initial begin
    fork
      normal_task();
      normal_task();
      auto_task();
      auto_task();
    join
    $finish;
  end

endmodule
