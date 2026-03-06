# DATE2.CBL - Date Formatting with ACCEPT Statements

## Program Overview
**Program ID:** DATE2

This COBOL program demonstrates date and time formatting using ACCEPT statements to retrieve system date and time information. Unlike DATE1.CBL which uses the CURRENT-DATE function, this program uses the traditional ACCEPT FROM DATE/TIME approach, showing an alternative method for date handling in COBOL.

## Purpose
The program demonstrates:
- ACCEPT FROM DATE and related statements
- Multiple date format retrieval (DATE, DATE YYYYMMDD, DAY, DAY YYYYDDD)
- Day-of-week determination
- Date formatting with day names
- Ordinal number generation
- Time formatting with precision
- Alternative date handling techniques

## ACCEPT Statement Variants

### 1. ACCEPT DATE
```cobol
ACCEPT DATE-VALUE FROM DATE
```
- Returns: YYMMDD (6 digits)
- Two-digit year (Y2K issue potential)
- Example: 260305 (March 5, 2026)

### 2. ACCEPT DATE YYYYMMDD
```cobol
ACCEPT DATE-YYYYMMDD-VALUE FROM DATE YYYYMMDD
```
- Returns: YYYYMMDD (8 digits)
- Four-digit year (Y2K compliant)
- Example: 20260305

### 3. ACCEPT DAY
```cobol
ACCEPT DAY-VALUE FROM DAY
```
- Returns: YYDDD (5 digits)
- Julian date format (day of year)
- Example: 26064 (64th day of 2026)

### 4. ACCEPT DAY YYYYDDD
```cobol
ACCEPT DAY-YYYYDDD-VALUE FROM DAY YYYYDDD
```
- Returns: YYYYDDD (7 digits)
- Four-digit year with Julian day
- Example: 2026064

### 5. ACCEPT DAY-OF-WEEK
```cobol
ACCEPT DAY-OF-WEEK-VALUE FROM DAY-OF-WEEK
```
- Returns: Single digit (1-7)
- 1 = Monday, 7 = Sunday
- ISO 8601 standard

### 6. ACCEPT TIME
```cobol
ACCEPT TIME-VALUE FROM TIME
```
- Returns: HHMMSSss (8 digits)
- Hours, minutes, seconds, hundredths
- Example: 08543075 (08:54:30.75)

## Data Structures

### Date Storage Areas
```cobol
DATE-VALUE
├── DATE-YY (2 digits)
├── DATE-MM (2 digits)
└── DATE-DD (2 digits)

DATE-YYYYMMDD-VALUE
├── DATE-YYYY (4 digits)
├── DATE-MM (2 digits)
└── DATE-DD (2 digits)

DAY-VALUE
├── DAY-YY (2 digits)
└── DAY-DDD (3 digits)

DAY-YYYYDDD-VALUE
├── DAY-YYYY (4 digits)
└── DAY-DDD (3 digits)
```

### Time Storage
```cobol
TIME-VALUE
├── TIME-HOUR (2 digits)
├── TIME-MINUTE (2 digits)
├── TIME-SECOND (2 digits)
└── TIME-HUNDREDTHS (2 digits)
```

### Lookup Tables

**Month Names:**
```cobol
MONTH-ENTRY OCCURS 12
├── MONTH-NUMBER (2 digits)
└── MONTH-NAME
    ├── MONTH-ABBREV (3 characters)
    └── FILLER (6 characters)
```

**Day Names:**
```cobol
DAY-NAME OCCURS 7 PIC X(09)
    Monday, Tuesday, Wednesday, Thursday, 
    Friday, Saturday, Sunday
```

**Day Ordinals:**
```cobol
DAY-ORDINAL OCCURS 10 PIC X(02)
    th, st, nd, rd, th, th, th, th, th, th
```

## Output Formats

### Example 1: Verbose Date with Day Name
```
Today is Wednesday, the 5th of March, 2026
```
Components:
- Day name from DAY-OF-WEEK lookup
- Day with ordinal suffix
- Full month name
- Four-digit year

### Example 2: US Shorthand Format
```
03/05/26
```
- MM/DD/YY format
- Slash separators

### Example 3: European Shorthand Format
```
05.03.26
```
- DD.MM.YY format
- Period separators

### Example 4: Precise Time
```
08:54:30.75
```
- HH:MM:SS.ss format
- Hundredths of a second precision

## Program Flow

### 1. Retrieve All Date/Time Values
```cobol
ACCEPT DATE-VALUE          FROM DATE 
ACCEPT DATE-YYYYMMDD-VALUE FROM DATE YYYYMMDD
ACCEPT DAY-VALUE           FROM DAY 
ACCEPT DAY-YYYYDDD-VALUE   FROM DAY YYYYDDD 
ACCEPT DAY-OF-WEEK-VALUE   FROM DAY-OF-WEEK
ACCEPT TIME-VALUE          FROM TIME
```
- Retrieves all available date/time formats
- Demonstrates different ACCEPT variants
- All values from same moment in time

### 2. Format Verbose Date

**Calculate Ordinal:**
```cobol
DIVIDE DATE-DD IN DATE-YYYYMMDD-VALUE BY 10 
    GIVING DAY-DIV-BY-10
    REMAINDER DAY-LAST-DIGIT
```

