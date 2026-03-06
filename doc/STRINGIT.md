# STRINGIT.CBL - String Manipulation Techniques

## Program Overview
**Program ID:** STRINGIT

This COBOL program demonstrates various techniques for string manipulation and formatting, specifically focusing on formatting a person's name in different ways. It shows multiple approaches from simple MOVE statements to complex STRING operations with INSPECT.

## Purpose
The program demonstrates:
- Basic MOVE statements for string handling
- INSPECT statement for counting characters
- Reference modification (substring operations)
- STRING statement for concatenation
- DELIMITED BY clause variations
- Trailing space removal
- String length calculation
- Multiple formatting approaches

## Data Structures

### Name Components
```cobol
WS-NAME
├── WS-FAMILY-NAME (60 chars) - "Kirk"
├── WS-GIVEN-NAME (60 chars) - "James"
└── WS-MIDDLE-NAME (60 chars) - "Tiberius"
```

### Output Areas
```cobol
WS-NAMES-IN-OUTPUT-ORDER
├── WS-GIVEN-NAME-OUT (60 chars)
├── WS-MIDDLE-NAME-OUT (60 chars)
└── WS-FAMILY-NAME-OUT (60 chars)
```

### Length Tracking
```cobol
WS-NAME-LENGTHS
├── WS-GIVEN-NAME-LENGTH (COMP-3)
├── WS-MIDDLE-NAME-LENGTH (COMP-3)
├── WS-FAMILY-NAME-LENGTH (COMP-3)
└── WS-OUTPUT-LENGTH (COMP-3)
```

### Final Output
```cobol
WS-OUTPUT-AREA (180 chars)
```

## Example 1: Simple MOVE Statements

### Approach
```cobol
MOVE WS-GIVEN-NAME TO WS-GIVEN-NAME-OUT
MOVE WS-MIDDLE-NAME TO WS-MIDDLE-NAME-OUT
MOVE WS-FAMILY-NAME TO WS-FAMILY-NAME-OUT
```

### Result
```
<James                                                       Tiberius                                                    Kirk                                                        >
```

### Characteristics
- **Simplest approach**
- Each field padded to 60 characters
- Total: 180 characters
- Lots of trailing spaces
- Not space-efficient

### Use Case
- When fixed-length fields are required
- Simple data movement
- No formatting needed

## Example 2: INSPECT and Reference Modification

### Step 1: Count Characters
```cobol
INITIALIZE WS-NAME-LENGTHS
INSPECT WS-GIVEN-NAME 
    TALLYING WS-GIVEN-NAME-LENGTH 
    FOR CHARACTERS BEFORE INITIAL SPACE
```
- Counts characters until first space
- "James" → length = 5

### Step 2: Display with Reference Modification
```cobol
DISPLAY 
    '<'
    WS-GIVEN-NAME(1:WS-GIVEN-NAME-LENGTH)
    SPACE 
    WS-MIDDLE-NAME(1:WS-MIDDLE-NAME-LENGTH) 
    SPACE 
    WS-FAMILY-NAME(1:WS-FAMILY-NAME-LENGTH) 
    '>'
```

### Result
```
<James Tiberius Kirk>
```

### Characteristics
- **Space-efficient**
- Exact length extraction
- Manual space insertion
- Requires length calculation
- Good for display

### Reference Modification Syntax
```cobol
field-name(starting-position:length)
```
- Starting position: 1-based
- Length: number of characters
- Example: "James"(1:3) = "Jam"

## Example 3: STRING Statement

### Approach
```cobol
STRING 
    WS-GIVEN-NAME  DELIMITED BY SPACE 
    SPACE          DELIMITED BY SIZE 
    WS-MIDDLE-NAME DELIMITED BY SPACE 
    SPACE          DELIMITED BY SIZE 
    WS-FAMILY-NAME DELIMITED BY SPACE 
    INTO WS-OUTPUT-AREA 
END-STRING
```

### Result
```
<James Tiberius Kirk                                                                                                                                                                    >
```

### Characteristics
- **Automatic space handling**
- DELIMITED BY SPACE stops at first space
- DELIMITED BY SIZE uses entire field
- Concatenates efficiently
- Padded to field length

### DELIMITED BY Variations

**DELIMITED BY SPACE:**
- Stops at first space character
- Extracts only the actual name
- Example: "James     " → "James"

