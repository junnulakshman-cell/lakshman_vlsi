# SystemVerilog Upcasting and Downcasting

This example explains the direction of class handle conversion in SystemVerilog.

## Aim

- Show direct assignment for upcasting: `p = c;`
- Show safe runtime conversion for downcasting: `$cast(c, p);`
- Clarify when `$cast()` is required and when it is not

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
    c = new();
    c.data = 8'hAA;
    c.addr = 16'h1234;
    c.read_data = 16'h5678;

    p = c; // Upcasting
    $display("Upcasting successful: data = %0h", p.data);

    if ($cast(c, p)) begin
      $display("Downcasting successful: addr = %0h", c.addr);
    end
  end
endmodule
```

## Key concepts

- Upcasting: child handle to parent handle
- Downcasting: parent handle to child handle using `$cast()`
- Upcasting is usually direct; downcasting requires runtime validation

## Typical usage

- Base-class interfaces in reusable verification components
- Polymorphic transaction handling
- UVM object and transaction processing

## File

- `upcasting_downcasting_example.sv`
