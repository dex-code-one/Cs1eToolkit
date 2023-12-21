<#
.SYNOPSIS
    Creates a new instance of the ScriptLog class.

.DESCRIPTION
    The New-ScriptLog function is a utility to instantiate the [ScriptLog] class. It allows for the creation of a logging object with an optional custom log file path. If no path is provided, ScriptLog uses its default path settings.

.PARAMETER LogPath
    An optional parameter to specify the path of the log file. If not provided, ScriptLog will use a default path.

.EXAMPLE
    $log = New-ScriptLog -LogPath "C:\Logs\MyLog.log"
    This command creates a new instance of ScriptLog, directing the log output to "C:\Logs\MyLog.log".

.EXAMPLE
    $log = New-ScriptLog
    This command creates a new instance of ScriptLog with the default log file path of $env:ProgramData\1E\ScriptLogs\YYYY.MM.DD.HH.mm.ss.fffffff.log

.NOTES
    Author: john.nelson@1e.com
    Version: 1.0
    Requires: PowerShell 5.0 or higher
    Requires: ScriptLog class
#>
function New-ScriptLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$LogPath
    )
    
    # Emitting a verbose message if VerbosePreference is set to 'Continue'
    Write-Verbose "Creating a new instance of ScriptLog"
    $log = [ScriptLog]::new($LogPath)
    Write-Verbose "Log [$($log.LogFilePath)] was created or opened"
    return $log
}