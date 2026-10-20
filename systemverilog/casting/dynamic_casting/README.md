# SystemVerilog Dynamic Casting (`$cast`)

This example shows how to perform safe runtime type checking with `$cast()` in a class hierarchy.

## Aim

- Convert a parent-class handle into a child-class handle only when valid
- Use runtime type checking to avoid invalid downcasts
- Understand the difference between casting and object creation

## Example

```systemverilog
class parent_packet;
  logic [7:0] data;
endclass

class child_packet extends parent_packet;
  logic [15:0] addr;
  logic [15:0] read_data;
endclass

module tb;
  parent_packet p;
  child_packet c;

  initial begin
    p = new child_packet();
    p.data = 8'hAA;

    if ($cast(c, p)) begin
      $display("Downcasting is successful");
      c.addr = 16'h1234;
      c.read_data = 16'h5678;
      $display("Data = %0h Address = %0h Read Data = %0h",
               c.data, c.addr, c.read_data);
    end else begin
      $display("Downcasting has failed");
    end
  end
endmodule
```

## Key concepts

- `$cast(dest, src)` checks whether the source handle is compatible with the destination type
- A parent handle can point to a child object
- A downcast fails if the source handle does not actually reference the required child class

## Typical usage

- UVM transaction type checking
- Polymorphic object handling
- Scoreboard logic that needs derived-class fields

## File

- `downcasting_example.sv`
