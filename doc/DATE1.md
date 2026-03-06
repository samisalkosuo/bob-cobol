# DATE1.CBL - Date Formatting with CURRENT-DATE Function

## Program Overview
**Program ID:** DATE1

This COBOL program demonstrates comprehensive date and time formatting using the CURRENT-DATE intrinsic function. It shows how to format dates in multiple styles including NCSA timestamp format, verbose date format, and shorthand formats for both US and European conventions.

## Purpose
The program demonstrates:
- CURRENT-DATE intrinsic function usage
- Date and time component extraction
- Multiple date formatting styles
- MOVE CORRESPONDING for selective field copying
- STRING statement for complex formatting
- Table lookups for month names
- Ordinal number generation (1st, 2nd, 3rd, etc.)
- International date format variations

## Data Structures

### Current Date Data (from CURRENT-DATE function)
```cobol
CURRENT-DATE-DATA
├── CURRENT-DATE
│   ├── FULL-YEAR (4 digits: CCYY)
│   │   ├── CENTURY (2 digits)
│   │   └── YEAR-2-DIGIT (2 digits)
│   ├── MONTH (2 digits)
│   └── DAY-OF-MONTH (2 digits)
├── CURRENT-TIME
│   ├── HOUR (2 digits, 24-hour format)
│   ├── MINUTE (2 digits)
│   ├── SECOND (2 digits)
│   └── MILLISECONDS (2 digits)
└── TIMEZONE-INFORMATION
    ├── TIMEZONE-DIRECTION ('+' or '-')
    ├── TIMEZONE-OFFSET-HOURS (2 digits)
    └── TIMEZONE-OFFSET-MINUTES (2 digits)
```

### Month Lookup Table
```cobol
MONTH-ABBR-DATA (12 entries)
Each entry: [Month Number (2)][Month Name (9)]
    01January, 02February, 03March, etc.
```
- Indexed by MONTH-INDEX
- Provides month abbreviations and full names
- Used for converting numeric month to text

### Day Ordinals Table
```cobol
DAY-ORDINALS-DATA (10 entries)
    th, st, nd, rd, th, th, th, th, th, th
```
- Maps last digit (0-9) to ordinal suffix
- Used for formatting: 1st, 2nd, 3rd, 4th, etc.

## Output Formats

### Example 1: NCSA Common Log Format
```
[DD/MMM/YYYY:HH:MM:SS +HHMM]
Example: [05/Mar/2026:08:54:30 +0200]
```
- Used in web server logs
- Compact but complete timestamp
- Includes timezone information

### Example 2: Verbose Date Format
```
Month DDth, YYYY
Example: March 5th, 2026
```
- Human-readable format
- Includes ordinal suffix (st, nd, rd, th)
- Full month name

### Example 3: US Shorthand Format
```
MM/DD/YY
Example: 03/05/26
```
- Month/Day/Year order
- Two-digit year
- Slash separators

### Example 4: European Shorthand Format
```
DD.MM.YY
Example: 05.03.26
```
- Day/Month/Year order
- Two-digit year
- Period separators

## Program Flow

### 1. Get Current Date/Time
```cobol
MOVE FUNCTION CURRENT-DATE to CURRENT-DATE-DATA
```
- Retrieves system date, time, and timezone
- Returns 21-byte value with all components

### 2. Format NCSA Timestamp
```cobol
MOVE CORRESPONDING CURRENT-DATE TO NCSA-TIMESTAMP
MOVE CORRESPONDING CURRENT-TIME TO NCSA-TIMESTAMP
MOVE CORRESPONDING TIMEZONE-INFORMATION TO NCSA-TIMESTAMP
MOVE MONTH-ABBREV(MONTH IN CURRENT-DATE) 
  TO MONTH-ABBR IN NCSA-TIMESTAMP
```
- Uses MOVE CORRESPONDING for matching field names
- Looks up month abbreviation from table
- Builds complete timestamp with literals

### 3. Format Verbose Date
**Step 1: Calculate Ordinal Suffix**
```cobol
DIVIDE DAY-OF-MONTH IN CURRENT-DATE BY 10 
    GIVING DAY-DIV-BY-10
    REMAINDER DAY-LAST-DIGIT
```
- Gets last digit of day (for ordinal lookup)
- Example: 23 → last digit = 3 → "rd"

**Step 2: Build String**
```cobol
STRING 
    MONTH-NAME(MONTH IN CURRENT-DATE) DELIMITED BY SPACE 
    SPACE DELIMITED BY SIZE 
    DAY-OF-MONTH IN CURRENT-DATE DELIMITED BY SIZE 
    DAY-ORDINAL(DAY-LAST-DIGIT) DELIMITED BY SIZE 
    ", " DELIMITED BY SIZE 
    FULL-YEAR OF CURRENT-DATE DELIMITED BY SIZE      
    INTO FULL-DATE 
END-STRING
```
- Concatenates components with proper spacing
- Uses DELIMITED BY to control string termination

