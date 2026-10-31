# SystemVerilog CRV: Three Error-Injection Methods

This README compares three ways to generate valid and invalid stimulus
using SystemVerilog Constraint Random Verification (CRV).

The examples use a memory-burst transaction with these legal values:

-   **Start address:** `0` to `4095`
-   **Burst length:** `{1, 2, 4, 8, 16}`
-   **Beat size:** `{1, 2, 4}` bytes
-   **Alignment:** `start_addr % beat_size == 0`
-   **Boundary:** `start_addr + (burst_len * beat_size) <= 4096`

The goal is to generate normal traffic and deliberately inject illegal
values so that the DUT's error handling can be verified.

------------------------------------------------------------------------

## Method 1 --- Separate Valid and Invalid Random Variables

### Idea

Create separate randomized variables for legal transactions and
invalid/error transactions. Constraints keep the legal variables valid,
while the invalid variables are randomized from explicitly illegal sets
or ranges.

### Example

``` systemverilog
class burst_txn_method1;
  rand int unsigned addr;
  rand int unsigned burst_len;
  rand int unsigned beat_size;

  rand int unsigned bad_addr;
  rand int unsigned bad_burst_len;
  rand int unsigned bad_beat_size;

  constraint legal_c {
    addr      inside {[0:4095]};
    burst_len inside {1, 2, 4, 8, 16};
    beat_size inside {1, 2, 4};

    addr % beat_size == 0;
    addr + (burst_len * beat_size) <= 4096;
  }

  constraint illegal_c {
    bad_addr      inside {[4096:5000]};
    bad_burst_len inside {3, 5, 6, 7, 9, 10, 15};
    bad_beat_size inside {3, 5, 6};
  }
endclass
```

> Note: This example randomizes legal and invalid values in the same
> transaction. In a practical testbench, select which group to drive
> using a scenario or error-mode field.

### Advantages

-   Easy to understand and debug.
-   Legal and illegal stimulus are explicitly separated.
-   Useful when the test needs to exercise specific invalid values.

### Disadvantages

-   More random variables and constraints are required.
-   The invalid variables may be randomized even when the test intends
    to send normal traffic, unless controlled by a mode.
-   Maintaining separate legal/invalid sets can become cumbersome as the
    protocol grows.

### Best suited for

Small tests, directed error scenarios, and cases where the legal and
illegal values need independent control.

------------------------------------------------------------------------

## Method 2 --- Combined Valid/Invalid Randomization with a Mode

### Idea

Use one set of transaction fields and a randomized mode to choose
whether the generated transaction is legal or intentionally illegal.
Constraints are conditional on the mode.

This approach avoids maintaining two separate sets of data fields.

### Example

``` systemverilog
typedef enum bit [1:0] {
  NORMAL,
  BAD_ADDRESS,
  BAD_BURST,
  BAD_BEAT
} error_mode_t;

class burst_txn_method2;
  rand int unsigned addr;
  rand int unsigned burst_len;
  rand int unsigned beat_size;
  rand error_mode_t mode;

  constraint mode_weight_c {
    mode dist {
      NORMAL      := 60,
      BAD_ADDRESS := 15,
      BAD_BURST   := 15,
      BAD_BEAT    := 10
    };
  }

  constraint normal_values_c {
    if (mode == NORMAL) {
      addr      inside {[0:4095]};
      burst_len inside {1, 2, 4, 8, 16};
      beat_size inside {1, 2, 4};

      addr % beat_size == 0;
      addr + (burst_len * beat_size) <= 4096;
    }
  }

  constraint injected_values_c {
    if (mode == BAD_ADDRESS)
      addr inside {[4096:5000]};

    if (mode == BAD_BURST)
      burst_len inside {3, 5, 6, 7, 9, 10, 15};

    if (mode == BAD_BEAT)
      beat_size inside {3, 5, 6};
  }
endclass
```

### Advantages

-   One transaction object and one set of fields.
-   The mode clearly identifies the intended scenario.
-   Weighted mode selection can balance normal and error traffic.
-   Convenient for constrained-random regression.

### Disadvantages

-   Conditional constraints can become complicated.
-   Constraints must be carefully written so that one mode does not
    conflict with another.
-   `dist` controls probability; it does **not** guarantee that every
    mode appears in a finite run.

### Best suited for

Protocol-level constrained-random testing where legal and invalid
traffic should be mixed according to a scenario distribution.

------------------------------------------------------------------------

## Method 3 --- Generate Legal Stimulus, Then Inject an Error in `post_randomize()`

### Idea

First randomize a completely legal transaction. Then, in
`post_randomize()`, copy the legal values into driven fields and mutate
one selected field to create an error.

This separates **legal stimulus generation** from **error injection**.

### Example

