# Runtime Polymorphism Using Virtual Methods

## Overview

This example demonstrates runtime polymorphism in SystemVerilog using a parent handle and a derived object. It shows how virtual methods allow method dispatch to resolve according to the actual object type at runtime.

## File

- `virtual_runtime_polymorphism.sv`

## Example summary

The base class defines a virtual method. The derived class overrides it. A handle of the base type points to the derived object, and the overridden implementation is selected dynamically at runtime.

## Why this matters

This is the standard pattern used in reusable class hierarchies and verification environments, including UVM.