### 4. Format US Shorthand
```cobol
MOVE CORRESPONDING CURRENT-DATE TO SHORTHAND-DATE-US-STYLE
MOVE YEAR-2-DIGIT IN CURRENT-DATE 
     TO YEAR-2-DIGIT IN SHORTHAND-DATE-US-STYLE
```
- Uses pre-defined structure with slash separators
- Copies date components

### 5. Format European Shorthand
```cobol
MOVE CORRESPONDING CURRENT-DATE TO SHORTHAND-DATE-EURO-STYLE
MOVE YEAR-2-DIGIT IN CURRENT-DATE 
     TO YEAR-2-DIGIT IN SHORTHAND-DATE-EURO-STYLE
```
- Uses pre-defined structure with period separators
- Copies date components

## Key Techniques

### CURRENT-DATE Function
Returns a 21-byte value:
- Positions 1-8: Date (YYYYMMDD)
- Positions 9-16: Time (HHMMSSss)
- Positions 17-21: Timezone (±HHMM)

### MOVE CORRESPONDING
```cobol
MOVE CORRESPONDING source TO destination
```
- Moves fields with matching names
- Ignores non-matching fields
- Efficient for partial structure copying

### STRING Statement
```cobol
STRING 
    field1 DELIMITED BY delimiter1
    field2 DELIMITED BY delimiter2
    INTO target-field
END-STRING
```
- Concatenates multiple fields
- Controls termination with DELIMITED BY
- DELIMITED BY SIZE uses entire field
- DELIMITED BY SPACE stops at first space

### Table Indexing
```cobol
MONTH-ABBREV(MONTH IN CURRENT-DATE)
```
- Direct array access using month number
- Efficient lookup without searching

### REDEFINES for Tables
```cobol
01  MONTH-ABBR-DATA.
    05  FILLER PIC X(11) VALUE '01January'.
    ...
01  FILLER REDEFINES MONTH-ABBR-DATA.
    05  MONTH-ENTRY OCCURS 12 ...
```
- Defines data as literals
- Redefines as array for access
- Combines initialization with structure

## Ordinal Number Logic

### Ordinal Suffix Rules
- 1 → st (1st, 21st, 31st)
- 2 → nd (2nd, 22nd)
- 3 → rd (3rd, 23rd)
- 0, 4-9 → th (4th, 5th, 10th, 20th, etc.)

### Implementation
```cobol
DIVIDE DAY-OF-MONTH BY 10 
    GIVING DAY-DIV-BY-10
    REMAINDER DAY-LAST-DIGIT
```
- Gets last digit: 23 → 3
- Looks up in table: DAY-ORDINAL(3) → "rd"
- Result: "23rd"

**Note:** This simplified approach works for most cases but doesn't handle 11th, 12th, 13th correctly (they should all be "th", not "st", "nd", "rd").

## International Date Formats

### US Format (MM/DD/YY)
- Month first
- Common in United States
- Can be ambiguous (03/05/26 = March 5 or May 3?)

### European Format (DD.MM.YY)
- Day first
- Common in Europe and most of the world
- Uses period separator
- Less ambiguous in context

### ISO Format (YYYY-MM-DD)
- Not shown in this program
- International standard
- Unambiguous
- Sortable

## Technical Notes

### FILLER Usage
- Used for unnamed fields
- Common for literals in structures
- Reduces namespace clutter

### Picture Clauses
- `PIC 9(04)`: 4 numeric digits
- `PIC X(02)`: 2 alphanumeric characters
- `PIC X VALUE "/"`: Single character literal

### OCCURS Clause
- Defines arrays/tables
- Can be indexed or subscripted
- Efficient for repeated structures

## Use Cases

This program is useful for:
- Log file timestamp generation
- Report headers with formatted dates
- User interface date display
- International date format conversion
- Audit trail timestamps

## Educational Value

This program teaches:
- CURRENT-DATE function usage
- Multiple date formatting techniques
- STRING statement for complex formatting
- Table lookup operations
- MOVE CORRESPONDING for selective copying
- International date format awareness
- Ordinal number generation
- REDEFINES for data organization

## Best Practices Demonstrated

1. **Structured Data**: Well-organized date/time structures
2. **Reusable Tables**: Month and ordinal lookup tables
3. **Clear Formatting**: Separate structures for each format
4. **Descriptive Names**: Self-documenting field names
5. **Modular Approach**: Each format in its own section