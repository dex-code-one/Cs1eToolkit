<#
.SYNOPSIS
    A class for handling script logging in PowerShell.

.DESCRIPTION
    The ScriptLog class provides an easy way to create and manage log files for PowerShell scripts.
    It supports features like verbose, info, warning, and error message logging, log rotation based on size,
    and customizable logging levels.

    Simply create a new instance of the ScriptLog class, write your messages, and close the log when you're done.

.PARAMETER LogFilePath
    Specifies the path of the log file.

.PARAMETER MaxSize
    Sets the maximum size of the log file before it is rolled over. Default is 10MB.

.PARAMETER MaxRollovers
    Specifies the maximum number of rollover log files to keep. Default is 5.

.EXAMPLE
    $logger = [ScriptLog]::new("C:\logs\mylog.log")
    $logger.WriteInfo("This is an info message.")
    $logger.Close()

    This example creates a new instance of ScriptLog where the file is in c:\logs\mylog.log, writes an info message to the log, and then closes the log.

.EXAMPLE
    $logger = [ScriptLog]::new("C:\logs\mylog.log")
    $logger.WriteWarning("This is a warning message.")
    $logger.Close()

    This example creates a new instance of ScriptLog where the file is in c:\logs\mylog.log, writes a warning message to the log, and then closes the log.

.EXAMPLE
    $logger = [ScriptLog]::new("C:\logs\mylog.log")
    $logger.WriteError("This is an error message.")
    $logger.Close()

    This example creates a new instance of ScriptLog where the file is in c:\logs\mylog.log, writes an error message to the log, and then closes the log.

.EXAMPLE
    $logger = [ScriptLog]::new("stuff")
    $logger.WriteVerbose("This is a verbose message.")
    $logger.Close()

    This example creates a new instance of ScriptLog, writes a verbose message to the log, and then closes the log.
    Here there is no directory nor extension specified, so the log file will be created in C:\ProgramData\1E\ScriptLogs\stuff.log.

.EXAMPLE
    $logger = [ScriptLog]::new("stuff")
    $logger.Write("This is a custom message.")
    $logger.Close()

    This example creates a new instance of ScriptLog, writes a custom message to the log, and then closes the log.
    Here there is no directory nor extension specified, so the log file will be created in C:\ProgramData\1E\ScriptLogs\stuff.log.

.EXAMPLE
    $logger = [ScriptLog]::new()
    $logger.Write("This is a custom message.", "WARN")
    $logger.Close()

    This example creates a new instance of ScriptLog, writes a custom message to the log with a warning level, and then closes the log.
    Here there is nothing specified at all, so the log file will be created in C:\ProgramData\1E\ScriptLogs\YYYY.MM.DD.HH.mm.ss.fffffff.log.

.NOTES
    Author: john.nelson@1e.com
    Version: 202312.1823.2950.1

    Because we make use of the StreamWriter class, the log file can be written to very quickly and efficiently
    compared to other methods like Out-File or Add-Content. The StreamWriter is also opened in shared read/write
    mode, so the log file can be opened and read by other processes while the script is running.

    Don't forget to close the log when you're done with it!

    This class makes use of the following .NET classes:
        System.IO.File
        System.IO.FileInfo
        System.IO.Directory
        System.IO.StreamWriter
        System.DateTime
        System.IO.FileMode
        System.IO.FileAccess
        System.IO.FileShare

    This class makes use of the following PowerShell classes:
        System.IO.Path

#>
class ScriptLog : System.IDisposable {
    [string] $LogFilePath
    [System.IO.StreamWriter] $LogWriter
    [int64] $MaxSize = 10MB  # Default max log size
    [int] $MaxRollovers = 5  # Default max number of rollover logs
    [System.Collections.Hashtable]$ValidLevels # Valid log levels

    # Private members
    hidden [TimeZoneInfo] $localTimeZone = [TimeZoneInfo]::Local
    hidden [System.Collections.Hashtable] $abbreviationMap

    ScriptLog() {
        $defaultLogFileName = $MyInvocation.MyCommand.Name -replace '\.ps1$', ''
        if (-not $defaultLogFileName) {
            $defaultLogFileName = (Get-Date -Format "yyyy.MM.dd.HH.mm.ss.fffffff")
        }
        $this.LogFilePath = "$env:ProgramData\1E\ScriptLogs\$($defaultLogFileName).log"
        $this.InitializeLog()
    }

    ScriptLog([string] $FilePath) {
        if (-not [System.IO.Path]::IsPathRooted($FilePath)) {
            $FilePath = "$env:ProgramData\1E\ScriptLogs\$FilePath"
        }

        if (-not $FilePath.EndsWith(".log")) {
            $FilePath += ".log"
        }

        $this.LogFilePath = $FilePath
        $this.InitializeLog()
    }

