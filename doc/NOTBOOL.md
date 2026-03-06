# NOTBOOL.CBL - Boolean Flag Patterns in COBOL

## Program Overview
**Program ID:** NOTBOOL

This COBOL program demonstrates various patterns for implementing boolean (true/false) logic in COBOL, which doesn't have a native boolean data type. It shows different approaches to creating and manipulating flag variables.

## Purpose
The program demonstrates:
- Boolean flag implementation patterns
- Various true/false value conventions
- Flag testing and toggling
- Level 88 condition names for boolean logic
- Different data types for flags (alphanumeric, numeric)
- Comparison-based boolean logic
- EVALUATE statement with flags

## Boolean Flag Patterns

### Pattern 1: Simple Character Flag
```cobol
EX2-FLAG                 PIC X VALUE SPACE
EX2-TRUE-VALUE           PIC X VALUE 'T'
```
**Convention:**
- Space = False
- 'T' = True

**Usage:**
```cobol
MOVE EX2-TRUE-VALUE TO EX2-FLAG 
IF EX2-FLAG EQUAL EX2-TRUE-VALUE 
    MOVE 'true' TO THE-ANSWER 
END-IF
```

**Toggle:**
```cobol
IF EX2-FLAG EQUAL EX2-TRUE-VALUE 
    MOVE SPACE TO EX2-FLAG 
ELSE  
    MOVE EX2-TRUE-VALUE TO EX2-FLAG 
END-IF
```

### Pattern 2: Yes/No Flag
```cobol
EX3-FLAG                 PIC X VALUE 'N'
EX3-YES-VALUE            PIC X VALUE 'Y'
```
**Convention:**
- 'N' = No (False)
- 'Y' = Yes (True)

**Usage:**
```cobol
MOVE EX3-YES-VALUE TO EX3-FLAG 
IF EX3-FLAG EQUAL EX3-YES-VALUE 
    MOVE 'yes' TO THE-ANSWER 
END-IF
```

**Negation Test:**
```cobol
if ex3-flag not equal ex3-yes-value 
    move 'no' to the-answer
```

### Pattern 3: 1/0 Flag
```cobol
EX4-FLAG                  PIC X VALUE '1'
EX4-TRUE-VALUE            PIC X VALUE '1'
EX4-FALSE-VALUE           PIC X VALUE '0'
```
**Convention:**
- '0' = False
- '1' = True

**Usage with EVALUATE:**
```cobol
EVALUATE TRUE
    WHEN EX4-FLAG EQUAL EX4-TRUE-VALUE
       MOVE 'true' TO THE-ANSWER 
    WHEN EX4-FLAG EQUAL EX4-FALSE-VALUE   
       MOVE 'false' TO THE-ANSWER  
    WHEN OTHER
       MOVE 'not set' TO THE-ANSWER
END-EVALUATE
```

**Toggle:**
```cobol
IF EX4-FLAG EQUAL EX4-TRUE-VALUE 
    MOVE EX4-FALSE-VALUE TO EX4-FLAG 
ELSE 
    MOVE EX4-TRUE-VALUE TO EX4-FLAG 
END-IF
```

### Pattern 4: Level 88 Condition Name (Simple)
```cobol
EX5-FIELD                 PIC X
    88  EX5-FLAG          VALUE 'T'
```
**Convention:**
- 'T' = True
- Anything else = False

**Usage:**
```cobol
SET EX5-FLAG TO TRUE 
if Ex5-Flag 
    move 'true' to The-Answer 
end-if
```

**Toggle:**
```cobol
IF EX5-FLAG  
    MOVE SPACE TO EX5-FIELD 
ELSE     
    SET EX5-FLAG TO TRUE
END-IF
```

### Pattern 5: Level 88 with FALSE Value
```cobol
FILLER                    PIC X
    88  EX6-FLAG          VALUE 'T', FALSE 'F'
```
**Convention:**
- 'T' = True
- 'F' = False

**Usage:**
```cobol
SET EX6-FLAG TO TRUE 
if Ex6-Flag 
    move 'true' to The-Answer 
end-if
```

