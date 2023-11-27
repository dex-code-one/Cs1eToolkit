---
external help file: Cs1eToolkit-help.xml
Module Name: Cs1eToolkit
online version:
schema: 2.0.0
---

# New-1EVersion

## SYNOPSIS
Generates a version number based on the current date and time.

## SYNTAX

```
New-1EVersion
```

## DESCRIPTION
The New-Version function creates a version number using the current date and time.
The format of the version number is A.B.C.D, where:
- A represents the year and month in the format YYYYMM.
- B represents the day and hour in the format DDHH.
- C represents the minute and second in the format MMSS.
- D is a constant segment, set to 1.

This versioning system ensures that each version number is unique and sequentially 
meaningful, based on the exact time of generation.

This function does not accept any parameters.

## EXAMPLES

### EXAMPLE 1
```
New-Version
This example generates a version number based on the current date and time.
```

## PARAMETERS

## INPUTS

## OUTPUTS

### System.Version
### The output is a System.Version object, which represents the generated version number.
## NOTES
Author: john.nelson@1e.com
Version: 1.0
Date: 2023-11-26

## RELATED LINKS
