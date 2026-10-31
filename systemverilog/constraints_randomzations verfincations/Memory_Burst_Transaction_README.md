# SystemVerilog CRV: Memory Burst Transaction with Post-Randomization Error Injection

## 1. Project Overview

This example generates **16 memory-burst transactions per
randomization**. Each transaction has:

-   A starting address
-   A burst length
-   A beat size in bytes
-   A fault mode

The legal transaction fields are generated using SystemVerilog
**Constraint Random Verification (CRV)**. After the solver generates
legal values, the class uses `post_randomize()` to create a separate set
of **driven values** and inject one selected error.

The example demonstrates:

1.  Dynamic-array size constraints
2.  Range and set-membership constraints
3.  Address-alignment constraints
4.  Memory-boundary constraints
5.  Array-reduction constraints for required burst-length coverage
6.  Weighted `dist` selection of fault modes
7.  Post-randomization mutation
8.  Validation and error-distribution counting

> Important: the class-level checks in this example validate the
generated and injected stimulus. A complete DUT testbench must also
drive the injected fields into the DUT and check the DUT's response.

------------------------------------------------------------------------

## 2. Legal Transaction Requirements

The assumed memory address space is 4096 bytes, with valid byte
addresses from `0` through `4095`.

  Field          Legal requirement
  -------------- ------------------------------------------------
  `start_addr`   `0` through `4095`
  `burst_len`    `1`, `2`, `4`, `8`, or `16` beats
  `beat_size`    `1`, `2`, or `4` bytes per beat
  Alignment      `start_addr % beat_size == 0`
  Boundary       `start_addr + (burst_len * beat_size) <= 4096`

The total transfer size is:

``` systemverilog
total_data = burst_len * beat_size;
```

The exclusive end address is:

``` systemverilog
end_addr = start_addr + total_data;
```

The boundary expression uses an **exclusive end address**. Therefore, a
transfer ending exactly at `4096` is legal; its last accessed byte is
`4095`.

------------------------------------------------------------------------

## 3. Fault Modes

The enum selects which field is mutated after legal randomization:

  Fault enum          Injected value Why it is invalid
  --------------- ------------------ ------------------------------------
  `NO_ERROR`             No mutation Original legal values are retained
  `BAD_ADDRESS`       Address `4099` Outside the valid address range
  `BAD_BURST`       Burst length `7` Not in `{1,2,4,8,16}`
  `BAD_BEAT`           Beat size `3` Not in `{1,2,4}`

Only one field is changed for each selected fault mode. This makes the
injected condition easier to identify and debug.

The enum is declared as `logic [2:0]`. The four listed enum values
receive the encodings `0`, `1`, `2`, and `3` in declaration order.

------------------------------------------------------------------------

## 4. Constraint-by-Constraint Explanation

### 4.1 Dynamic array sizes

``` systemverilog
start_addr.size() == 16;
burst_len.size()  == 16;
beat_size.size()  == 16;
fault.size()      == 16;
```

These constraints tell the solver that each randomized dynamic array
must contain exactly 16 elements. The arrays are indexed from `0`
through `15`.

Because all transaction arrays have the same size, the same index refers
to the fields of one transaction. For example, `start_addr[5]`,
`burst_len[5]`, `beat_size[5]`, and `fault[5]` describe transaction 5.

The `invalid_*` arrays are not randomized. They are output/drive-side
arrays, so the constructor explicitly allocates them with 16 entries.

### 4.2 Address range

``` systemverilog
foreach (start_addr[i])
  start_addr[i] inside {[0:4095]};
```

`inside` checks whether a value belongs to a set or range. This
constraint restricts every generated starting address to the memory's
valid byte-address range.

### 4.3 Legal burst lengths

``` systemverilog
foreach (burst_len[i])
  burst_len[i] inside {1, 2, 4, 8, 16};
```

The burst length must be one of the permitted powers of two. The set
syntax is exact: values such as `3`, `7`, or `12` are not legal.

### 4.4 Legal beat sizes

``` systemverilog
foreach (beat_size[i])
  beat_size[i] inside {1, 2, 4};
```

The beat size is expressed in bytes. The solver may select a 1-byte,
2-byte, or 4-byte beat.

### 4.5 Address alignment

``` systemverilog
foreach (start_addr[i])
  start_addr[i] % beat_size[i] == 0;
```

The modulo operator `%` returns the remainder. A remainder of zero means
the address is aligned to the beat size:

-   1-byte beat: every address is aligned
-   2-byte beat: address must be even
-   4-byte beat: address must be divisible by four

Since `beat_size` is constrained to nonzero legal values, the modulo
expression is safe for the randomized baseline.

### 4.6 Memory boundary

``` systemverilog
foreach (start_addr[i])
  start_addr[i] + (burst_len[i] * beat_size[i]) <= 4096;
```

This ensures that the transfer does not extend past the memory's
exclusive end address.

For example:

-   `start_addr = 4080`, `burst_len = 4`, `beat_size = 4`
-   `total_data = 4 * 4 = 16`
-   `end_addr = 4080 + 16 = 4096`
-   This transfer is legal.

### 4.7 Required burst-length coverage using array reductions

