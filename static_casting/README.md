# SystemVerilog Static Casting

## 1. Aim

To understand how **static casting** works in SystemVerilog and how it converts values between different data types, such as `logic [7:0]`, `int`, `byte`, and `byte unsigned`.

## 2. What Is Static Casting?

Static casting is a way to explicitly convert a value from one data type to another using the target data type followed by a single quote.

### Syntax

```systemverilog
data_type'(expression);
```

### Examples

```systemverilog
data_r = int'(data);
addr_r = byte'(addr);
addr_ru = unsigned'(addr);
```

- `int'(data)` converts the expression to a 32-bit signed integer.
- `byte'(addr)` converts the expression to an 8-bit signed byte.
- `unsigned'(addr)` converts the expression to an unsigned value while retaining the expression's width.

**Important:** Static casting does not necessarily change the underlying bit pattern. The result depends on the target type and its width and signedness.

## 3. SystemVerilog Code

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

    $display("=============== BEFORE THE CASTING ===========");
    $display("DATA = %0h (%0d) ADDR = %0h (%0d)",
             data, data, addr, addr);

    data_r = int'(data);
    addr_r = byte'(addr);

    $display("=============== AFTER THE CASTING ============");
    $display("DATA_r = %8h (%0d) ADDR_r = %0h (%0d)",
             data_r, data_r, addr_r, addr_r);
  end

  initial begin
    addr_ru = unsigned'(addr);

    $display("ADDR_ru = %0h (%0d)", addr_ru, addr_ru);
  end

endmodule
```

## 4. Explanation of Data Types

| Data type | Width | Signedness |
|---|---:|---|
| `logic [7:0]` | 8 bits | Unsigned by default |
| `int` | 32 bits | Signed |
| `byte` | 8 bits | Signed |
| `byte unsigned` | 8 bits | Unsigned |

## 5. Step-by-Step Explanation

### Step 1: Assign hexadecimal values

```systemverilog
data = 8'hAA;
addr = 8'hBB;
```

- `data` stores hexadecimal `AA`, equivalent to decimal `170`.
- `addr` stores hexadecimal `BB`, equivalent to decimal `187`.

### Step 2: Cast `data` to `int`

```systemverilog
data_r = int'(data);
```

The original value is an 8-bit unsigned value. The cast produces a 32-bit signed integer.

Since `data` is unsigned and its value is `8'hAA`, the resulting integer is positive:

- Hexadecimal: `000000AA`
- Decimal: `170`

### Step 3: Cast `addr` to `byte`

```systemverilog
addr_r = byte'(addr);
```

The `byte` type is an 8-bit signed type.

The bit pattern `8'hBB` represents decimal `187` when interpreted as unsigned, but as a signed 8-bit two's-complement value, it represents `-69`.

Therefore:

- Hexadecimal bit pattern: `BB`
- Signed decimal value: `-69`

### Step 4: Cast to unsigned

```systemverilog
addr_ru = unsigned'(addr);
```

The `unsigned` cast changes the signedness of the expression without changing its width. Here, `addr` is already an 8-bit unsigned `logic` vector.

Therefore, the resulting value remains:

- Hexadecimal: `BB`
- Decimal: `187`

## 6. Expected Output

The first `initial` block produces:

```text
=============== BEFORE THE CASTING ===========
DATA = aa (170) ADDR = bb (187)
=============== AFTER THE CASTING ============
DATA_r = 000000aa (170) ADDR_r = bb (-69)
```

The second `initial` block produces:

```text
ADDR_ru = bb (187)
```

**Note:** The two `initial` blocks execute concurrently. Their relative output order is not guaranteed, so the `ADDR_ru` line may appear before the other output. The `%h` format specifier prints hexadecimal digits, while `%d` prints the decimal interpretation.

## 7. Real-Time VLSI Application

Static casting is useful in RTL design and verification when you need to:

- Convert transaction fields into integer variables for scoreboards.
- Interpret signed and unsigned data correctly.
- Handle address and data fields in bus protocols such as AXI and APB.
- Convert values for arithmetic operations and comparisons.
- Avoid unexpected results caused by width and signedness mismatches.

For example, when processing an 8-bit sensor sample, casting to a signed `byte` interprets the most significant bit as a sign bit. Casting to `byte unsigned` interprets all eight bits as a non-negative value.

## 8. Interview Questions

**Q1. What is static casting in SystemVerilog?**

Static casting explicitly converts an expression to a specified data type using the syntax `type'(expression)`.

**Q2. What is the difference between `int'(data)` and `byte'(data)`?**

`int` is a 32-bit signed type, whereas `byte` is an 8-bit signed type. The conversion may change the width and interpretation of the value.

**Q3. Why does `byte'(8'hBB)` produce `-69`?**

Because `byte` is signed and the most significant bit of `8'hBB` is 1. Interpreted as an 8-bit two's-complement number, the value is `-69`.

**Q4. What is the difference between `byte` and `byte unsigned`?**

Both types are 8 bits wide, but `byte` is signed and `byte unsigned` is unsigned.

**Q5. Does static casting always change the bit pattern?**

No. A cast can change only the type interpretation, or it can change the width and therefore affect the resulting representation.

**Q6. What is the difference between static casting and dynamic casting?**

Static casting uses `type'(expression)` for type conversion. Dynamic casting uses `$cast(destination, source)` and returns success or failure when checking whether a runtime conversion is valid.

## 9. Conclusion

Static casting is an important SystemVerilog feature for explicit type conversion. Understanding width, signedness, and two's-complement representation helps prevent RTL arithmetic bugs and verification mismatches.

**Key takeaway:** Always check both the bit width and signedness when casting between SystemVerilog data types.
