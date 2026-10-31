# README — Multi-Channel Signal Scheduler (4 Channels, 16 Samples)

## 1. Overview

This version models **four physical channels** and **sixteen signal samples/configuration records**. Channel-level attributes are stored in four-entry arrays, while sample-level attributes are stored in sixteen-entry arrays.

This is a useful model when multiple samples are scheduled through a smaller set of physical channels.

> Important: Keep the channel-level and sample-level array sizes distinct. Do not apply `unique` to a 16-element array whose legal domain contains only four values.

## 2. Data model

| Variable | Suggested size | Meaning |
|---|---:|---|
| `channel_id` | 4 | Physical channel identifiers |
| `mode` | 4 | Mode assigned to each physical channel |
| `phase` | 4 | Phase assigned to each physical channel |
| `clock_domain` | 4 | Clock domain for each physical channel |
| `amplitude` | 16 | Sample amplitudes |
| `sample_period` | 16 | Sample periods |
| `frequency_mhz` | 16 | Sample frequencies |
| `priority_level` | 16 | Priority for each sample |
| `sample_count` | 16 | Sample count/length values |

A sample maps to a channel using `sample_index % 4`. For sample index 0, the mapped channel is 0; index 4 maps to channel 0 again; index 15 maps to channel 3.

## 3. Enum definition

```systemverilog
typedef enum bit [1:0] {
  NORMAL = 0,
  BURST  = 1,
  IDLE   = 2,
  ERROR  = 3
} signal_mode_e;
```

The enum gives meaningful names to the two-bit mode encoding. `mode[i] == BURST` is clearer than comparing against the literal `1`.

## 4. Main constraint concepts

### Array sizes

Use fixed dynamic-array sizes in the constructor and constrain the sizes consistently. Four-entry arrays are channel-level; sixteen-entry arrays are sample-level.

### Value ranges

Examples of range constraints:

```systemverilog
channel_id[i] inside {[0:3]};
amplitude[i] inside {[0:255]};
sample_period[i] inside {[1:20]};
phase[i] inside {0, 90, 180, 270};
frequency_mhz[i] inside {[1:100]};
priority_level[i] inside {[0:7]};
clock_domain[i] inside {[0:3]};
sample_count[i] inside {[1:16]};
```

The declared type also limits values. For example, `bit [7:0] amplitude` is an unsigned 8-bit value, so its representable range is already 0 through 255.

### Unique channel IDs

```systemverilog
constraint unique_channel_id {
  unique {channel_id};
}
```

This is satisfiable for four channel IDs selected from `{0,1,2,3}`. It requires all four IDs to be different, so they will form a permutation of 0, 1, 2, 3.

Do **not** use this constraint on sixteen channel IDs when each is restricted to only four values. That is unsatisfiable.

### Mode presence

To require at least one channel in each mode:

```systemverilog
constraint mode_presence {
  mode.sum() with (int'(item == BURST)) >= 1;
  mode.sum() with (int'(item == IDLE))  >= 1;
}
```

For exactly one of a mode, use `== 1`. These reductions count matching elements. Avoid writing the same reduction inside a `foreach` loop: the loop does not add useful meaning.

### Sample-to-channel mapping

```systemverilog
constraint sample_period_by_mode {
  foreach (sample_period[i]) {
    if (mode[i % 4] == BURST)
      sample_period[i] inside {[1:4]};
    else if (mode[i % 4] == NORMAL)
      sample_period[i] inside {[5:20]};
  }
}
```

This is intentional modulo mapping: sample arrays have sixteen entries, while the channel mode array has four.

### Amplitude by mode

```systemverilog
constraint amplitude_by_mode {
  foreach (amplitude[i]) {
    if (mode[i % 4] == NORMAL)
      amplitude[i] == 0;
    else
      amplitude[i] inside {[1:225]};
  }
}
```

This defines the amplitude behavior for NORMAL versus every other mode. If IDLE must also have zero amplitude, or ERROR needs a special range, add explicit `else if` branches. An `else` applies to every mode not matched by the `if`.

### Priority restrictions

```systemverilog
constraint priority_channel {
  foreach (priority_level[i]) {
    if (priority_level[i] inside {6,7})
      channel_id[i % 4] inside {0,1};
  }
}

constraint priority_clock {
  foreach (priority_level[i]) {
    if (priority_level[i] inside {6,7})
      clock_domain[i % 4] inside {0,1};
  }
}
```

These are implications in conditional form: only high-priority samples impose the restriction. Because channel-level attributes are mapped by `% 4`, multiple samples can refer to the same physical channel.

### Frequency and amplitude dependency

```systemverilog
constraint frequency_amplitude_rules {
  foreach (frequency_mhz[i]) {
    if (amplitude[i] > 200)
      frequency_mhz[i] <= 50;

    if (frequency_mhz[i] > 80)
      amplitude[i] <= 100;
  }
}
```

These conditions are compatible: high amplitude restricts frequency, and high frequency restricts amplitude. They do not require a particular frequency or amplitude unless another constraint does.

### Error mode

```systemverilog
constraint error_channel_rule {
  foreach (mode[i]) {
    if (mode[i] == ERROR)
      channel_id[i % 4] inside {0,1};
  }
}
```

The modulo is used because `mode` is channel-level and `channel_id` has four entries. If both arrays are four entries, direct `i` is also correct.

## 5. Constraints that are commonly impossible

A `unique` constraint requires every listed element to differ.

- `unique {channel_id}` on 4 entries with domain 0–3: possible.
- `unique {clock_domain}` on 4 entries with domain 0–3: possible.
- `unique {phase}` on 4 entries with legal values `{0,90,180,270}`: possible.
- Any of those `unique` constraints on 16 entries with only four legal values: impossible.

For this design, uniqueness is appropriate only for the four channel-level arrays, not for the sixteen sample-level arrays.

## 6. Constructor and post-randomize

The constructor allocates each dynamic array. The `c_sizes` constraint can additionally enforce the intended lengths.

`post_randomize()` is called after a successful `randomize()`. It should display the generated values and can perform non-random checks, but it should not be used as a substitute for constraints.

For a clear display, show sample attributes at index `i` and channel attributes at index `i % 4`:

```systemverilog
$display("%0d %0d %0d %0d %0d %s %0d %0d",
  channel_id[i % 4], amplitude[i], frequency_mhz[i],
  phase[i % 4], sample_period[i], mode[i % 4].name(),
  priority_level[i], clock_domain[i % 4]);
```

## 7. Testbench usage

```systemverilog
initial begin
  ms = new();

  repeat (10) begin
    if (!ms.randomize())
      $fatal(1, "Randomization failed");
  end
end
```

Do not disable constraints merely to get a passing randomization result without understanding why they conflict. First identify the unsatisfiable requirement, then revise the model or the requirement.

## 8. Debug checklist

1. Confirm array sizes in the constructor and `c_sizes`.
2. Check that every `foreach` index is valid for the array being accessed.
3. Use `% 4` only for sample-to-channel mapping.
4. Verify `unique` domain cardinality.
5. Check whether a mode rule is `at least one`, `exactly one`, or unrestricted.
6. Review `if/else`: `else` covers every unmatched enum value.
7. On failure, temporarily disable one constraint block at a time to isolate the conflict, then restore and fix the root cause.
8. Inspect simulator diagnostics; do not treat successful compilation as proof that randomization succeeds.
