# Inter-Process Synchronization in SystemVerilog

This folder contains standalone SystemVerilog examples for each synchronization concept described in the README.

## Files

- `event_synchronization.sv` : event trigger and wait example
- `event_chaining.sv` : chained event dependency example
- `semaphore_synchronization.sv` : semaphore acquire and release example
- `shared_bus_arbitration.sv` : bus arbitration using semaphore and event
- `fork_join_constructs.sv` : `fork...join`, `join_any`, and `join_none` examples
- `disable_fork.sv` : cleanup and timeout handling with `disable fork`
- `uvm_style_synchronization.sv` : monitor/timeout synchronization pattern

## Combined Example

- `inter_process_sychronization.sv` : a single top-level example that combines the main concepts
