# MOVEME.CBL - MOVE Statement and Data Type Demonstration

## Program Overview
**Program ID:** MOVEME

This COBOL program provides a comprehensive demonstration of the MOVE statement and various COBOL data types. It shows how data is stored internally in different formats and how MOVE operations affect binary, packed decimal, floating-point, and display data types.

## Purpose
The program demonstrates:
- MOVE statement behavior with different data types
- Internal representation of various COBOL data types
- Binary (COMP) data storage
- Packed decimal (COMP-3) data storage
- Floating-point (COMP-1, COMP-2) data storage
- Display numeric formats
- INITIALIZE statement
- Hexadecimal display of internal data
- Calling the HEX2TEXT subprogram

## Data Types Demonstrated

### 1. Binary Integer (COMP)
```cobol
WS-BINARY-ITEM-4    PIC S9(09) COMP  -- 4-byte binary
WS-BINARY-ITEM-8    PIC S9(16) COMP  -- 8-byte binary
```
- Platform-dependent representation
- Efficient for arithmetic
- Stored in binary format

### 2. Packed Decimal (COMP-3)
```cobol
WS-PACKED-DECIMAL-ITEM  PIC S9(04)V9(03) COMP-3
```
- Two digits per byte
- Sign in last nibble
- Exact decimal arithmetic

### 3. Single-Precision Float (COMP-1)
```cobol
WS-SINGLE-PRECISION  COMP-1
```
- 4 bytes (32 bits)
- IEEE 754 format (typically)
- Scientific notation support

### 4. Double-Precision Float (COMP-2)
```cobol
WS-DOUBLE-PRECISION  COMP-2
```
- 8 bytes (64 bits)
- IEEE 754 format (typically)
- Higher precision than COMP-1

### 5. Display Numeric
```cobol
WS-DISPLAY-NUMERIC-SIGNED    PIC S9(05)V9(02)
WS-DISPLAY-NUMERIC-UNSIGNED  PIC 9(05)
WS-DISPLAY-NUMERIC-FORMATTED PIC -ZZ,ZZ9.99
WS-DISPLAY-CURRENCY-VALUE    PIC -$$,$$9.99
```
- Character representation
- Human-readable
- One byte per digit

## Program Flow

### Example 1: Text Value
```cobol
MOVE 'Repent, Harlequin!' TO WS-ORIGINAL-VALUE
```
**Output:**
```
Text value: "Repent, Harlequin!"
```
- Shows alphanumeric data storage
- ASCII or EBCDIC depending on platform

### Example 2: 4-Byte Binary Integer
```cobol
MOVE 375502 TO WS-BINARY-ITEM-4
```
**Hex Output (Little-endian):**
```
Hex value: 6EBA0500
```
**Breakdown:**
- 375502 decimal = 0x0005BA6E
- Stored little-endian: 6E BA 05 00

### Example 3: 8-Byte Binary Integer
```cobol
MOVE -281064762375502 TO WS-BINARY-ITEM-8
```
**Hex Output:**
```
Hex value: 42BAFEFFFFFF00FF
```
- Negative number in two's complement
- 8-byte storage

### Example 4: MOVE SPACES to Binary
```cobol
MOVE SPACES TO WS-BINARY-ITEM-4-AS-TEXT
```
**Hex Output:**
```
Hex value: 20202020 (ASCII) or 40404040 (EBCDIC)
```
- Shows what happens when moving non-numeric to numeric field
- Space character repeated
- Creates invalid numeric data

### Example 5: Single-Precision Float
```cobol
MOVE 06.23E-24 TO WS-SINGLE-PRECISION
```
**Hex Output:**
```
Hex value: [IEEE 754 representation]
```
- Scientific notation: 6.23 × 10⁻²⁴
- Stored in IEEE 754 format
- 4 bytes

### Example 6: Double-Precision Float
```cobol
MOVE 3246.16E-32 TO WS-DOUBLE-PRECISION
```
**Hex Output:**
```
Hex value: [IEEE 754 representation]
```
- Scientific notation: 3246.16 × 10⁻³²
- Stored in IEEE 754 format
- 8 bytes

