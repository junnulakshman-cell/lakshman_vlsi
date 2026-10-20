# SystemVerilog Enum Casting

This example shows how to convert integer values into enum values using explicit casting.

## Aim

- Define an enum type for named states or values
- Cast integer values into enum variables
- Use `.name()` to print readable symbolic names

## Example

```systemverilog
module enum_casting;

  typedef enum logic [2:0] {
    APPLE,
    ORANGE,
    BANANA,
    MANGO
  } fruits_names;

  fruits_names fruits_order;

  initial begin
    fruits_order = fruits_names'(2);
    $display("fruits_order = %s", fruits_order.name());

    for (int i = 0; i < 4; i++) begin
      fruits_order = fruits_names'(i);
      $display("num = %0d fruits_order = %s", i, fruits_order.name());
    end
  end

endmodule
```

## Key concepts

- `fruits_names'(2)` converts `2` into the enum literal `BANANA`
- `.name()` returns the textual name of the enum value
- Enum casting is commonly used in FSMs and protocol state machines

## Typical usage

- FSM states
- Protocol communication states
- Testbench transaction modes

## File

- `enum_casting.sv`
