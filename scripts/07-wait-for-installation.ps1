# scripts\07-wait-for-installation.ps1
param(
    [string[]]$TargetVMs = @(),
    [int]$TimeoutSeconds = 900,
    [int]$PingInterval = 15
)

Write-Host "Starting step 07" -ForegroundColor Cyan
Write-Host "Waiting for installation..." -ForegroundColor Cyan
. "$PSScriptRoot\..\settings.ps1"

if ($TargetVMs.Count -eq 0) {
    $TargetVMs = $VMs.Keys
}

foreach ($vmName in $TargetVMs) {
    Write-Host "Waiting '$vmName' VM to finish installation"

    $startTime = Get-Date
    $timeoutTime = $startTime.AddSeconds($TimeoutSeconds)
    $vmUp = $false

    while ((Get-Date) -lt $timeoutTime) {
        $vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue
        if (-not $vm) {
            Write-Warning "'$vmName' VM not found. Ignoring..."
            break
        }

        if ($vm.State -ne 'Running') {
            Write-Host "'$vmName' VM is still offline. Waiting..."
            Start-Sleep -Seconds $PingInterval
            continue
        }

        $vmIP = ($vm | Get-VMNetworkAdapter).IPAddresses | Where-Object { $_ -match '^192\.168|10\.|172\.' }
        if (-not $vmIP) {
            Write-Host "Waiting for valid IP from '$vmName' VM"
            Start-Sleep -Seconds $PingInterval
            continue
        }

        Write-Host "IP detected: $vmIP. Testing connection..."

        if (Test-Connection -ComputerName $vmIP -Count 1 -Quiet) {
            Write-Host "'$vmName' VM answered the ping. Instalation probably finished."
            $vmUp = $true
            break
        }

        Write-Host "Still waiting for a response from '$vmName' VM... Trying again on $PingInterval seconds."
        Start-Sleep -Seconds $PingInterval
    }

    if (-not $vmUp) {
        Write-Warning "Timeout: '$vmName' VM did not answer in $TimeoutSeconds seconds."
    }
}