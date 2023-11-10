<# Notes:

Goal - Create a domain controller and populate with OUs, Groups, and Users.
This script must be run after prepDomainController.

Disclaimer - This example code is provided without copyright and AS IS.  It is free for you to use and modify.

#>

configuration BuildDomainController
{
    Import-DscResource -ModuleName xActiveDirectory, xComputerManagement, xNetworking, xDnsServer
    Node localhost
    {

        LocalConfigurationManager {
            ActionAfterReboot = 'ContinueConfiguration'
            ConfigurationMode = 'ApplyOnly'
            RebootNodeIfNeeded = $true
        }
  
        xIPAddress NewIPAddress {
            IPAddress = $node.IPAddress
            InterfaceAlias = $node.InterfaceAlias
            AddressFamily = 'IPV4'
        }

        xDefaultGatewayAddress NewIPGateway {
            Address = $node.GatewayAddress
            InterfaceAlias = $node.InterfaceAlias
            AddressFamily = 'IPV4'
            DependsOn = '[xIPAddress]NewIPAddress'
        }

        xDnsServerAddress PrimaryDNSClient {
            Address = $node.DnsAddress
            InterfaceAlias = $node.InterfaceAlias
            AddressFamily = 'IPV4'
            DependsOn = '[xDefaultGatewayAddress]NewIPGateway'
        }

        User Administrator {
            Ensure = 'Present'
            UserName = 'Administrator'
            Password = $Cred
            DependsOn = '[xDnsServerAddress]PrimaryDNSClient'
        }

        xComputer NewComputerName {
            Name = $node.ThisComputerName
            DependsOn = '[User]Administrator'
        }

        WindowsFeature ADDSInstall {
            Ensure = 'Present'
            Name = 'AD-Domain-Services'
            DependsOn = '[xComputer]NewComputerName'
        }

        xADDomain FirstDC {
            DomainName = $node.DomainName
            DomainAdministratorCredential = $domainCred
            SafemodeAdministratorPassword = $domainCred
            DatabasePath = $node.DCDatabasePath
            LogPath = $node.DCLogPath
            SysvolPath = $node.SysvolPath 
            DependsOn = '[WindowsFeature]ADDSInstall'
        }

		xADUser myaccount {
            DomainName = $node.DomainName
            Path = "CN=Users,$($node.DomainDN)"
            UserName = 'djones'
            GivenName = 'Donna'
            Surname = 'Jones'
            DisplayName = 'Donna Jones'
            Enabled = $true
            Password = $Cred
            DomainAdministratorCredential = $Cred
            PasswordNeverExpires = $true
            DependsOn = '[xADDomain]FirstDC'
        }

        xADUser root {
            DomainName = $node.DomainName
            Path = "CN=Users,$($node.DomainDN)"
            UserName = 'root'
            GivenName = 'root'
            Surname = 'root'
            DisplayName = 'root'
            Enabled = $true
            Password = $Cred
            DomainAdministratorCredential = $Cred
            PasswordNeverExpires = $true
            DependsOn = '[xADDomain]FirstDC'
        }

        xADGroup IT {
            GroupName = 'IT'
            Path = "CN=Users,$($node.DomainDN)"
            Category = 'Security'
            GroupScope = 'Global'
            MembersToInclude = 'root'
            DependsOn = '[xADDomain]FirstDC'
        }

        xADGroup DomainAdmins {
            GroupName = 'Domain Admins'
            Path = "CN=Users,$($node.DomainDN)"
            Category = 'Security'
            GroupScope = 'Global'
            MembersToInclude = 'root'
            DependsOn = '[xADDomain]FirstDC'
        }

        xADGroup EnterpriseAdmins {
            GroupName = 'Enterprise Admins'
            Path = "CN=Users,$($node.DomainDN)"
            Category = 'Security'
            GroupScope = 'Universal'
            MembersToInclude = 'root'
            DependsOn = '[xADDomain]FirstDC'
        }

        xADGroup SchemaAdmins {
            GroupName = 'Schema Admins'
            Path = "CN=Users,$($node.DomainDN)"
            Category = 'Security'
            GroupScope = 'Universal'
            MembersToInclude = 'root'
            DependsOn = '[xADDomain]FirstDC'
        }

        xDnsServerADZone addReverseADZone {
            Name = '1.168.192.in-addr.arpa'
            DynamicUpdate = 'Secure'
            ReplicationScope = 'Forest'
            Ensure = 'Present'
            DependsOn = '[xADDomain]FirstDC'
        }
    }
}
            
$ConfigData = @{
    AllNodes = @(
        @{
            Nodename = "localhost"
            ThisComputerName = "VM000"
            IPAddress = "192.168.1.10/24"
            DnsAddress = "192.168.1.10"
            GatewayAddress = "192.168.1.2"
            InterfaceAlias = "Ethernet0"
            DomainName = "home.lab"
            DomainDN = "DC=Home,DC=lab"
            DCDatabasePath = "C:\NTDS"
            DCLogPath = "C:\NTDS"
            SysvolPath = "C:\Sysvol"
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser = $true
        }
    )
}

$domainCred = Get-Credential -UserName home\Administrator -Message "Please enter a new password for Domain Administrator."
$Cred = Get-Credential -UserName Administrator -Message "Please enter a new password for Local Administrator and other accounts."

BuildDomainController -ConfigurationData $ConfigData

Set-DSCLocalConfigurationManager -Path .\BuildDomainController –Verbose
Start-DscConfiguration -Wait -Force -Path .\BuildDomainController -Verbose