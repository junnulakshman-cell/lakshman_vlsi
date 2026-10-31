# Constraints Randomizations Verifications

This folder is reserved for SystemVerilog constraint-random verification (CRV) examples, validation patterns, and verification-related notes for the `systemverilog` section of the repository.

## Contents

This folder is intended to hold examples and reference material related to:

- constrained-random stimulus generation
- legal vs illegal value selection
- fault injection and post-randomization mutation
- array size and domain constraints
- mode selection, uniqueness, and cross-constraints
- verification checks and result reporting

## Typical topics covered

- `rand` / `randc` usage
- `inside`, `unique`, and `dist` constraints
- `foreach` indexing rules and modulo-based channel mapping
- array reduction constraints such as `sum() with (...)`
- `post_randomize()` validation and debug printing
- legal baseline generation followed by injected error cases

## Example usage

This folder can contain focused CRV examples such as:

- multi-channel signal scheduler generation
- memory burst transaction generation
- fault injection patterns
- verification-only stimulus self-checks

## Repository organization

The parent `systemverilog` directory already contains topic-based folders such as:

- casting
- oop
- queue
- task_lifetime
- associative_array
- static_properties_methods

This new folder keeps the randomization and verification material grouped together for easier navigation.

---

This folder was added to support the CRV and verification examples discussed in the repository documentation and SystemVerilog stimulus-generation examples.
