# UVM-Style Synchronization

## Overview

The UVM-style synchronization pattern is commonly used in verification environments where a monitor waits for a specific event or signal, and a timeout is applied to detect failure or missing completion. This pattern is often used in advanced testbenches and is a natural extension of the event-based synchronization concepts already discussed.

## Why this pattern matters

In real verification flows, you usually want to know:

- did the expected signal occur?
- did it occur within a valid time window?
- if not, what should the testbench do?

This pattern models exactly that: wait for completion, but also handle the case where it never arrives.

## Core idea

A task starts in parallel with a timeout process:

- the monitor waits for a valid completion signal
- the timeout thread waits for a maximum allowed duration
- whichever occurs first determines the next action

## Example structure

```systemverilog
module tb;
    event done;

    initial begin
        fork
            begin
                @done;
                $display("Transaction completed successfully");
            end
            begin
                #1000;
                $display("Timeout: transaction did not complete");
            end
        join_any
    end
endmodule
```

## What this example demonstrates

The file `../uvm_style_synchronization.sv` shows:

- monitor/timeout parallel wait logic
- asynchronous completion checking
- handling of missing signal events
- a common pattern in UVM-style verification

## Typical use cases

- waiting for packet completion
- monitoring a handshake signal
- timeout detection in assertions or stimulus flow
- aborting deadlocked verification processes

## Design considerations

This pattern is extremely valuable because it makes the testbench robust. Without a timeout, a missing trigger could stall the entire simulation indefinitely. With a timeout, the simulation can report an error and continue or abort cleanly.

## Related topics

- [Event Synchronization](../event_synchronization/README.md)
- [Fork/Join Constructs](../fork_join_constructs/README.md)
- [Disable Fork](../disable_fork/README.md)