### Example 7: Packed Decimal
```cobol
MOVE -256.095 TO WS-PACKED-DECIMAL-ITEM
```
**Hex Output:**
```
Hex value: 0256095D
```
**Breakdown:**
- PIC S9(04)V9(03) COMP-3
- Digits: 0256095
- Sign: D (negative)
- Format: 02 56 09 5D

### Example 8: MOVE SPACES to Packed Decimal
```cobol
MOVE SPACES TO WS-PACKED-DECIMAL-ITEM-AS-TEXT
```
**Hex Output:**
```
Hex value: 20202020 (ASCII) or 40404040 (EBCDIC)
```
- Overwrites packed decimal with spaces
- Creates invalid packed decimal data

### Example 9: Display Numeric Signed
```cobol
MOVE -4832.61 TO WS-DISPLAY-NUMERIC-SIGNED
```
**Result:**
```
Result: -4832.61
```
- PIC S9(05)V9(02)
- Character representation
- Sign displayed

### Example 10: Display Numeric Formatted
```cobol
MOVE -4832.61 TO WS-DISPLAY-NUMERIC-FORMATTED
```
**Result:**
```
Result: -4,832.61
```
- PIC -ZZ,ZZ9.99
- Zero suppression
- Comma separator
- Negative sign

### Example 11: Currency Format
```cobol
MOVE -4832.61 TO WS-DISPLAY-CURRENCY-VALUE
```
**Result:**
```
Result: -$4,832.61
```
- PIC -$$,$$9.99
- Dollar sign
- Formatted for currency

### Example 13: INITIALIZE Group Item
```cobol
INITIALIZE WS-GROUP-ITEM
    REPLACING ALPHANUMERIC DATA BY SPACES
              NUMERIC DATA BY ZEROES
```
**Hex Output:**
```
[Shows spaces for alphanumeric, zeros for numeric]
```
- Selective initialization
- Different values for different types

### Example 14: MOVE SPACES to Group Item
```cobol
MOVE SPACES TO WS-GROUP-ITEM
```
**Hex Output:**
```
[Shows all spaces]
```
- Treats entire group as alphanumeric
- Overwrites all fields with spaces
- May corrupt numeric fields

## Key Concepts

### MOVE Statement Behavior

**Alphanumeric to Alphanumeric:**
- Left-justified
- Padded with spaces on right
- Truncated if too long

**Numeric to Numeric:**
- Aligned on decimal point
- Zero-filled as needed
- Converted between formats

**Alphanumeric to Numeric:**
- Dangerous - may create invalid data
- Should validate first
- Example 4 and 8 show this

**Numeric to Alphanumeric:**
- Converts to character representation
- May lose formatting

### Data Type Storage

**COMP (Binary):**
- Native machine format
- Fast arithmetic
- Platform-dependent byte order

**COMP-3 (Packed Decimal):**
- Two digits per byte
- Sign in last nibble
- Portable across platforms
- Exact decimal arithmetic

**COMP-1/COMP-2 (Floating-Point):**
- IEEE 754 format (usually)
- Scientific notation
- Approximate values
- Good for very large/small numbers

**DISPLAY:**
- Character format
- One byte per digit
- Human-readable
- Slower arithmetic

### INITIALIZE vs MOVE

**INITIALIZE:**
```cobol
INITIALIZE group-item
    REPLACING ALPHANUMERIC DATA BY SPACES
              NUMERIC DATA BY ZEROES
```
- Type-aware initialization
- Different values for different types
- Safer for mixed groups

**MOVE SPACES:**
```cobol
MOVE SPACES TO group-item
```
- Treats entire group as alphanumeric
- All fields get spaces
- May corrupt numeric fields

## Hexadecimal Display

### Purpose
Shows internal representation of data:
- Debugging
- Understanding storage formats
- Verifying data integrity
- Learning data types

