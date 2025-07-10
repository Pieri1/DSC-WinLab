# scripts\08-appply-dsc.ps1
param(
    [string]$VMName = "DC01",
    [string]$ConfigurationScript = "$PSScriptRoot\..\dsc\SetupDC.ps1"
)

Write-Host "Starting step 08" -ForegroundColor Cyan
Write-Host "Applying DSC..." -ForegroundColor Cyan
. "$PSScriptRoot\..\settings.ps1"
. "$PSScriptRoot\..\dsc\SetupDC.ps1"

$vm = Get-VM -Name $VMName -ErrorAction Stop
$vmIP = ($vm | Get-VMNetworkAdapter).IPAddresses | Where-Object { $_ -match '^192\.168|10\.|172\.' }

if (-not $vmIP) {
    Write-Error "'$VMName' VM IP not found." -ForegroundColor Yellow
    return
}

Write-Host "VM IP: $vmIP"

Write-Host "Creating remote session with WinRM..."
$sess = New-PSSession -ComputerName $vmIP -Credential (Get-Credential) -ErrorAction Stop

Write-Host "Copying DSC script to VM..."
Copy-Item -ToSession $sess -Path $ConfigurationScript -Destination "C:\DSC"

Invoke-Command -Session $sess -ScriptBlock {
    Set-Location C:\DSC
    . .\SetupDC.ps1
    SetupDC -DomainName "lab.local" -SafeModePassword "P@ssword123" -OutputPath C:\DSC\MOF
    Start-DscConfiguration -Path C:\DSC\MOF -Wait -Force -Verbose
}

Write-Host "DSC Configuration applied on '$VMName' VM" -ForegroundColor Green