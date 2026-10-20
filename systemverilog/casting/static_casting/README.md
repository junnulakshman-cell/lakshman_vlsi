# SystemVerilog Static Casting

This example explains how `type'(expression)` is used to cast between different data types.

## Aim

- Convert `logic [7:0]` values to `int` and `byte`
- Understand signed vs. unsigned behavior
- Show why static casting is important in bus protocols and verification

## Example

```systemverilog
module static_casting_example;

  logic [7:0] data;
  logic [7:0] addr;

  int data_r;
  byte addr_r;
  byte unsigned addr_ru;

  initial begin
    data = 8'hAA;
    addr = 8'hBB;

    $display("BEFORE: DATA = %0h (%0d) ADDR = %0h (%0d)",
             data, data, addr, addr);

    data_r = int'(data);
    addr_r = byte'(addr);

    $display("AFTER: DATA_r = %0h (%0d) ADDR_r = %0h (%0d)",
             data_r, data_r, addr_r, addr_r);
  end

  initial begin
    addr_ru = unsigned'(addr);
    $display("ADDR_ru = %0h (%0d)", addr_ru, addr_ru);
  end

endmodule
```

## Key concepts

- `int'(data)` expands to a 32-bit signed integer
- `byte'(addr)` shrinks to 8-bit signed data
- `unsigned'(addr)` keeps the same width but changes signedness
- A cast does not change the underlying bit pattern, only interpretation

## Typical usage

- Converting transaction fields to integer values
- Handling signed and unsigned address/data buses
- Preventing arithmetic errors in RTL and testbench code

## File

- `static_casting_example.sv`
