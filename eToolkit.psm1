# This file is meant to be viewed in VSCode.  It is not intended to be run directly.
# Use CTRL+K CTRL+0 collapse all outlined sections for better readability.
#
# Module: Cs1eToolkit
# Author: John.Nelson@1e.com
# Version: 202312.1823.2950.1
#
# This module contains all of the functions and classes that are used by the 1E Customer Success team

#region Variables

#endregion Variables

#region Classes

    #----------------------------------------------------------------
    #region CsLogEntry Class
    #----------------------------------------------------------------
    class CsLogEntry {
        #================================================================================================================================
        #region Public Properties
            [string] $TimeStamp
            [string] $ContextHash
            [string] $Level
            [string] $EntryHash
            [string] $Message
        #endregion
        #================================================================================================================================

        #================================================================================================================================
        #region Constructors
            CsLogEntry([string] $TimeStamp, [string] $ContextHash, [string] $Level, [string] $Message) {
                $this.TimeStamp = $TimeStamp
                $this.ContextHash = $ContextHash
                $this.Level = $Level
                $this.Message = $Message
                $this.EntryHash = $this.HashEntry()
            }

        #endregion
        #================================================================================================================================

        #================================================================================================================================
        #region Public Methods
            
        #endregion
        #================================================================================================================================

        #================================================================================================================================
        #region Private Methods
        #================================================================================================================================

            #----------------------------------------------------------------
            #region HashEntry
            #----------------------------------------------------------------
            # Returns the hash of the log entry
            hidden [string] HashEntry() {
                return $this.MD5("$($this.TimeStamp)$($this.ContextHash)$($this.Level)$($this.Message)")
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region MD5
            #----------------------------------------------------------------
            # Returns the MD5 hash of the input string
            hidden [string] MD5([string] $inputString) {
                return [System.BitConverter]::ToString([System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::Unicode.GetBytes($inputString))) -replace '-'
            }
            #endregion
            #----------------------------------------------------------------


        #endregion
        #================================================================================================================================
    }
    #endregion
    #----------------------------------------------------------------

    #----------------------------------------------------------------
    #region CsLog Class
    #----------------------------------------------------------------
    class CsLog {
        #================================================================================================================================
        #region Public Properties
            [System.IO.FileInfo] $LogFile
            [int32] $LogMaxBytes = 10MB
            [int32] $LogMaxRollovers = 5
            [System.IO.FileInfo[]] $RolloverLogs
            [int32] $TailLines = 40
            [ordered] $LoggingContext
            [System.DateTimeOffset] $InstantiatedTime = [System.DateTimeOffset]::Now
            [bool] $EchoMessages = $false
            [hashtable] $LevelColors = @{
                'Debug' = 'DarkGray'
                'Info' = 'Green'
                'Warn' = 'Yellow'
                'Error' = 'Red'
                'Fatal' = 'Magenta'
            }
        #endregion
        #================================================================================================================================
        
        #================================================================================================================================
        #region Private Properties
            hidden [string] $defaultExtension = '.log'
            hidden [string] $defaultPrefix = 'CsLog_'
            hidden [string] $defaultNamePattern = 'yyyyMMdd_HHmmss'
            hidden [string] $defaultDirectory = [System.IO.Path]::Combine($env:ProgramData, '1E\CsLogs')
            hidden [string] $FS = "`u{200B}`u{00A0}" # Field Separator (Zero Width Space + No-Break Space)
            hidden [string] $RS = "`u{200B}`n" # Record Separator (Zero Width Space + Newline)
            hidden [System.Text.Encoding] $encoding = [System.Text.Encoding]::Unicode
            hidden [string] $encodingName = 'Unicode'
            hidden [string] $fallbackDirectory = [System.IO.Path]::Combine($env:TEMP, '1E\CsLogs')
            hidden [System.Management.Automation.Host.PSHost] $host = $Host
            hidden [System.Collections.Hashtable] $psVersionTable = $PSVersionTable
            hidden [string] $PSScriptRoot = $PSScriptRoot
            hidden [string] $PSCommandPath = $PSCommandPath
            hidden [object] $os
            hidden [string] $deviceIp
            hidden [string] $userSid
            hidden [int32] $sessionId
            hidden [int32] $processId
            hidden [ordered] $context
            hidden [string] $contextHash
            hidden [System.Security.Cryptography.MD5] $hasherMD5 = [System.Security.Cryptography.MD5]::Create()
            hidden [System.Security.Cryptography.SHA1] $hasherSHA1 = [System.Security.Cryptography.SHA1]::Create()
            hidden [System.Security.Cryptography.SHA256] $hasherSHA256 = [System.Security.Cryptography.SHA256]::Create()
            hidden [System.Security.Cryptography.SHA512] $hasherSHA512 = [System.Security.Cryptography.SHA512]::Create()
        #endregion
        #================================================================================================================================

        #================================================================================================================================
        #region Constructors
            CsLog() {
                # Create a new log file with a default name
                $this.LogFile = $this.StringToFileInfo($null)
                $this.Initialize()
            }

            CsLog([string] $Path) {
                $this.LogFile = $this.StringToFileInfo($Path)
                $this.Initialize()
            }
            
            hidden [void] Initialize() {
                # Set default values
                
                # Get the OS details
                try{$this.os = Get-CimInstance Win32_OperatingSystem -Verbose:$false | Select-Object -Property Caption, Version, OSArchitecture, SystemDirectory, WindowsDirectory} catch{$this.os = @{Caption='';Version='';OSArchitecture='';SystemDirectory='';WindowsDirectory=''}}

                # Get device IP
                try {$this.deviceIp = Get-NetIPAddress -AddressFamily IPv4 -Type Unicast | Where-Object {$_.InterfaceAlias -notlike '*Loopback*' -and $_.PrefixOrigin -ne 'WellKnown'} | Sort-Object -Property InterfaceMetric -Descending | Select-Object -First 1 -ExpandProperty IPAddress} catch {$this.deviceIp = ''}

                # Get user SID
                try {$this.userSid = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value} catch {$this.userSid = ''}

                # Get session ID
                try {$this.sessionId = [System.Diagnostics.Process]::GetCurrentProcess().SessionId} catch {$this.sessionId = $null}

                # Get process ID
                try {$this.processId = [System.Diagnostics.Process]::GetCurrentProcess().Id} catch {$this.processId = $null}

                # Make sure the log directory exists first, if not, force it to exist
                if (-not (Test-Path -Path $this.LogFile.Directory)) {
                    try {
                        New-Item -Path $this.LogFile.Directory -ItemType Directory -Force -ErrorAction Stop
                    }
                    catch {
                        # If we can't create the log directory, use the fallback directory (%TEMP%\1e\CsLogs)
                        Write-Warning "Unable to create log directory $($this.LogFile.Directory). Using fallback directory $($this.fallbackDirectory) instead"
                        $this.LogFile = $this.StringToFileInfo([System.IO.Path]::Combine($this.fallbackDirectory, $this.LogFile.Name))
                        if (-not (Test-Path -Path $this.LogFile.Directory)) {
                            try {
                                New-Item -Path $this.LogFile.Directory -ItemType Directory -Force -ErrorAction Stop
                            }
                            catch {
                                # If we can't create the log directory, fail
                                throw "Unable to create log directory $($this.defaultDirectory) and fallback directory $($this.fallbackDirectory)"
                            }
                        }
                    }
                }

                # Make sure the log file exists, if not, create it
                if (-not (Test-Path -Path $this.LogFile.FullName)) {
                    try {
                        New-Item -Path $this.LogFile.FullName -ItemType File -Force -ErrorAction Stop
                    }
                    catch {
                        # If we can't create the log file, fail
                        throw "Unable to create log file $($this.LogFile.FullName)`n$_"
                    }
                }

                # Get the list of RollOver files
                $this.RolloverLogs = Get-ChildItem -Path $this.LogFile.Directory -Filter "$($this.LogFile.BaseName).*$($this.LogFile.Extension)" -File |
                    Sort-Object -Property Name -Descending

                # Synchronize the context
                if ($this.SyncContext()) {
                    # If the context has changed or is new, write the context to the log
                    $this.Write("`n$($this.GetSingleLine())`n$($this.HashtableToString($this.context))`n$($this.GetSingleLine())", 'Info')
                }
                
            }
        #endregion
        #================================================================================================================================

        #================================================================================================================================
        #region Public Methods 

            #----------------------------------------------------------------
            #region Clear
            #----------------------------------------------------------------
            # Clears the log file and removes all rollover logs
            [void] Clear() {
                # Clear the current log file
                Set-Content -Path $this.LogFile.FullName -Value '' -Force -Encoding $this.encodingName

                # Clear the rollover logs
                foreach ($log in $this.RolloverLogs) {
                    $log.Delete()
                }

                # Clear the context hash so the context will always be written to the new log
                $this.contextHash = $null

                # Synchronize the context
                if ($this.SyncContext()) {
                    # If the context has changed or is new, write the context to the log
                    $this.Write("`n$($this.GetSingleLine())`n$($this.HashtableToString($this.context))`n$($this.GetSingleLine())", 'Info')
                }
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region Debug
            #----------------------------------------------------------------
            # Logs a message at the Debug level
            [void] Debug([string] $Message) {
                $this.Write($Message, 'Debug')
            }

            # Logs multiple messages at the Debug level
            [void] Debug([string[]] $Messages) {
                $this.Write($Messages, 'Debug')
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region Error
            #----------------------------------------------------------------
            # Logs a message at the Error level
            [void] Error([string] $Message) {
                $this.Write($Message, 'Error')
            }

            # Logs multiple messages at the Error level
            [void] Error([string[]] $Messages) {
                $this.Write($Messages, 'Error')
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region FindContextInLog
            #----------------------------------------------------------------
            # Finds context in the log file
            [CsLogEntry[]] FindContextInLog() {
                return $this.FindContextInLog($this.LogFile)
            }

            # Finds context in the log file and if $RollOverLogs is true, also searches the rollover logs
            [CsLogEntry[]] FindContextInLog([bool] $RolloverLogs = $false) {
                if ($RolloverLogs) {
                    $theLogs = [System.IO.FileInfo[]](@($this.LogFile) + $this.RolloverLogs)
                } else {
                    $theLogs = [System.IO.FileInfo[]]@($this.LogFile)
                }
                return $this.FindContextInLog($theLogs)
            }

            # Finds context in all of the log files passed in
            [CsLogEntry[]] FindContextInLog([System.IO.FileInfo[]] $LogFile) {
                # Re-verify that all the files in the list exist
                $validFiles = $LogFile| Where-Object {Test-Path -Path $_.FullName -ErrorAction SilentlyContinue}

                # If the files don't exist, return an empty array
                if ($validFiles.Count -eq 0) {
                    return [CsLogEntry[]]@()
                }

                # Get distinct ContextHash values from the log (this will be a 32 hexadecimal character string between two field separators)
                $hashes = (Get-Content -Path $validFiles.FullName -Raw) | Select-String -Pattern "($($this.FS)[0-9A-F]{32}$($this.FS))" -AllMatches | ForEach-Object {$_.Matches.Value} | Sort-Object -Unique

                # Foreach context hash, get the first record with that context hash
                return $hashes | ForEach-Object {
                    $hash = $_
                    $record = (Get-Content -Path $validFiles.FullName -Raw) -split $this.RS | Where-Object {$_ -like "*$hash*"} | Select-Object -First 1
                    $fields = ($record -split $this.FS).ForEach({$_.Trim()})
                    if ($fields.Count -eq 4) {
                        [CsLogEntry]::new($fields[0], $fields[1], $fields[2], $fields[3])
                    }
                }
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region FindInLog
            #----------------------------------------------------------------
            # Finds a string in the log file matching the pattern
            [CsLogEntry[]] FindInLog([string] $Pattern) {
                return $this.FindInLog($Pattern, '*', [DateTime]::MinValue, [DateTime]::MaxValue, '*')
            }

            # Finds a string in the log between two dates
            [CsLogEntry[]] FindInLog([string] $Pattern, [DateTime] $Start, [DateTime] $End) {
                return $this.FindInLog($Pattern, '*', $Start, $End, '*')
            }
            
            # Finds a string in the log of a specific level
            [CsLogEntry[]] FindInLog([string] $Pattern, [string] $Level) {
                return $this.FindInLog($Pattern, $Level, [DateTime]::MinValue, [DateTime]::MaxValue, '*')
            }

            # Finds a string in the log with a specific level and contextHash between two dates
            [CsLogEntry[]] FindInLog([string] $Pattern, [string] $Level, [DateTime] $Start, [DateTime] $End, [string]$ContextHash) {
                # If the properties haven't been cleared, and the log exists, tail the log and return the result
                if ($this.LogFile.FullName -and (Test-Path -Path $this.LogFile.FullName)) {
                    # Parse the log file into records using the record separator
                    return (Get-Content -Path $this.LogFile.FullName -Raw) -split $this.RS |
                        # Pre-filter to return only those records that match the pattern somewhere on the line
                        Where-Object {($_ -like $Pattern) -and ($_ -like "*$Level*") -and ($_ -like "*$ContextHash*")} |
                            # Parse each record into fields using the field separator
                            ForEach-Object {
                                $fields = ($_ -split $log.FS).ForEach({$_.Trim()})
                                if ($fields.Count -eq 4) {
                                    [CsLogEntry]::new($fields[0], $fields[1], $fields[2], $fields[3])
                                }
                            } | Where-Object {
                                $_.Message -like $Pattern -and $_.Level -like $Level -and $_.ContextHash -like $ContextHash -and [DateTime]$_.TimeStamp -ge $Start -and [DateTime]$_.TimeStamp -le $End
                            } # Only return those records that match the pattern in the message
                } else {
                    return [CsLogEntry[]]@()
                }                
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region OpenCmTrace
            #----------------------------------------------------------------
            # Using powershell, Find the first instance of CMTrace.exe and open a logfile with it
            [void] OpenCmTrace() {
                $cmTrace = $this.FindFirst('CMTrace.exe')
                if ($cmTrace) {
                    Start-Process -FilePath $cmTrace.FullName -ArgumentList $this.LogFile.FullName
                }
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region OpenExplorer
            #----------------------------------------------------------------
            # Opens the log file in Windows Explorer
            [void] OpenExplorer() {
                Start-Process -FilePath "explorer.exe" -ArgumentList "/select, `"$($this.LogFile.FullName)`""
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region Fatal
            #----------------------------------------------------------------
            # Logs a message at the Fatal level
            [void] Fatal([string] $Message) {
                $this.Write($Message, 'Fatal')
            }

            # Logs multiple messages at the Fatal level
            [void] Fatal([string[]] $Messages) {
                $this.Write($Messages, 'Fatal')
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region GetContent
            #----------------------------------------------------------------
            # Gets the content of the log file
            [CsLogEntry[]] GetContent() {
                # If the properties haven't been cleared, and the log exists, tail the log and return the result
                if ($this.LogFile.FullName -and (Test-Path -Path $this.LogFile.FullName)) {
                    # Parse the log file into records using the record separator
                    return (Get-Content -Path $this.LogFile.FullName -Raw) -split $this.RS |
                        # Parse each record into fields using the field separator
                        ForEach-Object {
                            $fields = ($_ -split $log.FS).ForEach({$_.Trim()})
                            if ($fields.Count -eq 4) {
                                [CsLogEntry]::new($fields[0], $fields[1], $fields[2], $fields[3])
                            }
                    }                    
                } else {
                    return [CsLogEntry[]]@()
                }
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region GetDateRangeOfLog
            #----------------------------------------------------------------
            # Gets the date range of the log file
            [PSCustomObject] GetDateRangeOfLog() {
                # If the properties haven't been cleared, and the log exists
                if ($this.LogFile.FullName -and (Test-Path -Path $this.LogFile.FullName)) {
                    # Get the date from the first record in the log
                    $first = ((Get-Content -Path $this.LogFile.FullName -First 1) -split $this.FS)[0]

                    # Get the date from the last record in the log
                    $last = (((Get-Content -Path $this.LogFile.FullName -Raw) -split $this.RS | Where-Object {$_} | Select-Object -Last 1) -split $this.FS)[0]

                    # Return the date range
                    return [PSCustomObject]@{
                        First = [DateTimeOffset]::ParseExact($first, "yyyy-MM-dd HH:mm:ss.fffffff zzz", [System.Globalization.CultureInfo]::InvariantCulture)
                        Last = [DateTimeOffset]::ParseExact($last, "yyyy-MM-dd HH:mm:ss.fffffff zzz", [System.Globalization.CultureInfo]::InvariantCulture)
                        TimeSpan = [DateTimeOffset]::ParseExact($last, "yyyy-MM-dd HH:mm:ss.fffffff zzz", [System.Globalization.CultureInfo]::InvariantCulture) - [DateTimeOffset]::ParseExact($first, "yyyy-MM-dd HH:mm:ss.fffffff zzz", [System.Globalization.CultureInfo]::InvariantCulture)
                    }
                }
                else {
                    return [PSCustomObject]@{
                        First = [DateTimeOffset]::MinValue
                        Last = [DateTimeOffset]::MinValue
                        TimeSpan = [DateTimeOffset]::MinValue - [DateTimeOffset]::MinValue
                    }
                }
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region Help
            #----------------------------------------------------------------
            # Displays help for the CsLog class
            [void] Help() {
                Write-Host @'
CsLog Class

This class is a simple logging class that writes log messages to a file. Useful for logging in PowerShell scripts.


Properties
----------
LogFile: [System.IO.FileInfo] The log file to write to. If not set, the log file will be created in the default directory with a default name.
LogMaxBytes: [int32] The maximum size of the log file in bytes before it rolls over. Default is 10MB.
LogMaxRollovers: [int32] The maximum number of rollover logs to keep. Default is 5.
RolloverLogs: [System.IO.FileInfo[]] An array of the rollover logs.
TailLines: [int32] The number of lines to tail from the log file. Default is 40.
LoggingContext: [ordered] The context to be written to the log. This is a hashtable of key-value pairs that will be written to the log.
InstantiatedTime: [System.DateTimeOffset] The time the class was instantiated. Default is the current time.
EchoMessages: [bool] Whether or not to echo log messages to the console. Default is false.
LevelColors: [hashtable] A hashtable of log level names and their associated console colors. Default is Debug=Gray, Info=White, Warn=Yellow, Error=Red, Fatal=DarkRed.


Methods
-------
Clear: Clears the log file and removes all rollover logs.
Debug: Logs a message at the Debug level.
Error: Logs a message at the Error level.
Fatal: Logs a message at the Fatal level.
GetContent: Gets the content of the log file.
Help: Displays help for the CsLog class.
Info: Logs a message at the Info level.
Size: Gets the size of the log file.
StringEscape: Converts a string to escaped unicode. Useful for seeing what invisible or non-ASCII characters are in the string.
Tail: Tails the log file.
Warn: Logs a message at the Warn level.


Examples
--------
# Create a new log file in the default directory with the default name (CsLog_yyyyMMdd_HHmmss.log) in the default directory (%ProgramData%\1E\CsLogs)
$log = [CsLog]::new()

# Create a new log file with a specific name
$log = [CsLog]::new("C:\Logs\MyLog.log")

# Log a message at the Info level
$log.Info("This is an info message")

# Log a message at the Warn level
$log.Warn("This is a warning message")

# Log a message at the Error level
$log.Error("This is an error message")

# Log a message at the Fatal level
$log.Fatal("This is a fatal message")

# Log a message at the Debug level
$log.Debug("This is a debug message")

# Get the content of the log file
$log.GetContent()

# Get the size of the log file
$log.Size()

# Tail the log file
$log.Tail()

# Tail (get) the last 100 lines of the log file (Output will be an array of [CsLogEntry] objects)
$log.Tail(100)

# Clear the log file and remove all rollover logs
$log.Clear()

# Tell the CsLog class to echo to the console every time a message is logged
$log.EchoMessages = $true

'@
            }
            #endregion
            #----------------------------------------------------------------
            
            #----------------------------------------------------------------
            #region Info
            #----------------------------------------------------------------
            # Logs a message at the Info level
            [void] Info([string] $Message) {
                $this.Write($Message, 'Info')
            }

            # Logs multiple messages at the Info level
            [void] Info([string[]] $Messages) {
                $this.Write($Messages, 'Info')
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region Size
            #----------------------------------------------------------------
            # Gets the size of the log file
            [int64] Size() {
                return (Get-Item -Path $this.LogFile.FullName).Length
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region Tail
            #----------------------------------------------------------------
            # Tails the log file
            [CsLogEntry[]] Tail() {
                return $this.Tail($this.TailLines)
            }

            [CsLogEntry[]] Tail([int] $lines) {
                # If the properties haven't been cleared, and the log exists, tail the log and return the result
                if ($this.LogFile.FullName -and (Test-Path -Path $this.LogFile.FullName)) {
                    # Parse the log file into records using the record separator
                    return (Get-Content -Path $this.LogFile.FullName -Raw) -split $this.RS |
                        # Get the last $lines records
                        Select-Object -Last $lines |
                            # Parse each record into fields using the field separator
                            ForEach-Object {
                                $fields = ($_ -split $log.FS).ForEach({$_.Trim()})
                                if ($fields.Count -eq 4) {
                                    [CsLogEntry]::new($fields[0], $fields[1], $fields[2], $fields[3])
                                }    
                            }                    
                } else {
                    return [CsLogEntry[]]@()
                }
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region Warn
            #----------------------------------------------------------------
            # Logs a message at the Warn level
            [void] Warn([string] $Message) {
                $this.Write($Message, 'Warn')
            }

            # Logs multiple messages at the Warn level
            [void] Warn([string[]] $Messages) {
                $this.Write($Messages, 'Warn')
            }
            #endregion
            #----------------------------------------------------------------
        
        #endregion
        #================================================================================================================================

        #================================================================================================================================
        #region Private Methods

            #----------------------------------------------------------------
            #region Echo
            #----------------------------------------------------------------
            # Echoes a message to the console with the appropriate color
            hidden [void] Echo([string] $Message, [string] $Level) {
                Write-Host $Message -ForegroundColor $this.LevelColors[$Level] -NoNewline
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region FindFirst
            #----------------------------------------------------------------
            # Finds the first instance of a file across all local drives using the specified search pattern
            hidden [System.IO.FileInfo] FindFirst([string] $Filter) {
                $isElevated = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

                # If the user is running elevated, search all local drives using robocopy (fast)
                if ($isElevated) {
                    return $this.FixedDisks() |
                        Where-Object {$_.Name -like '?:\'} |
                            ForEach-Object {(robocopy $_.Name null $N /L /MT /NC /NDL /NJH /NJS /NP /NS /S /XJD /ZB).trim() | Where-Object {$_ -ne "" -and $_ -like $Filter}} |
                                Select-Object -First 1
                }
                # If the user is not running elevated, search all local drives using Get-ChildItem
                else {
                    return $this.FixedDisks() |
                        Where-Object {$_.Name -like '?:\'} |
                            ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -File -ErrorAction SilentlyContinue -Filter $Filter} |
                                Select-Object -First 1
                }
                
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region FixedDisks
            #----------------------------------------------------------------
            # Gets all fixed disks on the local machine
            hidden [System.IO.DriveInfo[]] FixedDisks() {
                return [System.IO.DriveInfo]::GetDrives() | Where-Object {$_.DriveType -in 3,6}
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region GetContext
            #----------------------------------------------------------------
            # Gets runtime context to be used in a log message
            [ordered] GetContext() {
                return [ordered]@{
                    LOG_NAME =                   $this.LogFile.Name
                    LOG_BASE_NAME =              $this.LogFile.BaseName
                    LOG_EXTENSION =              $this.LogFile.Extension
                    LOG_FULL_NAME =              $this.LogFile.FullName
                    LOG_DIRECTORY =              $this.LogFile.Directory
                    LOG_MAX_BYTES =              $this.LogMaxBytes
                    LOG_MAX_ROLLOVERS =          $this.LogMaxRollovers
                    RECORD_SEPARATOR_UNICODE =   $this.StringEscape($this.RS)
                    FIELD_SEPARATOR_UNICODE =    $this.StringEscape($this.FS)
                    DEVICE_NAME =                $env:COMPUTERNAME
                    DEVICE_IP =                  $this.deviceIp
                    USER_SID =                   $this.userSid
                    SESSION_ID =                 $this.sessionId
                    SESSION_NAME =               $env:SESSIONNAME
                    PROCESS_ID =                 $this.processId
                    OS_NAME =                    $this.os.Caption
                    OS_VERSION =                 $this.os.Version
                    OS_ARCHITECTURE =            $this.os.OSArchitecture
                    OS_SYSTEM_DIRECTORY =        $this.os.SystemDirectory
                    OS_WINDOWS_DIRECTORY =       $this.os.WindowsDirectory
                    POWERSHELL_HOST_NAME =       $this.host.Name
                    POWERSHELL_HOST_VERSION =    $this.host.Version
                    POWERSHELL_HOST_CULTURE =    $this.host.CurrentCulture
                    POWERSHELL_HOST_UI_CULTURE = $this.host.CurrentUICulture
                    POWERSHELL_VERSION =         $this.psVersionTable.PSVersion
                    POWERSHELL_EDITION =         $this.psVersionTable.PSEdition
                    SCRIPT_PATH =                $this.PSCommandPath
                    SCRIPT_DIRECTORY =           $this.PSScriptRoot
                    TAIL_LINES =                 $this.TailLines
                }
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region GetLogMessage
            #----------------------------------------------------------------
            # Builds a log message from the input message and level
            [string] GetLogMessage([string] $Level, [string] $Message) {
                return `
                    [DateTimeOffset]::Now.ToString("yyyy-MM-dd HH:mm:ss.fffffff zzz") + $this.FS + `
                    $this.contextHash + $this.FS + `
                    $level + $this.FS + `
                    $message + $this.RS
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region GetDoubleLine
            #----------------------------------------------------------------
            # Gets a double-line
            hidden [string] GetDoubleLine() {
                return '═' * 100
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region GetSingleLine
            #----------------------------------------------------------------
            # Gets a single-line
            hidden [string] GetSingleLine() {
                return '─' * 100
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region HashtableToString
            #----------------------------------------------------------------
            # Converts a hashtable to a readable string
            hidden [string] HashtableToString([hashtable] $hashTable) {
                return ($hashTable.GetEnumerator() | Sort-Object | ForEach-Object {"$($_.Key)`: $($_.Value)"}) -join "`n"
            }      
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region MD5
            #----------------------------------------------------------------
            # Returns the MD5 hash of the input string
            hidden [string] MD5([string] $inputString) {
                return [System.BitConverter]::ToString($this.hasherMD5.ComputeHash($this.encoding.GetBytes($inputString))) -replace '-'
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region RollOver
            #----------------------------------------------------------------
            # Rolls over the log file
            hidden [void] RollOver() {
                # Get the existing rollover log files (rollover logs are named LogFolder\LogBaseName.*.log where * is a number from 1 to LogMaxRollovers)
                $this.RolloverLogs = Get-ChildItem -Path $this.LogFile.Directory -Filter "$($this.LogFile.BaseName).*$($this.LogFile.Extension)" -File |
                    Sort-Object -Property Name

                # If the number of rollover logs is greater than or equal to LogMaxRollovers, delete the oldest rollover log
                if ($this.RolloverLogs.Count -ge $this.LogMaxRollovers) {
                    try {
                        $this.RolloverLogs[-1].Delete()
                    }
                    catch {
                        # If we can't delete the oldest rollover log, do nothing, we'll try to move the data below instead
                    }
                }

                # Rename all the existing logs to the next highest number
                for ($i = $this.LogMaxRollovers; $i -gt 1; $i--) {
                    $oldLog = [System.IO.Path]::Combine($this.LogFile.Directory, "$($this.LogFile.BaseName).$($i - 1)$($this.LogFile.Extension)")
                    $newLog = [System.IO.Path]::Combine($this.LogFile.Directory, "$($this.LogFile.BaseName).$($i)$($this.LogFile.Extension)")
                    if (Test-Path -Path $oldLog) {
                        Write-Verbose "Rolling over $oldLog --> $newLog"
                        try {
                            # try to rename the log file to the next highest rollover
                            Rename-Item -Path $oldLog -NewName $newLog -Force -ErrorAction Stop
                        }
                        catch {
                            # if we can't rename the log, try to copy its contents to the next highest rollover this is a last-ditch effort
                            # to preserve the log contents if we can't rename the file for some reason like when the file is in use by 
                            # another process or the folder it's in is delete protected but we can still write to the file. This is more 
                            # disk intensive than a rename, but it's better than losing the log contents.
                            $firstError = $_
                            try {
                                Get-Content -Path $oldLog -Raw -Force -ErrorAction Stop | Set-Content -Path $newLog -Force -ErrorAction Stop -Encoding $this.encodingName
                            }
                            catch {
                                Write-Host $firstError
                                Write-Host $_
                                throw "Unable to rollover $oldLog --> $newLog"
                            }
                        }
                    }
                }

                # Rename the current log to .1.log
                $newLog = [System.IO.Path]::Combine($this.LogFile.Directory, "$($this.LogFile.BaseName).1$($this.LogFile.Extension)")
                Write-Verbose "Rolling over $($this.LogFile.FullName) --> $newLog"
                try {
                    Rename-Item -Path $this.LogFile.FullName -NewName $newLog -Force -ErrorAction Stop
                }
                catch {
                    $firstError = $_
                    # if we can't rename the log, try to copy its contents to the archive
                    try {
                        Get-Content -Path $this.LogFile.FullName -Raw -Force -ErrorAction Stop | Set-Content -Path $newLog -Encoding $this.encodingName -Force -ErrorAction Stop
                    }
                    catch {
                        Write-Error $firstError
                        Write-Error $_
                        throw "Unable to rollover $($this.LogFile.FullName) --> $newLog"
                    }
                    # clear the log file contents since we couldn't rename it
                    Set-Content -Path $this.LogFile.FullName -Value '' -Force -Encoding $this.encodingName -ErrorAction Stop
                }

                # re-populate the list of rollover logs (this is a bit redundant, but it makes sure the list is for sure up to date)
                $this.RolloverLogs = Get-ChildItem -Path $this.LogFile.Directory -Filter "$($this.LogFile.BaseName).*$($this.LogFile.Extension)" -File |
                    Sort-Object -Property Name -Descending

                # clear the context hash so the context will always be written to the new log
                $this.contextHash = $null
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region SHA1
            #----------------------------------------------------------------
            # Returns the SHA1 hash of the input string
            hidden [string] SHA1([string] $inputString) {
                return [System.BitConverter]::ToString($this.hasherSHA1.ComputeHash($this.encoding.GetBytes($inputString))) -replace '-'
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region SHA256
            #----------------------------------------------------------------
            # Returns the SHA256 hash of the input string
            hidden [string] SHA256([string] $inputString) {
                return [System.BitConverter]::ToString($this.hasherSHA256.ComputeHash($this.encoding.GetBytes($inputString))) -replace '-'
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region StringToFileInfo
            #----------------------------------------------------------------
            # Converts a string representing a path of somekind (like Name, FullName, BaseName) to a
            # FileInfo object using defaults if there's not enough to make a [System.IO.FileInfo] object
            hidden [System.IO.FileInfo] StringToFileInfo([string] $Path) {
                # If the path is empty, set it to a default value of defaultPrefix + defaultNamePattern which is CsLog_yyyyMMdd_HHmmss.log
                if (-not $Path) {
                    $Path = $this.defaultPrefix + [System.DateTime]::Now.ToString($this.defaultNamePattern)
                }

                # Get the parts of the path passed in so we know if we've been given a full path or just a file name
                $directory = [System.IO.Path]::GetDirectoryName($Path)
                $name = [System.IO.Path]::GetFileName($Path)
                $extension = [System.IO.Path]::GetExtension($Path)

                # If the log name doesn't have an extension, add default extension
                if (-not $extension) {
                    $name = $name + $this.defaultExtension
                }

                # If the log name doesn't have a directory, use the preferred log folder
                if (-not $directory) {
                    $directory = $this.defaultDirectory
                }

                # Return a new FileInfo object        
                return [System.IO.FileInfo]::new([System.IO.Path]::Combine($directory, $name))
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region StringEscape
            #----------------------------------------------------------------
            # Converts a string to escaped unicode. Useful for seeing what invisible or non-ASCII characters are in the string
            [string] StringEscape([string]$inputString) {
                $sb = New-Object System.Text.StringBuilder
                # Loop through each character in the input string and append the escaped unicode value to the string builder
                foreach ($char in $inputString.ToCharArray()) {
                    [void]$sb.Append('\u{0:X4}' -f [int]$char)
                }
                return $sb.ToString()
            }
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region SyncContext
            #----------------------------------------------------------------
            # Synchronizes the context with the current context. Returns true if the context has changed or is new, otherwise returns false
            hidden [bool] SyncContext() {
                # Get the logging context
                $this.context = $this.GetContext()

                # Update the context hash with the current context
                $this.LoggingContext = $this.context # Just in case the user wants to see the context
                $this.contextHash = $this.MD5($this.HashtableToString($this.Context))

                # If the contextHash is already found in the log, return false, otherwise return true
                try {
                    $isFound = (Select-String -Path $this.LogFile.FullName -Pattern $this.contextHash -Quiet -ErrorAction Stop)
                    return -Not $isFound
                }
                catch {
                    # if the log isn't found at all, return true
                    return $true
                }
            }    
            #endregion
            #----------------------------------------------------------------

            #----------------------------------------------------------------
            #region Write
            #----------------------------------------------------------------
            #Write (single message)
            hidden [void] Write([string] $Message, [string] $Level = 'Info') {
                # Build the log message
                $msg = $this.GetLogMessage($level, $message)

                try {

                    # Open the log file with a StreamWriter
                    $streamWriter = [System.IO.StreamWriter]::new($this.LogFile, $true, $this.encoding)

                    try {
                        # see if the message will make the log exceed the LogMaxBytes property
                        if (($this.encoding.GetByteCount($msg) + $streamWriter.BaseStream.Length) -ge $this.LogMaxBytes) {
                            # if it will, close the log...
                            $streamWriter.Close()
                            # ...and roll it over
                            $this.RollOver()
                            # then open the log again
                            $streamWriter = [System.IO.StreamWriter]::new($this.LogFile, $true, $this.encoding)
                            # Synchronize the context to the class property
                            if ($this.SyncContext()) {
                                # If the context has changed or is new, write the context to the log
                                $streamWriter.Write($this.GetLogMessage("$($this.GetSingleLine())`n$($this.HashtableToString($this.context))`n$($this.GetSingleLine())", 'Info'))
                            }
                            # get the message again, as the the original timestamp has changed
                            $msg = $this.GetLogMessage($level, $message)
                        }

                        # Write the message to the log
                        $streamWriter.Write($msg)

                        # Echo the message to the console if EchoMessages is true
                        if ($this.EchoMessages) {
                            $this.Echo($msg, $level)
                        }
                    }
                    catch {
                        # If there was an error writing to the log, write the error to the console
                        Write-Error "Error writing to log:`n$_"
                    }
                    finally {
                        # Close the log if it's open
                        if ($streamWriter) {$streamWriter.Close()}
                    }
                }
                catch {
                    # If there was an error writing to the log, write the error to the console
                    Write-Host "Error writing to log:`n$_"
                }
            }
            
            #Write (multiple messages)
            hidden [void] Write([string[]] $Messages, [string] $Level = 'Info') {
                # Open the log file with a StreamWriter
                $streamWriter = [System.IO.StreamWriter]::new($this.LogFile, $true, $this.encoding)

                try {

                    # Loop through each message and write it to the log without closing in between (unless the log rolls over)
                    foreach ($message in $Messages) {
                        # Build the log message
                        $msg = $this.GetLogMessage($level, $message)
                        # see if the message will make the log exceed the LogMaxBytes property
                        if (($this.encoding.GetByteCount($msg) + $streamWriter.BaseStream.Length) -ge $this.LogMaxBytes) {
                            # if it will, close the log...
                            $streamWriter.Close()
                            # ...and roll it over
                            $this.RollOver()
                            # then open the log again
                            $streamWriter = [System.IO.StreamWriter]::new($this.LogFile, $true, $this.encoding)
                            # Synchronize the context to the class property
                            if ($this.SyncContext()) {
                                # If the context has changed or is new, write the context to the log
                                $streamWriter.Write($this.GetLogMessage("$($this.GetSingleLine())`n$($this.HashtableToString($this.context))`n$($this.GetSingleLine())", 'Info'))
                            }
                            # get the message again, as the the original timestamp has changed
                            $msg = $this.GetLogMessage($level, $message)
                        }

                        # Write the message to the log
                        $streamWriter.Write($msg)

                        # Echo the message to the console if EchoMessages is true
                        if ($this.EchoMessages) {
                            $this.Echo($msg, $level)
                        }
                    }
                }
                catch {
                    # If there was an error writing to the log, write the error to the console
                    Write-Error "Error writing to log:`n$_"
                }
                finally {
                    # Close the log if it's open
                    if ($streamWriter) {$streamWriter.Close()}
                }
            }
            #endregion
            #----------------------------------------------------------------    


        #endregion
        #================================================================================================================================
    }
    #endregion
    #----------------------------------------------------------------

    #----------------------------------------------------------------
    #region CsServer Class
    #----------------------------------------------------------------
    # Class to represent a server
    class CsServer {
        #================================================================
        #region Public Properties

        [string] $Fqdn
        [string] $FqdnValidationRegex = "^((?!-)[A-Za-z0-9-]{1,63}(?<!-)\.)+[A-Za-z]{2,6}$"

        #endregion
        #================================================================

        #================================================================
        #region Private Properties


        #endregion
        #================================================================

        #================================================================
        #region Constructors

        CsServer([string] $Fqdn) {
            if ($this.ValidateFqdn($Fqdn)) {
                $this.Fqdn = $Fqdn
            } else {
                throw "Invalid FQDN"
            }
        }

        [bool] ValidateFqdn($Fqdn) {
            return $Fqdn -match $this.FqdnValidationRegex
        }

        #endregion
        #================================================================

        #================================================================
        #region Public Methods

        [string] ToString() {
            return $this.Fqdn
        }

        #endregion
        #================================================================
    }
    #endregion
    #----------------------------------------------------------------

    #----------------------------------------------------------------
    #region CsAzureApp Class
    #----------------------------------------------------------------
    # Class to represent an Azure App
    class CsAzureApp {
        #================================================================
        #region Public Properties

        [string] $AppID

        #endregion
        #================================================================

        #================================================================
        #region Private Properties
        
        #endregion
        #================================================================

        #================================================================
        #region Constructors
        CsAzureApp() {
            $this.AppID = ""
        }
                
        CsAzureApp([string] $AppID) {
            $this.AppID = $AppID
        }

        [bool] ValidateAppID($AppID) {
            return $AppID -match "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"
        }

        #endregion
        #================================================================

        #================================================================
        #region Public Methods

        [string] ToString() {
            return $this.AppID
        }

        #endregion
        #================================================================
    }
    #endregion
    #----------------------------------------------------------------

    #----------------------------------------------------------------
    #region CsCertSubject Class
    #----------------------------------------------------------------
    # Class to represent a certificate subject
    class CsCertSubject {
        #================================================================
        #region Public Properties

        [string] $Subject

        #endregion
        #================================================================

        #================================================================
        #region Private Properties

        #endregion
        #================================================================

        #================================================================
        #region Constructors

        CsCertSubject([string] $Subject) {
            $this.Subject = $Subject
        }

        #endregion
        #================================================================

        #================================================================
        #region Public Methods

        [string] ToString() {
            return $this.Subject
        }

        #endregion
        #================================================================

        #================================================================
        #region Private Methods

        [bool] ValidateSubject($Subject) {
            return $Subject -match "CN=.*"
        }

        #endregion
        #================================================================
    }
    #endregion
    #----------------------------------------------------------------

    #----------------------------------------------------------------
    #region CsPlatform Class
    #----------------------------------------------------------------
    class CsPlatform {
        #================================================================
        #region Public Properties
        [string] $Server
        [string] $AppID
        [string] $CertSubject
        [string] $CertThumbprint
        [string] $Principal
        
        #endregion
        #================================================================

        #================================================================
        #region Private Properties

        #endregion
        #================================================================

        #================================================================
        #region Constructors

        CsPlatform([string] $Server, [string] $AppID, [string] $CertSubject, [string] $Principal) {
            $this.Server = $Server
            $this.AppID = $AppID
            $this.CertSubject = $CertSubject
            $this.Principal = $Principal
        }
        
        #endregion
        #================================================================

        #================================================================
        #region Public Methods

        #endregion
        #================================================================

        #================================================================
        #region Private Methods

        #endregion
        #================================================================
    }
    #endregion
    #----------------------------------------------------------------

    #----------------------------------------------------------------
    #region CsPrincipal Class
    #----------------------------------------------------------------
    # Class to represent a principal
    class CsPrincipal {
        #================================================================
        #region Public Properties

        [string] $Principal

        #endregion
        #================================================================

        #================================================================
        #region Private Properties

        #endregion
        #================================================================

        #================================================================
        #region Constructors

        CsPrincipal([string] $Principal) {
            if ($this.ValidatePrincipal($Principal)) {
                $this.Principal = $Principal
            } else {
                throw "Invalid Principal"
            }
        }

        #endregion
        #================================================================

        #================================================================
        #region Public Methods

        [string] ToString() {
            return $this.Principal
        }

        #endregion
        #================================================================

        #================================================================
        #region Private Methods

        [bool] ValidatePrincipal($Principal) {
            return $Principal -match ".*@.*"
        }

        #endregion
        #================================================================
    }
    #endregion
    #----------------------------------------------------------------    


#endregion Classes

#region Functions

    function ConvertFrom-JulianDay {
        <#
        .SYNOPSIS
            Converts a Julian Day number to a date and time.

        .DESCRIPTION
            The ConvertFrom-JulianDay function converts a Julian Day number to a date and time. The Julian Day number is a continuous count of days since the beginning of the Julian Period on January 1, 4713 BCE. The function supports both the Gregorian and Julian calendar systems as output.

        .PARAMETER JulianDay
            Specifies the Julian Day number to convert to a date and time. The parameter accepts a System.Double object, which represents the Julian Day number.

        .EXAMPLE
            PS> ConvertFrom-JulianDay -JulianDay 2459376.5
            This example returns the date and time for the specified Julian Day number.

        .OUTPUTS
            System.DateTime
            The output is a System.DateTime object, which represents the date and time for the Julian Day number.

        .NOTES
            Author: john.nelson@1e.com
            Version: 1.0
            Date: 2024-03-03
        #>
        param (
            [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
            [double]$JulianDay
        )
            
        process {
            $J = [Math]::Floor($JulianDay + 0.5)
            $j = $J + 32044
            $g = [Math]::Floor($j / 146097)
            $dg = $j % 146097
            $c = [Math]::Floor(($dg / 36524 + 1) * 3 / 4)
            $dc = $dg - $c * 36524
            $b = [Math]::Floor($dc / 1461)
            $db = $dc % 1461
            $a = [Math]::Floor(($db / 365 + 1) * 3 / 4)
            $da = $db - $a * 365
            $y = $g * 400 + $c * 100 + $b * 4 + $a
            $m = [Math]::Floor(($da * 5 + 308) / 153) - 2
            $d = $da - [Math]::Floor(($m + 4) * 153 / 5) + 122
            $Y = $y - 4800 + [Math]::Floor(($m + 2) / 12)
            $M = ($m + 2) % 12 + 1
            $D = $d + 1

            $dayFraction = $JulianDay + 0.5 - [Math]::Floor($JulianDay + 0.5)
            $ticksPerDay = 864000000000 # 24 * 60 * 60 * 10^7
            $tickFraction = $dayFraction * $ticksPerDay

            $date = Get-Date -Year $Y -Month $M -Day $D -Hour 0 -Minute 0 -Second 0
            $date = $date.AddTicks([Math]::Round($tickFraction))

            return $date
        }
    }

    function ConvertTo-XmlString {
        <#
        .SYNOPSIS
        Converts an object to a formatted XML string.

        .DESCRIPTION
        Converts an object to an XML string. The object is first serialized to an XML file using Export-Clixml, then the XML file is read, deleted, and its content is returned as a formatted string.

        .PARAMETER Object
        The object to convert to XML. This parameter accepts pipeline input.

        .EXAMPLE
        ConvertTo-XmlString -Object $error
        Converts the $error variable to a formatted XML string.

        .EXAMPLE
        $error | ConvertTo-XmlString
        Converts the $error variable to a formatted XML string by accepting it from the pipeline.

        .NOTES
        This does use a temporary file to store the XML data in order to make use of the Export-CliXml cmdlet which has really complete support for serializing objects to XML. The temporary file is created in the user's TEMP directory and is removed after the XML string is created.

        Author: john.nelson@1e.com
        Date: 2024-03-06
        #>
        [CmdletBinding()]
        param (
            [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
            [Object]$InputObject
        )

        Process {
            $tempFile = $tempFile = New-TemporaryFile
            try {
                $InputObject | Export-Clixml -Path $tempFile
                $xmlDocument = New-Object System.Xml.XmlDocument
                $xmlDocument.Load($tempFile)
                $settings = New-Object System.Xml.XmlWriterSettings
                $settings.OmitXmlDeclaration = $false
                $settings.Encoding = [System.Text.Encoding]::Unicode
                $settings.Indent = $true
                $settings.IndentChars = '    '
                $stringWriter = New-Object System.IO.StringWriter
                $xmlWriter = [System.Xml.XmlWriter]::Create($stringWriter, $settings)
                $xmlDocument.WriteTo($xmlWriter)
                $xmlWriter.Flush()
                $stringWriter.Flush()
                $stringWriter.ToString()
            } catch {
                Write-Error "An error occurred: $_"
            } finally {
                Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue
            }
        }
    }

    function Get-JulianDay {

        <#
        .SYNOPSIS
            Converts a date and time to a Julian Day number.

        .DESCRIPTION
            The Get-JulianDay function converts a date and time to a Julian Day number. The Julian Day number is a continuous count of days since the beginning of the Julian Period on January 1, 4713 BCE. The function supports both the Gregorian and Julian calendar systems as input.

        .PARAMETER DateTime
            Specifies the date and time to convert to a Julian Day number. The parameter accepts a DateTime object or a string representation of a date and time. If the parameter is not specified, the current date and time are used.

        .EXAMPLE
            PS> Get-JulianDay
            This example returns the Julian Day number for the current date and time.

        .EXAMPLE
            PS> Get-JulianDay -DateTime "2023-11-26 12:00:00"
            This example returns the Julian Day number for the specified date and time.

        .OUTPUTS
            System.Double
            The output is a System.Double object, which represents the Julian Day number.

        .NOTES
            Author: john.nelson@1e.com
            Version: 1.0
            Date: 2024-03-03

        #>
        param (
            [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
            [ValidateScript({$_ -is [DateTime] -or $_ -is [string]})]$DateTime
        )

        process {

            if (-not $DateTime) {
                $DateTime = Get-Date
            } elseif ($DateTime -is [string]) {
                $DateTime = [DateTime]::Parse($DateTime)
            }

            $year = $DateTime.Year
            $month = $DateTime.Month
            $day = $DateTime.Day
            # No need to separately calculate hours, minutes, seconds, and milliseconds

            if ($month -le 2) {
                $year--
                $month += 12
            }

            $A = [Math]::Floor($year / 100)
            $B = 2 - $A + [Math]::Floor($A / 4)
            $JD = [Math]::Floor(365.25 * ($year + 4716)) + [Math]::Floor(30.6001 * ($month + 1)) + $day + $B - 1524.5

            # Calculate the fractional day from ticks
            $ticks = $DateTime.Ticks % [TimeSpan]::TicksPerDay # Get the remaining ticks for the current day
            $fractionalDay = $ticks / [TimeSpan]::TicksPerDay # Divide by the total number of ticks in a day

            $JD += $fractionalDay

            return $JD
        }
    }

    function New-CsLog {
        <#
        .SYNOPSIS
            Creates a new instance of the CsLog class.

        .DESCRIPTION
            The New-Cslog function creates a new instance of the CsLog class. The function supports creating a new log file with a specified file path, or using a default file path based on the script name and current date and time.

        .PARAMETER Path
            Specifies the path of the log file. If the parameter is not specified, the default log file path is used.

        .EXAMPLE
            PS> New-Cslog -Path "C:\logs\mylog.log"
            This example creates a new instance of the CsLog class with the specified log file path.

        .EXAMPLE
            PS> New-Cslog
            This example creates a new instance of the CsLog class with the default log file path.

        .OUTPUTS
            CsLog
            The output is an instance of the CsLog class.

        .NOTES
            Author:
            Version: 1.0
            Date: 2024-03-03
        #>
        param (
            [string] $Path
        )
        return [CsLog]::new($Path)
    }

    function New-CsLogEntry {
        <#
        .SYNOPSIS
            Creates a new instance of the CsLogEntry class.

        .DESCRIPTION
            The New-CsLogEntry function creates a new instance of the CsLogEntry class. The function supports creating a new log entry with a specified date and time, level, message, and context.

        .PARAMETER DateTime
            Specifies the date and time of the log entry.

        .PARAMETER Level
            Specifies the level of the log entry. The parameter accepts a string value, such as "Debug", "Info", "Warn", "Error", or "Fatal".

        .PARAMETER Message
            Specifies the message of the log entry. The parameter accepts a string value.

        .PARAMETER Context
            Specifies the context of the log entry. The parameter accepts a hashtable value.

        .EXAMPLE
            PS> New-CsLogEntry -Level "Info" -Message "This is an info message"
            This example creates a new instance of the CsLogEntry class with the specified level and message.

        .EXAMPLE
            PS> New-CsLogEntry -Level "Error" -Message "This is an error message" -Context @{ "Key1" = "Value1"; "Key2" = "Value2" }
            This example creates a new instance of the CsLogEntry class with the specified level, message, and context.

        .OUTPUTS
            CsLogEntry
            The output is an instance of the CsLogEntry class.

        .NOTES
            Author:
            Version: 1.0
            Date: 2024-03-03
        #>
        param (
            [DateTimeOffset] $TimeStamp,
            [string] $ContextHash,
            [string] $Level,
            [string] $Message
        )
        return [CsLogEntry]::new($TimeStamp, $ContextHash, $Level, $Message)
    }



    function New-Version {
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

    function Test-IsDirectory {
        <#
        .SYNOPSIS
        Tests if a path is a directory.

        .DESCRIPTION
        Tests if a path is a directory. Works with both strings and System.IO.FileSystemInfo objects like FileInfo, DirectoryInfo and FileSystemInfo

        .PARAMETER Path
        The path to test.  Can be a string or a System.IO.FileSystemInfo object like FileInfo, DirectoryInfo and FileSystemInfo

        .EXAMPLE
        Test-IsDirectory -Path 'C:\Windows'
        Returns: True

        .EXAMPLE
        Test-IsDirectory -Path 'C:\Windows\myfile.txt'
        Returns: False

        .EXAMPLE
        Test-IsDirectory -Path (Get-Item 'C:\Windows')
        Returns: True

        .NOTES
        Author: john.nelson@1e.com
        Date: 2024-03-06

        #>
        [CmdletBinding()]
        param (
            [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
            [System.Object]$Path
        )

        process {
            if ($Path -is [System.IO.FileSystemInfo]) {$Path = $Path.FullName}
            return Test-Path -Path $Path -PathType Container
        }
    }

#endregion Functions

#region Public

    # Check if Ps1eToolkit is already loaded
    if (-not (Get-Module -Name Ps1eToolkit -ListAvailable)) {
        Write-Warning "Ps1eToolkit module is not loaded. Attempting to load it."

        # Attempt to import Ps1eToolkit
        try {
            Import-Module Ps1eToolkit -ErrorAction Stop -Global
            Write-Verbose "Ps1eToolkit module loaded successfully."
        } catch {
            Write-Error "Failed to load the required Ps1eToolkit module. Please ensure it is installed. Error: $_"
            return
        }
    }

    # Export the module functions (wildcards for now, but we may want to be more specific later)
    Export-ModuleMember -Function * -Cmdlet * -Variable * -Alias *

    # Write some help to get the user started
    Write-Host @'
The Cs1eToolkit module has been loaded successfully

USAGE EXAMPLES:

Using module Cs1eToolkit            # tell your script to use the classes and functions in the module
$log = New-1eCslog "MyLog"          # create a new log called "MyLog" in the default folder (%ProgramData%\1E\CsLogs)
$log.Help()                         # display the help for the log class

'@

#endregion Public


