# Disable Fork

## Overview

`disable fork` is a SystemVerilog mechanism used to terminate all child threads spawned by the current process. It is especially useful when a testbench must stop background tasks after a timeout or when a sequence ends unexpectedly.

This is a key cleanup primitive in simulations, because background tasks can otherwise continue running and produce invalid state or hanging behavior.

## Why use `disable fork`?

It is helpful when:

- a timeout occurs and the process must stop waiting
- multiple parallel tasks are no longer needed
- testbench control needs to abort background work safely
- simulations must avoid lingering threads that keep the environment active

## Core concept

When a process has spawned children using `fork ... join_none`, those children may still be running in the background. `disable fork` terminates them immediately so the active process can transition to a clean exit or recovery path.

## Example structure

```systemverilog
module tb;
    initial begin
        fork
            begin
                #1000 $display("Long-running task completed");
            end
        join_none

        #200;
        disable fork;
        $display("All child processes stopped");
    end
endmodule
```

## What this example demonstrates

The file `../disable_fork.sv` shows:

- background thread creation
- timeout-based termination
- cleanup of active parallel processes
- prevention of runaway simulation threads

## Typical use cases

- timeouts in testbenches
- cancelling background monitors after test completion
- stopping redundant verification activities
- cleaning up parallel tasks before exit

## Design considerations

- Use `disable fork` with care; it terminates all active child threads created by the current process.
- It is especially important after `fork ... join_none`.
- If you only want to stop one thread, other mechanisms may be more precise.

## Related topics

- [Fork/Join Constructs](../fork_join_constructs/README.md)
- [UVM-Style Synchronization](../uvm_style_synchronization/README.md)
- [Event Synchronization](../event_synchronization/README.md)
