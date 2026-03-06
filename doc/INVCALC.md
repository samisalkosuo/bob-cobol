# INVCALC.CBL - Invoice Calculator with Sales Tax

## Program Overview
**Program ID:** INVCALC

This COBOL program demonstrates a complete invoice calculation system with sales tax processing. It creates a sample invoice with multiple line items, calculates totals including sales tax for taxable items, and displays a formatted invoice report.

## Purpose
The program demonstrates:
- Complex data structures with nested OCCURS
- Invoice processing logic
- Sales tax calculations
- Conditional processing (taxable vs non-taxable items)
- OCCURS DEPENDING ON for variable-length arrays
- Level 88 condition names for item status
- Formatted numeric output
- Business calculation patterns
- Report generation

## Data Structures

### Invoice Structure
```cobol
INVOICE
├── INV-DATE (8 chars: YYYYMMDD)
├── INV-NUMBER (8 chars)
├── INV-TOTAL-AMOUNT (COMP-3)
├── INV-TOTAL-BEFORE-TAX (COMP-3)
├── INV-TOTAL-SALES-TAX (COMP-3)
├── INV-RETURN (1 char)
│   └── 88 IS-RETURN (VALUE 'R')
├── INV-LINE-ITEM-COUNT (COMP-3)
└── INV-LINE (OCCURS 1 TO 100 DEPENDING ON INV-LINE-ITEM-COUNT)
    ├── INV-LINE-SKU (10 chars)
    ├── INV-LINE-UNIT-PRICE (COMP-3)
    ├── INV-LINE-QUANTITY (COMP-3)
    └── INV-LINE-TAXABLE (1 char)
        ├── 88 TAXABLE-ITEM (VALUE 'T')
        └── 88 NONTAXABLE-ITEM (VALUE 'N')
```

### Working Storage
```cobol
FILLER
├── SALES-TAX-RATE (COMP-3: 0.065 = 6.5%)
├── WORKING-INDEX (COMP)
├── CUMULATIVE-PRICE-BEFORE-TAX (COMP-3)
├── CUMULATIVE-PRICE-WITH-TAX (COMP-3)
├── CUMULATIVE-SALES-TAX (COMP-3)
├── LINE-WORKING-TOTAL (COMP-3)
└── LINE-WORKING-TAX (COMP-3)
```

### Formatted Output Fields
```cobol
INVOICE-FORMATTED
├── INV-DATE-FORMATTED (10 chars: YYYY/MM/DD)
├── INV-TOTAL-AMOUNT-FORMATTED ($,$$$,$$9.99)
├── INV-TOTAL-BEFORE-TAX-FORMATTED ($,$$$,$$9.99)
├── INV-TOTAL-SALES-TAX-FORMATTED ($$,$$9.999)
├── INV-LINE-QUANTITY-FORMATTED (Z,ZZ9)
├── INV-LINE-UNIT-PRICE-FORMATTED ($$,$$9.99)
├── SALES-TAX-RATE-FORMATTED (.99999)
└── LINE-NUMBER-FORMATTED (ZZ9)
```

## Sample Invoice Data

### Invoice Header
- Date: 20230914 (September 14, 2023)
- Number: Sample 1
- Line Item Count: 3

### Line Items

**Line 1:**
- SKU: PROD004411
- Unit Price: $18.55
- Quantity: 2
- Taxable: Yes
- Line Total: $37.10
- Tax: $2.41 (6.5%)
- Total with Tax: $39.51

**Line 2:**
- SKU: PROD004412
- Unit Price: $6.32
- Quantity: 4
- Taxable: No
- Line Total: $25.28
- Tax: $0.00
- Total with Tax: $25.28

**Line 3:**
- SKU: PROD004413
- Unit Price: $2.28
- Quantity: 8
- Taxable: Yes (Note: Bug in code - sets TAXABLE-ITEM(1) instead of (3))
- Line Total: $18.24
- Tax: $1.19 (6.5%)
- Total with Tax: $19.43

### Invoice Totals
- Total Before Tax: $80.62
- Total Sales Tax: $3.60
- Total Amount: $84.22

## Program Flow

### 1. Initialize Invoice
```cobol
INITIALIZE INVOICE 
    REPLACING ALPHANUMERIC DATA BY SPACES 
              NUMERIC DATA BY ZEROES
```
- Clears all fields
- Sets alphanumeric to spaces
- Sets numeric to zeros

