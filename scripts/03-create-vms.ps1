# scripts\03-create-vms.ps1
param()

Write-Host "Starting step 03" -ForegroundColor Cyan
Write-Host "Creating VMs..." -ForegroundColor Cyan
. "$PSScriptRoot\..\settings.ps1"

foreach ($vmName in $VMs.Keys) {
    $config = $VMs[$vmName]
    $ram = $config.RAM
    $diskSize = $config.DiskSize
    $iso = if ($config.ContainsKey("ISO")) { $config.ISO } else { $DefaultISO }
    $vhdPath = "$VMPath\$vmName.vhdx"

    if (Get-VM -Name $vmName -ErrorAction SilentlyContinue) {
        Write-Host "The VM '$vmName' already exists. Skipping creation..." -ForegroundColor Yellow
        continue
    }

    Write-Host "Creating VM '$vmName' with $($ram/1MB) MB of RAM and $($diskSize/1GB) GB of disk size..."
    
    try {
        New-VM -Name $vmName -Generation 2 -MemoryStartupBytes $ram -NewVHDPath $vhdPath -NewVHDSizeBytes $diskSize -SwitchName $SwitchName | Out-Null
        Add-VMDvdDrive -VMName $vmName -Path $iso | Out-Null
        Set-VMFirmware -VMName $vmName -EnableSecureBoot On -SecureBootTemplate "MicrosoftWindows" | Out-Null
        Write-Host "VM '$vmName' created sucessfully."
    } catch {
        Write-Error "Error creating VM '$vmName': $_"
    }
}