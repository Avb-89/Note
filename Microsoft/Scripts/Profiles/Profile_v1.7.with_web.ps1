# записываем изменение настроек окна
 (Get-Host).UI.RawUI.ForegroundColor="Green"
 (Get-Host).UI.RawUI.backgroundColor="Black"
 (Get-Host).UI.RawUI.CursorSize=10
 (Get-Host).UI.RawUI.WindowTitle="Good_Luck_&_Have_FUN!"

# Изменим директорию, в которой начинаем работать:>
 Set-Location C:\
# запишем какие-нибудь алиасы:
 Set-Alias lst Get-ChildItem>
 function adm {cd E:\NEXUS\Soft\PSTools\} 
 Set-Alias mc "E:\NEXUS\Soft\FAR\Far.exe"
 Set-Alias eve "C:\EVE\Launcher\evelauncher.exe"
 Set-Alias lol "C:\League of Legends\LeagueClient.exe"
 function lin {cd D:\Cygwin\bin\}
 Set-Alias ssh "G:\Cygwin\bin\ssh.exe"
 Set-Alias nano "G:\Notepad++\notepad++.exe"
 Set-Alias web "G:\K-Meleon\K-Meleon.exe"
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


# Добавляем удобную нам кодировку
 chcp 866
# очищаем экран, чтобы введённые нами команды не отображались на экране, и применились цветовыые настройки
 Clear-Host