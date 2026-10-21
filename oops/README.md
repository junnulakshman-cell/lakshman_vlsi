# OOP Concepts in SystemVerilog

This folder contains a structured collection of SystemVerilog Object-Oriented Programming (OOP) examples and explanations.

The aim is to teach the core OOP principles used in digital design, verification, and hardware modeling:

- Abstraction
- Encapsulation
- Inheritance
- Polymorphism
- Runtime dispatch
- Dynamic casting
- Abstract base classes
- Pure virtual methods

---

## Topics covered

### 1. Encapsulation

Encapsulation hides data and exposes controlled access through class methods.

- File: `encapsulation_local_protected_access.sv`
- README: `README_encapsulation_local_protected_access.md`

Concepts:
- `local` access specifier
- `protected` access specifier
- data hiding
- controlled access via methods

---

### 2. Inheritance

Inheritance allows a child class to reuse and extend the behavior of a parent class.

- File: `inheritance_basic.sv`
- README: `README_inheritance_basic.md`

Concepts:
- base class
- derived class
- `extends`
- `super.new()`
- protected member access

---

### 3. Virtual Class and Pure Virtual Method

Abstract classes define a contract that derived classes must implement.

- File: `pure_virtual_polymorshims.sv`
- README: `README_pure_virtual_polymorshims.md`

Concepts:
- `virtual class`
- pure virtual function
- abstract base class
- interface design
- method overriding

---

### 4. Runtime Polymorphism and Dynamic Casting

A parent handle can point to a child object, and the correct overridden method is called at runtime.

- File: `virtual_class_runtime_polymorphism_dynamic_casting.sv`
- README: `README_virtual_class_runtime_polymorphism_dynamic_casting.md`

Concepts:
- runtime polymorphism
- parent handle / child object
- virtual method dispatch
- `$cast()`
- upcasting

---

## OOP concept summary

### Abstraction

Abstraction hides implementation details and exposes only relevant behavior.

Example:
- abstract base class
- pure virtual method

### Encapsulation

Encapsulation keeps internal variables safe and only exposes them through methods.

Example:
- `protected` data in parent class
- `local` data inside child object

### Inheritance

Inheritance allows a class to reuse features from another class.

Example:
- child inherits from parent
- child adds its own member and methods

### Polymorphism

Polymorphism allows one interface to behave differently depending on the actual object type.

Example:
- parent handle calling child `display()`

### Dynamic Casting

Dynamic casting safely converts class handles when the type relationship is valid.

Example:
- `$cast(parent_handle, child_handle)`

---

## Recommended order to study

1. Encapsulation
2. Inheritance
3. Pure virtual method
4. Polymorphism
5. Dynamic casting

This order builds the foundation from basic OOP principles to advanced runtime behavior.

---

## Notes

These examples are intentionally simple and focused on learning. They are meant to help with:

- interview preparation
- digital design concepts
- verification modeling
- SystemVerilog OOP understanding

---

## Folder structure

```text
oops/
├── README.md
├── README_encapsulation_local_protected_access.md
├── README_inheritance_basic.md
├── README_pure_virtual_polymorshims.md
├── README_virtual_class_runtime_polymorphism_dynamic_casting.md
├── encapsulation_local_protected_access.sv
├── inheritance_basic.sv
├── pure_virtual_polymorshims.sv
├── virtual_class_runtime_polymorphism_dynamic_casting.sv
├── ... other OOP-related examples
└── diagrams/assets if added later
```

---

## Final takeaway

SystemVerilog OOP is a powerful way to model reusable and structured hardware behavior. These examples demonstrate how object-oriented concepts can be applied in practical design and verification workflows.
