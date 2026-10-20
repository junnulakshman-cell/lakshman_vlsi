# SystemVerilog Enum Casting

## 1. Aim

To understand how **static casting works with enumerated types (`enum`)** in SystemVerilog and how integer values can be converted into enum values.

## 2. What Is an Enum?

An enumeration is a user-defined data type that represents a fixed set of named values.

### Syntax

```systemverilog
typedef enum logic [2:0] {
    APPLE,
    ORANGE,
    BANANA,
    MANGO
} fruits_names;
```

Here:

- `enum` defines an enumerated data type.
- `logic [2:0]` specifies a 3-bit underlying type.
- `APPLE`, `ORANGE`, `BANANA`, and `MANGO` are enumeration literals.
- `fruits_names` is the name of the new data type.

Because no explicit values are assigned, the enum literals receive consecutive values starting from zero.

| Enum literal | Binary | Decimal |
|---|---|---:|
| `APPLE` | `000` | 0 |
| `ORANGE` | `001` | 1 |
| `BANANA` | `010` | 2 |
| `MANGO` | `011` | 3 |

**Note:** Your original code uses `ORANAGE` and `MANAGO`. The corrected spelling in this README is `ORANGE` and `MANGO`.

## 3. SystemVerilog Code

Save the following code as `enum_casting.sv`.

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
  end

  initial begin
    int i;

    for (i = 0; i < 4; i++) begin
      fruits_order = fruits_names'(i);

      $display("num = %0d fruits_order = %s",
               i, fruits_order.name());
    end
  end

endmodule
```

## 4. Expected Output

```text
fruits_order = BANANA
num = 0 fruits_order = APPLE
num = 1 fruits_order = ORANGE
num = 2 fruits_order = BANANA
num = 3 fruits_order = MANGO
```

**Important:** Both `initial` blocks execute concurrently. The first line may appear at a different position relative to the loop output, depending on simulation scheduling. The loop output itself follows the order shown above.

## 5. Step-by-Step Explanation

### Step 1: Declare the enum data type

```systemverilog
typedef enum logic [2:0] {
  APPLE, ORANGE, BANANA, MANGO
} fruits_names;
```

This creates a custom type named `fruits_names` with four legal named values.

### Step 2: Declare an enum variable

```systemverilog
fruits_names fruits_order;
```

The variable `fruits_order` can store one of the declared enum values.

### Step 3: Perform enum static casting

```systemverilog
fruits_order = fruits_names'(2);
```

The expression `fruits_names'(2)` casts the integer value `2` to the enum type.

Since `BANANA` has the underlying value `2`, the variable stores `BANANA`.

### Step 4: Display the enum name

```systemverilog
$display("fruits_order = %s", fruits_order.name());
```

The `.name()` method returns the string corresponding to the current enum literal.

For example:

- `fruits_order = APPLE` returns `"APPLE"`.
- `fruits_order = ORANGE` returns `"ORANGE"`.
- `fruits_order = BANANA` returns `"BANANA"`.
- `fruits_order = MANGO` returns `"MANGO"`.

### Step 5: Iterate through the enum values

```systemverilog
for (i = 0; i < 4; i++) begin
  fruits_order = fruits_names'(i);
  $display("num = %0d fruits_order = %s",
           i, fruits_order.name());
end
```

The loop executes four times.

| Iteration | `i` | Cast result | Displayed name |
|---|---:|---|---|
| 1 | 0 | `fruits_names'(0)` | `APPLE` |
| 2 | 1 | `fruits_names'(1)` | `ORANGE` |
| 3 | 2 | `fruits_names'(2)` | `BANANA` |
| 4 | 3 | `fruits_names'(3)` | `MANGO` |

Each integer is converted to the corresponding enum value.

## 6. Important Concepts

### Enum casting syntax

```systemverilog
enum_type'(expression);
```

Example:

```systemverilog
fruits_order = fruits_names'(1);
```

### Enum `.name()` method

```systemverilog
fruits_order.name()
```

Returns the name of the current enum value as a string.

### Enum `.first()`, `.last()`, `.next()`, and `.prev()`

SystemVerilog also provides enum methods for navigating legal enum literals.

```systemverilog
fruits_order = fruits_order.first();
$display("%s", fruits_order.name());

fruits_order = fruits_order.next();
$display("%s", fruits_order.name());
```

For the declared enum, these statements print `APPLE` followed by `ORANGE`.

### Important caution about invalid values

Casting an integer to an enum does not automatically guarantee that the resulting value corresponds to a declared literal. For example:

```systemverilog
fruits_order = fruits_names'(4);
```

The underlying 3-bit value `4` is representable, but no declared enum literal has that value. Calling `.name()` for an unnamed enum value returns an empty string.

Use valid enum values or validate the input before relying on the enum name.

## 7. Real-Time Applications in VLSI

Enum casting is useful in RTL design and verification for:

- **FSMs:** Converting numeric state encodings into named states.
- **Protocol verification:** Representing AXI, APB, and I2C transaction states.
- **UVM testbenches:** Converting numeric configuration values into enum-based modes.
- **Debugging:** Printing readable state names in simulation logs.
- **Test generation:** Iterating through valid modes or states in a testbench.

For example, a controller may define `IDLE`, `READ`, `WRITE`, and `DONE` states. Enum names make waveforms and debug messages easier to understand than numeric state encodings.

## 8. Interview Questions

**Q1. What is enum casting in SystemVerilog?**

It is the explicit conversion of an expression into an enumerated data type using the enum type name followed by a single quote.

**Q2. What does `fruits_names'(2)` return?**

It produces an enum value with underlying value `2`, which corresponds to `BANANA` in this example.

**Q3. What is the purpose of `.name()`?**

It returns the string name of the current enum literal.

**Q4. Can we directly assign an integer to an enum variable?**

A direct assignment of an integer to an enum variable is generally not permitted as an ordinary implicit conversion. Explicit casting is used when appropriate.

**Q5. What happens if we cast an integer that has no matching enum literal?**

The cast can produce an underlying value that is not a declared enum literal. The `.name()` method then returns an empty string for that unnamed value.

**Q6. Why are enums useful in FSM design?**

They provide readable symbolic state names, improve code clarity, and make simulation debugging easier.

**Q7. What is the difference between an enum's underlying value and its name?**

The underlying value is the encoded numeric representation, while the name is the symbolic identifier associated with a declared enum literal.

## 9. Conclusion

Enum casting allows integer expressions to be converted explicitly into enumerated values. Combined with `.name()`, it makes SystemVerilog code more readable and improves debugging in RTL and verification environments.

**Key takeaway:** Use `fruits_names'(i)` to cast a numeric value to the enum type, and use `.name()` to display the corresponding symbolic name.
