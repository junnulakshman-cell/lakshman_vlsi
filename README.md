# Lakshman VLSI – SystemVerilog Examples

This repository contains a curated set of SystemVerilog examples and design notes focused on object-oriented programming, type casting, transactions, queues, and verification concepts used in digital design and VLSI workflows.

## Repository structure

```text
lakshman_vlsi/
├── README.md
├── README_ASSOCTIVE_ARRAY.me
├── READ_QUEUE.md
├── associative_queue_array.sv
├── axi_transaction_order.sv
├── axi_transaction_order_README.md
├── axi_write_buffer_queue.sv
├── shallow_deep_copy.sv
├── dynamic_casting/
│   ├── README.md
│   ├── downcasting_example.sv
│   └── dynamic_casting_examples.sv
├── enum_casting/
│   ├── README.md
│   └── enum_casting.sv
├── static_casting/
│   ├── README.md
│   └── static_casting_example.sv
├── upcasting_downcasting/
│   ├── README.md
│   └── upcasting_example.sv
├── systemverilog/
│   ├── associative_array/
│   │   ├── README.md
│   │   └── axi_transaction_order.sv
│   ├── associative_queue/
│   │   ├── README.md
│   │   └── associative_queue_array.sv
│   ├── casting/
│   │   ├── dynamic_casting/
│   │   │   ├── README.md
│   │   │   └── downcasting_example.sv
│   │   ├── enum_casting/
│   │   │   ├── README.md
│   │   │   └── enum_casting.sv
│   │   ├── static_casting/
│   │   │   ├── README.md
│   │   │   └── static_casting_example.sv
│   │   └── upcasting_downcasting/
│   │       ├── README.md
│   │       └── upcasting_downcasting_example.sv
│   ├── oop/
│   │   ├── README.md
│   │   └── shallow_deep_copy.sv
│   ├── queue/
│   │   ├── README.md
│   │   └── axi_write_buffer_queue.sv
│   ├── static_properties_methods/
│   │   ├── README.md
│   │   └── static_properties_methods.sv
│   └── task_lifetime/
│       ├── README.md
│       ├── automatic_task_examples.sv
│       ├── normal_task_examples.sv
│       ├── normal_vs_automatic_task.md
│       └── task_lifetime_examples.sv
├── oops/
│   ├── README.md
│   ├── README_abstract_class_pure_virtual_methods.md
│   ├── README_constructor_inheritance.md
│   ├── README_encapsulation_local_protected_access.md
│   ├── README_encapsulation_protected_local_access.md
│   ├── README_inheritance_basic.md
│   ├── README_method_overriding_constructor_chaining.md
│   ├── README_polymorphism.md
│   ├── README_polymorphism_without_virtual_function.md
│   ├── README_pure_virtual_polymorshims.md
│   ├── README_virtual_class_runtime_polymorphism_dynamic_casting.md
│   ├── abstract_class_pure_virtual_methods.sv
│   ├── axi_constructor_inheritance.sv
│   ├── axi_inheritance.sv
│   ├── axi_inheritance_polymorphism.sv
│   ├── axi_transaction_polymorphism.sv
│   ├── deep_copy_diagram.svg
│   ├── deep_shallow_copy_README.md
│   ├── encapsulation_local_protected_access.sv
│   ├── encapsulation_protected_local_access.sv
│   ├── inheritance_basic.sv
│   ├── method_overriding_constructor_chaining.sv
│   ├── non_virtual_polymorphism_base_handle.sv
│   ├── polymorphism/
│   │   └── runtime_polymorphism_virtual/
��   │       └── virtual_runtime_polymorphism.sv
│   ├── polymorphism_without_virtual_function.md
│   ├── pure_virtual_polymorshims.sv
│   ├── shallow_deep_copy.sv
│   └── virtual_class_runtime_polymorphism_dynamic_casting.sv
├── weather-dashboard/
│   ├── README.md
│   ├── index.html
│   └── style.css
├── docs/
│   ├── overview/
│   │   ├── project_summary.md
│   │   └── architecture_notes.md
│   ├── examples/
│   │   ├── associative_arrays.md
│   │   ├── queue_design.md
│   │   └── transaction_ordering.md
│   └── references/
│       └── systemverilog_guides.md
├── .gitignore
├── LICENSE
├── CONTRIBUTING.md
└── assets/
    ├── images/
    └── diagrams/
```

## Topics covered

- Associative arrays and sparse data handling
- Queues, FIFOs, and buffering patterns
- Associative queue examples
- Shallow and deep copy behavior in SystemVerilog classes
- Object-oriented programming concepts
- Inheritance, polymorphism, and virtual methods
- Static casting, dynamic casting, enum casting, and up/down casting
- Inter-process synchronization and transaction order modeling

## Organization notes

- Core SystemVerilog learning examples are grouped by concept.
- The `systemverilog/` directory acts as the main learning structure.
- The `oops/` directory contains deeper OOP-focused examples.
- `weather-dashboard/` is kept separate as a front-end/app companion.
- `docs/` is intended for high-level notes, examples, and reference material.

## Quick links

- [Associative Array](systemverilog/associative_array/README.md)
- [Queue](systemverilog/queue/README.md)
- [Associative Queue](systemverilog/associative_queue/README.md)
- [OOP](systemverilog/oop/README.md)
- [OOP Examples](oops/README.md)
- [Shallow / Deep Copy](oops/deep_shallow_copy_README.md)
- [Casting](systemverilog/casting/static_casting/README.md)

