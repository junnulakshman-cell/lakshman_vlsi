# Copy by Handle

This example demonstrates handle assignment in SystemVerilog.

## Key idea

```systemverilog
v1 = v2;
```

This copies the class handle, not the object itself. Both handles point to the same object.

## What happens?

- `v1` and `v2` initially point to separate objects.
- After `v1 = v2;`, both handles refer to the same object.
- Modifying through one handle changes what the other handle observes.

## Example behavior

```text
--- Before Copy by Handle ---
v1: a=0, b=0
v2: a=30, b=40

--- After Copy by Handle ---
v1: a=30, b=40
v2: a=30, b=40

--- After Modifying v2 ---
v1: a=20, b=59
v2: a=20, b=59
```

## Important concept

Handle assignment does not create a new object. To create a new object, use `new()`.
