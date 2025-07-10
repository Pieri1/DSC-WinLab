# scripts\01-check-requirements.ps1
param()

Write-Host "Starting step 01" -ForegroundColor Cyan
Write-Host "Verifing system requirements..." -ForegroundColor Cyan
. "$PSScriptRoot\..\settings.ps1"

$currentIdentity = [Security,Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity) 
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)){
    Write-Error "This script must be executed as an Administrator."
    exit 1
}

$hypervFeature = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
if ($hypervFeature.State -ne 'Enabled') {
    Write-Host "Hyper-V is not activated. Activating now..." -ForegroundColor Yellow
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -All -NoRestart
    Write-Host "Restart the machine to finish Hyper-V activation." -ForegroundColor Magenta
    exit 0
} else {
    Write-Host "Hyper-v is already activated."
}

if (-not (Test-Path $DefaultISO)) {
    Write-Error "The specified ISO could not be found: $DefaultISO"
    exit 1
} else {
    Write-Host "ISO found in $DefaultISO"
}

@($BasePath, $VMPath) | ForEach-Object {
    if (-not (Test-Path $_)) {
        Write-Host "Creating folder $_"
        New-Item -Path $_ -ItemType Directory | Out-Null
    }
}

Write-Host "Requirements sucessfully verified." -ForegroundColor Green