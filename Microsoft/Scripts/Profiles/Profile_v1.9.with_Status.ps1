# записываем изменение настроек окна
 (Get-Host).UI.RawUI.ForegroundColor="Green"
 (Get-Host).UI.RawUI.backgroundColor="Black"
 (Get-Host).UI.RawUI.CursorSize=10
 (Get-Host).UI.RawUI.WindowTitle="Good_Luck_&_Have_FUN!"

# Изменим директорию, в которой начинаем работать:>
 Set-Location C:\
# запишем какие-нибудь алиасы:
 Set-Alias -name lst -Value Get-ChildItem
 function adm {cd E:\NEXUS\Soft\PSTools\} 
 Set-Alias mc "E:\NEXUS\Soft\FAR\Far.exe"
 Set-Alias eve "C:\EVE\Launcher\evelauncher.exe"
 Set-Alias lol "C:\League of Legends\LeagueClient.exe"
 function lin {cd D:\Cygwin\bin\}
 Set-Alias ssh "F:\Cygwin\bin\ssh.exe"
 Function nano {python "E:\Nexus\Developnet\DEV\Python\Pro\02\Note.py"}
 function www {start microsoft-edge:}
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

 function status {gc C:\Servers.txt |%{if(Test-Connection $_ -Count 2 -Quiet){Write-Host $_ '- availeble' -f DarkGreen}else{Write-Host $_ '- fail!' -f Red}}}

# Добавляем удобную нам кодировку
# chcp 866
 chcp 65001
# очищаем экран, чтобы введённые нами команды не отображались на экране, и применились цветовыые настройки
 Clear-Host