# PowerShell Beginner (EN\PL)

## Date and evennt plan
### Part 1 2021.06.22 12:00 - 14:00 Kraków time 
    1) Short introduction
    2) 
### Part 2 2021.06.24 12:00 - 14:00 Kraków time


## Prerequisites for participants  
    Windows OPS 
    Basic understanding:
    - What for PowerShell used (WiKi, YouTube, internet articles)
    - What is cmdlet
    - What is functions
    - What is parameters
    Практика применения в решении рабочих задач - чем больше вопросов будет на момент начала практикума, тем больше получите от мероприятия

## Требование к инфраструктуре
    - Windows 7 SP1 или старше
    - PowerShell 5.1  - проверить версию можно при помощи команды $PSVersionTable.PSVersion
    - Visual Studio Code (рекомендовано)
    
    Для владельцев семерок и восьмерок, желающих поднять свою версию WMF до 5.1, ссылки на документацию и закачку
    https://docs.microsoft.com/ru-ru/powershell/scripting/windows-powershell/install/installing-windows-powershell?view=powershell-7 
    https://www.microsoft.com/en-us/download/details.aspx?id=54616

## Самостоятельная проверка
    Для самостоятельной проверки входных знаний можно использовать скрипт SelfVerification.ps1
    Уровень вопросов от начального до среднего.
    Если тесты показывают уровень ниже 30% (или не получилось запустить SelfVerification.ps1 скрипт) - уровень будет не достаточным. 
    Возможно будет трудно понимать то о чем идет речь.
    Если тесты показывают уровень выше 30% и до 90% - приложу все усилия что-бы вам было интересно или хотя бы полезно :) 
    Если все вопросы простые и финальный результат теста больше 90% - то практикум может быть не интересным

## План практикума
1. Objects: how could be created, modified,  
2. Loops
   1. Differences between Foreach and Foreach-Object
   2. For
   3. do\until
   4. while
   5. break\continue\next\out : out
3. Remote command execution (winrm)
   1. PSRemoting configuration
   2. Invoke-Command
   3. Enter-PSSession\New-PSSession\Remove-PSSession
4. Regular expressions, search, replace and text analyze 
   1. Select-String
   2. match
   3. replace
   4. class: \[regex\]
5. Optimization and best practices
