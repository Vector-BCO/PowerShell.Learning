[К списку тем](https://github.com/Vector-BCO/PowerShell.Learning/wiki)

# Ссылки и книги
## Базовая справка
[Help about_regular_expressions](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-7)

## Занимательное чтиво 
[Jeffrey E.F. Friedl "Mastering Regular Expressions" \[O'Reilly\]](https://www.oreilly.com/library/view/mastering-regular-expressions/0596528124/)

Существует несколько вариантов переводов в том числе англоязычный и русскоязычный

## Доступно и довольно полно расписанная статья по использованию регулярных выражений в PowerShell
[Блог Kevin Marquette](https://powershellexplained.com/2017-07-31-Powershell-regex-regular-expression/)

## Онлайн конструктор и валидатор регулярных выражений
[regex101](https://regex101.com/)

## База готовых регулярных выражений
[regexlib](http://regexlib.com/)

# Коммандлеты, операторы сравнения, класс [regex], переменная 
## Select-String -Pattern 'Exp1'
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/select-string?view=powershell-7

## -match -replace -split и -cmatch -creplace -csplit 
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-5.1

## Класс [regex]
https://docs.microsoft.com/en-us/dotnet/api/system.text.regularexpressions.regex?view=netcore-3.1

## Методы "String": .Match(), .Split(), .Replace()
```PowerShell
"" | Get-Member
```