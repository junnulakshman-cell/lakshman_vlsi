# Inter-Process Synchronization in SystemVerilog

This folder demonstrates the main inter-process synchronization mechanisms used in SystemVerilog and UVM verification.

## Topics Covered

- Event synchronization
- Event chaining
- Semaphore-based mutual exclusion
- Shared resource arbitration
- Fork/Join constructs
- join_any, join_none, and wait fork
- disable fork
- UVM-style synchronization patterns

## Overview

In verification environments, multiple processes often run concurrently. These processes must coordinate to:

- notify completion
- wait for a condition
- protect a shared resource
- serialize access to a bus or memory
- synchronize monitors, drivers, and checkers

SystemVerilog provides several synchronization primitives for this purpose.

---

## 1. Event Synchronization

An event is a synchronization object used to notify one or more waiting processes.

```systemverilog
event transaction_ready;

initial begin
  #10;
  -> transaction_ready;
end

initial begin
  @(transaction_ready);
  $display("Transaction ready");
end
```

### Uses

- generator-to-driver notification
- monitor-to-scoreboard signaling
- handshake between parallel processes

### Key points

- `-> event_name;` triggers the event
- `@(event_name);` waits for the event
- `->>` schedules event trigger in the NBA region
- `wait(event_name.triggered);` waits for the event to be triggered

---

## 2. Event Chaining

Event chaining connects multiple processes in a sequence using events.

```systemverilog
module tb;
  event e1, e2, e3;

  initial begin
    @(e1)
    $display("Process 1 complete");
    -> e3;
  end

  initial begin
    @(e3)
    $display("Process 3 complete");
    -> e2;
  end

  initial begin
    @(e2)
    $display("Process 2 complete");
  end

  initial begin
    $display("Process 4 complete");
    -> e1;
  end
endmodule
```

This creates a dependency chain:

```text
Process 4 -> e1 -> Process 1 -> e3 -> Process 3 -> e2 -> Process 2
```

This is useful for controlled sequential execution without introducing delays.

---

## 3. Semaphore Synchronization

A semaphore controls access to shared resources using keys. It is useful for mutual exclusion.

```systemverilog
semaphore bus_lock;

initial begin
  bus_lock = new(1);
  bus_lock.get(1);
  // critical section
  bus_lock.put(1);
end
```

### Use cases

- shared bus access
- shared interface access
- shared memory access
- checkers and register models

### Important methods

- `get()` : blocking acquire
- `try_get()` : non-blocking acquire
- `put()` : release the key

---

## 4. Shared Bus Arbitration Example

A common verification pattern is a generator triggering a transaction while multiple drivers compete for a single bus.

```systemverilog
module semaphore_event_example;
  semaphore bus_lock;
  event transaction_ready;

  initial begin
    bus_lock = new(1);

    fork
      begin
        #10;
        ->> transaction_ready;
      end

      begin
        wait(transaction_ready.triggered);
        bus_lock.get(1);
        #10;
        bus_lock.put(1);
      end

      begin
        wait(transaction_ready.triggered);
        bus_lock.get(1);
        #15;
        bus_lock.put(1);
      end
    join
  end
endmodule
```

Only one process gets the semaphore key at a time. Others wait.

---

## 5. Fork-Join Constructs

SystemVerilog has several fork/join variants that control how the parent process waits for child processes.

### fork...join

Parent waits until all child processes finish.

```systemverilog
fork
  read_operation();
  wait_operation();
  write_operation();
join
```

### fork...join_any

Parent waits until any one child finishes.

```systemverilog
fork
  read_operation();
  wait_operation();
  write_operation();
join_any
```

### fork...join_none

Parent continues immediately while children run in parallel.

```systemverilog
fork
  read_operation();
  wait_operation();
  write_operation();
join_none
```

### wait fork

Waits for all currently active child processes to finish.

```systemverilog
fork
  read_operation();
  wait_operation();
  write_operation();
join_none

wait fork;
```

---

## 6. disable fork

`disable fork` terminates active child processes created by the current fork block.

```systemverilog
fork
  read_operation();
  wait_operation();
  write_operation();
join_any

disable fork;
```

This is commonly used in timeout handling and clean shutdown logic.

---

## 7. Typical UVM Use Cases

These synchronization primitives are heavily used in UVM verification:

- generator -> driver notification using events
- monitor -> scoreboard communication
- shared bus access using semaphores
- timeout logic using fork...join_any + disable fork
- background monitors using fork...join_none

```systemverilog
fork
  begin
    wait(response_done);
  end

  begin
    #100us;
    `uvm_error("TIMEOUT", "Response missing");
  end
join_any

disable fork;
```

---

## 8. Interview Questions

### Q1. What is an event?
An event is a synchronization object used for process communication and notification.

### Q2. What is a semaphore?
A semaphore is a resource-protection mechanism that uses keys to allow or block access.

### Q3. Difference between `event` and `semaphore`?
- Event: notification and synchronization
- Semaphore: mutual exclusion and shared resource control

### Q4. What does `fork...join` do?
The parent waits until all child processes complete.

### Q5. What does `fork...join_any` do?
The parent waits until the first child process finishes.

### Q6. What does `disable fork` do?
It kills active child processes created by the current fork block.

---

## Summary

SystemVerilog synchronization is essential in verification because parallel processes must coordinate safely and predictably.

The most commonly used mechanisms are:

- `event` for signal/notification
- `semaphore` for mutual exclusion and resource control
- `fork...join` for process coordination
- `disable fork` for cleanup and timeout control

These concepts form the foundation of robust UVM testbench architecture.

---

## File Contents

This folder contains:

- `README.md` : explanation and theory
- `inter_process_sychronization.sv` : practical SystemVerilog example combining the concepts

