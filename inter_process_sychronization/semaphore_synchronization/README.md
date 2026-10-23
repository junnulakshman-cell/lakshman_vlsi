# Semaphore Synchronization

## Overview

A `semaphore` in SystemVerilog is a synchronization object that controls access to a shared resource by counting available tokens. It is commonly used when multiple processes compete for limited access to a resource.

The key operations are:

- `get()` — acquire a token
- `put()` — release a token

## Why use semaphores?

Semaphores are used when:

- several tasks need access to a single resource
- only a limited number of tasks may enter a critical section
- you need mutual exclusion or controlled concurrency
- multiple requests must be serialized or limited by count

## Concept

A semaphore starts with a defined count. If a process calls `get()` and a token is available, it proceeds. If the count is zero, the process blocks until another process releases a token via `put()`.

## Example structure

```systemverilog
module tb;
    semaphore s;

    initial begin
        s = new(1);

        s.get();
        $display("Critical section entered");
        #10;
        s.put();
        $display("Critical section released");
    end
endmodule
```

## What this example demonstrates

The file `../semaphore_synchronization.sv` illustrates:

- semaphore creation
- token acquire (`get()`)
- token release (`put()`)
- controlled access to a shared resource

## Typical use cases

- shared bus arbitration
- access to memories or register banks
- preventing simultaneous writes to a common resource
- controlling the number of active consumers in a resource pool

## Important notes

- `semaphore` is better than plain events when you need counting and mutual exclusion.
- It is ideal for critical section protection.
- A semaphore with count 1 behaves similarly to a mutex.

## Related topics

- [Shared Bus Arbitration](../shared_bus_arbitration/README.md)
- [Fork/Join Constructs](../fork_join_constructs/README.md)
- [Disable Fork](../disable_fork/README.md)
