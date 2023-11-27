<#
.SYNOPSIS
    Generates a version number based on the current date and time.

.DESCRIPTION
    The New-Version function creates a version number using the current date and time.
    The format of the version number is A.B.C.D, where:
    - A represents the year and month in the format YYYYMM.
    - B represents the day and hour in the format DDHH.
    - C represents the minute and second in the format MMSS.
    - D is a constant segment, set to 1.

    This versioning system ensures that each version number is unique and sequentially 
    meaningful, based on the exact time of generation.

    This function does not accept any parameters.

.EXAMPLE
    PS> New-Version
    This example generates a version number based on the current date and time.

.OUTPUTS
    System.Version
    The output is a System.Version object, which represents the generated version number.

.NOTES
    Author: john.nelson@1e.com
    Version: 1.0
    Date: 2023-11-26

#>
function New-Version {
    [CmdletBinding()]
    [OutputType([System.Version])]
    $currentTime = Get-Date
    
    # format: A.B.C.D where:
    # A = YYYYMM
    # B = DDHH
    # C = MMSS
    # D = 1

    # A - Year and Month (6 digits)
    $yearMonthSegment = ($currentTime.Year.ToString() + $currentTime.Month.ToString("00"))

    # B - Day and Hour (4 digits)
    $dayHourSegment = ($currentTime.Day.ToString("00") + $currentTime.Hour.ToString("00"))

    # C - Minute and Second (4 digits)
    $minuteSecondSegment = ($currentTime.Minute.ToString("00") + $currentTime.Second.ToString("00"))

    # D - Default to 1
    $incrementingSegment = 1

    return [System.Version]"$yearMonthSegment.$dayHourSegment.$minuteSecondSegment.$incrementingSegment"  
    
}