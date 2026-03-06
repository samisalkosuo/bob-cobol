# bob-cobol

COBOL source code examples with comprehensive documentation.

## Overview

This repository contains 15 COBOL programs demonstrating various programming concepts, techniques, and best practices. Each program has been thoroughly analyzed and documented.

## Directory Structure

```
bob-cobol/
├── src/          # COBOL source files (.CBL)
├── doc/          # Documentation files (.md)
└── README.md     # This file
```

## Programs and Documentation

All COBOL source files have been documented with detailed explanations. Documentation files are located in the `doc/` directory.

### 1. [ATTRACT.CBL](doc/ATTRACT.md) - Gravitational Attraction Calculator
Calculates gravitational force between two celestial bodies using Newton's law of universal gravitation. Demonstrates scientific computing, floating-point arithmetic, and mathematical functions in COBOL.

### 2. [BRAKES.CBL](doc/BRAKES.md) - Brake Temperature Calculator
Calculates temperature increase in vehicle brakes due to energy dissipation. Demonstrates physics calculations and energy/heat transfer principles.

### 3. [COND88.CBL](doc/COND88.md) - Level 88 Condition Names
Comprehensive demonstration of level 88 condition names for creating boolean-like flags and enumerated types in COBOL.

### 4. [CPSEQFR.CBL](doc/CPSEQFR.md) - Sequential File Copy (Fixed-Length)
Demonstrates sequential file processing with fixed-length records, including field reordering and file status checking.

### 5. [CPSEQVR.CBL](doc/CPSEQVR.md) - Sequential File Copy (Variable-Length)
Shows variable-length record processing with OCCURS DEPENDING ON and dynamic record size handling.

### 6. [DATE1.CBL](doc/DATE1.md) - Date Formatting (CURRENT-DATE)
Demonstrates date and time formatting using the CURRENT-DATE intrinsic function, including multiple international date formats.

### 7. [DATE2.CBL](doc/DATE2.md) - Date Formatting (ACCEPT)
Shows traditional date/time handling using ACCEPT statements, including day-of-week and Julian date formats.

### 8. [HELLO.CBL](doc/HELLO.md) - Interactive Greeting Program
Simple but elegant interactive program demonstrating string manipulation, user input handling, and trailing space removal.

### 9. [HEX2TEXT.CBL](doc/HEX2TEXT.md) - Binary to Hexadecimal Converter
Utility subprogram that converts binary data to hexadecimal text representation. Essential for debugging and data visualization.

### 10. [IFEVAL.CBL](doc/IFEVAL.md) - Conditional Logic Demonstration
Comprehensive tutorial on IF statements, EVALUATE statements, and comparison operators in COBOL.

### 11. [INVCALC.CBL](doc/INVCALC.md) - Invoice Calculator
Complete invoice processing system with sales tax calculations, demonstrating complex data structures and business logic.

### 12. [MOVEME.CBL](doc/MOVEME.md) - MOVE Statement and Data Types
Comprehensive demonstration of MOVE statement behavior with various COBOL data types (COMP, COMP-3, COMP-1, COMP-2, DISPLAY).

### 13. [NOTBOOL.CBL](doc/NOTBOOL.md) - Boolean Flag Patterns
Shows various patterns for implementing boolean (true/false) logic in COBOL, which lacks a native boolean data type.

### 14. [REFORMER.CBL](doc/REFORMER.md) - Data Transformation
Demonstrates data format conversion, date reformatting, SKU lookup, and field reordering for data integration.

### 15. [STRINGIT.CBL](doc/STRINGIT.md) - String Manipulation
Shows multiple techniques for string manipulation and formatting, from simple MOVE statements to complex STRING operations.

## Documentation Features

Each documentation file includes:

- **Program Overview** - Purpose and high-level description
- **Data Structures** - Detailed explanation of data organization
- **Program Flow** - Step-by-step execution logic
- **Code Examples** - Annotated code snippets
- **Key Concepts** - Important techniques demonstrated
- **Use Cases** - Real-world applications
- **Educational Value** - Learning objectives
- **Best Practices** - Professional coding patterns
- **Technical Notes** - Implementation details
- **Potential Improvements** - Enhancement suggestions

## Topics Covered

### Data Types and Storage
- Binary integers (COMP)
- Packed decimal (COMP-3)
- Floating-point (COMP-1, COMP-2)
- Display numeric formats
- Alphanumeric data

### File Processing
- Sequential file I/O
- Fixed-length records
- Variable-length records
- File status checking
- Record transformation

### String Manipulation
- MOVE statements
- STRING statement
- UNSTRING statement
- INSPECT statement
- Reference modification

### Control Structures
- IF statements
- EVALUATE statements
- PERFORM loops
- Condition names (level 88)

### Advanced Features
- Table lookups (SEARCH)
- OCCURS DEPENDING ON
- Subprogram calls
- Date/time functions
- Mathematical functions

### Business Applications
- Invoice processing
- Sales tax calculation
- Data validation
- Format conversion
- Report generation

## Getting Started

1. Browse the `src/` directory to see the COBOL source files
2. Read the corresponding documentation in the `doc/` directory
3. Each `.md` file provides comprehensive explanation of its corresponding `.CBL` file

## Educational Use

These programs serve as:
- Learning resources for COBOL programming
- Reference implementations of common patterns
- Examples of best practices
- Templates for similar applications
- Study materials for COBOL concepts

## Documentation Quality

All documentation includes:
- Clear explanations suitable for beginners
- Technical depth for experienced programmers
- Code examples with annotations
- Comparison with other programming languages
- Common pitfalls and how to avoid them
- Performance considerations
- Real-world use cases

## Contributing

This is a documentation project. The COBOL source files are provided as-is for educational purposes.

## License

Educational and reference use.

---

**Note**: All 15 COBOL programs have been fully documented with comprehensive markdown files in the `doc/` directory.