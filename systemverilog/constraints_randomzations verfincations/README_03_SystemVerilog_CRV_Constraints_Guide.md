# README — SystemVerilog Constraint Randomization (CRV): Concepts, Types, and Patterns

## 1. What is Constraint Randomization?

Constraint Randomization (CRV) is a SystemVerilog verification technique in which variables are declared `rand` or `randc`, and a constraint solver generates values satisfying the declared rules.

```systemverilog
class packet;
  rand bit [7:0] data;

  constraint data_range {
    data inside {[10:100]};
  }
endclass

module tb;
  packet p;
  initial begin
    p = new();
    if (!p.randomize())
      $fatal("Randomization failed");
    $display("data=%0d", p.data);
  end
endmodule
```

The solver searches for an assignment satisfying all active constraints. It does not promise a particular value unless the constraints determine it.

## 2. Random variable kinds

### `rand`

A `rand` variable is randomized on each successful `randomize()` call.

```systemverilog
rand bit [7:0] data;
```

### `randc`

A `randc` variable cycles through its representable or constrained value set without repeating until the cycle is exhausted, subject to simulator support and constraint interactions.

```systemverilog
randc bit [1:0] mode;
```

Use `randc` for cycle-like coverage of a small domain; use `rand` when repetitions are acceptable.

## 3. Constraint blocks

A constraint block is a declarative set of rules:

```systemverilog
constraint c_name {
  data inside {[0:15]};
}
```

Constraint blocks are not procedural code. The order in which constraints are written does not mean they execute one after another.

## 4. Common constraint types and patterns

### 4.1 Range constraint — `inside`

```systemverilog
constraint c_range {
  value inside {[1:10]};
}
```

A set can also be specified:

```systemverilog
constraint c_set {
  mode inside {NORMAL, BURST, IDLE, ERROR};
}
```

`inside` supports value lists and ranges. It is commonly used for legal protocol encodings, sizes, IDs, and operating modes.

### 4.2 Equality and inequality

```systemverilog
constraint c_equal {
  a == b;
  c != d;
}
```

Equality constraints relate variables. They can be used to enforce consistency between transaction fields.

### 4.3 Conditional constraints — `if/else`

```systemverilog
constraint c_mode {
  if (mode == BURST)
    period inside {[1:4]};
  else if (mode == NORMAL)
    period inside {[5:20]};
  else
    period == 1;
}
```

The condition is part of the declarative model. The `else` branch applies whenever the earlier condition is false. For enums, remember that it may include several modes.

### 4.4 Implication — `->`

```systemverilog
constraint c_priority {
  (priority inside {6,7}) -> (channel inside {0,1});
}
```

Logical implication means: if the left-hand condition is true, the right-hand condition must be true. If the left side is false, this implication places no requirement on the right side.

Equivalent conditional form:

```systemverilog
if (priority inside {6,7})
  channel inside {0,1};
```

### 4.5 `foreach`

`foreach` applies a rule to each array element:

```systemverilog
constraint c_each {
  foreach (data[i])
    data[i] inside {[0:255]};
}
```

For multidimensional arrays, each dimension can have an index:

```systemverilog
constraint c_matrix {
  foreach (matrix[i,j])
    matrix[i][j] inside {[0:15]};
}
```

Always ensure an index is valid for the array being accessed.

### 4.6 Array size constraints

Dynamic arrays can have their sizes constrained:

```systemverilog
constraint c_size {
  data.size() == 16;
}
```

The constructor may allocate arrays using `new[N]`; size constraints document and enforce the intended size during randomization.

### 4.7 `unique`

```systemverilog
constraint c_unique {
  unique {id};
}
```

All listed elements must have different values.

Cardinality rule: if there are `N` elements and only `M` legal distinct values, global uniqueness requires `N <= M`.

Examples:
- 4 elements, legal domain 0–3: possible.
- 16 elements, legal domain 0–3: impossible.
- 16 elements, legal domain 0–15: possible.

Uniqueness is a relation among elements, not a range restriction.

### 4.8 Array reduction methods: `sum`, `and`, `or`, `xor`

Reduction methods combine array elements into a result. A `with` clause can transform each element.

Count matching modes:

```systemverilog
constraint c_mode_count {
  mode.sum() with (int'(item == BURST)) >= 1;
}
```

The cast to `int` makes the Boolean comparison contribute as an integer 0 or 1.

Other common examples:

```systemverilog
constraint c_sum {
  data.sum() == 100;
}

constraint c_at_least_one {
  data.or() == 1; // useful for bit arrays, depending on element type
}
```

Check the element type and reduction result width when using arithmetic reductions. A narrow result can overflow if not cast or widened appropriately.

### 4.9 Soft constraints

A `soft` constraint is a default preference that can be overridden by stronger constraints.

```systemverilog
constraint c_default {
  soft burst_len == 4;
}
```

Soft constraints are useful for defaults that tests may override. They are not a guarantee that the preferred value will always be selected if other constraints conflict.

### 4.10 `solve ... before`

```systemverilog
constraint c_order {
  solve mode before period;
}
```

