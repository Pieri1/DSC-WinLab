# scripts\09-finalize.ps1
param()

Write-Host "Starting step 09" -ForegroundColor Cyan
Write-Host "Finishing installation..." -ForegroundColor Cyan
. "$PSScriptRoot\..\settings.ps1"

$startTime = Get-Date
$report = @()

Write-Host "Finishing lab creation and collecting information..."

foreach ($vmName in $VM,Keys) {
    $vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue
    if (-not $vm){
        $report += [PSCustomObject]@{
            VMName = $vmName
            Status = "VM not found"
            IP = "-"
            DSC = "-"
        }
        continue
    }

    $ip = ($vm | Get-VMNetworkAdapter).IPAddresses | Where-Object { $_ -match '^192\.168|10\.|172\.' } | Select-Object -First 1
    $reachable = false
    if ($ip -and (Test-Connection -ComputerName $ip -Count 1 -Quiet)) {
        $reachable = $true
    }

    $dscStatus = "-"
    if ($reachable) {
        try {
            $dscStatus = Invoke-Command -ComputerName $ip -ScriptBlock {
                if (Get-DscConfigurationStatus) {
                    return "DSC applied."
                } else {
                    return "No DSC configuration applied."
                }
            } -Credential (Get-Credential) -ErrorAction Stop
        } catch {
            $dscStatus = "WinRM failed."
        }
    }

    $report += [PSCustomObject]@{
        VMName = $vmName
        Status = if ($vm.State -eq "Running") { "On" } else { "Off" }
        IP = if ($ip) { $ip } else { "-" }
        DSC = $dscStatus
    }
}

$report | Format-Table -AutoSize

$duration = New-TimeSpan -Start $startTime -End (Get-Date)
Write-Host "Verification duration: $($duration.ToString())"