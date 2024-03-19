# This file is meant to be viewed in VSCode.  It is not intended to be run directly.
# Use CTRL+K CTRL+0 collapse all outlined sections for better readability.
#
# Module: Cs1eToolkit
# Author: John.Nelson@1e.com
# Version: 202312.1823.2950.1
#
# This module contains all of the functions and classes that are used by the 1E Customer Success team

#region Variables
# Define the ASCII control characters, but instead of using the actual control characters, we use their symbolic representations
# this allows us to see them in the code and makes it easier to understand what they are, but they are valid XML characters which
# could be used in XML files or other text files where the actual control characters would not be valid.  Important for logging
# where we delineate each log entry with a record separator character (RS) and each field within the log entry with a unit 
# separator character (US).  This allows us to parse the log file easily and programmatically.
$FS = [char]0x241C  # Field Separator symbol
$GS = [char]0x241D  # Group Separator symbol
$RS = [char]0x241E  # Record Separator symbol
$US = [char]0x241F  # Unit Separator symbol

#endregion Variables

#region Classes

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
            [bool] $EchoMessages = $true
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
            hidden [string] $FS = "`u{200B}`t " # Field Separator
            hidden [string] $RS = "`u{200B}`n" # Record Separator
            hidden [System.Text.Encoding] $encoding = [System.Text.Encoding]::Unicode
            hidden [string] $encodingName = 'Unicode'
            hidden [string] $fallbackDirectory = $env:TEMP
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
            [string[]] GetContent() {
                return Get-Content -Path $this.LogFile.FullName -Force -Encoding $this.encodingName -ErrorAction SilentlyContinue
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

This class is a simple logging class that writes log messages to a file. It has a few features that make it useful for logging in PowerShell scripts.


Properties
----------
LogFile: [System.IO.FileInfo] The log file to write to. If not set, the log file will be created in the default directory with a default name.
LogMaxBytes: [int32] The maximum size of the log file in bytes before it rolls over. Default is 10MB.
LogMaxRollovers: [int32] The maximum number of rollover logs to keep. Default is 5.
RolloverLogs: [System.IO.FileInfo[]] An array of the rollover logs.
TailLines: [int32] The number of lines to tail from the log file. Default is 40.
LoggingContext: [ordered] The context to be written to the log. This is a hashtable of key-value pairs that will be written to the log.
InstantiatedTime: [System.DateTimeOffset] The time the class was instantiated. Default is the current time.
EchoMessages: [bool] Whether or not to echo log messages to the console. Default is true.
LevelColors: [hashtable] A hashtable of log level names and their associated console colors. Default is Debug=Gray, Info=White, Warn=Yellow, Error=Red, Fatal=DarkRed.


Methods
-------
Debug: Logs a message at the Debug level.
Error: Logs a message at the Error level.
Fatal: Logs a message at the Fatal level.
GetContent: Gets the content of the log file.
Help: Displays help for the CsLog class.
Info: Logs a message at the Info level.
Size: Gets the size of the log file.
Tail: Tails the log file.
Warn: Logs a message at the Warn level.


Examples
--------
# Create a new log file in the default directory with the default name
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

# Tail the last 100 lines of the log file
$log.Tail(100)

# Clear the log file and remove all rollover logs
$log.Clear()

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
            [string[]] Tail() {
                return $this.Tail($this.TailLines)
            }

            [string[]] Tail([int] $lines) {
                # If the properties haven't been cleared, and the log exists, tail the log and return the result
                if ($this.LogFile.FullName -and (Test-Path -Path $this.LogFile.FullName)) {
                    return Get-Content -Path $this.LogFile.FullName -Tail $lines -Force -Encoding $this.encodingName -ErrorAction SilentlyContinue
                } else {
                    return @()
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
                return -not (Select-String -Path $this.LogFile.FullName -Pattern $this.contextHash -Quiet)
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

function New-Cslog {
    <#
    .SYNOPSIS
        Creates a new instance of the CsLog class.

    .DESCRIPTION
        The New-Cslog function creates a new instance of the CsLog class. The function supports creating a new log file with a specified file path, or using a default file path based on the script name and current date and time.

    .PARAMETER LogFilePath
        Specifies the path of the log file. If the parameter is not specified, the default log file path is used.

    .EXAMPLE
        PS> New-Cslog -LogFilePath "C:\logs\mylog.log"
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
        [string] $LogFilePath
    )
    return [CsLog]::new($LogFilePath)
}

function New-Separator {
    <#
    .SYNOPSIS
        Generates a customizable separator string based on specified type and length.

    .DESCRIPTION
        The New-Separator function creates a customizable separator string. It supports various styles, including single, double, and thick lines, as well as specialized top and bottom separators with corner decorations. The function is designed to enhance the visual layout of console output in scripts and command-line tools.

    .PARAMETER Type
        Specifies the type of separator to generate. Available types include:
        - Single: A single line separator. Example: '────────────────────────────────────────────────'
        - Double: A double line separator. Example: '════════════════════════════════════════════════'
        - Thick: A thick line separator. Example: '████████████████████████████████████████████████'
        - SingleTop: A top border with single line and corners. Example: '┌──────────────────────────┐'
        - SingleBottom: A bottom border with single line and corners. Example: '└──────────────────────────┘'
        - DoubleTop: A top border with double lines and corners. Example: '╔══════════════════════════╗'
        - DoubleBottom: A bottom border with double lines and corners. Example: '╚══════════════════════════╝'
        - ThickTop: A thick top border with corners. Example: '█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█'
        - ThickBottom: A thick bottom border with corners. Example: '█▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█'
        Default value: 'Double' (═══════════════════════════════════════════════════)

    .PARAMETER Length
        Specifies the length of the separator in characters.
        Default value: 100.

    .PARAMETER Name
        Optional. Specifies a name or label to be included in the separator for types with top or bottom borders. The name is placed at character position 2, in the separator. If the length of the separator is too short to include the name, an error is thrown.
        Default value: None.

    .EXAMPLE
        PS> New-Separator -Type Single -Length 50
        Generates a single line separator 50 characters wide.

    .EXAMPLE
        PS> New-Separator -Type 'SingleTop' -Length 50 -Name 'SECTION HEADER'
        Produces a single line top border with 'SECTION HEADER' , 50 characters wide.

        ┌──SECTION HEADER─────────────────────────────────┐

    .EXAMPLE
        PS> New-Separator -Type 'SingleBottom' -Length 50 -Name 'SECTION HEADER'
        Produces a single line bottom border with 'SECTION HEADER' , 50 characters wide.
        
        └──SECTION HEADER─────────────────────────────────┘

    .NOTES
        Author: john.nelson@1e.com
        Version: 202312.1823.2950.1
        This function is part of the Cs1eToolkit PowerShell module.

    .LINK
        Online Documentation: [URL to more detailed documentation or module repository]
    #>

    param (
        [string] $Type = 'Double', # Default type
        [int] $Length = 100, # Default length
        [string] $Name # Optional name (for top and bottom separators)
    )

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

    # Function to create the separator with name
    function CreateSeparator([string] $leftChar, [string] $middleChar, [string] $rightChar, [int] $length, [string] $name) {
        $name = $name.ToUpper()
        $adjustedLength = $length - 2 - $name.Length
        if ($adjustedLength -lt 0) {
            throw "Length is too short to include the name"
        }
        $middle = $middleChar * 2 + $name + $middleChar * ($adjustedLength - 2)
        return $leftChar + $middle + $rightChar
    }

    if ($Type -in 'SingleTop', 'SingleBottom', 'DoubleTop', 'DoubleBottom', 'ThickTop', 'ThickBottom') {
        $leftChar = $separatorChars[$Type][0]
        $middleChar = $separatorChars[$Type][1]
        $rightChar = $separatorChars[$Type][2]
        if ([string]::IsNullOrEmpty($Name)) {
            $middleChar = $middleChar * ($Length - 2)
            return $leftChar + $middleChar + $rightChar
        } else {
            return CreateSeparator $leftChar $middleChar $rightChar $Length $Name
        }
    } else {
        return $separatorChars[$Type] * $Length
    }
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
        Import-Module Ps1eToolkit -ErrorAction Stop
        Write-Verbose "Ps1eToolkit module loaded successfully."
    } catch {
        Write-Error "Failed to load the required Ps1eToolkit module. Please ensure it is installed. Error: $_"
        return
    }
}

# Export the module functions
Export-ModuleMember -Function * -Cmdlet * -Variable * -Alias *


#endregion Public