    [void] InitializeLog() {
        # Initialize the local time zone
        $this.abbreviationMap = @{
            $true = $this.localTimeZone.DaylightName
            $false = $this.localTimeZone.StandardName
        }

        # Initialize the valid log levels
        $this.ValidLevels = @{
            "VERBOSE" = $true
            "INFO" = $true
            "WARN" = $true
            "ERROR" = $true
        }        

        $logDirectory = [System.IO.Path]::GetDirectoryName($this.LogFilePath)
        if (-not [System.IO.Directory]::Exists($logDirectory)) {
            [System.IO.Directory]::CreateDirectory($logDirectory)
        }
    
        $fileStream = [System.IO.File]::Open(
            $this.LogFilePath, 
            [System.IO.FileMode]::OpenOrCreate, # Open the file or create if it doesn't exist
            [System.IO.FileAccess]::ReadWrite,  # Allow reading and writing
            [System.IO.FileShare]::ReadWrite)   # Allow other processes to read/write
    
        $fileStream.Seek(0, [System.IO.SeekOrigin]::End) # Seek to the end of the file
    
        $this.LogWriter = New-Object System.IO.StreamWriter $fileStream
        $this.LogWriter.AutoFlush = $true # Flush the buffer after every write

        # If this is an empty rollover or new log, Write the log header
        if ($this.GetLogSize() -eq 0) {
            Write-Verbose 'Initializing new log. Writing log header.'
            $this.WriteLogHeader()
        }
    }    

    [void] WriteVerbose([string] $Message) {
        $this.Write($Message, "VERBOSE",$null)
    }

    [void] WriteInfo([string] $Message) {
        $this.Write($Message, "INFO",$null)
    }

    [void] WriteWarning([string] $Message) {
        $this.Write($Message, "WARN",$null)
    }

    [void] WriteError([string] $Message) {
        $this.Write($Message, "ERROR",$null)
    }

    # Overload for writing a message with level and context
    [void] Write([string] $Message, [string] $Level = 'INFO', [string] $Context = ' ') {
        # Check to see if adding this message will cause the log to rollover, rollover if necessary
        $this.RotateLog([System.Text.Encoding]::UTF8.GetByteCount($Message))

        # Validate a valid log level was specified
        if (-not $this.validLevels[$Level]) {$Level = 'INFO'}

        # Handle null or empty context
        if ([string]::IsNullOrWhiteSpace($Context)) {$Context = ' '}

        # Write the message to the log file
        $now = [DateTime]::UtcNow
        $localTime = $now.ToLocalTime()

        # Use hashtable to determine abbreviation without explicit if/else
        $abbreviation = $this.abbreviationMap[$this.localTimeZone.IsDaylightSavingTime($localTime)]

        $logEntry = "[{0:yyyy-MM-dd HH:mm:ss.fffffff}][{1:yyyy-MM-dd HH:mm:ss.fffffff} {2}] [$Level] [$Context] $Message" -f $now, $localTime, $abbreviation
        $this.LogWriter.WriteLine($logEntry)
    }

    # Overload for writing a message with a level
    [void] Write([string] $Message, [string] $Level) {
        $this.Write($Message, $Level, $null)
    }
    
    # Overload for writing a message with default level and context
    [void] Write([string] $Message) {
        $this.Write($Message, $null, $null)
    }    

    # Close the log file and dispose of the StreamWriter object
    [void] Close() {
        $this.Dispose()
    }

    # Close the log file and dispose of the StreamWriter object
    [void] Dispose() {
        if ($this.LogWriter) {
            try {
                $this.LogWriter.Close()
            } finally {
                $this.LogWriter.Dispose()
            }
            $this.LogWriter = $null
        }
    }

    # Method to return the size of the log file
    [int64] GetLogSize() {if ([System.IO.File]::Exists($this.LogFilePath)) {return [System.IO.FileInfo]::new($this.LogFilePath).Length} else {return 0}}

    # NewSeparator method adapted from New-Separator function
    [string] NewSeparator([string] $Type = 'Double', [int] $Length = 100, [string] $Name) {
        $separatorChars = @{
            'Single' = '─'
            'Double' = '═'
            'Thick'  = '█'
            'SingleTop' = @('┌', '─', '┐')
            'SingleBottom' = @('└', '─', '┘')
            'DoubleTop' = @('╔', '═', '╗')
            'DoubleBottom' = @('╚', '═', '╝')
            'ThickTop' = @('█', '▀', '█')
            'ThickBottom' = @('█', '▄', '█')
        }

        if ($Type -in @('SingleTop', 'SingleBottom', 'DoubleTop', 'DoubleBottom', 'ThickTop', 'ThickBottom')) {
            $leftChar = $separatorChars[$Type][0]
            $middleChar = $separatorChars[$Type][1]
            $rightChar = $separatorChars[$Type][2]
            if ([string]::IsNullOrEmpty($Name)) {
                $middleChar = $middleChar * ($Length - 2)
                return $leftChar + $middleChar + $rightChar
            } else {
                $name = $name.ToUpper()
                $adjustedLength = $length - 2 - $name.Length
                if ($adjustedLength -lt 0) {
                    throw "Length is too short to include the name"
                }
                $middle = $middleChar * 2 + $name + $middleChar * ($adjustedLength - 1)
                return $leftChar + $middle + $rightChar
            }
        } else {
            return $separatorChars[$Type] * $Length
        }
    }

