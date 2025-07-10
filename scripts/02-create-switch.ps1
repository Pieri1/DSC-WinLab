# scripts\02-create-switch.ps1
param()

Write-Host "Starting step 02" -ForegroundColor Cyan
Write-Host "Creating virtual lan switch..." -ForegroundColor Cyan
. "$PSScriptRoot\..\settings.ps1"

$existingSwitch = Get-VMSwitch -Name $SwitchName -ErrorAction SilentlyContinue

if ($existingSwitch) {
    Write-Host "The switch '$SwitchName' already exists. Skipping creation..."
} else {
    try {
        New-VMSwitch -SwitchName $SwitchName -SwitchType Internal | Out-Null
        Write-Host "Internal switch '$SwitchName' created sucessfully."
    }
    catch {
        Write-Error "Error creating the switch: $_"
        exit 1
    }
}