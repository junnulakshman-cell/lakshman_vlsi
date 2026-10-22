# Task Lifetime in SystemVerilog

This topic explains the difference between a normal (static) task and an automatic task in SystemVerilog.

## Core idea

- A normal task has static lifetime by default.
- Its local variables are shared across invocations.
- An automatic task creates a separate storage instance for each call.
- This matters when multiple task calls run concurrently with `fork...join`.

## Why it matters

When two or more task calls execute at the same time, static tasks can interfere because they share the same local variables. Automatic tasks avoid this by giving each invocation independent local storage.

## Example summary

- `normal_task` shows shared local state across concurrent calls.
- `automatic_task` shows independent local state per invocation.

## Key rule

Use `task automatic ...` when each call must keep its own temporary variables, counters, or transaction state. Use a normal task only when intentionally shared local state is required.
