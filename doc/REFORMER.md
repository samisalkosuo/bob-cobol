# REFORMER.CBL - Data Transformation and Reformatting

## Program Overview
**Program ID:** REFORMER

This COBOL program demonstrates comprehensive data transformation techniques, converting data from one format to another. It shows field reordering, date conversion, SKU lookup and transformation, data type conversion, and hexadecimal display of the transformed record.

## Purpose
The program demonstrates:
- Data format conversion
- Date reformatting (MM/DD/YY to YYYYMMDD)
- Table lookup and code transformation
- Field reordering and restructuring
- Data type conversion (display to packed decimal)
- UNSTRING for parsing delimited data
- STRING for building formatted data
- SEARCH statement for table lookup
- Hexadecimal display of binary data
- Record transformation patterns

## Input Record Structure

```cobol
INPUT-RECORD (96 bytes)
├── IN-PRODUCT-CODE (4 chars)
├── FILLER (4 chars - spacing)
├── IN-PRODUCT-DESC (60 chars)
├── FILLER (2 chars - spacing)
├── IN-INVOICE-NO (8 chars)
├── IN-QUANTITY (4 digits)
├── IN-UNIT-PRICE (5 digits with 2 decimals)
├── FILLER (2 chars - spacing)
├── IN-INVOICE-DATE (8 chars: MM/DD/YY)
└── IN-TAXABLE (1 char: Y/N)
```

## Output Record Structure

```cobol
OUTPUT-RECORD (73 bytes)
├── OUT-SKU (10 chars)
├── FILLER (1 char)
│   └── 88 TAXABLE-ITEM (VALUE 'T', FALSE 'N')
├── OUT-ITEM-DESC (30 chars)
├── OUT-QUANTITY (COMP-3)
├── OUT-UNIT-PRICE (COMP-3)
├── OUT-INVOICE-NO (16 chars)
└── OUT-INV-DATE-YYYY-MM-DD (8 chars: YYYYMMDD)
```

## Sample Data

### Input
```
Product Code:    PK29
Description:     Pastel 29
Invoice Number:  I00956A5
Quantity:        3
Unit Price:      5.49
Invoice Date:    10/15/22
Taxable:         Y
```

### Output
```
SKU:             PKCC1929
Taxable:         T
Description:     Pastel 29
Quantity:        3 (packed decimal)
Unit Price:      5.49 (packed decimal)
Invoice Number:  I00956A5
Date:            20221015
```

## Transformation Steps

### 1. Date Conversion (MM/DD/YY → YYYYMMDD)

**Input:** "10/15/22"

**Step 1: Parse with UNSTRING**
```cobol
UNSTRING IN-INVOICE-DATE 
    DELIMITED BY WS-SLASH 
    INTO 
        WS-DATE-MONTH    -- "10"
        WS-DATE-DAY      -- "15"
        WS-DATE-YEAR     -- "22"
END-UNSTRING
```

**Step 2: Add Century**
```cobol
MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-DATA
MOVE WS-CURRENT-CENTURY TO WS-DATE-CENTURY  -- "20"
```

**Step 3: Build YYYYMMDD**
```cobol
MOVE WS-DATE-WORK-AREA TO OUT-INV-DATE-YYYY-MM-DD
```

**Result:** "20221015"

### 2. SKU Transformation

**Input Product Code:** "PK29"

**Step 1: Extract Prefix**
```
First 2 characters: "PK"
```

**Step 2: Lookup in Table**
```cobol
SEARCH WS-SKU-LOOKUP-ENTRY 
    AT END  
        MOVE WS-DEFAULT-SKU-PREFIX TO WS-SKU-PREFIX 
    WHEN THEIR-PRODUCT-CODE-PREFIX (SKU-INDEX) 
         IS EQUAL TO IN-PRODUCT-CODE(1:2) 
            MOVE OUR-SKU-GROUP-CODE (SKU-INDEX) 
                TO WS-SKU-PREFIX 
END-SEARCH
```

**Lookup Table:**
```
AB → ABTC
GT → GTHH
KR → KRNB
PK → PKCC  ← Match!
ZW → ZWYT
```

**Step 3: Build SKU**
```cobol
STRING 
    WS-SKU-PREFIX DELIMITED BY SIZE        -- "PKCC"
    IN-PRODUCT-CODE(3:2) DELIMITED BY SIZE -- "29"
    INTO OUT-SKU
END-STRING
```

