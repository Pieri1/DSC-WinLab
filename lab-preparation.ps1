# lab-preparation.ps1
param()

Write-Host "Starting lab preparation assistant" -ForegroundColor Cyan
. "$PSScriptRoot\..\settings.ps1"

$steps = @(
    @{ Name = "01-check-requirements.ps1"},
    @{ Name = "02-create-switch.ps1"},
    @{ Name = "03-create-vms.ps1"},
    @{ Name = "04-mount-isos.ps1"},
    @{ Name = "05-create-and-attach-unattend.ps1"; Args = @{ VMName = "DC01" } },
    @{ Name = "06-start-vms.ps1"; Args = @{ TargetVMs = @("DC01") } },
    @{ Name = "07-wair-for-installation.ps1"; Args = @{ TargetVMs = @("DC01") } },
    @{ Name = "08-apply-dsc.ps1"; Args = @{ VMName = "DC01" } },
    @{ Name = "09-finalize.ps1"}
)

foreach ($step in $steps) {
    $scriptName = $step.Name
    $args = $step.Args

    Write-Host "Calling step: $scriptName" -ForegroundColor Cyan 
    $scriptPath = Join-Path "$PSScriptRoot\scripts" $scriptName

    if (-not (Test-Path $scriptPath)) {
        Write-Warning "Script $scriptName not found. Skipping..."
        continue
    }

    if ($args) {
        & $scriptPath @args
    } else {
        & $scriptPath
    }
}