``` systemverilog
typedef enum bit [1:0] {
  NO_ERROR,
  BAD_ADDRESS,
  BAD_BURST,
  BAD_BEAT
} fault_mode_t;

class burst_txn_method3;
  // Randomized legal transaction
  rand int unsigned start_addr;
  rand int unsigned burst_len;
  rand int unsigned beat_size;
  rand fault_mode_t fault;

  // Values that will be driven to the DUT
  int unsigned drive_addr;
  int unsigned drive_burst_len;
  int unsigned drive_beat_size;

  constraint legal_addr_c {
    start_addr inside {[0:4095]};
    start_addr % beat_size == 0;
  }

  constraint legal_burst_c {
    burst_len inside {1, 2, 4, 8, 16};
  }

  constraint legal_beat_c {
    beat_size inside {1, 2, 4};
  }

  constraint boundary_c {
    start_addr + (burst_len * beat_size) <= 4096;
  }

  constraint fault_weight_c {
    fault dist {
      NO_ERROR    := 60,
      BAD_ADDRESS := 15,
      BAD_BURST   := 15,
      BAD_BEAT    := 10
    };
  }

  function void post_randomize();
    // Start with a valid transaction.
    drive_addr      = start_addr;
    drive_burst_len = burst_len;
    drive_beat_size = beat_size;

    // Mutate one field according to the selected fault.
    case (fault)
      BAD_ADDRESS: drive_addr      = 4099;
      BAD_BURST:   drive_burst_len = 7;
      BAD_BEAT:    drive_beat_size = 3;
      NO_ERROR:    ;
    endcase
  endfunction
endclass
```

### Step-by-step flow

1.  The solver randomizes `start_addr`, `burst_len`, and `beat_size`
    under legal constraints.
2.  The solver selects a `fault` mode.
3.  `post_randomize()` copies the legal fields into the `drive_*`
    fields.
4.  The selected fault changes one driven field:
    -   `BAD_ADDRESS`: address becomes `4099`.
    -   `BAD_BURST`: burst length becomes `7`.
    -   `BAD_BEAT`: beat size becomes `3`.
5.  The driver sends the `drive_*` fields to the DUT.
6.  The monitor/checker verifies that the DUT responds as expected.

### Advantages

-   The solver only needs to solve the legal transaction constraints.
-   The intended fault is explicit and easy to inspect.
-   Good separation between valid stimulus generation and fault
    mutation.
-   Useful for testing error handling without making the main constraint
    set overly complex.

### Disadvantages

-   The mutated fields are not solver-constrained; the
    post-randomization code must guarantee the intended illegal value.
-   The testbench must drive `drive_*`, not the original legal fields.
-   A mutation may accidentally violate multiple rules unless the fault
    is designed carefully.
-   `post_randomize()` does not itself prove that the DUT detected the
    error.

### Best suited for

Fault injection, corner-case testing, and verification environments that
need a valid baseline transaction followed by a controlled mutation.

------------------------------------------------------------------------

## Comparison

  --------------------------------------------------------------------------
  Feature           Method 1:         Method 2: Mode-based Method 3:
                    Separate fields   constraints          Post-randomize
                                                           mutation
  ----------------- ----------------- -------------------- -----------------
  Main idea         Keep legal and    Use one set of       Generate legal
                    invalid fields    fields with          values, then
                    separately        conditional          mutate
                                      constraints          

  Constraint        Moderate          Can become high      Usually lower for
  complexity                                               the legal
                                                           transaction

  Separate legal    Yes               Depends on mode      Yes
  baseline                                                 

  Error selection   Separate invalid  Randomized mode      Randomized fault
                    variables /                            mode
                    scenario                               

  Main risk         Extra fields and  Constraint conflicts Incorrect
                    duplicated rules                       mutation or
                                                           driving the wrong
                                                           fields

  Best use          Directed          Mixed                Controlled fault
                    invalid-value     constrained-random   injection
                    testing           traffic              
  --------------------------------------------------------------------------

## Which Method Should You Choose?

-   **For simple directed tests:** Method 1 is straightforward.
-   **For mixed legal/illegal constrained-random traffic:** Method 2 is
    convenient.
-   **For corner cases and controlled error injection:** Method 3 is
    often the cleanest approach, especially when you want the solver to
    generate a legal baseline and then inject exactly one fault.

There is no universally best method. The choice depends on whether the
test needs separate invalid fields, solver-controlled conditional
traffic, or a legal transaction that is deliberately mutated.

## Important Verification Notes

### 1. Weighted randomization is not coverage

A constraint such as:

``` systemverilog
fault dist {
  NO_ERROR    := 60,
  BAD_ADDRESS := 15,
  BAD_BURST   := 15,
  BAD_BEAT    := 10
};
```

sets relative weights. It does not guarantee that each mode will appear
in a small number of randomizations. Use counters, coverage, or explicit
scenario sequencing when guaranteed occurrence is required.

### 2. Check the DUT response

Generating an illegal transaction only proves that the testbench
injected an error. A complete test should also check the DUT's response,
such as:

-   error response or status,
-   rejection of the transaction,
-   no unintended memory update,
-   recovery or return to a valid state.

### 3. Prefer one fault at a time for isolation

When debugging, inject one error type per transaction. Multiple
simultaneous errors can make it unclear which condition caused the DUT
response. Add multi-fault scenarios after individual error handling is
verified.

### 4. Keep generated and driven values distinct in Method 3

In Method 3, `start_addr`, `burst_len`, and `beat_size` are the legal
baseline. The driver should use `drive_addr`, `drive_burst_len`, and
`drive_beat_size`, which contain the post-randomization mutation.

------------------------------------------------------------------------

## Suggested Regression Plan

1.  Run normal traffic and confirm the DUT accepts valid transactions.
2.  Inject bad addresses and check the address error response.
3.  Inject illegal burst lengths and check the burst error response.
4.  Inject illegal beat sizes and check the beat error response.
5.  Track how many times each fault mode occurs.
6.  Add boundary-focused legal cases, such as transfers ending exactly
    at address `4096`.
7.  Add mixed and multi-fault tests only after the individual error
    cases pass.