### 2. Set Invoice Header
```cobol
MOVE '20230914' TO INV-DATE  
MOVE 'Sample 1' TO INV-NUMBER 
MOVE 3 TO INV-LINE-ITEM-COUNT
```

### 3. Populate Line Items
For each line item:
```cobol
MOVE 'PROD004411' TO INV-LINE-SKU(1)  
MOVE 18.55 TO INV-LINE-UNIT-PRICE(1)
MOVE 2 TO INV-LINE-QUANTITY(1)
SET TAXABLE-ITEM(1) TO TRUE
```

### 4. Calculate Totals
```cobol
PERFORM WITH TEST BEFORE 
    VARYING WORKING-INDEX FROM 1 BY 1 
    UNTIL WORKING-INDEX > INV-LINE-ITEM-COUNT
    [calculation logic]
END-PERFORM
```

**For each line item:**

a. **Validate Data**
```cobol
IF INV-LINE-QUANTITY(WORKING-INDEX) IS NUMERIC 
AND INV-LINE-UNIT-PRICE(WORKING-INDEX) IS NUMERIC
```

b. **Calculate Line Total**
```cobol
MULTIPLY INV-LINE-QUANTITY(WORKING-INDEX) 
    BY INV-LINE-UNIT-PRICE(WORKING-INDEX) 
    GIVING LINE-WORKING-TOTAL
```

c. **Add to Subtotal**
```cobol
ADD LINE-WORKING-TOTAL TO CUMULATIVE-PRICE-BEFORE-TAX
```

d. **Calculate Tax (if taxable)**
```cobol
IF TAXABLE-ITEM(WORKING-INDEX) 
    MULTIPLY LINE-WORKING-TOTAL
        BY SALES-TAX-RATE 
        GIVING LINE-WORKING-TAX
    ADD LINE-WORKING-TAX TO LINE-WORKING-TOTAL
END-IF
```

e. **Add to Grand Total**
```cobol
ADD LINE-WORKING-TOTAL TO CUMULATIVE-PRICE-WITH-TAX
ADD LINE-WORKING-TAX TO CUMULATIVE-SALES-TAX
```

### 5. Store Final Totals
```cobol
MOVE CUMULATIVE-SALES-TAX TO INV-TOTAL-SALES-TAX 
MOVE CUMULATIVE-PRICE-BEFORE-TAX TO INV-TOTAL-BEFORE-TAX 
MOVE CUMULATIVE-PRICE-WITH-TAX TO INV-TOTAL-AMOUNT
```

### 6. Print Invoice
```cobol
PERFORM PRINT-INVOICE-DETAILS
```

## Calculation Logic

### Line Total Calculation
```
Line Total = Quantity × Unit Price
```

### Tax Calculation (for taxable items)
```
Line Tax = Line Total × Sales Tax Rate
Line Total with Tax = Line Total + Line Tax
```

### Invoice Totals
```
Total Before Tax = Sum of all line totals (before tax)
Total Sales Tax = Sum of all line taxes
Total Amount = Total Before Tax + Total Sales Tax
```

## Output Format

### Invoice Header
```
----------------------------------------
Invoice Number:   Sample 1
Invoice Date:     2023/09/14
Total Amount:     $84.22
Total Before Tax: $80.62
Total Sales Tax:  $3.600
Sales Tax Rate:   .06500
```

### Line Item Detail
```
Line   1
SKU  PROD004411
Quantity    2
Unit Price:  $18.55
Taxable Item

Line   2
SKU  PROD004412
Quantity    4
Unit Price:  $6.32
Nontaxable Item

Line   3
SKU  PROD004413
Quantity    8
Unit Price:  $2.28
Taxable Item
```

## Picture Clauses for Formatting

### Currency Format
```cobol
PIC $,$$$,$$9.99
```
- Dollar sign
- Comma thousands separator
- Two decimal places
- Example: $1,234.56

### Quantity Format
```cobol
PIC Z,ZZ9
```
- Zero suppression (Z)
- Comma separator
- Right-aligned
- Example: 1,234 or 5

### Tax Rate Format
```cobol
PIC .99999
```
- Five decimal places
- Example: .06500 (6.5%)

### Line Number Format
```cobol
PIC ZZ9
```
- Zero suppression
- Right-aligned
- Example: 1, 12, 123

## Key Features

### OCCURS DEPENDING ON
```cobol
INV-LINE OCCURS 1 TO 100 DEPENDING ON INV-LINE-ITEM-COUNT
```
- Variable-length array
- Minimum 1, maximum 100 line items
- Actual count in INV-LINE-ITEM-COUNT
- Efficient memory usage