**Result:** "PKCC1929"

### 3. Taxable Flag Conversion

**Input:** 'Y' (Yes) or 'N' (No)

**Conversion:**
```cobol
IF IN-TAXABLE IS EQUAL TO 'Y' 
    SET TAXABLE-ITEM TO TRUE    -- Sets to 'T'
ELSE  
    SET TAXABLE-ITEM TO FALSE   -- Sets to 'N'
END-IF
```

**Result:** 'T' or 'N'

### 4. Numeric Field Conversion

**Quantity:**
```cobol
MOVE IN-QUANTITY TO OUT-QUANTITY
```
- Input: PIC 9(04) (display format)
- Output: PIC S9(5) COMP-3 (packed decimal)
- Automatic conversion

**Unit Price:**
```cobol
MOVE IN-UNIT-PRICE TO OUT-UNIT-PRICE
```
- Input: PIC S9(03)V99 (display format)
- Output: PIC S9(7)V99 COMP-3 (packed decimal)
- Automatic conversion

## SKU Lookup Table

### Table Definition
```cobol
WS-SKU-LOOKUP-DATA
├── 'ABTC45' → AB maps to ABTC, suffix 45
├── 'GTHH05' → GT maps to GTHH, suffix 05
├── 'KRNB13' → KR maps to KRNB, suffix 13
├── 'PKCC19' → PK maps to PKCC, suffix 19
└── 'ZWYT54' → ZW maps to ZWYT, suffix 54
```

### Table Structure (REDEFINES)
```cobol
WS-SKU-LOOKUP-TABLE REDEFINES WS-SKU-LOOKUP-DATA
    WS-SKU-LOOKUP-ENTRY OCCURS 5 TIMES INDEXED BY SKU-INDEX
        ├── THEIR-PRODUCT-CODE-PREFIX (2 chars)
        └── OUR-SKU-GROUP-CODE (4 chars)
```

### Default SKU
```cobol
WS-DEFAULT-SKU-PREFIX PIC X(04) VALUE 'XX00'
```
- Used when no match found
- Indicates unknown product code

## SEARCH Statement

### Syntax
```cobol
SEARCH table-entry
    AT END
        [statements if not found]
    WHEN condition
        [statements if found]
END-SEARCH
```

### How It Works
1. Starts at current index position
2. Tests WHEN condition
3. If true, executes WHEN statements and exits
4. If false, increments index and continues
5. If end of table reached, executes AT END

### Index Management
- Index must be set before SEARCH
- SEARCH automatically increments index
- Index remains at found position after SEARCH

## UNSTRING Statement

### Purpose
Parses delimited strings into separate fields

### Syntax
```cobol
UNSTRING source-string
    DELIMITED BY delimiter
    INTO field1 field2 field3
END-UNSTRING
```

### Example
```
Input: "10/15/22"
Delimiter: "/"
Result: "10", "15", "22"
```

## STRING Statement

### Purpose
Concatenates multiple fields into one

### Syntax
```cobol
STRING 
    source1 DELIMITED BY delimiter1
    source2 DELIMITED BY delimiter2
    INTO target
END-STRING
```

### Example
```
Source1: "PKCC" (DELIMITED BY SIZE)
Source2: "29" (DELIMITED BY SIZE)
Result: "PKCC29"
```

## Hexadecimal Display

### Purpose
Shows internal representation of transformed record

### Process
```cobol
MOVE OUTPUT-RECORD TO WS-ORIGINAL-VALUE 
MOVE LENGTH OF OUTPUT-RECORD TO WS-ORIGINAL-LENGTH
CALL 'HEX2TEXT' USING WS-HEX2TEXT-CONVERSION
```

### Output Format
```
High-order nibbles: [hex digits]
Low-order nibbles:  [hex digits]
```

### Hex Display Loop
```cobol
PERFORM 
    WITH TEST BEFORE 
    VARYING HEX-OFFSET FROM 1 BY 2 
    UNTIL HEX-OFFSET IS GREATER THAN LENGTH OF OUTPUT-RECORD * 2    
     ADD 1 TO HEX-TARGET       
     MOVE WS-RESULT(HEX-OFFSET:1) 
         TO HEX-OUTPUT-RECORD-HIGH-ORDER(HEX-TARGET:1) 
     MOVE WS-RESULT(HEX-OFFSET + 1:1) 
         TO HEX-OUTPUT-RECORD-LOW-ORDER(HEX-TARGET:1)           
END-PERFORM
```

