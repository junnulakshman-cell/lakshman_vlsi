# Lakshman VLSI – SystemVerilog Examples

This repository contains a practical collection of SystemVerilog examples covering design, verification, class-based modeling, casting, synchronization, transaction modeling, and randomized constraint-based test generation.

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
│   └── downcasting_example.sv
├── enum_casting/
│   ├── README.md
│   └── enum_casting.sv
├── inter_process_sychronization/
│   ├── README.md
│   ├── disable_fork.sv
│   ├── disable_fork/
│   │   ├── README.md
│   │   └── disable_fork.sv
│   ├── event_chaining.sv
│   ├── event_chaining/
│   │   ├── README.md
│   │   └── event_chaining.sv
│   ├── event_synchronization.sv
│   ├── event_synchronization/
│   │   ├── README.md
│   │   └── event_synchronization.sv
│   ├── fork_join_constructs.sv
│   ├── fork_join_constructs/
│   │   ├── README.md
│   │   └── fork_join_constructs.sv
│   ├── inter_process_sychronization.sv
│   ├── semaphore_synchronization.sv
│   ├── semaphore_synchronization/
│   │   ├── README.md
│   │   └── semaphore_synchronization.sv
│   ├── shared_bus_arbitration.sv
│   ├── shared_bus_arbitration/
│   │   ├── README.md
│   │   └── shared_bus_arbitration.sv
│   ├── uvm_style_synchronization.sv
│   └── uvm_style_synchronization/
│       ├── README.md
│       └── uvm_style_synchronization.sv
├── inter_process_syncrospthons/
│   └── inter_process_syncrospthons.sv
├── static_casting/
│   ├── README.md
│   └── static_casting_example.sv
├── upcasting_downcasting/
│   ├── README.md
│   └── upcasting_example.sv
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
│   ├── handle_assignment_diagram.svg
│   ├── inheritance_basic.sv
│   ├── method_overriding_constructor_chaining.sv
│   ├── non_virtual_polymorphism_base_handle.sv
│   ├── polymorphism/
│   │   └── runtime_polymorphism_virtual/
│   │       └── virtual_runtime_polymorphism.sv
│   ├── polymorphism_without_virtual_function.md
│   ├── pure_virtual_polymorshims.sv
│   ├── shallow_deep_copy.sv
│   └── virtual_class_runtime_polymorphism_dynamic_casting.sv
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
│   ├── constraints_randomzations verfincations/
│   │   ├── README.md
│   │   ├── Memory_Burst_Transaction.sv
│   │   ├── Memory_Burst_Transaction_README.md
│   │   ├── Multi_Channel_Signal_Scheduler_Corrected.sv
│   │   ├── README_01_Four_Channels_16_Samples.md
│   │   ├── README_02_Sixteen_Independent_Records.md
│   │   ├── README_03_SystemVerilog_CRV_Constraints_Guide.md
│   │   └── SystemVerilog_CRV_Three_Error_Injection_Methods_README.md
│   ├── inter_process synchronization/
│   │   └── inter_process_synchronization.sv
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
├── weather-dashboard/
│   ├── README.md
│   ├── index.html
│   └── style.css
└── docs/
    ├── overview/
    │   ├── project_summary.md
    │   └── architecture_notes.md
    ├── examples/
    │   ├── associative_arrays.md
    │   ├── queue_design.md
    │   └── transaction_ordering.md
    └── references/
        └── systemverilog_guides.md
```

## Topics covered

- Associative arrays and sparse memory-style modeling
- Queues, FIFOs, and AXI-style buffering logic
- Object-oriented programming in SystemVerilog
- Class inheritance, polymorphism, encapsulation, and method overriding
- Static, dynamic, enum, and up/down casting
- Shallow vs. deep copy and handle assignment behavior
- Inter-process synchronization using events, semaphores, disable_fork, and fork/join
- Shared-bus arbitration and UVM-style synchronization patterns
- Randomization, constraints, and verification-oriented CRV examples
- Task lifetime and static property/method usage
- Transaction ordering and verification examples

## Important notes

- This repo contains both core learning examples and advanced verification content.
- Some folder names include historical spelling variations such as `inter_process_sychronization` and `constraints_randomzations verfincations` and are kept as-is for continuity.
- The `systemverilog/` directory is the main conceptual grouping for tutorials and examples.
- The `oops/` directory extends the OOP learning track with more detailed examples.
- `weather-dashboard/` is a separate front-end companion app and is not part of the RTL core.

## Quick links

- [Associative Array](systemverilog/associative_array/README.md)
- [Queue](systemverilog/queue/README.md)
- [Associative Queue](systemverilog/associative_queue/README.md)
- [OOP](systemverilog/oop/README.md)
- [OOP Examples](oops/README.md)
- [Shallow / Deep Copy](oops/deep_shallow_copy_README.md)
- [Casting](systemverilog/casting/static_casting/README.md)
- [Inter-process Synchronization](inter_process_sychronization/README.md)
- [Constraints and Randomization](systemverilog/constraints_randomzations%20verfincations/README.md)
- [Task Lifetime](systemverilog/task_lifetime/README.md)

