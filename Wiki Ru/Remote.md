[К списку тем](https://github.com/Vector-BCO/PowerShell.Learning/wiki)

# Конфигурация
В PowerShell используется [WinRM](https://docs.microsoft.com/en-us/windows/win32/winrm/portal) который основан на [WS-Management Protocol](https://docs.microsoft.com/en-us/windows/win32/winrm/ws-management-protocol) что дает довольно широкий спектр настроек безопасности.

Настройки по умолчанию дает возможность подключения всем и отовсюду, что правда без авторизации работать это будет исключительно в домене и при административном уровне привилегий.

Для настройки можно использовать утилиту [winrm](https://docs.microsoft.com/en-us/windows/win32/winrm/installation-and-configuration-for-windows-remote-management)
Пример:
    winrm quickconfig

Или набор коммандлетов [PSRemoting](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/enable-psremoting?view=powershell-5.1)
Пример:
    Enable-PSRemoting -Force

Так же в рамках домена настройку [winrm можно производить через GPO](https://www.kjctech.net/how-to-enable-winrm-with-domain-group-policy-for-powershell-remoting/)

# New-PSSession
Коммандлет для установления подключения с компьютерами в сети
Сама процедура установки подключения довольно длительная (в сравнении с другими процедурами в языке) 
Поэтому если необходимо производить несколько операций на удаленных ПК одну за одной, то с точки зрения производительности логику стоит выстраивать на PSSession

Параметров настройки подключения намного больше чем при настройке подключения используя параметр ComputerName в Invoke-Command или Enter-PSSession

После выполнения операций хорошей практикой является закрытье открытых сессий при помощи **Remove-PSSession**

Например:
    Необходимо получить процессоров со всех ПК в домене, после чего сверить со списком доступных процессоров для замены 
    Когда получится получить список сравнения - выполнить на ПК с необходимыми процессорами скрипт диагностики
Решение примера может быть похожим на это:
```PowerShell
    $CompatibleCPUs = Import-CSV "C:\Work Documents\CPUs.csv"
    $Computers = Import-CSV "C:\Work Documents\DomainComputers.csv"
    $PoShSession = New-PSSession -ComputerName $Computers
    $result = Invoke-Command -Session $PoShSession -ScriptBlock {
        [psobject]@{
            ComputerName = $Env:ComputerName
            ProcessorName = Get-CimInstance win32_processor | select -ExpandProperty name
        }
    }
    $DiagnosticNeeded = ($result | Where-Object {$CompatibleCPUs.Name -contains $_.ProcessorName}).ComputerName
    $PoShSession = $PoShSession | Where-Object {$_.Computername -in $DiagnosticNeeded}
    Invoke-Command -Session $PoShSession -ScriptBlock {
        . \\SMBServer1\DomainScripts\DiagnosticScript.ps1
    }
    Remove-PSSession $PoShSession
```


# Invoke-Command
Служит для **не интерактивного** выполнения команд (не требующих взаимодействия с пользователем)
## Параметр -ComputerName
Параметр может принимать название ПК или его IP адрес или их список.
В Примере 1 команда будет выполняться на каждом ПК 1 за 1, что при большом количестве итераций
будет сильно увеличивать время выполнения команды. Пример 2 предпочтительнее.

```PowerShell
    # Пример 1
    Get-ADComputer -Filter * | Foreach {
        # ScriptBlock будет выполнен на каждом ПК >поочередно<
        Invoke-Command -ComputerName $_.Name -ScriptBlock {$Env:ComputerName}
    }
```
```PowerShell
    # Пример 2
    # $ADComputers будет содержать список всех ПК в домене
    $ADComputers = (Get-ADComputer -Filter *).Name
    # ScriptBlock будет выполнен на всех ПК >параллельно<
    Invoke-Command -ComputerName $ADComputers -ScriptBlock {$Env:ComputerName}
```

## Параметр -Session
Описание доступно в **New-PSSession**

```PowerShell
    $ADComputers = (Get-ADComputer -Filter *).Name
    $PoShSession = New-PSSession -ComputerName $ADComputers
    Invoke-Command -Session $PoShSession -ScriptBlock {$Env:ComputerName}
```

## Параметр -ScriptBlock
ScriptBlock это часть кода которая находится в фигурных скобках
```PowerShell
    { Get-Command Invoke-Command }
```
При этом содержимое скобок само по себе не выполняется и может быть сохранено в переменной и использовано позже
```PowerShell
    $ScrBlock = { $Env:ComputerName }
```
Следовательно в параметр **-ScriptBlock** можно подать как набор команд обрамленных фигурными скобками, 
так и переменную которая будет содержать в себе ScriptBlock
```PowerShell
    # Пример
    $Computers = @('ComputerA','ComputerB','ComputerC')
    $ScrBlock = {
        Write-Output "You are connected to $ENV:ComputerName"
        $scrPath = '\\SMBServer1\DomainScripts\DiagnosticScript.ps1'
        Write-Output "Starting diagnostic script : $scrPath"
        $result = . $scrPath
        If ($result.Status -eq 'Succeed'){
            return $true
        } Else {
            return $false
        }
    }
    Invoke-Command -ComputerName $Computers -ScriptBlock $ScrBlock
```

## Параметр -ASJob 
Позволяет запустить выполнение команд на удаленных ПК в отдельных процессах и по умолчанию не блокирует дальнейшее выполнение скрипта
Пример:
```PowerShell
    $Computers = '127.0.0.1'
    $ScrBlock = {
        Start-Sleep 5
        return 'Some actions A'
    }
    Invoke-Command -ComputerName $Computers -ScriptBlock $ScrBlock -AsJob
    # Тут можно выполнить часть скрипта который никак не пересекается с выполнением $ScrBlock
    'Some other actions B'
    # Если будет необходимость дождаться выполнения $ScrBlock то для этого доступны Job командлеты
    $Jobs = Get-Job
    $Jobs | Wait-Job -Timeout 60
    $Jobs | Receive-Job
    $Jobs | Remove-Job -Force
```

# Enter-PSSession
Служит для **интерактивного** выполнения команд
Параметры ComputerName и Session работают аналогично
При работе с ComputerName доступно больше дополнительных параметров для управления сеансов 
которые в случае с Session должны выставляться через **New-PSSession**