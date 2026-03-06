# HEX2TEXT.CBL - Binary to Hexadecimal Conversion Utility

## Program Overview
**Program ID:** HEX2TEXT

This COBOL program is a utility subprogram that converts binary data to its hexadecimal text representation. It's designed to be called by other programs to display binary data in a human-readable hexadecimal format.

## Purpose
The program demonstrates:
- Subprogram design with LINKAGE SECTION
- Binary to hexadecimal conversion
- Byte-level data manipulation
- REDEFINES for viewing data differently
- Arithmetic operations for conversion
- Character string manipulation
- Utility program patterns

## Program Type
**Subprogram (Called Program)**
- Not standalone - must be called by another program
- Uses LINKAGE SECTION for parameter passing
- Returns control with GOBACK
- Reusable utility function

## Data Structures

### Working Storage
```cobol
HEXVAL   PIC X(8)     - Temporary hex value storage
HEXSTR   PIC X(16)    - Hex digit lookup: "0123456789ABCDEF"
DEC      PIC S9(4) COMP - Binary value for conversion
FILLER   REDEFINES DEC
    DECBYTE PIC X    - Single byte view of DEC
I, J, Q, R, J1, Q1, R1 - Loop and calculation variables (COMP)
```

### Linkage Section (Parameters)
```cobol
LS-HEX2TEXT-CONVERSION
├── LS-ORIGINAL-LENGTH (COMP)
│   - Number of bytes to convert
├── LS-ORIGINAL-VALUE (120 bytes)
│   - Binary data to convert
└── LS-RESULT (240 bytes)
    - Hexadecimal text output (2 chars per byte)
```

## Conversion Algorithm

### Overview
Each byte (8 bits) converts to 2 hexadecimal digits:
- Byte value 0-255 → "00" to "FF"
- High nibble (4 bits) → First hex digit
- Low nibble (4 bits) → Second hex digit

### Step-by-Step Process

**For each byte in input:**

1. **Extract Byte**
```cobol
MOVE LS-ORIGINAL-VALUE(I:1) TO DECBYTE
```
- Gets one byte from input
- Stores in DECBYTE (redefines DEC)

2. **Calculate Output Position**
```cobol
COMPUTE J = 2 * I - 1
```
- Each input byte produces 2 output characters
- Byte 1 → positions 1-2
- Byte 2 → positions 3-4
- etc.

3. **Divide by 16**
```cobol
DIVIDE DEC BY 16 GIVING Q REMAINDER R
```
- Q = quotient (high nibble, 0-15)
- R = remainder (low nibble, 0-15)
- Example: 175 ÷ 16 = 10 remainder 15 (0xAF)

4. **Calculate Lookup Positions**
```cobol
COMPUTE J1 = J + 1      - Second hex digit position
COMPUTE Q1 = Q + 1      - Quotient lookup index (1-based)
COMPUTE R1 = R + 1      - Remainder lookup index (1-based)
```
- Add 1 because COBOL arrays are 1-based

5. **Lookup Hex Digits**
```cobol
MOVE HEXSTR(Q1:1) TO LS-RESULT(J:1)    - High nibble
MOVE HEXSTR(R1:1) TO LS-RESULT(J1:1)   - Low nibble
```
- Uses HEXSTR as lookup table
- Converts 0-15 to '0'-'9', 'A'-'F'

## Conversion Examples

### Example 1: Byte Value 0
```
Input:  0
Divide: 0 ÷ 16 = 0 remainder 0
Q1 = 1, R1 = 1
HEXSTR(1:1) = '0', HEXSTR(1:1) = '0'
Output: "00"
```

### Example 2: Byte Value 175 (0xAF)
```
Input:  175
Divide: 175 ÷ 16 = 10 remainder 15
Q1 = 11, R1 = 16
HEXSTR(11:1) = 'A', HEXSTR(16:1) = 'F'
Output: "AF"
```

### Example 3: Byte Value 255 (0xFF)
```
Input:  255
Divide: 255 ÷ 16 = 15 remainder 15
Q1 = 16, R1 = 16
HEXSTR(16:1) = 'F', HEXSTR(16:1) = 'F'
Output: "FF"
```

### Example 4: Multi-byte Conversion
```
Input:  [65, 66, 67] ("ABC" in ASCII)
Byte 1: 65 → "41" (A in hex)
Byte 2: 66 → "42" (B in hex)
Byte 3: 67 → "43" (C in hex)
Output: "414243"
```

## REDEFINES Technique

### Purpose
View the same memory location as different data types:

```cobol
01  DEC      PIC S9(4) COMP.
01  FILLER   REDEFINES DEC.
    02  FILLER PIC X.
    02  DECBYTE PIC X.
```

### How It Works
- DEC is a 2-byte binary integer
- DECBYTE redefines the second byte
- Allows byte-level access to binary data

