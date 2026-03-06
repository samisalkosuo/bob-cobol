# BRAKES.CBL - Brake Temperature Calculator

## Program Overview
**Program ID:** BRAKES

This COBOL program calculates the temperature increase (ΔT) in a vehicle's brakes due to energy dissipation during braking. It demonstrates a practical physics calculation using the principle of energy conservation and heat transfer.

## Purpose
The program demonstrates:
- Scientific calculations in COBOL
- Use of COMP-2 (double-precision floating-point) for physics calculations
- Formatted numeric output with picture clauses
- Energy and thermodynamics calculations

## Physics Background
When a vehicle brakes, kinetic energy is converted to heat energy in the brake system. This program calculates how much the brake temperature increases based on:
- The weight of the vehicle
- The height difference (potential energy)
- The mass and specific heat capacity of the brakes

## Data Structures

### Given Values (Input Constants)
- **m**: Mass of the brake system = 100 kg
- **sh**: Specific heat capacity = 800 J/(kg⋅°C)
- **w**: Weight of the vehicle = 10,000 N (Newtons)
- **d**: Height/distance = 75.0 m (meters)
- **a**: Acceleration due to gravity = 9.8 m/s²

### Calculated Values
- **Mgh**: Potential energy (or work done) in Joules
- **mc**: Heat capacity of the brake system (mass × specific heat)
- **deltaT-Celsius**: Temperature increase in degrees Celsius
- **deltaT-Celsius-Formatted**: Formatted output with decimal places

## Program Flow

### 1. Energy Calculation
Calculates the potential energy (or work done by brakes):
```
Mgh = w × a × d
```
Where:
- w = weight (10,000 N)
- a = acceleration (9.8 m/s²)
- d = distance (75.0 m)

Result: Mgh = 10,000 × 9.8 × 75.0 = 7,350,000 Joules

### 2. Heat Capacity Calculation
Calculates the total heat capacity of the brake system:
```
mc = m × sh
```
Where:
- m = mass of brakes (100 kg)
- sh = specific heat capacity (800 J/(kg⋅°C))

Result: mc = 100 × 800 = 80,000 J/°C

### 3. Temperature Change Calculation
Calculates the temperature increase:
```
ΔT = Mgh / mc
```

Result: ΔT = 7,350,000 / 80,000 = 91.875°C

### 4. Output
Displays the temperature increase in a formatted manner with the picture clause `Z,ZZ9.99`, which:
- Suppresses leading zeros
- Includes comma as thousands separator
- Shows two decimal places

## Formulas Used

### Energy Conservation
```
Potential Energy = Weight × Acceleration × Distance
Mgh = w × a × d
```

### Heat Transfer
```
Q = mc × ΔT
Therefore: ΔT = Q / mc
```

Where:
- Q = Heat energy (Joules)
- m = Mass (kg)
- c = Specific heat capacity (J/(kg⋅°C))
- ΔT = Temperature change (°C)

## Output Format
The program displays:
```
deltaT-Celsius:    91.88
```

The formatted output uses:
- `Z` for zero suppression
- `,` for thousands separator
- `9` for digits
- `.99` for two decimal places

## Technical Notes

### Data Types
- All calculations use COMP-2 (double-precision floating-point)
- This ensures accuracy for scientific calculations
- The formatted output uses a DISPLAY picture clause for readable output

### Calculation Precision
The program maintains high precision throughout calculations and only formats for display at the end, which is a best practice for scientific computing.

## Practical Application
This type of calculation is important for:
- Automotive engineering
- Brake system design
- Safety analysis
- Understanding energy dissipation in mechanical systems

## Educational Value
This program demonstrates:
- Real-world physics applications in COBOL
- Proper use of floating-point arithmetic
- Energy and thermodynamics calculations
- Formatted numeric output
- The relationship between mechanical work and heat energy

## Example Scenario
A vehicle weighing 10,000 N descends a 75-meter hill. The brakes (100 kg with specific heat capacity of 800 J/(kg⋅°C)) must dissipate all the potential energy. The program calculates that the brake temperature will increase by approximately 91.88°C.