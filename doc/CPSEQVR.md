# CPSEQVR.CBL - Variable-Length Sequential File Processing

## Program Overview
**Program ID:** CPSEQVR

This COBOL program demonstrates processing of variable-length sequential files. It reads variable-length records, adds a new field to each record, and writes them to an output file. This showcases advanced file handling with dynamic record sizes.

## Purpose
The program demonstrates:
- Variable-length record processing
- Dynamic record size handling with DEPENDING ON clause
- OCCURS DEPENDING ON (ODO) for variable-sized tables
- Record length manipulation
- Field counting and dynamic array sizing
- Variable-length file I/O operations

## File Definitions

### Input File (INFILE)
- **Logical Name**: INFILE
- **Physical Name**: 'VARFILE1'
- **Recording Mode**: V (Variable)
- **Block Size**: 0 (system-determined)
- **Record Size**: 5 to 50 bytes (variable)
- **Length Control**: IN-RECLEN

### Output File (OUTFILE)
- **Logical Name**: OUTFILE
- **Physical Name**: 'VARFILE2'
- **Recording Mode**: V (Variable)
- **Block Size**: 0 (system-determined)
- **Record Size**: 5 to 50 bytes (variable)
- **Length Control**: OUT-RECLEN

## Data Structures

### File Status Codes
```cobol
INPUT-FILE-STATUS    PIC X(02)
    88  INFILE-OK        VALUE '00'
    88  END-OF-INPUT     VALUE '10'

OUTPUT-FILE-STATUS   PIC X(02)
    88  OUTFILE-OK       VALUE '00'
```

### Record Length Variables
- **IN-RECLEN**: Input record length (PIC S9(9) COMP)
- **OUT-RECLEN**: Output record length (PIC S9(4) COMP)

### Counters
- **RECORD-COUNT**: Number of records processed (PIC S9(5) COMP-3)
- **FIELD-COUNT**: Number of 5-byte fields in current record (PIC S9(3) COMP-3)

### Variable-Length Record Area
```cobol
RECORD-AREA
    RECORD-FIELD OCCURS 1 TO 10 DEPENDING ON FIELD-COUNT
                 PIC X(05)
```
- Can hold 1 to 10 fields
- Each field is 5 bytes
- Actual number determined by FIELD-COUNT at runtime

## Program Flow

### 1. File Opening
```cobol
OPEN INPUT INFILE
IF NOT INFILE-OK 
    DISPLAY 'INFILE STATUS ON OPEN: ' INPUT-FILE-STATUS
    GO TO END-OF-PROGRAM
END-IF    

OPEN OUTPUT OUTFILE
IF NOT OUTFILE-OK
    DISPLAY 'OUTFILE STATUS ON OPEN: ' OUTPUT-FILE-STATUS
    GO TO END-OF-PROGRAM
END-IF
```
- Opens both files with error checking
- Exits if either file fails to open

### 2. Main Processing Loop
```cobol
PERFORM UNTIL END-OF-INPUT 
    READ INFILE 
    IF INFILE-OK
        [Process record]
        ADD 1 TO RECORD-COUNT
END-PERFORM
```

### 3. Record Processing Logic

**Step 1: Calculate Field Count**
```cobol
COMPUTE FIELD-COUNT = IN-RECLEN / LENGTH OF RECORD-FIELD
```
- Divides input record length by 5 (field size)
- Determines how many complete fields are in the record

**Step 2: Move Input to Working Area**
```cobol
MOVE INPUT-RECORD TO RECORD-AREA
```
- Copies input record to the variable-length array

**Step 3: Add New Field**
```cobol
ADD 1 TO FIELD-COUNT 
MOVE 'XXXXX' TO RECORD-FIELD(FIELD-COUNT)
```
- Increments field count to add one more field
- Adds 'XXXXX' as the new field at the end

**Step 4: Calculate Output Length**
```cobol
COMPUTE OUT-RECLEN = FIELD-COUNT * LENGTH OF RECORD-FIELD
```
- Multiplies number of fields by 5
- Sets the output record length

**Step 5: Write Output Record**
```cobol
WRITE OUTPUT-RECORD FROM RECORD-AREA
```
- Writes the modified record to output file
- Uses OUT-RECLEN to determine how many bytes to write

