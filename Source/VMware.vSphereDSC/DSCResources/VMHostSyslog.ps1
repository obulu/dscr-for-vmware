<#
Copyright (c) 2018 VMware, Inc.  All rights reserved

The BSD-2 license (the "License") set forth below applies to all parts of the Desired State Configuration Resources for VMware project.  You may not use this file except in compliance with the License.

BSD-2 License

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#>

[DscResource()]
class VMHostSyslog : VMHostBaseDSC {
    <#
    .DESCRIPTION

    The remote host(s) to send logs to.
    #>
    [DscProperty()]
    [string] $Loghost

    <#
    .DESCRIPTION

    Verify remote SSL certificates against the local CA Store.
    #>
    [DscProperty()]
    [bool] $CheckSslCerts

    <#
    .DESCRIPTION

    Default network retry timeout in seconds if a remote server fails to respond.
    #>
    [DscProperty()]
    [long] $DefaultTimeout

    <#
    .DESCRIPTION

    Message queue capacity after which messages are dropped.
    #>
    [DscProperty()]
    [long] $QueueDropMark

    <#
    .DESCRIPTION

    The directory to output local logs to.
    #>
    [DscProperty()]
    [string] $Logdir

    <#
    .DESCRIPTION

    Place logs in a unique subdirectory of logdir, based on hostname.
    #>
    [DscProperty()]
    [bool] $LogdirUnique

    <#
    .DESCRIPTION

    Default number of rotated local logs to keep.
    #>
    [DscProperty()]
    [long] $DefaultRotate

    <#
    .DESCRIPTION

    Default size of local logs before rotation, in KiB.
    #>
    [DscProperty()]
    [long] $DefaultSize

    <#
    .DESCRIPTION

    Number of rotated dropped log files to keep.
    #>
    [DscProperty()]
    [long] $DropLogRotate

    <#
    .DESCRIPTION

    Size of dropped log file before rotation, in KiB.
    #>
    [DscProperty()]
    [long] $DropLogSize

    [void] Set() {
        Write-Verbose -Message "$(Get-Date) $($s = Get-PSCallStack; "Entering {0}" -f $s[0].FunctionName)"

        $this.ConnectVIServer()
        $vmHost = $this.GetVMHost()

        $this.UpdateVMHostSyslog($vmHost)
    }

    [bool] Test() {
        Write-Verbose -Message "$(Get-Date) $($s = Get-PSCallStack; "Entering {0}" -f $s[0].FunctionName)"

        $this.ConnectVIServer()
        $vmHost = $this.GetVMHost()

        return !$this.ShouldUpdateVMHostSyslog($vmHost)
    }

    [VMHostSyslog] Get() {
        Write-Verbose -Message "$(Get-Date) $($s = Get-PSCallStack; "Entering {0}" -f $s[0].FunctionName)"

        $result = [VMHostSyslog]::new()

        $this.ConnectVIServer()
        $vmHost = $this.GetVMHost()
        $this.PopulateResult($vmHost, $result)

        return $result
    }

    <#
    .DESCRIPTION

    Returns a boolean value indicating if VMHostSyslog needs to be updated.
    #>
    [bool] ShouldUpdateVMHostSyslog($VMHost) {
        Write-Verbose -Message "$(Get-Date) $($s = Get-PSCallStack; "Entering {0}" -f $s[0].FunctionName)"

        $esxcli = Get-Esxcli -Server $this.Connection -VMHost $vmHost -V2
        $current = Get-VMHostSyslogConfig -EsxCLi $esxcli

        $shouldUpdateVMHostSyslog = @()

        $shouldUpdateVMHostSyslog += $this.LogHost -ne $current.LogHost
        $shouldUpdateVMHostSyslog += $this.CheckSslCerts -ne $current.EnforceSSLCertificates
        $shouldUpdateVMHostSyslog += $this.DefaultTimeout -ne $current.DefaultNetworkRetryTimeout
        $shouldUpdateVMHostSyslog += $this.QueueDropMark -ne $current.MessageQueueDropMark
        $shouldUpdateVMHostSyslog += $this.Logdir -ne $current.LocalLogOutput
        $shouldUpdateVMHostSyslog += $this.LogdirUnique -ne $current.LogToUniqueSubdirectory
        $shouldUpdateVMHostSyslog += $this.DefaultRotate -ne $current.LocalLoggingDefaultRotations
        $shouldUpdateVMHostSyslog += $this.DefaultSize -ne $current.LocalLoggingDefaultRotationSize
        $shouldUpdateVMHostSyslog += $this.DropLogRotate -ne $current.DroppedLogFileRotations
        $shouldUpdateVMHostSyslog += $this.DropLogSize -ne $current.DroppedLogFileRotationSize

        return ($shouldUpdateVMHostSyslog -contains $true)
    }

    <#
    .DESCRIPTION

    Updates the configuration of the VMHostSyslog.
    #>
    [void] UpdateVMHostSyslog($VMHost) {
        Write-Verbose -Message "$(Get-Date) $($s = Get-PSCallStack; "Entering {0}" -f $s[0].FunctionName)"

        $esxcli = Get-Esxcli -Server $this.Connection -VMHost $vmHost -V2

        $VMHostSyslogConfig = @{
            loghost = $this.Loghost
            checksslcerts = $this.CheckSslCerts
            defaulttimeout = $this.DefaultTimeout
            queuedropmark = $this.QueueDropMark
            logdir = $this.Logdir
            logdirunique = $this.LogdirUnique
            defaultrotate = $this.DefaultRotate
            defaultsize = $this.DefaultSize
            droplogrotate = $this.DropLogRotate
            droplogsize = $this.DropLogSize
        }
        Set-VMHostSyslogConfig -EsxCli $esxcli -VMHostSyslogConfig $VMHostSyslogConfig
    }

    <#
    .DESCRIPTION

    Populates the result returned from the Get() method with the values of the VMHostService from the server.
    #>
    [void] PopulateResult($VMHost, $syslog) {
        Write-Verbose -Message "$(Get-Date) $($s = Get-PSCallStack; "Entering {0}" -f $s[0].FunctionName)"

        $esxcli = Get-Esxcli -Server $this.Connection -VMHost $vmHost -V2
        $currentVMHostSyslog = Get-VMHostSyslogConfig -EsxCLi $esxcli

        $syslog.Server = $this.Server
        $syslog.Name = $VMHost.Name
        $syslog.Loghost = $currentVMHostSyslog.RemoteHost
        $syslog.CheckSslCerts = $currentVMHostSyslog.CheckSslCerts
        $syslog.DefaultTimeout = $currentVMHostSyslog.DefaultTimeout
        $syslog.QueueDropMark = $currentVMHostSyslog.QueueDropMark
        $syslog.Logdir = $currentVMHostSyslog.Logdir
        $syslog.LogdirUnique = $currentVMHostSyslog.LogdirUnique
        $syslog.DefaultRotate = $currentVMHostSyslog.DefaultRotate
        $syslog.DefaultSize = $currentVMHostSyslog.DefaultSize
        $syslog.DropLogRotate = $currentVMHostSyslog.DropLogRotate
        $syslog.DropLogSize = $currentVMHostSyslog.DropLogSize
    }
}