    # Method to try moving a file with retries (useful for log rotation)
    [void] TryMoveFile($source, $destination) {
        $maxRetries = 5
        $delay = 500 # milliseconds

        for ($i = 0; $i -lt $maxRetries; $i++) {
            try {
                [System.IO.File]::Move($source, $destination)
                break
            } catch {
                Start-Sleep -Milliseconds $delay
            }
        }
    }

    # Method to try deleting a file with retries (useful for log rotation)
    [void] TryDeleteFile($file) {
        $maxRetries = 5
        $delay = 500 # milliseconds

        for ($i = 0; $i -lt $maxRetries; $i++) {
            try {
                [System.IO.File]::Delete($file)
                break
            } catch {
                Start-Sleep -Milliseconds $delay
            }
        }
    }

    # Method to write the log header on new/rollover logs
    hidden [void] WriteLogHeader() {
        # Operating System Details
        $osInfo = Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, OSArchitecture, InstallDate, LastBootUpTime
    
        # Hardware Information
        $cpuInfo = Get-CimInstance Win32_Processor | Select-Object Name
        $memoryInfo = Get-CimInstance Win32_PhysicalMemory | Measure-Object Capacity -Sum | Select-Object Sum
    
        # Disk Space Information
        $diskInfo = Get-PSDrive -PSProvider FileSystem | Select-Object -Unique Name, Used, Free, @{Name="TotalSize"; Expression={$_.Used + $_.Free}}
    
        # Network Settings
        $networkInfo = Get-NetAdapter | Select-Object Name, Status, MacAddress
        $ipAddress = Get-NetIPAddress | Select-Object IPAddress, InterfaceAlias
    
        # Runtime Environment
        $runtimeEnv = @{
            CurrentUser = [System.Environment]::UserName
            SystemDirectory = [System.Environment]::SystemDirectory
            MachineName = [System.Environment]::MachineName
        }
    
        # Format Output
        $output = @"
$($this.NewSeparator('DoubleTop',32,$null))
  NEW LOG: $([System.IO.FileInfo]::new($this.LogFilePath).CreationTime)
$($this.NewSeparator('Double',32,$null))
$($this.NewSeparator('DoubleTop',80,'System Information'))

Operating System:
    OS Name: $($osInfo.Caption)
    Version: $($osInfo.Version)
    Architecture: $($osInfo.OSArchitecture)
    Installed: $($osInfo.InstallDate)
    Last Boot Up Time: $($osInfo.LastBootUpTime)

Hardware Information:
    CPU: $($cpuInfo.Name)
    Total Physical Memory: $($memoryInfo.Sum)

Disk Space:

"@
    foreach ($disk in $diskInfo) {
        $output += "    Drive $($disk.Name): Used = $($disk.Used / 1GB) GB; Free = $($disk.Free / 1GB) GB; Total = $($disk.TotalSize / 1GB) GB`n"
    }

    $output += @"
    
Network Information:
    Adapter Name: $($networkInfo.Name)
    Status: $($networkInfo.Status)
    MAC Address: $($networkInfo.MacAddress)
    IP Address: $($ipAddress.IPAddress)

Runtime Environment:
    Current User: $($runtimeEnv.CurrentUser)
    System Directory: $($runtimeEnv.SystemDirectory)
    Machine Name: $($runtimeEnv.MachineName)

$($this.NewSeparator('DoubleBottom',80,'System Information'))
"@
        $this.LogWriter.WriteLine($output)
    }        

    
    # Method to check the log size and rotate if necessary
    [void] RotateLog([int32]$AddedBytes = 0) {
        $logSize = [System.IO.FileInfo]::new($this.LogFilePath).Length + $AddedBytes

        if ($logSize -gt $this.maxSize) {
            # Close and dispose the current StreamWriter
            if ($this.LogWriter) {
                $this.LogWriter.Close()
                $this.LogWriter.Dispose()
                $this.LogWriter = $null # Clear the object
            }

            # Rotate the log files
            for ($i = $this.maxRollovers - 1; $i -gt 0; $i--) {
                $oldLog = "$($this.LogFilePath).$i"
                $newLog = "$($this.LogFilePath).$($i + 1)"
                if ([System.IO.File]::Exists($oldLog)) {
                    $this.TryMoveFile($oldLog, $newLog)
                }
            }

            # Rename the current log file to the first rollover
            $this.TryMoveFile($this.LogFilePath, "$($this.LogFilePath).1")

            # Delete the oldest log file if it exists
            $oldestLog = "$($this.LogFilePath).$($this.maxRollovers)"
            if ([System.IO.File]::Exists($oldestLog)) {
                $this.TryDeleteFile($oldestLog)
            }

            # Reinitialize log for a new file
            $this.InitializeLog()
        }
    }
}
