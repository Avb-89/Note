<# Notes:

Authors: Greg Shields

Goal - Configure a Nano Server.

Disclaimers

!!!!!!!!!!
This script is provided primarily as an example series of cmdlets and
is not directly intended to be run as-is.
!!!!!!!!!!

This example code is provided without copyright and AS IS.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>

set-item wsman:\localhost\client\trustedhosts -value 192.168.3.112	//Используйте командлет Set-Item, чтобы 										
																	//установить значение элемента 
																	//TrustedHosts в список, разделенный
																	//запятыми, который включает в себя 
																	//текущие и новые значения.

$cred = get-credential 192.168.3.112\administrator					//Командлет Get-Credential создает 	
																	//объект хранения учетных данных для 	
																	//указанных имени пользователя и пароля
																	//-Credential <PSCredential>
																	//Указывает имя пользователя для учетных 
																	//данных, например "User01" или 
																	//"Domain01\User01". Имя параметра 	
																	//("Credential") необязательно.
																	//При отправке команды появляется запрос 
																	//на ввод пароля.
																	//Если ввести имя пользователя без 	
																	//указания домена, командлет Get-
																	//Credential вставит перед именем 	
																	//обратную косую черту.
																	//Если параметр пропущен, программа 
																	//просит ввести имя пользователя и 		
																	//пароль.
enter-pssession -computername 192.168.3.112 -credential $cred		//открывает сессию

get-dnsclientserveraddress											//узнаем какие DNS-серверы используются моим компьютером
set-dnsclientserveraddress -interfacealias ethernet -serveraddress 192.168.3.10	//Присваиваем интерфейсу с псевдонимом ethernet 12 информацию о DNS серверах

### This first command is run on an existing domian machine to create the ODJ blob.


//Сначала, на любом компьютере домена, к которому нужно присоединить новый компьютер, выполняется команда djoin /provision для подготовки файла с данными
//новой учетной записи, а затем, на компьютере, присоединяемом к домену, выполняется команда djoin.exe /REQUESTODJ с использованием полученного на
//предыдущем шаге файла.

/PROVISION - Подготовка учетной записи компьютера в домене.
/SAVEFILE < путь_к_файлу > - Сохранение данных подготовки в файле, указанном как путь_к_файлу.
/WINDOWSPATH < путь > - путь к каталогу с автономным образом Windows. 

djoin /provision /domain company.pri /machine nanoserver1 /savefile c:/nanoserver/nanoserver1.txt

### Copy the results of the first command to the candidate machine and run this second
### command to complete the domain join.
djoin /requestodj /loadfile C:\nanoserver1.txt /windowspath C:\Windows /localos	//DJOIN – присоединить компьютер к домену

### Configure package providers and install DNS and IIS roles.
install-packageprovider -name nuget -minimumversion 2.8.5.201 -force	//Этот командлет устанавливает один или несколько поставщиков пакетов для управления
																		//пакетами.
																		//NuGet — система управления пакетами для платформ разработки Microsoft, 
																		//в первую очередь библиотек .NET Framework. Управляется .NET Foundation.
	
save-module -path "$env:programfiles\windowspowershell\modules" -name nanoserverpackage	//Сохраняет модуль локально без его установки. - Загрузка модуля
Install-packageprovider nanoserverpackage												//Этот командлет устанавливает один или несколько поставщиков пакетов
																						//для управления пакетами.
																						//NanoServerPackage - имя поставщика
							
Import-packageprovider nanoserverpackage												//Добавляет поставщиков пакетов управления пакетами в текущий сеанс.
find-nanoserverpackage																	//Выведем список доступных пакетов Nano Server
install-nanoserverpackage -name microsoft-nanoserver-dns-package						//установка пакета днс
enable-windowsoptionalfeature -online -featurename dns-server-full-role					//Ресурс WindowsOptionalFeature в DSC Windows PowerShell 
																						//предоставляет механизм включения
																						//дополнительных компонентов на целевом узле.
install-nanoserverpackage -name microsoft-nanoserver-iis-package						//Установка пакета ИИС
import-module iis*																		//Импорт модуля ИИС
mkdir c:\site1
new-iissite -name site1 -bindinginformation "*:80:site1" -physicalpath c:\site1			//Командлет New-IISSite используется для создания веб-сайта 
																						//служб IIS с данным физическим сайтом в качестве информации 
																						//о корне и привязке для прослушивания определенного IP-адреса:
																						//Port: Hostname.
get-iissite site1																		//Получает информацию о конфигурации для веб-сайта IIS.
start-service was,w3svc																	//W3svc-Веб-служба публикации
start-iissite site1																		//Запускает существующий сайт на сервере ИИС