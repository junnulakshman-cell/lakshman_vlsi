# Inter-Process Synchronization in SystemVerilog

This folder contains standalone SystemVerilog examples that demonstrate how different synchronization mechanisms coordinate parallel or concurrent processes in simulation and verification environments.

## Why this matters

SystemVerilog testbenches often contain multiple processes running at the same time. These processes may represent:

- monitor threads
- stimulus generators
- scoreboards
- timeout handlers
- arbitration logic for shared resources

Without synchronization, these processes can race, miss events, or produce inconsistent results. The constructs in this folder help model real-world timing and control behavior in a deterministic way.

## Topics included

Each concept is covered as a separate topic with its own detailed README:

- [Event Synchronization](event_synchronization/README.md) — simple signaling between processes using `event`
- [Event Chaining](event_chaining/README.md) — sequential trigger propagation across multiple events
- [Semaphore Synchronization](semaphore_synchronization/README.md) — token-based mutual exclusion and resource control
- [Shared Bus Arbitration](shared_bus_arbitration/README.md) — bus grant logic using semaphores and events
- [Fork/Join Constructs](fork_join_constructs/README.md) — parallel process creation and waiting rules
- [Disable Fork](disable_fork/README.md) — cleanup and termination of spawned processes
- [UVM-Style Synchronization](uvm_style_synchronization/README.md) — timeout and completion coordination used in verification environments

## Files in this folder

- `event_synchronization.sv` — event trigger and wait example
- `event_chaining.sv` — chained event dependency example
- `semaphore_synchronization.sv` — semaphore acquire and release example
- `shared_bus_arbitration.sv` — bus arbitration using semaphore and event
- `fork_join_constructs.sv` — `fork...join`, `join_any`, and `join_none` examples
- `disable_fork.sv` — cleanup and timeout handling with `disable fork`
- `uvm_style_synchronization.sv` — monitor/timeout synchronization pattern
- `inter_process_sychronization.sv` — combined example integrating several concepts

## Quick comparison

| Mechanism | Best for | Typical behavior |
| --- | --- | --- |
| `event` | Simple signaling | One process triggers, another waits |
| `semaphore` | Resource locking | Control access count and mutual exclusion |
| `fork...join` | Parallel execution | Spawn tasks and wait for completion |
| `disable fork` | Forced cleanup | Stop child threads when needed |
| timeout logic | robustness | Detect missing completion or deadlock |

## Running the examples

Each file is intended to be compiled and simulated in a SystemVerilog simulator such as:

- Questa/ModelSim
- Vivado simulator
- Icarus Verilog (for basic simulation)

A typical compile flow is:

```bash
vsim -c -do "run -all; quit" event_synchronization.sv
```

or for a general simulation tool:

```bash
iverilog -g2012 event_synchronization.sv
vvp a.out
```

## Design mindset

Most synchronization methods in SystemVerilog are used to answer one of these questions:

1. When should a process start?
2. Which process is allowed to access a shared resource?
3. How do we detect that something completed or timed out?
4. How do we clean up child processes safely?

This folder shows practical patterns that answer those questions using examples that are easy to read and extend.

## Combined example

The file `inter_process_sychronization.sv` brings the important ideas together in a single design example, showing how different synchronization primitives can work together in a realistic testbench model.

---

For deeper explanation, open each topic-specific README in this directory.
