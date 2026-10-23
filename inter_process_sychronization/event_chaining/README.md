# Event Chaining

## Overview

Event chaining is a pattern where one event triggers a second event, which then causes another process to continue. This creates a sequence of dependent operations and is useful when a task must wait for several stages to complete in order.

This pattern is commonly used to model pipeline stages, sequential operations, or dependency-based task scheduling.

## Why use event chaining?

When one process finishes a step and another process must only proceed after that step is complete, events can be chained to create a clean dependency chain.

This is useful for:

- multi-stage processing
- pipeline modeling
- sequencing of monitors and checkers
- controlled wake-up of dependent tasks

## Key idea

Instead of directly executing the next stage, the earlier stage triggers an event. The next stage waits on that event before moving forward.

## Example structure

```systemverilog
module tb;
    event e1, e2;

    initial begin
        #10 -> e1;
    end

    initial begin
        @e1;
        $display("Stage 1 complete");
        #10 -> e2;
    end

    initial begin
        @e2;
        $display("Stage 2 complete");
    end
endmodule
```

## What this demonstrates

The file `../event_chaining.sv` shows:

- multiple event objects
- sequential dependence between tasks
- trigger/wait ordering for staged execution
- simple pipeline-like behavior without shared state

## Typical use cases

- feeding a scoreboard after a monitor captures data
- sequencing testbench operations in ordered phases
- enabling the next stage after completion of the previous one

## Design considerations

- Event chaining works well for simple dependency chains.
- If the dependency structure becomes complex, a semaphore, mailbox, or structured state machine may be cleaner.
- It is best for signaling, not for data transfer or resource locking.

## Related topics

- [Event Synchronization](../event_synchronization/README.md)
- [Fork/Join Constructs](../fork_join_constructs/README.md)
- [Semaphore Synchronization](../semaphore_synchronization/README.md)
