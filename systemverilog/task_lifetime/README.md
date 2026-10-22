# Task Lifetime in SystemVerilog

This folder contains the complete set of examples and notes for understanding normal (static) tasks versus automatic tasks in SystemVerilog.

## Files in this folder

- `README.md` — overview and file index
- `normal_vs_automatic_task.md` — detailed concept guide with syntax, examples, and explanations
- `normal_task_examples.sv` — static task examples and concurrency demonstrations
- `automatic_task_examples.sv` — automatic task examples and comparison code

## Quick summary

- Normal task: local variables are static by default and shared across calls.
- Automatic task: each call gets independent local storage.
- Use `task automatic` when concurrent operations need independent state.
- Use a normal task only when intentionally shared state is desired.

## Recommended reading order

1. Read `normal_vs_automatic_task.md`
2. Run `normal_task_examples.sv`
3. Run `automatic_task_examples.sv`
4. Compare output behavior in `fork...join` simulations
