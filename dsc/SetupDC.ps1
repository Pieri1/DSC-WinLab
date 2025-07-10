# dsc\SetupDC.ps1
param(
    [string]$VMName = "DC01",
    [string]$ConfigurationScript = "$PSScriptRoot\..\dsc\SetupDC.ps1"
)
Write-Host "Applying DSC..." -ForegroundColor Cyan
. "$PSScriptRoot\..\settings.ps1"

Configuration SetupDC {
    param (
        [string]$DomainName = "lab.local"
        [string]$SafeModePassword = "P@ssw0rd123"
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration, xAdctiveDirectory

    Node "localhost" {
        WindowsFeature ADDSInstall {
            Ensure = "Present"
            Name = "AD-Domain-Services"
        }

        xADDomain FirstDC {
            DomainName = $DomainName
            DomainAdministratorCredential = Get-Credential -Message "Type the credential for creating the domain"
            SafemodeAdministratorPassword = (ConvertTo-SecureString $SafeModePassword -AsPlainText -Force)
            DependsOn = "[WindowsFeature]ADDSInstall"
            DomainNetbiosName = ($DomainName.Split(',')[0]).ToUpper()
        }
    }
}