**Toggle:**
```cobol
IF EX6-FLAG  
    SET EX6-FLAG TO FALSE 
ELSE     
    SET EX5-FLAG TO TRUE
END-IF
```

### Pattern 6: Numeric Flag
```cobol
EX7-FLAG                  PIC S9 COMP-3 VALUE -1
EX7-TRUE                  PIC S9 COMP-3 VALUE 1
EX7-FALSE                 PIC S9 COMP-3 VALUE -1
```
**Convention:**
- -1 = False
- 1 = True

**Usage:**
```cobol
MOVE EX7-TRUE TO EX7-FLAG 
if EX7-FLAG EQUAL EX7-TRUE 
    MOVE 'true' TO THE-ANSWER 
END-IF
```

**Toggle (Arithmetic):**
```cobol
COMPUTE EX7-FLAG = EX7-FLAG * -EX7-FLAG
```
- If flag = 1: 1 × -1 = -1 (toggles to false)
- If flag = -1: -1 × -(-1) = -1 × 1 = -1 (stays false - bug!)

## Comparison of Patterns

| Pattern | Data Type | True Value | False Value | Level 88 | Toggle Method |
|---------|-----------|------------|-------------|----------|---------------|
| 1 | PIC X | 'T' | SPACE | No | IF-ELSE |
| 2 | PIC X | 'Y' | 'N' | No | IF-ELSE |
| 3 | PIC X | '1' | '0' | No | IF-ELSE |
| 4 | PIC X | 'T' | Other | Yes | IF-ELSE |
| 5 | PIC X | 'T' | 'F' | Yes (with FALSE) | SET |
| 6 | PIC S9 COMP-3 | 1 | -1 | No | COMPUTE |

## Advantages and Disadvantages

### Pattern 1: Space/T
**Advantages:**
- Simple
- Space is default initialization
- Clear true value

**Disadvantages:**
- No explicit false value
- Space might be ambiguous

### Pattern 2: Y/N
**Advantages:**
- Self-documenting (Yes/No)
- Both values explicit
- Common convention

**Disadvantages:**
- Requires explicit initialization
- No level 88 support shown

### Pattern 3: 1/0
**Advantages:**
- Numeric-like (familiar to programmers)
- Both values explicit
- Works well with EVALUATE

**Disadvantages:**
- Character type (not numeric)
- Requires comparison constants

### Pattern 4: Level 88 (Simple)
**Advantages:**
- Clean syntax: `IF EX5-FLAG`
- SET statement: `SET EX5-FLAG TO TRUE`
- Self-documenting

**Disadvantages:**
- No explicit FALSE value
- Toggle requires field access

### Pattern 5: Level 88 with FALSE
**Advantages:**
- Clean syntax for both true and false
- `SET flag TO TRUE` and `SET flag TO FALSE`
- Most COBOL-like approach
- Self-documenting

**Disadvantages:**
- Slightly more complex definition
- Requires understanding of FALSE clause

### Pattern 6: Numeric
**Advantages:**
- Arithmetic operations possible
- Efficient storage (COMP-3)
- Can use in calculations

