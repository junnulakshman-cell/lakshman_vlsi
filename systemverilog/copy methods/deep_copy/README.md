# Deep Copy

This example demonstrates deep copy of a class that contains a nested class handle.

The key steps are:

```systemverilog
v = new();
v.pck = new();
v.pck.count = this.pck.count;
```

This creates a new outer object and a new nested object so the copied version is independent from the source object.