### 4. Termination
```cobol
END-OF-PROGRAM.   
    DISPLAY 'NUMBER OF RECORDS PROCESSED: ' RECORD-COUNT 
    CLOSE INFILE
    CLOSE OUTFILE
    GOBACK
```

## Variable-Length Record Concepts

### DEPENDING ON Clause
The `DEPENDING ON` clause creates a variable-length table:
```cobol
RECORD-FIELD OCCURS 1 TO 10 DEPENDING ON FIELD-COUNT
```
- Minimum: 1 occurrence (5 bytes)
- Maximum: 10 occurrences (50 bytes)
- Actual size: Determined by FIELD-COUNT at runtime

### Record Length Management
Variable-length files require explicit length management:
- **IN-RECLEN**: Set by the READ operation (system provides actual length)
- **OUT-RECLEN**: Must be set by program before WRITE operation

### Recording Mode V
- **V** = Variable-length records
- System adds length prefix to each record
- Records can be different sizes
- More flexible but slightly more complex than fixed-length

## Example Processing

**Input Record (15 bytes):**
```
[AAAAA][BBBBB][CCCCC]
```
- IN-RECLEN = 15
- FIELD-COUNT = 15 / 5 = 3

**After Processing:**
```
[AAAAA][BBBBB][CCCCC][XXXXX]
```
- FIELD-COUNT = 4 (after ADD 1)
- OUT-RECLEN = 4 * 5 = 20

**Output Record (20 bytes):**
```
[AAAAA][BBBBB][CCCCC][XXXXX]
```

## Key Features

### Dynamic Array Sizing
- Array size changes based on FIELD-COUNT
- Efficient memory usage
- Flexible data handling

### Automatic Length Handling
- READ operation sets IN-RECLEN automatically
- Program calculates OUT-RECLEN explicitly
- System uses OUT-RECLEN for WRITE operation

### Field-Based Processing
- Treats records as arrays of 5-byte fields
- Easy to add, remove, or modify fields
- Structured approach to variable-length data

## Technical Notes

### COMP vs COMP-3
- **IN-RECLEN**: COMP (binary) - efficient for system-provided values
- **OUT-RECLEN**: COMP (binary) - efficient for calculations
- **FIELD-COUNT**: COMP-3 (packed decimal) - efficient for counters
- **RECORD-COUNT**: COMP-3 (packed decimal) - efficient for totals

### LENGTH OF Operator
```cobol
LENGTH OF RECORD-FIELD
```
- Returns the size of a single occurrence (5 bytes)
- Compile-time constant
- Used in calculations

### WRITE FROM Clause
```cobol
WRITE OUTPUT-RECORD FROM RECORD-AREA
```
- Writes from RECORD-AREA instead of OUTPUT-RECORD
- Useful when working with different data structures
- System uses OUT-RECLEN to determine bytes to write

## Error Handling

### File Open Errors
- Both files checked after opening
- Program exits if either fails
- Displays file status code

### Read/Write Errors
- Implicitly handled through file status
- Only processes records with INFILE-OK status
- No explicit write error checking (potential improvement)

## Use Cases

This type of program is useful for:
- Adding audit fields to existing records
- Appending timestamps or sequence numbers
- Data enrichment operations
- Record expansion for new requirements
- Migration to enhanced file formats

## Potential Improvements

1. Add write error checking
2. Validate field count doesn't exceed maximum (10)
3. Handle partial fields (when IN-RECLEN not divisible by 5)
4. Add more detailed error messages
5. Implement record validation

## Educational Value

This program teaches:
- Variable-length record processing
- OCCURS DEPENDING ON usage
- Dynamic array sizing
- Record length calculation and management
- Field-based data manipulation
- Advanced file I/O concepts
- Difference between fixed and variable-length files

## Comparison with CPSEQFR

| Feature | CPSEQFR | CPSEQVR |
|---------|---------|---------|
| Record Type | Fixed-length | Variable-length |
| Record Size | Always 40 bytes | 5-50 bytes |
| Operation | Field reordering | Field addition |
| Complexity | Simple | More complex |
| Length Management | Implicit | Explicit |
| Use Case | Format conversion | Data enrichment |