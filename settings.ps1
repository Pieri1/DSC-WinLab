# settings.ps1

# Installation Configuration
$BasePath = "C:\Labs\DSC-WinLab" ### Where you will install it. Change to the location of the DSC-WinLab folder
$VMPath = "$BasePath\VMs"
$ISOPath = "$BasePath\ISOs\WinServer2022.iso"
$SwitchName = "LocalNetworkWinLab"
$DefaultDelaySeconds = 15

# VM Configuration
$VMs = @{
    "DC01" = @{ RAM = 4GB; DiskSize = 60GB; ISO = "$BasePath\ISOs\WinServer2022.iso" }
    "CLIENT01" = @{ RAM = 2GB; DiskSize = 40GB; ISO = "$BasePath\ISOs\Win11.iso" }
}
$VMOrder = @("DC01","CLIENT01")
$StaticIPs = @{
    "DC01" = @{ IP = "192.168.100.10"; Mask = "255.255.255.0"; Gateway = "192.168.100.1"; DNS = "192.168.100.10" }
    "CLIENT01" = @{ IP = "192.168.100.11"; Mask = "255.255.255.0"; Gateway = "192.168.100.1"; DNS = "192.168.100.10" }
}

# ISO Configuration
$DefaultISO = $ISOPath

# Domain Configuration
$DomainName = "lab.local"
$DomainNetBIOS = "LAB"
$SafeModePassword = "P@ssw0rd123"
$DomainAdminUser = "Administrator"
$DomainAdminPassword = "P@ssw0rd123"
$LocalAdminPassword = "P@ssw0rdLocal123"