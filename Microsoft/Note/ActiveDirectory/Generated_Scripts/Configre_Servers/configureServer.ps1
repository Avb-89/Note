
configuration configureServer
{
    Import-DscResource -ModuleName xComputerManagement, xNetworking
    Node localhost
    {

        LocalConfigurationManager {
            ActionAfterReboot = 'ContinueConfiguration'
            ConfigurationMode = 'ApplyOnly'
            RebootNodeIfNeeded = $true
        }

        xIPAddress NewIPAddress {
            IPAddress = $node.IPAddress
            InterfaceAlias = "Ethernet0"
            PrefixLength = 24
            AddressFamily = "IPV4"
        }

        xDefaultGatewayAddress NewIPGateway {
            Address = $node.GatewayAddress
            InterfaceAlias = "Ethernet0"
            AddressFamily = "IPV4"
            DependsOn = '[xIPAddress]NewIPAddress'
        }

        xDnsServerAddress PrimaryDNSClient {
            Address        = $node.DNSIPAddress
            InterfaceAlias = "Ethernet0"
            AddressFamily = "IPV4"
            DependsOn = '[xDefaultGatewayAddress]NewIPGateway'
        }

        User Administrator {
            Ensure = "Present"
            UserName = "Administrator"
            Password = $Cred
            DependsOn = '[xDnsServerAddress]PrimaryDNSClient'
        }

        xComputer ChangeNameAndJoinDomain {
            Name = $node.ThisComputerName
            DomainName    = $node.DomainName
            Credential    = $domainCred
            DependsOn = '[User]Administrator'
        }
    }
}

$ConfigData = @{
    AllNodes = @(
        @{
            Nodename = "localhost"
            ThisComputerName = "VM001"
            IPAddress = "192.168.1.2"
            GatewayAddress = "192.168.1.1"
            DNSIPAddress = "192.168.1.1"
            DomainName = "Home.lab"
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser = $true
        }
    )
}

$domainCred = Get-Credential -UserName home\Administrator -Message "Please enter a new password for Domain Administrator."
$Cred = Get-Credential -UserName Administrator -Message "Please enter a new password for Local Administrator and other accounts."

configureServer -ConfigurationData $ConfigData

Set-DSCLocalConfigurationManager -Path .\configureServer –Verbose
Start-DscConfiguration -Wait -Force -Path .\configureServer -Verbose
