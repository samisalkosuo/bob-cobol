# CPSEQFR.CBL - Sequential File Copy with Field Reordering

## Program Overview
**Program ID:** CPSEQFR

This COBOL program demonstrates sequential file processing by reading records from an input file and writing them to an output file with field reordering. It's a classic example of file I/O operations in COBOL with data transformation.

## Purpose
The program demonstrates:
- Sequential file processing (OPEN, READ, WRITE, CLOSE)
- File status checking and error handling
- Fixed-length record handling
- Field reordering during copy operations
- Record counting
- Proper file handling with status codes

## File Definitions

### Input File (INFILE)
- **Logical Name**: INFILE
- **Physical Name**: 'INFILE1'
- **Record Length**: 40 characters (fixed)
- **Recording Mode**: F (Fixed)
- **Block Size**: 0 (system-determined blocking)

**Record Structure:**
```
INPUT-RECORD (40 bytes total)
├── INPUT-FIRST-10  (10 bytes)
└── INPUT-LAST-30   (30 bytes)
```

### Output File (OUTFILE)
- **Logical Name**: OUTFILE
- **Physical Name**: 'OUTFILE1'
- **Record Length**: 40 characters (fixed)
- **Recording Mode**: F (Fixed)
- **Block Size**: 0 (system-determined blocking)

**Record Structure:**
```
OUTPUT-RECORD (40 bytes total)
├── OUTPUT-FIRST-30  (30 bytes)
└── OUTPUT-LAST-10   (10 bytes)
```

## Data Structures

### File Status Codes
```cobol
INPUT-FILE-STATUS  PIC X(02)
    88  GOOD-READ      VALUE '00'
    88  END-OF-INPUT   VALUE '10'

OUTPUT-FILE-STATUS PIC X(02)
    88  GOOD-WRITE     VALUE '00'
```

**Common File Status Codes:**
- '00' = Successful operation
- '10' = End of file reached
- Other values indicate errors

### Working Storage
- **RECORD-COUNT**: Tracks number of successfully processed records (PIC S9(5) COMP-3)

## Program Flow

### 1. Open Input File
```cobol
OPEN INPUT INFILE
IF NOT GOOD-READ 
    DISPLAY 'STATUS ON INFILE OPEN: ' INPUT-FILE-STATUS
    GO TO END-OF-PROGRAM
END-IF
```
- Opens file for reading
- Checks status immediately
- Exits if open fails

### 2. Open Output File
```cobol
OPEN OUTPUT OUTFILE 
IF NOT GOOD-WRITE 
    DISPLAY 'STATUS ON OUTFILE OPEN: ' OUTPUT-FILE-STATUS 
END-IF
```
- Opens file for writing
- Creates new file or overwrites existing
- Checks status but continues (note: should probably exit on error)

### 3. Main Processing Loop
```cobol
PERFORM UNTIL END-OF-INPUT
    READ INFILE 
    IF GOOD-READ 
        MOVE INPUT-FIRST-10 TO OUTPUT-LAST-10
        MOVE INPUT-LAST-30 TO OUTPUT-FIRST-30
        WRITE OUTPUT-RECORD 
        IF GOOD-WRITE 
            ADD 1 TO RECORD-COUNT
        ELSE
            DISPLAY 'STATUS ON OUTFILE WRITE: ' OUTPUT-FILE-STATUS
            GO TO END-OF-PROGRAM
        END-IF 
    END-IF  
END-PERFORM
```

**Processing Steps:**
1. Read a record from input file
2. If read successful:
   - Reorder fields (swap first and last portions)
   - Write to output file
   - If write successful, increment counter
   - If write fails, display error and exit
3. Continue until end of file

### 4. Cleanup and Termination
```cobol
END-OF-PROGRAM.   
    DISPLAY 'NUMBER OF RECORDS PROCESSED: ' RECORD-COUNT 
    CLOSE INFILE
    CLOSE OUTFILE 
    GOBACK
```
- Displays total records processed
- Closes both files
- Returns to calling program or OS

## Field Reordering Logic

**Input Record Layout:**
```
[10 bytes][30 bytes]
```

**Output Record Layout:**
```
[30 bytes][10 bytes]
```

**Transformation:**
- Input bytes 1-10 → Output bytes 31-40
- Input bytes 11-40 → Output bytes 1-30

This effectively swaps the first and last portions of each record.

## Error Handling

### File Open Errors
- Input file: Displays error and exits immediately
- Output file: Displays error but continues (potential issue)

### Read Errors
- Implicitly handled by END-OF-INPUT condition
- Only processes records with GOOD-READ status

### Write Errors
- Displays error message with status code
- Exits immediately to prevent data corruption

## File Status Codes Explained

### Success Codes
- **'00'**: Operation successful

### End-of-File Codes
- **'10'**: End of file reached (normal for sequential read)

### Common Error Codes (not explicitly handled but may occur)
- **'30'**: Permanent error (file not found, etc.)
- **'34'**: Boundary violation (record too large)
- **'35'**: File not found
- **'37'**: File not open
- **'39'**: File attribute conflict
- **'41'**: File already open
- **'42'**: File not open for operation attempted

## Best Practices Demonstrated

1. **Immediate Status Checking**: Checks file status after every I/O operation
2. **Condition Names**: Uses 88-level conditions for readable status checks
3. **Record Counting**: Tracks successful operations
4. **Proper File Closure**: Closes files before program termination
5. **Error Messages**: Provides diagnostic information on errors

## Potential Improvements

1. Output file open should exit on error (like input file)
2. Could add more detailed error messages
3. Could validate record format before processing
4. Could add summary statistics (bytes processed, etc.)

## Use Cases

This type of program is useful for:
- Data format conversion
- Field reordering for different systems
- Data migration between applications
- File format standardization
- ETL (Extract, Transform, Load) operations

## Technical Notes

### Fixed-Length Records
- Both files use fixed 40-byte records
- No delimiters needed
- Predictable I/O performance
- Simple field extraction by position

### Blocking Factor
- BLOCK CONTAINS 0 means system determines optimal blocking
- Improves I/O efficiency
- Transparent to program logic

### COMP-3 for Counter
- Uses packed decimal for efficient storage
- Suitable for counters and accumulators
- Saves space compared to display format

## Educational Value

This program teaches:
- Sequential file processing fundamentals
- File status checking and error handling
- Fixed-length record manipulation
- Field-level data movement
- Proper file handling lifecycle (open, process, close)
- Production-quality error handling patterns