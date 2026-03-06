# COND88.CBL - Level 88 Condition Names Demonstration

## Program Overview
**Program ID:** COND88

This COBOL program demonstrates the use of level 88 condition names, which provide a way to define named conditions for data items. This is COBOL's approach to creating boolean-like flags and enumerated types.

## Purpose
The program demonstrates:
- Basic level 88 condition names
- Level 88 with TRUE/FALSE values
- Multiple value conditions
- Range-based conditions (THRU clause)
- SET statement for condition manipulation
- EVALUATE statement with condition names
- Age categorization using ranges

## What are Level 88 Condition Names?

Level 88 is a special level in COBOL that defines condition names. These are not data items themselves but rather named tests that can be applied to their parent data item. They provide:
- More readable code
- Self-documenting conditions
- Type-safe value checking
- Easy maintenance of valid values

## Data Structures and Condition Names

### 1. Simple 88 Condition (SIMPLE-88)
```cobol
05  FILLER                   PIC X VALUE SPACE. 
    88  SIMPLE-88            VALUE 'T'.
```
- Parent field is a single character
- Condition is TRUE when value is 'T'
- No explicit FALSE value defined

### 2. 88 Condition with FALSE (SIMPLE-88-WITH-FALSE)
```cobol
05  FILLER                   PIC X VALUE 'F'.
    88  SIMPLE-88-WITH-FALSE VALUE 'T', FALSE 'F'.
```
- Defines both TRUE ('T') and FALSE ('F') values
- Allows bidirectional SET operations

### 3. Multiple Value Conditions (CATEGORY-A and CATEGORY-B)
```cobol
05  CATEGORY-CODE            PIC X VALUE SPACE.
    88  CATEGORY-A           VALUE 'A', '3', '7'.
    88  CATEGORY-B           VALUE 'B', '9', 'X'.
```
- Multiple values can satisfy a single condition
- Useful for grouping related codes

### 4. Range-Based Conditions (Age Categories)
```cobol
05  PERSON-AGE               PIC 9(03). 
    88  PERSON-IS-A-CHILD    VALUE 0 THRU 12. 
    88  PERSON-IS-A-TEEN     VALUE 13 THRU 19. 
    88  PERSON-IS-YOUNG-ADULT VALUE 20 THRU 35. 
    88  PERSON-IS-AN-ADULT   VALUE 36 THRU 49. 
    88  PERSON-IS-MIDDLE-AGED VALUE 50 THRU 59. 
    88  PERSON-IS-A-SENIOR   VALUE 60 THRU 74. 
    88  PERSON-IS-ELDERLY    VALUE 75 THRU 200.
```
- Uses THRU to define value ranges
- Creates mutually exclusive age categories
- Self-documenting age classifications

## Program Flow and Examples

### Example 1: Basic SET and IF
```cobol
SET SIMPLE-88 TO TRUE 
IF SIMPLE-88 
    MOVE 'true' TO THE-ANSWER 
END-IF
```
- SET statement assigns the TRUE value to the parent field
- IF tests the condition directly

### Example 2: Testing NOT Condition
```cobol
IF NOT SIMPLE-88
    MOVE 'false' TO THE-ANSWER 
END-IF
```
- NOT operator inverts the condition test

### Example 3: Bidirectional SET with FALSE
```cobol
SET SIMPLE-88-WITH-FALSE TO TRUE 
SET SIMPLE-88-WITH-FALSE TO FALSE
```
- Can set both TRUE and FALSE values
- Only works when FALSE value is explicitly defined

### Example 4: Multiple Value Testing
```cobol
SET CATEGORY-A TO TRUE 
IF CATEGORY-A 
    MOVE 'true' TO THE-ANSWER 
END-IF
```
- Setting to TRUE assigns the first value in the list ('A')

### Example 5: EVALUATE with Multiple Values
```cobol
MOVE 'E' TO CATEGORY-CODE 
EVALUATE TRUE 
    WHEN CATEGORY-A 
       MOVE 'A' TO THE-ANSWER 
    WHEN CATEGORY-B 
       MOVE 'B' TO THE-ANSWER     
    WHEN OTHER
       MOVE '?' TO THE-ANSWER 
END-EVALUATE
```
- EVALUATE TRUE tests conditions in order
- WHEN OTHER handles values not in any category

### Example 6: Age Categorization
```cobol
MOVE 37 TO PERSON-AGE 
EVALUATE TRUE   
    WHEN PERSON-IS-A-CHILD 
        MOVE 'child' TO THE-ANSWER 
    WHEN PERSON-IS-A-TEEN 
        MOVE 'teen' TO THE-ANSWER 
    WHEN PERSON-IS-YOUNG-ADULT 
        MOVE 'young' TO THE-ANSWER 
    WHEN PERSON-IS-AN-ADULT  
        MOVE 'adult' TO THE-ANSWER 
    ...
END-EVALUATE
```
- Age 37 falls in PERSON-IS-AN-ADULT range (36-49)
- Demonstrates range-based condition testing

## Key Concepts

### SET Statement
- `SET condition-name TO TRUE` - Sets parent field to TRUE value
- `SET condition-name TO FALSE` - Sets parent field to FALSE value (if defined)

### IF Statement with Condition Names
- `IF condition-name` - Tests if condition is true
- `IF NOT condition-name` - Tests if condition is false

### EVALUATE with Condition Names
- `EVALUATE TRUE` followed by `WHEN condition-name`
- Tests multiple conditions in sequence
- First matching condition executes its statements

## Advantages of Level 88 Conditions

1. **Readability**: `IF PERSON-IS-A-SENIOR` is clearer than `IF PERSON-AGE >= 60 AND PERSON-AGE <= 74`

2. **Maintainability**: Change value definitions in one place

3. **Self-Documentation**: Condition names describe business logic

4. **Type Safety**: Prevents invalid value assignments when using SET

5. **Centralized Logic**: All valid values defined with the data item

## Best Practices Demonstrated

1. Use meaningful condition names that describe business concepts
2. Define FALSE values when bidirectional setting is needed
3. Use ranges (THRU) for continuous value sets
4. Use multiple values for discrete valid codes
5. Combine with EVALUATE for complex decision logic

## Educational Value

This program serves as a comprehensive tutorial on:
- Level 88 condition name syntax and usage
- Different types of condition definitions
- SET, IF, and EVALUATE statements with conditions
- Creating self-documenting, maintainable code
- Implementing business rules in COBOL

## Technical Notes

- Condition names don't occupy storage; they're compile-time constructs
- The parent field holds the actual value
- Multiple 88-levels can be defined for the same parent field
- Conditions can overlap (multiple conditions can be true simultaneously)
- EVALUATE TRUE with WHEN tests conditions in order, executing only the first match