This influences the solve order and distribution behavior; it does not mean procedural execution. Use it when the distribution of dependent variables needs to be controlled. Do not add it automatically to every constraint.

### 4.11 `dist` distribution constraints

```systemverilog
constraint c_distribution {
  mode dist {
    NORMAL := 60,
    BURST  := 25,
    IDLE   := 10,
    ERROR  := 5
  };
}
```

`dist` expresses weighted distribution preferences. The weights are not a guarantee of exact counts in a finite number of randomizations. `:=` assigns a weight to each listed value; range-weight syntax can be used for ranges.

### 4.12 `foreach` plus relational uniqueness

A common pattern for pairwise-distinct values is `unique`. When special relationships are needed, index comparisons may be used:

```systemverilog
constraint c_pairwise {
  foreach (id[i])
    foreach (id[j])
      if (i < j)
        id[i] != id[j];
}
```

This expresses pairwise inequality. `unique {id}` is usually clearer for simple uniqueness.

### 4.13 `inside` with arrays and `foreach`

A constraint may relate a scalar or array element to a set. For example:

```systemverilog
constraint c_legal {
  foreach (priority[i])
    priority[i] inside {[0:7]};
}
```

Avoid confusing `inside` set membership with array membership; syntax and semantics depend on the expression on the left side.

## 5. Constraint modes

Constraint blocks can be enabled or disabled at runtime:

```systemverilog
obj.some_constraint.constraint_mode(0); // disable
obj.some_constraint.constraint_mode(1); // enable
```

This is useful for debugging or test-specific scenarios. Disabling a constraint changes the specification being generated. Restore it when the test is complete, and avoid disabling constraints just to hide a contradiction.

## 6. `pre_randomize()` and `post_randomize()`

- `pre_randomize()` runs before the solver randomizes the object.
- `post_randomize()` runs after successful randomization.

They are functions, so they do not consume simulation time. Use them for setup, derived non-random data, checks, and printing—not as a replacement for declarative relationships that should be solved.

Example:

```systemverilog
function void post_randomize();
  $display("mode=%s", mode.name());
endfunction
```

## 7. Inline constraints

A one-off constraint can be supplied at the call site:

```systemverilog
if (!obj.randomize() with {
  priority_level[0] == 7;
  mode[0] == ERROR;
})
  $fatal("Randomization failed");
```

Inline constraints are useful for targeted scenarios without permanently modifying the class constraint set.

## 8. `randcase` versus constraint `dist`

`randcase` is procedural weighted selection:

```systemverilog
randcase
  6: mode = NORMAL;
  3: mode = BURST;
  1: mode = ERROR;
endcase
```

It is not the same as a constraint block and does not ask the constraint solver to jointly solve all fields. Use `dist` when weighted choices should remain part of the constraint solution; use `randcase` for procedural branching.

## 9. Common CRV failure causes

1. Contradictory ranges, such as `x inside {[1:4]}` and `x inside {[8:10]}`.
2. `unique` with too many elements for the legal domain.
3. Incorrect array sizes or invalid indexes.
4. A mode condition accidentally constraining all other enum values through `else`.
5. Over-constraining the same variable from multiple blocks.
6. Unsuitable data widths or arithmetic overflow.
7. Assuming a random variable will take a specific value without constraining it.
8. Treating a weighted distribution as an exact frequency guarantee.
9. Using a reduction without considering its result type or cast.
10. Disabling a constraint without checking what behavior is then permitted.

## 10. Debugging workflow

1. Compile first; resolve syntax and type errors.
2. Call `randomize()` and check its return value.
3. Read the simulator's constraint conflict report.
4. Inspect sizes, domains, and indexes.
5. Temporarily disable one suspected block at a time to isolate the conflict.
6. Re-enable constraints and repair the specification.
7. Add post-randomize assertions/checks for important properties.
8. Run multiple seeds and review generated distributions and coverage.

## 11. Useful validation checks for the signal scheduler

For each generated sample, verify:

- Channel ID is in its allowed domain.
- Amplitude and frequency ranges are legal.
- NORMAL periods are 5–20.
- BURST periods are 1–4.
- High-priority records obey channel/clock restrictions.
- Amplitude/frequency cross-constraints hold.
- Required modes occur with the intended count.
- Uniqueness is applied only to arrays/domains where it is satisfiable.
- The printed fields use the intended mapping (direct index or modulo).

## 12. Interview summary

| Concept | Main purpose |
|---|---|
| `rand` | Generate a new value on each randomization |
| `randc` | Cycle through values without immediate repetition until exhausted |
| `inside` | Restrict a value to a set/range |
| `foreach` | Apply a rule to array elements |
| `unique` | Require distinct values |
| `->` | Conditional implication |
| `if/else` | Conditional constraints |
| `sum() with` | Reduce/count values using an expression |
| `soft` | Provide overridable defaults |
| `dist` | Weighted distribution preferences |
| `solve before` | Influence solve order/distribution |
| `constraint_mode()` | Enable/disable a named constraint block |
| Inline `with` | Add constraints for one randomize call |
| `pre_randomize()` | Pre-solver setup |
| `post_randomize()` | Post-solver processing/checks |
