
#╔═══LOG══════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    class eLogContext {
        #region Properties

        hidden [string] $os
        hidden [string] $deviceIp
        hidden [string] $userSid
        hidden [int] $sessionId
        hidden [int] $processId
        #endregion

        eLogContext () {
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
        }

    }

    class eLogEntry {
        #region Properties
        [System.DateTimeOffset] $EntryTime


    }
    #endregion
#╚═══LOG══════════════════════════════════════════════════════════════════════════════════════════════════════════════╝