``` systemverilog
burst_len.sum() with (int'(item == 1)) >= 1;
burst_len.sum() with (int'(item == 2 || item == 4)) >= 1;
burst_len.sum() with (int'(item == 8)) >= 1;
burst_len.sum() with (int'(item == 16)) >= 1;
```

The array reduction method `.sum()` adds the result of its `with`
expression over all elements.

The expression `item == 8` evaluates to a 1-bit Boolean value. Casting
it with `int'(...)` makes the reduction sum integer `1` for each
matching item and `0` otherwise. Therefore, the constraint means that at
least one matching item must exist.

These constraints guarantee: - At least one burst length of `1` - At
least one burst length of either `2` or `4` - At least one burst length
of `8` - At least one burst length of `16`

They do **not** separately require both `2` and `4`.

### 4.8 Weighted fault selection with `dist`

``` systemverilog
fault[i] dist {
  NO_ERROR    := 30,
  BAD_ADDRESS := 20,
  BAD_BURST   := 30,
  BAD_BEAT    := 20
};
```

`dist` assigns relative weights to values. The weights total 100, so the
intended approximate proportions are:

-   `NO_ERROR`: 30%
-   `BAD_ADDRESS`: 20%
-   `BAD_BURST`: 30%
-   `BAD_BEAT`: 20%

This is a probability preference, **not a guaranteed count**. A short
random run may not produce these exact proportions, and `dist` alone
does not guarantee every mode appears.

### 4.9 Why `post_randomize()` is used

The solver first satisfies the legal constraints. `post_randomize()`
then:

1.  Copies each legal field to its corresponding `invalid_*` drive
    field.
2.  Examines `fault[i]`.
3.  Mutates one selected field if a fault was requested.
4.  Calculates transfer size and end address for printing/checking.

The original randomized fields remain legal. The `invalid_*` fields
contain the values intended for the driver.

**Driver rule:** use `invalid_start_addr`, `invalid_burst_len`, and
`invalid_beat_size` as the driven values. Driving the original
randomized arrays would bypass the injected faults.

------------------------------------------------------------------------

## 5. Important Corrections Applied to the Supplied Code

The original snippet had a few issues that could make the print/check
output misleading or cause runtime problems:

1.  **Allocation of non-random dynamic arrays:** `invalid_*` arrays need
    allocation before assigning index values. The constructor now
    allocates each array to 16 entries.
2.  **Uninitialized calculation variables:** `total_data` and `end_addr`
    must be calculated inside the loop for each transaction before they
    are printed or checked.
3.  **Boundary check:** the normal transfer check must use
    `end_addr <= 4096`, where `end_addr = start_addr + total_data`.
    Checking only `total_data <= 4096` does not ensure that the transfer
    fits from its starting address.
4.  **Correct validation scope:** the original generated fields are
    checked as legal baseline values; the `invalid_*` fields are checked
    for the selected injected error.
5.  **No modulo with an illegal beat size:** alignment is checked only
    when the injected beat size is legal. An illegal beat size is itself
    the error condition.
6.  **Spelling and output labels:** display messages were clarified for
    readability.

------------------------------------------------------------------------

## 6. How to Read the Console Output

For each of the 16 array elements, the class prints two sections:

### Normal-case section

This displays the original randomized values:

-   Address
-   Burst length
-   Beat size
-   Total transfer size
-   Fault mode

These values should satisfy the legal constraints.

### Error-injection section

This displays the post-randomization `invalid_*` values. Depending on
the selected mode, one field may be invalid.

Examples:

-   `BAD_ADDRESS`: `invalid_start_addr` is `4099`
-   `BAD_BURST`: `invalid_burst_len` is `7`
-   `BAD_BEAT`: `invalid_beat_size` is `3`
-   `NO_ERROR`: all three values remain unchanged

A `Pass` message in this class means the testbench's stimulus check
found the intended property. It does not by itself mean that a DUT
detected or handled the error correctly.

------------------------------------------------------------------------

## 7. Testbench-Level Fault Counters

The module randomizes the same transaction object 10 times. Each
randomization produces 16 fault selections, so the total number of
counted fault selections is:

``` text
10 randomizations * 16 transactions = 160 selections
```

The counters are cumulative. They are not reset between `randomize()`
calls.

The final totals are stochastic because the fault modes use weighted
random selection. Do not expect exactly 30/20/30/20 percentages in every
run.

------------------------------------------------------------------------

## 8. Recommended Verification Extensions

To turn this stimulus generator into a full DUT verification test:

1.  Connect a driver to the `invalid_*` arrays.
2.  Send each transaction to the DUT.
3.  Monitor the DUT's response.
4.  Check that illegal address, burst, or beat-size cases receive the
    specified error response.
5.  Check that invalid transactions do not cause unintended memory
    writes.
6.  Add functional coverage for fault modes and boundary conditions.
7.  Use explicit sequencing or coverage-driven reruns if every fault
    type must occur.

------------------------------------------------------------------------

## 9. Files

-   `Memory_Burst_Transaction.sv` --- complete, commented SystemVerilog
    example.
-   This README --- detailed explanation of the constraints, fault
    injection, checks, and testbench flow.
