# ATTRACT.CBL - Gravitational Attraction Calculator

## Program Overview
**Program ID:** ATTRACT

This COBOL program calculates the gravitational force of attraction between two celestial bodies using Newton's law of universal gravitation. It's an interactive program that prompts users to enter the physical properties of two bodies and then computes the gravitational force between them.

## Purpose
The program demonstrates:
- Interactive user input handling in COBOL
- Scientific calculations using floating-point arithmetic (COMP-2)
- Mathematical functions (SQRT, ATAN, COS, SIN)
- Structured programming with PERFORM statements
- Data validation and error handling

## Data Structures

### Computational Work Areas
- **G**: Gravitational constant (6.67428e-11 N⋅m²/kg²)
- **dx, dy**: Distance components between bodies on X and Y axes
- **d**: Total distance between the two bodies
- **f**: Total gravitational force
- **theta**: Angle for force decomposition
- **fx, fy**: Force components along X and Y axes

### Body Array
An array of 2 bodies, each containing:
- **mass**: Mass of the body in kilograms (COMP-2)
- **vx, vy**: Velocity components on X and Y axes (COMP-2)
- **px, py**: Position coordinates on X and Y axes (COMP-2)

### Display Areas
Various formatted text fields for user prompts and output display.

## Program Flow

### 1. Data Collection Phase
The program uses a loop to collect attributes for both bodies:
- Prompts for mass (in KG)
- Prompts for velocity on X-axis
- Prompts for velocity on Y-axis
- Prompts for position on X-axis
- Prompts for position on Y-axis

### 2. Verification Phase
Displays the entered attributes for both bodies to allow user verification.

### 3. Confirmation
Asks the user if they want to proceed with the calculation. If the user enters 'n' or 'N', the program exits gracefully.

### 4. Calculation Phase
If confirmed, the program:
1. Calculates the distance between bodies using the Pythagorean theorem:
   ```
   d = √((px₁ - px₂)² + (py₁ - py₂)²)
   ```

2. Checks if bodies are at the same position (d = 0) and exits if true

3. Calculates gravitational force using Newton's law:
   ```
   F = G × m₁ × m₂ / d²
   ```

4. Decomposes the force into X and Y components:
   ```
   θ = atan(dx)
   fx = cos(θ) × F
   fy = sin(θ) × F
   ```

## Key Features

### Mathematical Accuracy
- Uses COMP-2 (double-precision floating-point) for all calculations
- Implements proper scientific notation for the gravitational constant
- Handles vector decomposition for force components

### User Interaction
- Clear, descriptive prompts for all inputs
- Verification step before calculation
- Option to cancel before computation
- Formatted output with meaningful labels

### Error Handling
- Checks for zero distance (bodies at same position)
- Graceful exit when user cancels

## Formulas Used

1. **Distance Formula:**
   ```
   d = √(dx² + dy²)
   where dx = px₁ - px₂ and dy = py₁ - py₂
   ```

2. **Newton's Law of Universal Gravitation:**
   ```
   F = G × m₁ × m₂ / d²
   ```

3. **Force Component Decomposition:**
   ```
   fx = F × cos(θ)
   fy = F × sin(θ)
   where θ = atan(dx)
   ```

## Output
The program displays:
- Distance between the two bodies
- Total gravitational force of attraction
- Force component along the X-axis
- Force component along the Y-axis

## Technical Notes
- Uses indexed OCCURS clause for the Body array
- Employs PERFORM VARYING for loop control
- Demonstrates proper use of COBOL intrinsic functions
- Shows good separation of concerns with separate paragraphs for different tasks

## Educational Value
This program serves as an excellent example of:
- Scientific computing in COBOL
- Interactive program design
- Proper data structure organization
- Mathematical function usage in COBOL
- User-friendly input/output handling