**DELIMITED BY SIZE:**
- Uses entire field length
- Includes all characters
- Example: SPACE (1 char) → " "

## Example 4: Combined Approach (Best Practice)

### Step 1: Calculate Lengths
```cobol
INITIALIZE WS-NAME-LENGTHS    
INSPECT WS-GIVEN-NAME 
    TALLYING WS-GIVEN-NAME-LENGTH 
    FOR CHARACTERS BEFORE INITIAL SPACE 
INSPECT WS-MIDDLE-NAME 
    TALLYING WS-MIDDLE-NAME-LENGTH 
    FOR CHARACTERS BEFORE INITIAL SPACE 
INSPECT WS-FAMILY-NAME 
    TALLYING WS-FAMILY-NAME-LENGTH 
    FOR CHARACTERS BEFORE INITIAL SPACE
```

### Step 2: Build String with Exact Lengths
```cobol
STRING 
    WS-GIVEN-NAME(1:WS-GIVEN-NAME-LENGTH) 
      DELIMITED BY SIZE 
    SPACE DELIMITED BY SIZE 
    WS-MIDDLE-NAME(1:WS-MIDDLE-NAME-LENGTH)
      DELIMITED BY SIZE     
    SPACE DELIMITED BY SIZE 
    WS-FAMILY-NAME(1:WS-FAMILY-NAME-LENGTH) 
      DELIMITED BY SIZE     
    INTO WS-OUTPUT-AREA
END-STRING
```

### Step 3: Calculate Total Length
```cobol
ADD WS-GIVEN-NAME-LENGTH 
    WS-MIDDLE-NAME-LENGTH 
    WS-FAMILY-NAME-LENGTH 
    2                        -- Two spaces
    GIVING WS-OUTPUT-LENGTH 
END-ADD
```

### Step 4: Display Exact Result
```cobol
DISPLAY '<' WS-OUTPUT-AREA(1:WS-OUTPUT-LENGTH) '>'
```

### Result
```
<James Tiberius Kirk>
```

### Characteristics
- **Most efficient**
- Exact length control
- No wasted space
- Combines best of all approaches
- Professional quality

## INSPECT Statement

### Purpose
Count or replace characters in a string

### Syntax for Counting
```cobol
INSPECT source-string
    TALLYING counter
    FOR CHARACTERS BEFORE INITIAL delimiter
```

### How It Works
1. Starts at beginning of string
2. Counts characters
3. Stops at first occurrence of delimiter
4. Stores count in counter

### Example
```
String: "James     "
Counter initialized to: 0
INSPECT counts: J-a-m-e-s (stops at space)
Result: counter = 5
```

### Important Notes
- Counter must be initialized to zero
- BEFORE INITIAL stops at first match
- FOR CHARACTERS counts all characters
- Can also count specific characters

## STRING Statement Details

### Basic Syntax
```cobol
STRING 
    source-1 DELIMITED BY delimiter-1
    source-2 DELIMITED BY delimiter-2
    INTO target
END-STRING
```

### Features
- Concatenates multiple sources
- Each source can have different delimiter
- Automatically handles spacing
- Stops at delimiter or end of field
- Target is not cleared first (should initialize)

### Pointer Option
```cobol
STRING 
    source-1 DELIMITED BY delimiter-1
    INTO target
    WITH POINTER position
END-STRING
```
- Position indicates where to start in target
- Updated after STRING completes
- Useful for multiple STRING operations

### ON OVERFLOW
```cobol
STRING 
    source-1 DELIMITED BY delimiter-1
    INTO target
    ON OVERFLOW
        [error handling]
END-STRING
```
- Triggered if target too small
- Optional error handling

## Comparison of Approaches

| Approach | Efficiency | Complexity | Flexibility | Best For |
|----------|-----------|------------|-------------|----------|
| Example 1 | Low | Low | Low | Fixed formats |
| Example 2 | High | Medium | High | Display only |
| Example 3 | Medium | Low | Medium | Simple concat |
| Example 4 | High | High | High | Production code |

## Use Cases

### Example 1: MOVE
- Database records with fixed fields
- Legacy system interfaces
- Simple data transfer

### Example 2: INSPECT + Reference Modification
- Display formatting
- Report generation
- Screen output

### Example 3: STRING with DELIMITED BY
- Simple concatenation
- Quick formatting
- Prototyping

### Example 4: Combined Approach
- Production applications
- Space-critical systems
- Professional reports
- API responses