**Build String:**
```cobol
STRING 
    'Today is ' DELIMITED BY SIZE 
    DAY-NAME(DAY-OF-WEEK-VALUE) DELIMITED BY SPACE 
    ', the ' DELIMITED BY SIZE 
    DATE-DD IN DATE-YYYYMMDD-VALUE DELIMITED BY SIZE 
    DAY-ORDINAL(DAY-LAST-DIGIT) DELIMITED BY SIZE 
    ' of ' DELIMITED BY SIZE     
    MONTH-NAME(DATE-MM IN DATE-YYYYMMDD-VALUE) DELIMITED BY SPACE 
    ', ' DELIMITED BY SIZE 
    DATE-YYYY OF DATE-YYYYMMDD-VALUE DELIMITED BY SIZE      
    INTO FULL-DATE 
END-STRING
```

### 3. Format Shorthand Dates
```cobol
MOVE DATE-MM OF DATE-VALUE TO MONTH OF SHORTHAND-DATE-US-STYLE 
MOVE DATE-DD OF DATE-VALUE TO DAY-OF-MONTH OF SHORTHAND-DATE-US-STYLE 
MOVE DATE-YY OF DATE-VALUE TO YEAR-2-DIGIT OF SHORTHAND-DATE-US-STYLE
```
- Uses pre-defined structures with separators
- Similar for European format

### 4. Display Time with Precision
```cobol
DISPLAY TIME-HOUR ':' TIME-MINUTE ':' TIME-SECOND 
        '.' TIME-HUNDREDTHS
```
- Concatenates time components with literals
- Shows hundredths of a second

## Key Differences from DATE1.CBL

| Feature | DATE1.CBL | DATE2.CBL |
|---------|-----------|-----------|
| Date Source | CURRENT-DATE function | ACCEPT statements |
| Timezone | Included | Not available |
| Milliseconds | Yes (2 digits) | Hundredths (2 digits) |
| Day of Week | Not shown | Included |
| Julian Date | Not shown | Included |
| Approach | Modern (function) | Traditional (ACCEPT) |

## Day-of-Week Mapping

```
1 = Monday
2 = Tuesday
3 = Wednesday
4 = Thursday
5 = Friday
6 = Saturday
7 = Sunday
```
- ISO 8601 standard
- Monday is first day of week
- Used to index DAY-NAME array

## Julian Date Format

### What is Julian Date?
- Day number within the year (1-366)
- January 1 = 001
- December 31 = 365 (or 366 in leap year)

### Example:
- March 5, 2026 = Day 64
- Calculation: 31 (Jan) + 28 (Feb) + 5 (Mar) = 64

### Use Cases:
- Simplified date arithmetic
- Day-of-year calculations
- Agricultural and astronomical applications

## Time Precision

### Hundredths of a Second
- TIME returns HHMMSSss
- ss = hundredths (0-99)
- Precision: 0.01 seconds
- Example: 08543075 = 08:54:30.75

### Comparison:
- DATE1.CBL: Milliseconds (0.001 sec precision)
- DATE2.CBL: Hundredths (0.01 sec precision)
- DATE2.CBL has lower precision

## Technical Notes

### Y2K Considerations
- DATE returns YY (two-digit year)
- DATE YYYYMMDD returns YYYY (four-digit year)
- Always prefer YYYYMMDD for new code
- YY format included for legacy compatibility

### ACCEPT vs FUNCTION
**ACCEPT Advantages:**
- Traditional COBOL approach
- Widely supported
- Simple syntax

**FUNCTION CURRENT-DATE Advantages:**
- Single call for all data
- Includes timezone
- More precise (milliseconds)
- Modern standard

### Performance
- Multiple ACCEPT statements may be slower
- Each ACCEPT is a system call
- CURRENT-DATE is typically one call
- Difference usually negligible

## Use Cases

This program is useful for:
- Legacy system maintenance
- Systems without CURRENT-DATE support
- Learning traditional COBOL date handling
- Day-of-week calculations
- Julian date processing
- Precise time logging

## Educational Value

This program teaches:
- Traditional COBOL date/time handling
- Multiple ACCEPT statement variants
- Day-of-week determination
- Julian date format
- Time precision handling
- Comparison with modern approaches
- Legacy code patterns

## Best Practices

1. **Use YYYYMMDD**: Avoid Y2K issues
2. **Store Day-of-Week**: Useful for business logic
3. **Consider Timezone**: Use CURRENT-DATE if needed
4. **Document Format**: Clearly indicate date format used
5. **Validate Input**: Check for valid dates when accepting user input

## Potential Issues

1. **No Timezone**: Cannot determine UTC offset
2. **Lower Time Precision**: Hundredths vs milliseconds
3. **Multiple System Calls**: Potentially slower
4. **Synchronization**: Multiple ACCEPTs might span second boundary
5. **Y2K Risk**: If using YY format

## Migration Path

To modernize this code:
1. Replace multiple ACCEPTs with single CURRENT-DATE
2. Use YYYYMMDD format consistently
3. Add timezone handling if needed
4. Consider ISO 8601 formats
5. Implement date validation