# IFEVAL.CBL - Conditional Logic and EVALUATE Demonstration

## Program Overview
**Program ID:** COND88 (Note: Program-ID doesn't match filename)

This COBOL program provides a comprehensive demonstration of conditional logic in COBOL, including IF statements, EVALUATE statements, and various comparison operators. It serves as a tutorial on decision-making constructs in COBOL.

## Purpose
The program demonstrates:
- Basic IF statements
- IF-ELSE constructs
- Nested IF statements
- Comparison operators (EQUAL, NOT EQUAL, GREATER THAN, LESS THAN)
- Abbreviated comparisons
- NUMERIC test
- EVALUATE statement (simple and complex)
- EVALUATE with multiple subjects (ALSO)
- Reference modification in conditions

## Data Structures

```cobol
FILLER
├── RESULT-OF-COMPARE (10 chars)
│   - Stores comparison results
├── ALPHA-1 (10 chars)
│   - First alphanumeric field for comparison
├── ALPHA-2 (10 chars)
│   - Second alphanumeric field for comparison
├── NUMERIC-1 (COMP-3)
│   - First numeric field (packed decimal)
└── NUMERIC-2-X
    └── NUMERIC-2 (COMP-3)
        - Second numeric field (packed decimal)
```

## Conditional Constructs Demonstrated

### 1. Basic IF Statement
```cobol
IF ALPHA-1 IS EQUAL TO ALPHA-2 
    MOVE 'equal' TO RESULT-OF-COMPARE 
END-IF
```
- Simple condition test
- Single action if true
- No ELSE clause

### 2. IF with NOT
```cobol
IF ALPHA-1 IS NOT EQUAL TO ALPHA-2    
    MOVE 'different' TO RESULT-OF-COMPARE    
END-IF
```
- Tests for inequality
- Negation of condition

### 3. IF-ELSE Statement
```cobol
IF ALPHA-1 IS EQUAL TO ALPHA-2    
    MOVE 'equal' TO RESULT-OF-COMPARE   
ELSE   
    MOVE 'different' TO RESULT-OF-COMPARE    
END-IF
```
- Two-way decision
- Action for both true and false

### 4. IF Without END-IF (Period-Terminated)
```cobol
IF ALPHA-1 IS EQUAL TO ALPHA-2 
    MOVE 'equal' TO RESULT-OF-COMPARE.
```
- Old-style COBOL syntax
- Period terminates the IF
- Less safe than END-IF

### 5. Abbreviated Comparison
```cobol
if alpha-1 equal alpha-2   
    move 'equal' to result-of-compare   
end-if
```
- Omits "IS" keyword
- Lowercase (style variation)
- Functionally identical

### 6. Literal Comparison
```cobol
IF ALPHA-1 IS EQUAL TO 'foobar'    
    MOVE 'equal' TO RESULT-OF-COMPARE    
ELSE    
    MOVE 'different' TO RESULT-OF-COMPARE  
END-IF
```
- Compares field to literal value
- Common pattern for validation

### 7. NUMERIC Test
```cobol
MOVE 'garbage' TO NUMERIC-2-X    
IF NUMERIC-2 IS NUMERIC   
    ADD 1 TO NUMERIC-2 
ELSE  
    MOVE 1 TO NUMERIC-2              
END-IF
```
- Tests if field contains valid numeric data
- Important for data validation
- Prevents arithmetic errors

### 8. Conditional Arithmetic
```cobol
IF NUMERIC-1 IS GREATER THAN ZERO   
    DIVIDE NUMERIC-2 BY NUMERIC-1 
        GIVING NUMERIC-2 
    END-DIVIDE     
ELSE   
    SUBTRACT 1 FROM NUMERIC-2 
        GIVING NUMERIC-2  
    END-SUBTRACT    
END-IF
```
- Prevents division by zero
- Different operations based on condition
- Nested arithmetic statements

### 9. Comparison Operators
```cobol
IF NUMERIC-1 IS GREATER THAN NUMERIC-2 
    MOVE 'numeric-1' TO RESULT-OF-COMPARE
ELSE 
    MOVE 'numeric-2' TO RESULT-OF-COMPARE
END-IF
```
- GREATER THAN comparison
- Determines larger value

### 10. Simple EVALUATE
```cobol
EVALUATE TRUE 
    WHEN NUMERIC-1 IS GREATER THAN NUMERIC-2 
       MOVE 'numeric-1' TO RESULT-OF-COMPARE   
    WHEN NUMERIC-1 < NUMERIC-2 
       MOVE 'numeric-2' TO RESULT-OF-COMPARE    
    WHEN OTHER
       MOVE 'equal' TO RESULT-OF-COMPARE
END-EVALUATE
```
- Multi-way decision
- Tests conditions in order
- WHEN OTHER for default case
- Uses abbreviated operator (<)

### 11. EVALUATE with ALSO (Multiple Subjects)
```cobol
EVALUATE TRUE ALSO TRUE 
    WHEN NUMERIC-1 IS GREATER THAN NUMERIC-2 
    ALSO ALPHA-1(1:3) EQUAL 'THX'
       MOVE 'THX and numeric-1' TO RESULT-OF-COMPARE   
    WHEN NUMERIC-1 < NUMERIC-2 
    ALSO ALPHA-1(1:3) EQUAL 'THX'
       MOVE 'THX and numeric-2' TO RESULT-OF-COMPARE 
    WHEN NUMERIC-1 = NUMERIC-1 
    ALSO ALPHA-2 = 'Terminator'
       MOVE 'Terminator and equal numbers' TO RESULT-OF-COMPARE      
    WHEN OTHER
       MOVE 'undefined' TO RESULT-OF-COMPARE
END-EVALUATE
```
- Tests multiple conditions simultaneously
- ALSO combines conditions (AND logic)
- Reference modification in condition
- Multiple comparison operators

## Comparison Operators

### Full Form
- `IS EQUAL TO` or `=`
- `IS NOT EQUAL TO` or `<>` or `NOT =`
- `IS GREATER THAN` or `>`
- `IS LESS THAN` or `<`
- `IS GREATER THAN OR EQUAL TO` or `>=`
- `IS LESS THAN OR EQUAL TO` or `<=`

### Abbreviated Forms
- `EQUAL` (omit IS and TO)
- `NOT EQUAL`
- `GREATER THAN`
- `LESS THAN`

### Symbolic Operators
- `=` (equal)
- `<>` (not equal)
- `>` (greater than)
- `<` (less than)
- `>=` (greater than or equal)
- `<=` (less than or equal)

## EVALUATE Statement

### Syntax
```cobol
EVALUATE subject-1 [ALSO subject-2 ...]
    WHEN condition-1 [ALSO condition-2 ...]
        statements
    WHEN condition-3 [ALSO condition-4 ...]
        statements
    WHEN OTHER
        statements
END-EVALUATE
```

### Advantages
1. **Cleaner than nested IFs**: More readable for multiple conditions
2. **Efficient**: Compiler can optimize
3. **Maintainable**: Easy to add/remove cases
4. **Flexible**: Supports multiple subjects with ALSO

### EVALUATE TRUE Pattern
```cobol
EVALUATE TRUE
    WHEN condition-1
        statements
    WHEN condition-2
        statements
END-EVALUATE
```
- Common idiom in COBOL
- Allows testing different conditions
- Similar to switch/case in other languages
- First matching WHEN executes

## Reference Modification in Conditions

```cobol
ALPHA-1(1:3) EQUAL 'THX'
```
- Tests substring of field
- Syntax: field(start:length)
- Useful for code prefixes
- Example: Check first 3 characters

## Data Type Considerations

### Alphanumeric Comparison
```cobol
MOVE 'cucumber' TO ALPHA-1 
MOVE 'radish' TO ALPHA-2
IF ALPHA-1 IS EQUAL TO ALPHA-2
```
- Character-by-character comparison
- Case-sensitive
- Padding with spaces if needed

### Numeric Comparison
```cobol
MOVE 7 TO NUMERIC-1 
MOVE 36 TO NUMERIC-2 
IF NUMERIC-1 IS GREATER THAN NUMERIC-2
```
- Arithmetic comparison
- Independent of storage format
- COMP-3 (packed decimal) used here

### Mixed Comparisons
- Numeric to numeric: arithmetic comparison
- Alphanumeric to alphanumeric: character comparison
- Avoid mixing types (may cause errors)

## NUMERIC Test

### Purpose
Validates that a field contains valid numeric data:
```cobol
IF NUMERIC-2 IS NUMERIC
```

### When to Use
- After reading external data
- Before arithmetic operations
- After alphanumeric moves to numeric fields
- Data validation routines

### What It Checks
- All digits are valid (0-9)
- Sign is valid (if signed field)
- Decimal point position is valid
- No invalid characters

## Best Practices Demonstrated

### 1. Use END-IF
```cobol
IF condition
    statements
END-IF
```
- Explicit scope termination
- Prevents ambiguity
- Safer than period termination

### 2. Validate Before Arithmetic
```cobol
IF NUMERIC-1 IS GREATER THAN ZERO
    DIVIDE NUMERIC-2 BY NUMERIC-1
```
- Prevents division by zero
- Checks for valid data

### 3. Use EVALUATE for Multiple Conditions
- More readable than nested IFs
- Easier to maintain
- Better performance

### 4. Consistent Formatting
- Indentation shows structure
- Aligned keywords
- Clear logic flow

## Common Patterns

### Pattern 1: Validation
```cobol
IF field IS NUMERIC
    [process]
ELSE
    [error handling]
END-IF
```

### Pattern 2: Range Check
```cobol
IF value > minimum AND value < maximum
    [valid range]
ELSE
    [out of range]
END-IF
```

### Pattern 3: Multi-way Decision
```cobol
EVALUATE TRUE
    WHEN condition-1
        [action-1]
    WHEN condition-2
        [action-2]
    WHEN OTHER
        [default-action]
END-EVALUATE
```

## Educational Value

This program teaches:
- All major conditional constructs in COBOL
- Comparison operator variations
- EVALUATE statement usage
- Data validation techniques
- Reference modification in conditions
- Best practices for conditional logic
- Difference between old and modern syntax

## Potential Issues

### 1. Program-ID Mismatch
- File named IFEVAL.CBL
- Program-ID is COND88
- Should match for clarity

### 2. Period vs END-IF
- Mixed usage shown
- END-IF is preferred
- Period termination can be error-prone

### 3. Incomplete Ordinal Logic
- Example shows various comparisons
- Not a complete working program
- Demonstrates syntax, not full logic

## Summary

IFEVAL.CBL (despite the Program-ID mismatch) is an excellent tutorial program that demonstrates:
- Complete range of conditional logic in COBOL
- Various comparison operators and their usage
- EVALUATE statement capabilities
- Data validation techniques
- Best practices for decision-making code

It serves as a valuable reference for COBOL programmers learning or reviewing conditional logic constructs.