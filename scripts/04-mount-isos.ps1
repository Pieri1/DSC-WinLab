# scripts\04-mount-isos.ps1
param()

Write-Host "Starting step 04" -ForegroundColor Cyan
Write-Host "Verifing and mounting ISOs on VMs" -ForegroundColor Cyan
. "$PSScriptRoot\..\settings.ps1"

foreach ($vmName in $VMs.Keys) {
    $config = $VMs[$vmName]
    $iso = if ($config.ContainsKey("ISO")) { $config.ISO } else { $DefaultIso }
    
    if (-not (Test-Path $iso)) {
        Write-Host "Iso not found to '$vmName'. Expected path: $iso" -ForegroundColor Yellow
        continue
    }

    $dvdDrive = Get-VMDvdDrive -VMName $vmName -ErrorAction SilentlyContinue

    if ($dvdDrive) {
        Write-Host "Updating ISO mounted in VM '$vmName'..."
        Set-VMDrive -VMName $vmName -Path $iso | Out-Null
    } else {
        Write-Host "Mouting ISO in '$vmName'..."
        Add-VMDvdDrive -VMName $vmName -Path $iso | Out-Null
    }

    Write-Host "ISO '$iso' mounted in '$vmName'." -ForegroundColor Green
}