## Common Patterns

### Pattern 1: Full Name Formatting
```cobol
STRING 
    LAST-NAME DELIMITED BY SPACE
    ", " DELIMITED BY SIZE
    FIRST-NAME DELIMITED BY SPACE
    INTO FULL-NAME
END-STRING
```
Result: "Kirk, James"

### Pattern 2: Address Formatting
```cobol
STRING 
    STREET DELIMITED BY SPACE
    ", " DELIMITED BY SIZE
    CITY DELIMITED BY SPACE
    ", " DELIMITED BY SIZE
    STATE DELIMITED BY SIZE
    " " DELIMITED BY SIZE
    ZIP DELIMITED BY SIZE
    INTO ADDRESS
END-STRING
```

### Pattern 3: Message Building
```cobol
STRING 
    "Error: " DELIMITED BY SIZE
    ERROR-MESSAGE DELIMITED BY SPACE
    " at line " DELIMITED BY SIZE
    LINE-NUMBER DELIMITED BY SIZE
    INTO ERROR-TEXT
END-STRING
```

## Best Practices

### 1. Initialize Counters
```cobol
INITIALIZE WS-NAME-LENGTHS
```
- Always initialize before INSPECT TALLYING
- Prevents accumulation errors

### 2. Initialize Target
```cobol
MOVE SPACES TO WS-OUTPUT-AREA
```
- Clear target before STRING
- Prevents leftover data

### 3. Calculate Exact Length
```cobol
ADD field-length-1 field-length-2 
    GIVING total-length
```
- Know exact output size
- Efficient memory usage

### 4. Use Reference Modification
```cobol
DISPLAY field(1:actual-length)
```
- Display only needed characters
- Cleaner output

### 5. Choose Right Delimiter
```cobol
DELIMITED BY SPACE  -- For variable content
DELIMITED BY SIZE   -- For fixed content
```

## Performance Considerations

### MOVE
- **Fastest**: Direct memory copy
- **Fixed length**: Always copies full field
- **Use when**: Fixed formats required

### STRING
- **Moderate**: Parsing overhead
- **Variable length**: Stops at delimiter
- **Use when**: Concatenation needed

### INSPECT + Reference Modification
- **Slower**: Two operations
- **Precise**: Exact length control
- **Use when**: Space critical

## Common Mistakes

### Mistake 1: Uninitialized Counter
```cobol
INSPECT field TALLYING counter  -- Counter not initialized!
```
**Fix:**
```cobol
INITIALIZE counter
INSPECT field TALLYING counter
```

### Mistake 2: Uncleared Target
```cobol
STRING source INTO target  -- Target has old data!
```
**Fix:**
```cobol
MOVE SPACES TO target
STRING source INTO target
```

### Mistake 3: Wrong Delimiter
```cobol
STRING field DELIMITED BY SIZE  -- Includes trailing spaces!
```
**Fix:**
```cobol
STRING field DELIMITED BY SPACE  -- Stops at space
```

### Mistake 4: Reference Modification Errors
```cobol
field(1:0)  -- Zero length!
field(100:10)  -- Beyond field size!
```
**Fix:**
```cobol
IF length > 0 AND length <= LENGTH OF field
    DISPLAY field(1:length)
END-IF
```

## Educational Value

This program teaches:
- Multiple string manipulation approaches
- INSPECT statement usage
- STRING statement variations
- Reference modification
- Length calculation
- Space handling
- Efficiency considerations
- Best practices for string formatting

## Real-World Applications

1. **Name Formatting**: Customer records, reports
2. **Address Formatting**: Mailing labels, invoices
3. **Message Building**: Error messages, logs
4. **Data Concatenation**: File records, APIs
5. **Report Generation**: Headers, detail lines
6. **Screen Display**: User interfaces

## Summary

STRINGIT.CBL demonstrates that COBOL provides multiple approaches for string manipulation:

1. **Simple MOVE**: Quick but space-inefficient
2. **INSPECT + Reference Modification**: Precise but requires calculation
3. **STRING with DELIMITED BY**: Automatic but less control
4. **Combined Approach**: Best of all worlds

The **combined approach (Example 4)** is recommended for production code because it:
- Calculates exact lengths
- Uses space efficiently
- Provides precise control
- Produces professional results

This program serves as an excellent reference for string manipulation techniques in COBOL programming.