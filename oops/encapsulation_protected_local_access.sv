// File: oops/encapsulation_protected_local_access.sv
// -----------------------------------------------------------------------------
// Topic: SystemVerilog OOP - Encapsulation using protected and local access
// -----------------------------------------------------------------------------
// This example demonstrates the following OOP concepts:
// 1) Encapsulation
// 2) Data hiding using protected and local members
// 3) Inheritance using `extends`
// 4) Controlled access through class methods
// -----------------------------------------------------------------------------

// `class parent;` defines the base class.
// It contains a `protected` member, which means it is visible to child classes,
// but cannot be accessed directly from outside the class hierarchy.
class parent;

  // `protected int status;` is a protected member.
  // It is inherited by child classes but hidden from the testbench.
  protected int status;

endclass

// `class child extends parent;` creates a derived class.
// The child class inherits the `status` variable from the parent class.
class child extends parent;

  // `local int retry_count;` is a local member.
  // It can only be used inside the `child` class and cannot be accessed externally.
  local int retry_count;

  // `function void set_status(int status);` updates the protected `status` variable.
  // `this.status` refers to the class property, while the argument `status`
  // is the value passed into the function.
  function void set_status(int status);

    // `this.status = status;` copies the incoming value into the inherited variable.
    this.status = status;

    // `$display` prints the current status value.
    $display("Status = %0b", status);

  endfunction

  // `function void set_retry_count();` decides whether retry logic is enabled.
  // It updates the local `retry_count` based on the inherited status value.
  function void set_retry_count();

    // `if(status == 1)` checks whether the feature is enabled.
    if(status == 1)
      // If enabled, retry count is set to 1.
      retry_count = 1'b1;
    else
      // If disabled, retry count is set to 0.
      retry_count = 1'b0;

  endfunction

  // `function void get_retry_count();` displays the retry outcome.
  // This method controls access to the private-like internal state.
  function void get_retry_count();

    // `if(retry_count == 1)` checks whether retry should be active.
    if(retry_count == 1)
      // If active, print the status and retry count.
      $display("Status = %0b Count = %0b",
               retry_count,status);
    else
      // If inactive, print the disabled message.
      $display("COUNT IS NOT RESTARTED");

  endfunction

endclass

// `module tb;` is the testbench module.
module tb;

  // `parent p;` declares a parent object handle.
  parent p;

  // `child c;` declares a child object handle.
  child c;

  // `initial begin` starts simulation-time behavior.
  initial begin

    // `p = new();` creates a parent object.
    p = new();

    // `c = new();` creates a child object.
    c = new();

    // `c.set_status(1);` enables the status flag.
    c.set_status(1);

    // `c.set_retry_count();` calculates retry_count based on status.
    c.set_retry_count();

    // `c.get_retry_count();` displays the retry status.
    c.get_retry_count();

    // `c.set_status(0);` disables the status flag.
    c.set_status(0);

    // Update retry count using the new status value.
    c.set_retry_count();

    // Display the retry result for the disabled case.
    c.get_retry_count();

    // Set the status back to active for the final check.
    c.set_status(1);

    // Recalculate retry_count for the final run.
    c.set_retry_count();

    // Display the final retry result.
    c.get_retry_count();

  end

endmodule

// -----------------------------------------------------------------------------
// Summary:
// - `protected` allows access in the parent and child hierarchy.
// - `local` hides the variable completely from outside the child class.
// - Methods provide controlled access to internal data.
// - This is a clean example of encapsulation and inheritance in SystemVerilog.
// -----------------------------------------------------------------------------
