# Event Synchronization

## Overview

`event` is one of the simplest synchronization primitives in SystemVerilog. It is used to signal that a certain condition has occurred so that another process can resume execution.

In behavioral modeling and testbench design, an event is often used for lightweight coordination between active processes. It is useful when one thread needs to tell another thread, "something happened."

## Why use events?

Events are helpful when:

- one process is waiting for another process to finish a step
- a monitor needs to notify a checker or scoreboard
- a timeout or completion signal must wake a waiting thread
- a transaction needs a trigger-based handshake

## Core concepts

### Triggering an event

The trigger operator `->` raises the event:

```systemverilog
-> my_event;
```

### Waiting for an event

The wait operator `@` blocks until the event is triggered:

```systemverilog
@my_event;
```

### Event object declaration

```systemverilog
event my_event;
```

## Example behavior

A basic event-based handshake is:

```systemverilog
module tb;
    event done;

    initial begin
        #10 -> done;
    end

    initial begin
        @done;
        $display("Event triggered: task completed.");
    end
endmodule
```

This model has two processes:

- one process triggers the event after a delay
- the other waits for that trigger before continuing

## What this example demonstrates

The file `../event_synchronization.sv` shows:

- event declaration
- trigger operation (`->`)
- blocking wait (`@`)
- synchronization between independent threads

## Typical use cases

- handshake between producer and consumer tasks
- signaling completion of a modeling step
- waking a waiting checker after a stimulus event

## Important notes

- Events are not shared variables; they are signaling objects.
- They are useful for synchronization, not for storing data.
- Multiple threads can wait on the same event, and all can be triggered by the same signal.

## Related topics

- [Event Chaining](../event_chaining/README.md)
- [Fork/Join Constructs](../fork_join_constructs/README.md)
- [UVM-Style Synchronization](../uvm_style_synchronization/README.md)
