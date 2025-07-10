# scripts\05-create-and-attach-unattend.ps1
param(
    [string]$VMName = "DC01"
)

Write-Host "Starting step 05" -ForegroundColor Cyan
Write-Host "Creating and attaching unattend.xml..." -ForegroundColor Cyan
. "$PSScriptRoot\..\settings.ps1"

$UnattendXMLsPath = "$BasePath\unattend"
$UnattendVHDPath = "$BasePath\vhd-unattend"
New-Item -ItemType Directory -Force -Path $UnattendXMLsPath, $UnattendVHDPath | Out-Null

$xmlSource = Join-Path $UnattendXMLsPath "$VMName-autounattend.xml"
$vhdTarget = Join-Path $UnattendVHDPath "$VMName-unattend.vhdx"

if (-not (Test-Path $xmlSource)) {
    Write-Error "XML file $xmlSource not found. Create the XML before continuing." -ForegroundColor Yellow
    return
}

if (Test-Path $vhdTarget) {
    Write-Host "VHD $vhdTarget already exists. Skipping creation." -ForegroundColor Yellow
} else {
    Write-Host "Creating VHD for $VMName..."
    New-VHD -Path $vhdTarget -SizeBytes 64MB -Dynamic -ErrorAction Stop | Out-Null
    Mount-VHD -Path $vhdTarget -Passthru | Initialize-Disk -PartitionStyle MBR -PassThru | New-Partition -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem FAT32 -Confirm:$false
}

$driveLetter = (Get-DiskImage -ImagePath $vhdTarget | Get-Disk | Get-Partition | Get-Volume).DriveLetter + ":"
Copy-Item $xmlSource -Destination (Join-Path $driveLetter "autounattend.xml") -Force
Dismount-VHD -Path $vhdTarget

Write-Host "Anexing VHD to the $VMName VM..."
Add-VMHardDiskDrive -VMName $VMName -Path $vhdTarget -ControllerType SCSI

Write-Host "Unattend VHD anexed to $VMName sucessfully." -ForegroundColor Green