### Memory Layout (Little-endian example)
```
DEC = 375 (0x0177)
┌────────┬────────┐
│ Byte 1 │ Byte 2 │
│  0x77  │  0x01  │
└────────┴────────┘
           ↑
        DECBYTE
```

## Hexadecimal Lookup Table

### HEXSTR Definition
```cobol
HEXSTR PIC X(16) VALUE "0123456789ABCDEF"
```

### Mapping
```
Position:  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
Character: 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
Value:     0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
```

### Usage
- Value 0-15 maps to position 1-16
- Direct lookup: HEXSTR(value+1:1)
- No conditional logic needed
- Efficient conversion

## Loop Structure

```cobol
PERFORM VARYING I FROM 1 BY 1 
        UNTIL I > LS-ORIGINAL-LENGTH
    [conversion logic]
END-PERFORM
```

- Processes each byte sequentially
- I = current byte position (1-based)
- Continues until all bytes processed

## Calling Convention

### From Calling Program
```cobol
01  WS-HEX2TEXT-CONVERSION.
    05  WS-ORIGINAL-LENGTH     PIC S9(09) COMP.
    05  WS-ORIGINAL-VALUE      PIC X(120).
    05  WS-RESULT              PIC X(240).

MOVE binary-data TO WS-ORIGINAL-VALUE
MOVE length-of-data TO WS-ORIGINAL-LENGTH
CALL 'HEX2TEXT' USING WS-HEX2TEXT-CONVERSION
DISPLAY WS-RESULT(1:WS-ORIGINAL-LENGTH * 2)
```

### Parameter Structure
- Single group item passed by reference
- Caller prepares input fields
- Subprogram fills result field
- Caller displays/uses result

## Use Cases

This utility is useful for:
- Debugging binary data
- Displaying packed decimal fields
- Showing COMP fields in readable format
- Memory dumps
- Data validation
- File format analysis
- Troubleshooting data corruption

## Technical Notes

### Binary Integer (COMP)
- Platform-dependent representation
- Typically 2 or 4 bytes
- Efficient for arithmetic
- Used for all loop counters

### Reference Modification
```cobol
field-name(start:length)
```
- Extracts substring
- Used for both input and output
- 1-based positioning

### DIVIDE with REMAINDER
```cobol
DIVIDE dividend BY divisor 
    GIVING quotient 
    REMAINDER remainder
```
- Single operation gets both results
- Efficient for conversion
- No separate modulo operation needed

## Performance Considerations

### Efficiency
- Simple arithmetic operations
- Direct table lookup (no searching)
- Single pass through data
- Minimal memory usage

### Limitations
- Maximum input: 120 bytes
- Maximum output: 240 characters
- Fixed-size buffers
- No dynamic allocation

## Potential Enhancements

1. **Variable Buffer Size**: Use OCCURS DEPENDING ON
2. **Error Checking**: Validate input length
3. **Lowercase Option**: Support 'a'-'f' output
4. **Formatting**: Add spaces between bytes
5. **Reverse Function**: Hex to binary conversion
6. **Address Display**: Show byte offsets

## Educational Value

This program teaches:
- Subprogram design patterns
- LINKAGE SECTION usage
- Binary to hex conversion algorithm
- REDEFINES for type conversion
- Byte-level data manipulation
- Lookup table techniques
- Reference modification
- Utility program structure

## Comparison with Other Languages

### C Equivalent:
```c
void hex2text(int length, unsigned char *input, char *output) {
    const char *hex = "0123456789ABCDEF";
    for (int i = 0; i < length; i++) {
        output[i*2] = hex[input[i] >> 4];
        output[i*2+1] = hex[input[i] & 0x0F];
    }
}
```

### Python Equivalent:
```python
def hex2text(data):
    return data.hex().upper()
```

COBOL's approach is more verbose but provides explicit control over the conversion process.

## Integration Example

### Used by MOVEME.CBL
```cobol
MOVE WS-BINARY-ITEM-4-AS-TEXT TO WS-ORIGINAL-VALUE
MOVE LENGTH OF WS-BINARY-ITEM-4 TO WS-ORIGINAL-LENGTH
CALL 'HEX2TEXT' USING WS-HEX2TEXT-CONVERSION
DISPLAY 'Hex value: ' WS-RESULT(1:WS-ORIGINAL-LENGTH * 2)
```

This shows how the utility integrates into larger programs for debugging and display purposes.

## Summary

HEX2TEXT.CBL is a well-designed utility subprogram that:
- Converts binary data to hexadecimal text
- Uses efficient lookup table approach
- Demonstrates proper subprogram structure
- Provides reusable functionality
- Serves as a debugging aid

It's an essential tool for any COBOL development environment where binary data needs to be examined or displayed.