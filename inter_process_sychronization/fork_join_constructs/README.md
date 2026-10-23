# Fork/Join Constructs

## Overview

The `fork...join` family in SystemVerilog allows one process to spawn multiple concurrent child processes. This is one of the most important features for parallelism in a testbench.

SystemVerilog provides several variants:

- `fork ... join` — wait for all child processes to finish
- `fork ... join_any` — wait for any child process to finish
- `fork ... join_none` — continue immediately without waiting

## Why use fork/join?

Fork/join is useful when:

- multiple independent tasks should execute in parallel
- a monitor and timeout checker run simultaneously
- a testbench wants to generate traffic while waiting for completion
- a process must trigger several actions at once

## Syntax overview

### `fork ... join`

```systemverilog
fork
    begin
        #10 $display("Thread 1");
    end
    begin
        #5  $display("Thread 2");
    end
join
```

This waits for both threads to complete before continuing.

### `fork ... join_any`

```systemverilog
fork
    begin
        #10 $display("Thread 1 complete");
    end
    begin
        #5  $display("Thread 2 complete");
    end
join_any
```

This continues when the first thread finishes.

### `fork ... join_none`

```systemverilog
fork
    begin
        #50 $display("Background task complete");
    end
join_none

$display("Main process continues immediately");
```

This allows the parent process to continue without waiting.

## What this example demonstrates

The file `../fork_join_constructs.sv` shows:

- process spawning
- waiting semantics differences
- concurrency patterns used in verification scenarios
- how parallel tasks can model real-time hardware behavior

## Typical use cases

- operating monitor and driver tasks simultaneously
- checking for timeout or completion in parallel
- generating stimulus while waiting for a response

## Design considerations

- `join_none` is useful for background tasks, but you must manage their lifecycle.
- `disable fork` is often used with `join_none` to terminate spawned tasks safely.
- Use parallelism carefully to avoid race conditions or unintended interleavings.

## Related topics

- [Disable Fork](../disable_fork/README.md)
- [Event Synchronization](../event_synchronization/README.md)
- [UVM-Style Synchronization](../uvm_style_synchronization/README.md)
