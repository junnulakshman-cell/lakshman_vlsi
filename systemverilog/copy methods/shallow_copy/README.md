# Shallow Copy

This example demonstrates that shallow copy copies the class handle, so both handles point to the same object.

Key idea:

```systemverilog
v1 = v2;
```

Both `v1` and `v2` refer to the same object. Modifying one affects the other.