### Level 88 Condition Names
```cobol
88 TAXABLE-ITEM VALUE 'T'
88 NONTAXABLE-ITEM VALUE 'N'
```
- Self-documenting code
- Easy to test: `IF TAXABLE-ITEM(index)`
- Easy to set: `SET TAXABLE-ITEM(index) TO TRUE`

### Data Validation
```cobol
IF INV-LINE-QUANTITY(WORKING-INDEX) IS NUMERIC 
AND INV-LINE-UNIT-PRICE(WORKING-INDEX) IS NUMERIC
```
- Validates data before calculation
- Prevents arithmetic errors
- Calls error handler if invalid

### COMP-3 for Financial Data
- Packed decimal format
- Exact decimal arithmetic
- No rounding errors
- Efficient storage

## Date Formatting

### Input Format
```
20230914 (YYYYMMDD)
```

### Output Format
```
2023/09/14 (YYYY/MM/DD)
```

### Conversion Logic
```cobol
MOVE INV-DATE(1:4) TO INV-DATE-FORMATTED(1:4)   -- Year
MOVE '/' TO INV-DATE-FORMATTED(5:1)             -- Separator
MOVE INV-DATE(5:2) TO INV-DATE-FORMATTED(6:2)   -- Month
MOVE '/' TO INV-DATE-FORMATTED(8:1)             -- Separator
MOVE INV-DATE(7:2) TO INV-DATE-FORMATTED(9:2)   -- Day
```

## Business Rules

### Sales Tax
- Rate: 6.5% (0.065)
- Applied only to taxable items
- Calculated per line item
- Accumulated for invoice total

### Taxable vs Non-Taxable
- Each line item has taxable flag
- 'T' = Taxable
- 'N' = Non-taxable
- Affects tax calculation only

### Return Processing
```cobol
88 IS-RETURN VALUE 'R'
```
- Flag for return invoices
- Displayed if set
- Could affect calculations (not implemented)

## Error Handling

### Invalid Data
```cobol
IF INV-LINE-QUANTITY(WORKING-INDEX) IS NUMERIC 
AND INV-LINE-UNIT-PRICE(WORKING-INDEX) IS NUMERIC
    [process]
ELSE 
    PERFORM INVALID-INVOICE-DATA 
END-IF
```

### Error Handler
```cobol
INVALID-INVOICE-DATA. 
    DISPLAY 'Invalid invoice data'
```
- Simple error message
- Could be enhanced with details
- Continues processing (doesn't abort)

## Code Issues

### Bug in Line 3 Setup
```cobol
SET TAXABLE-ITEM(1) TO TRUE
```
Should be:
```cobol
SET TAXABLE-ITEM(3) TO TRUE
```
- Sets wrong line item's taxable flag
- Copy-paste error
- Demonstrates importance of testing

## Use Cases

This program pattern is useful for:
- Invoice generation systems
- Order processing
- Sales tax calculation
- Receipt printing
- E-commerce checkout
- Point-of-sale systems
- Accounting applications

## Educational Value

This program teaches:
- Complex data structure design
- Variable-length arrays (ODO)
- Financial calculations
- Sales tax processing
- Data validation
- Formatted output
- Business logic implementation
- Report generation
- Level 88 condition names
- COMP-3 for financial data

## Best Practices Demonstrated

1. **Data Validation**: Check numeric fields before arithmetic
2. **Packed Decimal**: Use COMP-3 for financial data
3. **Condition Names**: Use 88-levels for flags
4. **Initialization**: Clear data structures before use
5. **Separation of Concerns**: Calculation and display separated
6. **Formatted Output**: Professional-looking reports
7. **Accumulation**: Proper totaling logic

## Potential Enhancements

1. **Fix Bug**: Correct line 3 taxable flag
2. **Return Handling**: Implement negative amounts for returns
3. **Discount Support**: Add discount calculations
4. **Multiple Tax Rates**: Support different rates per item
5. **Validation**: More comprehensive data validation
6. **Error Recovery**: Better error handling
7. **Subtotals**: Add category subtotals
8. **Rounding**: Implement proper rounding rules

## Summary

INVCALC.CBL is a comprehensive example of business calculation logic in COBOL, demonstrating:
- Invoice data structure design
- Sales tax calculation
- Variable-length arrays
- Financial data handling
- Report formatting
- Data validation

It serves as an excellent template for invoice processing systems and demonstrates professional COBOL programming practices for business applications.