# записываем изменение настроек окна
 (Get-Host).UI.RawUI.ForegroundColor="Green"
 (Get-Host).UI.RawUI.backgroundColor="Black"
 (Get-Host).UI.RawUI.CursorSize=10
 (Get-Host).UI.RawUI.WindowTitle="Good_Luck_&_Have_FUN!"

# Изменим директорию, в которой начинаем работать:>
 Set-Location C:\
# запишем какие-нибудь алиасы:
 function adm {cd D:\PSTools\}
 Set-Alias mc "D:\FAR\Far.exe"
 function www {start microsoft-edge:https://yandex.ru}
 function Connect-VM {
	param(
		[Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]
		[String[]]$ComputerName
	)
	PROCESS {
		foreach ($name in $computername) {
			vmconnect localhost $name
		}
	}
}

function PSEdit {
[CmdletBinding()]
param([Parameter(Mandatory=$true,ValueFromPipeline=$true)]$filename
)

Process {
    if (test-path $filename -PathType Leaf) {
        $file = Get-ChildItem $filename
        if ($file.PSProvider.Name -eq "Filesystem") {
            Start-Process PowerShell_ISE -ArgumentList $file
        }
        else {Write-Error "Wrong PSProvider: $($File.PSProvider.Name)" }
    }
    else {write-error "Bad path: $filename"}
  }
}

 function status {gc C:\Servers.txt |%{if(Test-Connection $_ -Count 2 -Quiet){Write-Host $_ '- availeble' -f DarkGreen}else{Write-Host $_ '- fail!' -f Red}}}

# Добавляем удобную нам кодировку
# chcp 866
 chcp 65001
# очищаем экран, чтобы введённые нами команды не отображались на экране, и применились цветовыые настройки
 Clear-Host
