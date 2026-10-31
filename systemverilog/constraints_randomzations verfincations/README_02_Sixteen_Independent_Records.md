# README — Multi-Channel Signal Scheduler (16 Independent Signal Records)

## 1. Overview

This version models **sixteen independent signal records**. Every array has sixteen entries, so each record's attributes are indexed directly with `i`.

This differs from the four-channel/16-sample architecture: there is no automatic grouping of records into four physical channels unless the design explicitly adds such a mapping.

## 2. Data model

All arrays have size 16:

- `channel_id`: channel identifier for each record
- `amplitude`: amplitude
- `sample_period`: period
- `phase`: phase
- `frequency_mhz`: frequency
- `mode`: mode enum
- `priority_level`: priority
- `clock_domain`: clock domain
- `sample_count`: count

If `channel_id` is constrained to `{0,1,2,3}`, repeated IDs are expected because sixteen records are being assigned to four possible channel identifiers.

## 3. Correct range and uniqueness design

### Option A — Four channel IDs may repeat

```systemverilog
constraint channel_range {
  foreach (channel_id[i])
    channel_id[i] inside {[0:3]};
}
```

Do not add `unique {channel_id}`. With sixteen elements and only four legal values, that would be impossible.

### Option B — Sixteen distinct channel IDs

If the intent is genuinely to have sixteen unique channel IDs:

```systemverilog
constraint channel_range {
  foreach (channel_id[i])
    channel_id[i] inside {[0:15]};
}

constraint unique_channel_id {
  unique {channel_id};
}
```

This is satisfiable: there are sixteen array elements and sixteen legal distinct values. Since the array has sixteen elements, a solution will use each value from 0 through 15 exactly once.

## 4. Correct direct-index constraints

Because all arrays have sixteen entries, use direct indexing:

```systemverilog
constraint burst_period {
  foreach (sample_period[i]) {
    if (mode[i] == BURST)
      sample_period[i] inside {[1:4]};
  }
}

constraint normal_period {
  foreach (sample_period[i]) {
    if (mode[i] == NORMAL)
      sample_period[i] inside {[5:20]};
  }
}

constraint amplitude_by_mode {
  foreach (amplitude[i]) {
    if (mode[i] == NORMAL)
      amplitude[i] == 0;
    else
      amplitude[i] inside {[1:225]};
  }
}

constraint error_mode {
  foreach (mode[i]) {
    if (mode[i] == ERROR)
      channel_id[i] inside {0,1};
  }
}
```

Using `mode[i % 4]` in this design would make records 4–15 depend on modes 0–3 repeatedly. That is only correct if a four-channel mapping is intentional.

## 5. Mode counts

To require at least one BURST and at least one IDLE entry:

```systemverilog
constraint mode_counts {
  mode.sum() with (int'(item == BURST)) >= 1;
  mode.sum() with (int'(item == IDLE))  >= 1;
}
```

To require exactly one of each:

```systemverilog
constraint mode_counts {
  mode.sum() with (int'(item == BURST)) == 1;
  mode.sum() with (int'(item == IDLE))  == 1;
}
```

The two versions express different specifications. Pick the one that matches the scheduler requirements.

## 6. Priority, frequency, and clock rules

```systemverilog
constraint priority_channel {
  foreach (priority_level[i]) {
    if (priority_level[i] inside {6,7})
      channel_id[i] inside {0,1};
  }
}

constraint priority_clock {
  foreach (priority_level[i]) {
    if (priority_level[i] inside {6,7})
      clock_domain[i] inside {0,1};
  }
}

constraint frequency_amplitude {
  foreach (frequency_mhz[i]) {
    if (amplitude[i] > 200)
      frequency_mhz[i] <= 50;

    if (frequency_mhz[i] > 80)
      amplitude[i] <= 100;
  }
}
```

These use corresponding entries because each array is record-aligned.

## 7. Why global uniqueness fails for some fields

Your original legal ranges include only four values for `clock_domain` and four legal values for `phase`.

```systemverilog
clock_domain[i] inside {0,1,2,3};
phase[i] inside {0,90,180,270};
```

For sixteen entries, this cannot satisfy:

```systemverilog
unique {clock_domain};
unique {phase};
```

The number of required distinct values (16) is larger than the number of available values (4).

Options:

- Remove global uniqueness if repetitions are valid.
- Increase the legal domain if the specification supports it.
- Apply uniqueness only to a selected subset or group, if that is what the design needs.

## 8. Output display

Use the same index for every independent record:

```systemverilog
foreach (amplitude[i]) begin
  $display("%0d %0d %0d %0d %0d %s %0d %0d",
    channel_id[i], amplitude[i], frequency_mhz[i],
    phase[i], sample_period[i], mode[i].name(),
    priority_level[i], clock_domain[i]);
end
```

This produces sixteen independent rows without repeating the first four entries.

## 9. Debug checklist

- Verify all nine arrays are allocated to 16.
- Confirm every array constraint loops over the matching array.
- Replace `%4` with direct indexing unless grouping is intentional.
- Keep `unique` only when the legal value domain has enough distinct values.
- Check mode-count intent (`>= 1` versus `== 1`).
- Check whether ERROR, IDLE, and NORMAL amplitude rules are mutually consistent.
- Run randomization repeatedly and inspect each generated record.
