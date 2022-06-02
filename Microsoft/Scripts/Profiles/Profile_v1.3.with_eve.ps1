# записываем изменение настроек окна
 (Get-Host).UI.RawUI.ForegroundColor="Green"
 (Get-Host).UI.RawUI.backgroundColor="Black"
 (Get-Host).UI.RawUI.CursorSize=10
 (Get-Host).UI.RawUI.WindowTitle="Have_a_good_day!"

# Изменим директорию, в которой начинаем работать:>
 Set-Location C:\
# запишем какие-нибудь алиасы:
 Set-Alias lst Get-ChildItem
 function adm {cd C:\NEXUS\Soft\PSTools\} 
 Set-Alias mc "C:\NEXUS\Soft\FAR\Far.exe"
 Set-Alias eve "C:\GM\EVE\Launcher\evelauncher.exe"
 function lin {cd D:\Cygwin\bin\}
 Set-Alias ssh "D:\Cygwin\bin\ssh.exe"
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