**Separates hex bytes into two lines:**
- High-order nibbles (first digit of each byte)
- Low-order nibbles (second digit of each byte)

## Data Type Conversions

### Display to Packed Decimal
```cobol
Input:  PIC 9(04)        -- 4 bytes
Output: PIC S9(5) COMP-3 -- 3 bytes
```
- More efficient storage
- Faster arithmetic
- Exact decimal precision

### Alphanumeric to Alphanumeric
```cobol
Input:  PIC X(60)
Output: PIC X(30)
```
- Truncated if too long
- Padded if too short

### Date Format Change
```cobol
Input:  MM/DD/YY (8 chars with slashes)
Output: YYYYMMDD (8 chars, no separators)
```
- Removes delimiters
- Adds century
- Standardizes format

## CURRENT-DATE Usage

### Purpose
Get current century for date conversion

### Structure
```cobol
WS-CURRENT-DATE-DATA
├── WS-CURRENT-DATE
│   └── WS-CURRENT-FULL-YEAR
│       └── WS-CURRENT-CENTURY (2 digits)
└── [other fields]
```

### Usage
```cobol
MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-DATA
MOVE WS-CURRENT-CENTURY TO WS-DATE-CENTURY
```

## Output Examples

### Example 1: Date Conversion
```
Input:  10/15/22
Output: 20221015
```

### Example 2: SKU Transformation
```
Input:  PK29
Output: PKCC1929
```

### Example 3: Converted Record
```
<PKCC1929TPastel 29........................[binary data]........I00956A5........20221015>
```

### Example 4: Hexadecimal Display
```
<[High-order nibbles of each byte]>
<[Low-order nibbles of each byte]>
```

## Use Cases

This transformation pattern is useful for:
- Data migration between systems
- Format standardization
- Legacy system integration
- ETL (Extract, Transform, Load) processes
- Data warehouse loading
- File format conversion
- System interface development

## Key Techniques

### 1. Reference Modification
```cobol
IN-PRODUCT-CODE(1:2)  -- First 2 characters
IN-PRODUCT-CODE(3:2)  -- Characters 3-4
```

### 2. Table Lookup
```cobol
SEARCH table-entry
    WHEN condition
        [action]
END-SEARCH
```

### 3. String Parsing
```cobol
UNSTRING source DELIMITED BY delimiter
    INTO field1 field2 field3
```

### 4. String Building
```cobol
STRING source1 source2 INTO target
```

### 5. Type Conversion
```cobol
MOVE display-field TO packed-field
```

## Educational Value

This program teaches:
- Data transformation patterns
- Format conversion techniques
- Table lookup operations
- String parsing and building
- Date manipulation
- Type conversion
- Hexadecimal display
- SEARCH statement usage
- Reference modification
- Real-world data integration

## Best Practices Demonstrated

1. **Lookup Tables**: Centralized code mapping
2. **Default Values**: Handle unknown codes gracefully
3. **Date Standardization**: Use YYYYMMDD format
4. **Type Conversion**: Use appropriate data types
5. **Validation**: Check for valid data
6. **Documentation**: Clear field descriptions
7. **Hexadecimal Display**: Debug binary data

## Potential Enhancements

1. **Error Handling**: Validate date components
2. **Logging**: Track transformations
3. **Statistics**: Count conversions by type
4. **Validation**: Check SKU format
5. **Flexible Tables**: Load lookup table from file
6. **Multiple Formats**: Support various date formats
7. **Batch Processing**: Process multiple records

## Common Pitfalls

1. **Century Assumption**: Always validate century logic
2. **Table Size**: Ensure table is large enough
3. **Index Initialization**: Set index before SEARCH
4. **Delimiter Handling**: Handle missing delimiters
5. **Truncation**: Check field sizes match
6. **Type Mismatch**: Validate conversions

## Summary

REFORMER.CBL is a comprehensive example of data transformation in COBOL, demonstrating:
- Multiple transformation techniques
- Date format conversion
- Code lookup and mapping
- Data type conversion
- String manipulation
- Hexadecimal visualization

It serves as an excellent template for data integration and ETL processes, showing professional patterns for transforming data between different formats and systems.