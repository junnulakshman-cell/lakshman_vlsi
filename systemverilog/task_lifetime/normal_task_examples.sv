module normal_task_static_demo;

  // A task is automatic by default in SystemVerilog.
  // This means each invocation of normal_task() gets its own copy of
  // normal_count and normal_data, so concurrent calls do not share state.
  // In other words, the two forked tasks run independently and keep separate
  // local variable values.
  task normal_task();
    int normal_count;
    int normal_data;

    normal_count = 5;
    $display("=======Normal_task========");

    // normal_data is uninitialized at this point, so it will display 'x'
    // for the first loop. Each task call has its own local storage.
    for (normal_count = 0; normal_count < 5; normal_count++)
      $display("normal_count = %0d data = %0d",
               normal_count, normal_data);

    normal_data = 5;

    // The second loop uses the same task-local variable value, but this is
    // only within the current invocation; no shared value is carried across
    // different forked calls.
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

  // This module is named to emphasize the concept of a static task.
  // If the task were declared as 'static task static_task();', the local
  // variables would retain their values across invocations instead of being
  // recreated for every call. This is a key lifetime concept in SystemVerilog.
  //
  // Note: In this example, the task is still a normal task because it is not
  // explicitly declared static. The comments explain the intended behavior
  // that a static task would demonstrate.
  task static_task();
    int data;
    int count;

    $display("======Static_task=======");

    // The loop uses the current values of data and count. If the task were
    // static, these variables would keep their previous values between calls.
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