**Disadvantages:**
- Less readable
- Toggle logic complex
- Bug in example (toggle doesn't work correctly)

## Best Practices

### 1. Use Level 88 with FALSE
```cobol
05  FLAG-FIELD           PIC X.
    88  FLAG-IS-TRUE     VALUE 'T', FALSE 'F'.
```
**Reasons:**
- Most readable
- Proper COBOL idiom
- Easy to test and set
- Self-documenting

### 2. Consistent Naming
```cobol
88  IS-ACTIVE           VALUE 'Y', FALSE 'N'.
88  HAS-ERROR           VALUE 'Y', FALSE 'N'.
88  RECORD-FOUND        VALUE 'Y', FALSE 'N'.
```
- Use IS-, HAS-, or verb prefixes
- Makes conditions read like English

### 3. Initialize Properly
```cobol
05  FLAG-FIELD           PIC X VALUE 'N'.
    88  FLAG-IS-TRUE     VALUE 'Y', FALSE 'N'.
```
- Always provide initial value
- Usually initialize to false

### 4. Document Convention
```cobol
*> Boolean flags use Y/N convention
*> Y = True, N = False
```

## Common Mistakes

### Mistake 1: Uninitialized Flags
```cobol
05  FLAG                 PIC X.
```
- Contains unpredictable value
- Should initialize: `VALUE 'N'` or `VALUE SPACE`

### Mistake 2: Inconsistent Values
```cobol
MOVE 'Y' TO FLAG
...
IF FLAG = 'T'  -- Wrong! Looking for 'T' but set to 'Y'
```

### Mistake 3: No FALSE Value
```cobol
88  IS-VALID            VALUE 'Y'.
...
SET IS-VALID TO FALSE  -- Error! No FALSE value defined
```

### Mistake 4: Complex Toggle Logic
```cobol
COMPUTE FLAG = FLAG * -FLAG  -- Confusing and error-prone
```
- Use simple IF-ELSE instead

## Testing Flags

### Direct Test
```cobol
IF FLAG = 'Y'
    [action]
END-IF
```

### Condition Name Test
```cobol
IF IS-ACTIVE
    [action]
END-IF
```

### Negation Test
```cobol
IF NOT IS-ACTIVE
    [action]
END-IF
```

### EVALUATE Test
```cobol
EVALUATE TRUE
    WHEN IS-ACTIVE
        [action-1]
    WHEN IS-INACTIVE
        [action-2]
END-EVALUATE
```

## Setting Flags

### Direct Assignment
```cobol
MOVE 'Y' TO FLAG
MOVE 'N' TO FLAG
```

### SET Statement (Level 88)
```cobol
SET IS-ACTIVE TO TRUE
SET IS-ACTIVE TO FALSE
```

### Conditional Set
```cobol
IF condition
    SET IS-ACTIVE TO TRUE
ELSE
    SET IS-ACTIVE TO FALSE
END-IF
```

## Toggle Patterns

### Simple Toggle
```cobol
IF FLAG = 'Y'
    MOVE 'N' TO FLAG
ELSE
    MOVE 'Y' TO FLAG
END-IF
```

### Level 88 Toggle
```cobol
IF IS-ACTIVE
    SET IS-ACTIVE TO FALSE
ELSE
    SET IS-ACTIVE TO TRUE
END-IF
```

### Compact Toggle (Not Recommended)
```cobol
COMPUTE FLAG = 1 - FLAG  -- Only works with 0/1 numeric
```

## Use Cases

Boolean flags are used for:
- Status indicators (active/inactive)
- Error flags (error/no-error)
- Processing flags (processed/unprocessed)
- Validation results (valid/invalid)
- Control flow (continue/stop)
- Feature toggles (enabled/disabled)

## Educational Value

This program teaches:
- Boolean logic in COBOL
- Various flag implementation patterns
- Level 88 condition names
- Flag testing and manipulation
- Best practices for boolean flags
- Common pitfalls to avoid

## Recommendations

### For New Code
Use Level 88 with FALSE:
```cobol
05  STATUS-FLAG          PIC X VALUE 'N'.
    88  IS-ACTIVE        VALUE 'Y', FALSE 'N'.
```

### For Legacy Code
Understand the pattern used:
- Document the convention
- Be consistent within the program
- Consider refactoring to level 88

### For Readability
```cobol
*> Good
IF IS-ACTIVE
    PERFORM PROCESS-RECORD
END-IF

*> Less Good
IF STATUS-FLAG = 'Y'
    PERFORM PROCESS-RECORD
END-IF
```

## Summary

NOTBOOL.CBL demonstrates that while COBOL lacks a native boolean type, there are several effective patterns for implementing boolean logic:

1. **Character flags** (Y/N, T/F, 1/0)
2. **Level 88 condition names** (recommended)
3. **Numeric flags** (less common)

The best practice is to use **Level 88 condition names with FALSE values**, which provides:
- Clean, readable syntax
- Self-documenting code
- Proper COBOL idioms
- Easy maintenance

This program serves as a comprehensive guide to boolean flag patterns in COBOL programming.