# Shared Bus Arbitration

## Overview

A shared bus is a common design challenge in hardware verification and digital systems. Several masters or agents may request access to the same bus, but only one can use it at a time. You need a mechanism that grants ownership fairly and safely.

This example modelsbus arbitration using a `semaphore` and an `event`, which is a simple and effective way to coordinate access.

## Why use arbitration?

Arbitration is needed when:

- multiple agents compete for the same path
- bus ownership must be granted securely
- one process must wait until a previous request completes
- shared resources need deterministic scheduling

## Core idea

- a semaphore represents the bus lock
- a process acquires the semaphore to request the bus
- the event signals when the bus grant or release cycle is complete
- the next request waits until the previous transaction ends

## Example structure

```systemverilog
module tb;
    semaphore bus_lock;
    event arb_done;

    initial begin
        bus_lock = new(1);

        bus_lock.get();
        $display("Bus granted to master");
        -> arb_done;
        #10;
        bus_lock.put();
        $display("Bus released");
    end
endmodule
```

## What this example demonstrates

The file `../shared_bus_arbitration.sv` shows:

- controlling access to a shared bus
- preventing simultaneous bus ownership
- using events for grant and completion signaling
- resource scheduling patterns in verification environments

## Typical use cases

- bus masters in an SoC
- shared register interfaces
- arbitration between monitor/checker components
- coordinating access to a common interface or memory path

## Design considerations

A simple semaphore-based arbitration model is useful for learning and for small testbench structures, but in larger systems you may want a richergrant policy such as round-robin, priority-based, or fairness-aware arbitration.

## Related topics

- [Semaphore Synchronization](../semaphore_synchronization/README.md)
- [Event Synchronization](../event_synchronization/README.md)
- [Fork/Join Constructs](../fork_join_constructs/README.md)
