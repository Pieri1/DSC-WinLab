# scripts\06-start-vms.ps1
param(
    [string[]]$TargetVMs = @()
)

Write-Host "Starting step 06" -ForegroundColor Cyan
Write-Host "Starting VMs..." -ForegroundColor Cyan
. "$PSScriptRoot\..\settings.ps1"

if ($TargetVMs.Count -eq 0) {
    $TargetVMs = $VMs.Keys
}

foreach ($vmName in $TargetVMs) {
    $vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue

    if (-not $vm) {
        Write-Warning "'$vmName' VM not found. Ignoring..."
        continue
    }

    if($vm.State -eq 'Running') {
        Write-Host "'$vmName' VM is already running. Skipping..."
        continue
    }

    Write-Host "Starting '$vmName' VM"
    Start-VM -Name $vmName | Out-Null
}

Write-Host "All Target-VMs has been started."