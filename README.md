# PowerShell Beginner (EN\PL)

## Date and evennt plan
### Part 1 2021.06.29 12:00 - 15:00 Kraków time
    0) Few words about author
    1) Short Powershell introduction
    2) Objects
    3) Loops
### Part 2 2021.06.30 12:00 - 15:00 Kraków time
    1) Remote command execution
    2) Regular expressions
    3*) Optimization and best practices (maybe will be moved to another day)

## Prerequisites for participants  
    Windows OPS 
    Basic understanding:
    - What for PowerShell used (WiKi, YouTube, internet articles)
    - What is cmdlet
    - What is functions
    - What is parameters
    Практика применения в решении рабочих задач - чем больше вопросов будет на момент начала практикума, тем больше получите от мероприятия

## System requirements
    - Windows 10 or Windows Server 2016/2019
    - PowerShell 5.1  - for validation could be used command `$PSVersionTable.PSVersion`
    - Visual Studio Code (recommended)
    
    If for some reason you have older Powershell version, it could be updated with the following links:
    https://docs.microsoft.com/ru-ru/powershell/scripting/windows-powershell/install/installing-windows-powershell?view=powershell-7 
    https://www.microsoft.com/en-us/download/details.aspx?id=54616

## Self verification
    Self Input\Output knowledge check could be done with: `SelfVerification.ps1` (Question level 100 - 200)
    Result description:
    <30% or failed to run SelfVerification.ps1 - material could be hard to understand
    >30% - <90% - will do all possible for not leave you asleep (maybe helpful for you)
    If all questions are easy for you and your result >90% - workshops may be not be interesting for you (contact me for to be a co-organizer)

## Practicum plan
1. Objects: how could be created, modified
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
