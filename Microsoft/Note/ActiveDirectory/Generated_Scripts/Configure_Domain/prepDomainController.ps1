<# Notes:
Этот скрипт не запускается просто так. чтобы он работал попробуй:
Register-PackageSource -Name PSGallery -Location https://www.powershellgallery.com/api/v2/ -ProviderName PowerShellGet -Force
Get-PackageSource -Name PSGallery -force 
и потом запускай скрипт.
#>

Get-PackageSource -Name PSGallery | Set-PackageSource -Trusted -Force -ForceBootstrap

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

Install-Module xActiveDirectory -Force
Install-Module xComputerManagement -Force
Install-Module xNetworking -Force
Install-Module xDnsServer -Force

Write-Host "You may now execute '.\buildDomainController.ps1'"