### Using HEX2TEXT
```cobol
MOVE data TO WS-ORIGINAL-VALUE
MOVE LENGTH OF data TO WS-ORIGINAL-LENGTH
CALL 'HEX2TEXT' USING WS-HEX2TEXT-CONVERSION
DISPLAY WS-RESULT(1:WS-ORIGINAL-LENGTH * 2)
```

## Packed Decimal Format

### Structure
```
Digits: D1 D2 D3 D4 ... Dn S
```
- Each byte holds 2 digits (nibbles)
- Last nibble is sign
- Sign codes: C=+, D=-, F=unsigned

### Example: -256.095
```
PIC S9(04)V9(03) COMP-3
Value: -256.095
Digits: 0256095
Hex: 02 56 09 5D
     │  │  │  └─ 5 and D (negative sign)
     │  │  └──── 0 and 9
     │  └─────── 5 and 6
     └────────── 0 and 2
```

## Binary Integer Format

### Little-Endian Example
```
Value: 375502 (decimal)
Hex: 0x0005BA6E
Storage: 6E BA 05 00
         └──┴──┴──┴── Least significant byte first
```

### Big-Endian Example
```
Value: 375502 (decimal)
Hex: 0x0005BA6E
Storage: 00 05 BA 6E
         └──┴──┴──┴── Most significant byte first
```

## Picture Clause Formatting

### Zero Suppression (Z)
```cobol
PIC ZZ,ZZ9.99
```
- Leading zeros become spaces
- Example: 0012.34 → "   12.34"

### Dollar Sign ($)
```cobol
PIC $$,$$9.99
```
- Floating dollar sign
- Example: 12.34 → "   $12.34"

### Minus Sign (-)
```cobol
PIC -ZZ,ZZ9.99
```
- Leading minus for negative
- Example: -12.34 → "-   12.34"

## Group Item Structure

```cobol
WS-GROUP-ITEM
├── WS-ALPHA-FIELD-1 (PIC X(05))
├── WS-PACKED-FIELD-2 (PIC S9(05) COMP-3)
├── WS-BOOLEAN-FIELD-3 (PIC X)
│   ├── 88 IT-IS-NOT-SO (VALUE SPACES)
│   └── 88 IT-IS-SO (VALUE 'T')
├── WS-TABLE-SIZE (PIC S9(3) COMP-3)
└── WS-TABLE-4 (OCCURS 1 TO 4 DEPENDING ON WS-TABLE-SIZE)
```

## Educational Value

This program teaches:
- Internal data representation
- MOVE statement behavior
- Data type characteristics
- Storage formats
- Hexadecimal interpretation
- INITIALIZE vs MOVE
- Picture clause formatting
- Calling subprograms
- Debugging techniques

## Best Practices

1. **Use Appropriate Types:**
   - COMP-3 for financial data
   - COMP for counters/indexes
   - DISPLAY for user-facing data

2. **Avoid Type Mismatches:**
   - Don't MOVE alphanumeric to numeric
   - Validate data before conversion

3. **Use INITIALIZE:**
   - Safer than MOVE SPACES for groups
   - Type-aware initialization

4. **Format for Display:**
   - Use picture clauses for output
   - Keep internal data unformatted

## Common Pitfalls

1. **MOVE SPACES to Numeric:**
   - Creates invalid data
   - Causes arithmetic errors

2. **Endianness Issues:**
   - Binary data not portable
   - Use COMP-3 for portability

3. **Floating-Point Precision:**
   - Approximate values
   - Not suitable for financial data

4. **Group MOVE:**
   - Treats group as alphanumeric
   - May corrupt numeric fields

## Summary

MOVEME.CBL is an invaluable educational program that:
- Demonstrates all major COBOL data types
- Shows internal data representation
- Explains MOVE statement behavior
- Provides hexadecimal visualization
- Teaches data type selection
- Illustrates formatting techniques

It serves as a comprehensive reference for understanding how COBOL stores and manipulates data internally.