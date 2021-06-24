[К списку тем](https://github.com/Vector-BCO/PowerShell.Learning/wiki)

# Циклы
[Wiki](https://ru.wikipedia.org/wiki/%D0%A6%D0%B8%D0%BA%D0%BB_(%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5)) Цикл - многократно исполняемая последовательность инструкций

    + Удобная конструкция перебора объектов или свойств по одному за итерацию
    + Удобная конструкция повторения блоков кода, функций итд.

    - Ресурсоемкая функциональность
    - Простота допустить ошибку с вложенностью и количеством элементов что может привести к ухудшению производительности
    - Возможность создать вечную петлю ("зависание" скрипта)

Справка по командам в PowerShell:
- [get-help about_Do](https://docs.microsoft.com/ru-ru/PowerShell/module/microsoft.powershell.core/about/about_do?view=powershell-5.1)
- [get-help about_For](https://docs.microsoft.com/en-us/PowerShell/module/microsoft.PowerShell.core/about/about_for?view=powershell-5.1)
- [get-help about_While](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_while?view=powershell-5.1)
- [get-help about_Foreach](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_foreach?view=powershell-5.1)

    **Foreach -Parrallel в PowerShell 5 (Workflows)**
- [Get-Help about_Foreach-Parrallel](https://docs.microsoft.com/en-us/powershell/module/psworkflow/about/about_foreach-parallel?view=powershell-5.1)

    **Foreach-Parrallel для PowerShell \< 7 версии**
- [Bonus Script](https://gallery.technet.microsoft.com/scriptcenter/Foreach-Parallel-Parallel-a8f3d22b)

    **Foreach -Parrallel в PowerShell 7**
- [Foreach-Object -Parallel](https://devblogs.microsoft.com/powershell/powershell-foreach-object-parallel-feature/)

- [get-help about_Break](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_break?view=powershell-5.1)
- [get-help about_Continue](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_continue?view=powershell-5.1)

# Случаи использования разных типов циклов
### Do { \<Code\> } Until ( \<Statement\> )
    Пока <Statement> не будет правдиво <Code> будет выполняться
    При любом <Statement>, <Code> выполниться минимум 1 раз.
#### Пример
```PowerShell
$i = 1
Do {
    $i
    $i++
} Until ( $i -ge 5 )
```

### For ( \<OnceBeginConfig\> ; \<Statement\> ; \<EachIterationCodeBlock\> ) { \<Code\> }
    Традиционный механизм позволяющий повторить часть кода несколько раз до тех пор пока <Statement> будет равно $True
    Полные аналоги есть во многих языках.
#### Пример №1 (традиционный)
```PowerShell
For ( $i = 1 ; $i -le 5 ; $i++ ) { $i }
```
#### Пример №2 (нетрадиционный)
```PowerShell
For ($i = $k = 1 ; $i -le 5; write-host "k : $k") { 
    $i
    $i++
    $k = $i
}
```

### While ( \<Statement\> ) { \<Code\> }
    Если <Statement> равно $True - код будет выполняться
    В отличии от Do\Until если <Statement> будет $False код внутри цикла не выполнится ни разу
#### Пример
```PowerShell
$i = 1
While($i -le 5){
    $i
    $i++
}
```

### PowerShell 5 Foreach-Object
Различаются 2 конструкции Foreach и Foreach-Object, где в некоторых случаях Foreach является алиасом Foreach-Object,
а в некоторых случая эти конструкции разняться по принципу работы. В примере 1 и примере 2 могут быть использованы как
Foreach-Object, так и алиас Foreach.
В примере 3 Foreach-Object использоваться не может.

#### Пример №1 Передача объектов через пайп
```PowerShell
1..5 | Foreach-Object { $_ }
```
#### Пример №2 Аналог примера №1 без пайпа
```PowerShell
ForEach-Object -InputObject @(1..5) -Process { $_ }
```
#### Пример №3 Перебор элементов в предопределенной (не автоматической) переменной
```PowerShell
ForEach($i in @(1..10)) { Test-Connection -Quiet "172.28.110.$i" -Count 1 }
```

### PowerShell 7 Foreach-Object -Parallel
Все утверждения для PowerShell 5 справедливо кроме Workflow который в 7 версии обозначен как Deprecated
В свою очередь Foreach-Object -Parallel в PoSh7 работает без дополнительных оберток (из коробки)

#### Пример
```PowerShell
1..10 | ForEach-Object -Parallel { Test-Connection -Quiet "172.28.110.$_" -Count 1 }
```

## Управляющие команды
В рамках цикла можно производить управление операциями, такое как завершение цикла или пропуск одной итерации

### Continue

#### Пример №1
В этом примере в выводе будет пропущена каждая комбинация в которой j будет равна 7
Аналогичным образом будет работать do\until, for и while 
```PowerShell
Foreach($i in @(1..5)) {
    Foreach($j in @(9..5)) {
        if ($j -eq 7){continue}
        Write-Host "i = $i || j = $j"
    }
}
```
#### Пример №2
В этом примере команда будет сильно отличаться от предыдущей так как полностью завершится когда j будет равна 7
```PowerShell
1..5 | Foreach {
    $i = $_
    9..5 | Foreach {
        $j = $_
        if ($j -eq 7){continue}
        Write-Host "i = $i || j = $j"
    }
}
```

### Break
#### Пример №1
Будет прервана обработка вложенного foreach в случае если j будет равна 7
Аналогичным образом будет работать do\until, for и while 

```PowerShell
Foreach($i in @(1..5)) {
    Foreach($j in @(9..5)) {
        if ($j -eq 7){break}
        Write-Host "i = $i || j = $j"
    }
}

# Вывод будет следующим
i = 1 || j = 9
i = 1 || j = 8
i = 2 || j = 9
i = 2 || j = 8
i = 3 || j = 9
i = 3 || j = 8
i = 4 || j = 9
i = 4 || j = 8
i = 5 || j = 9
i = 5 || j = 8
```
#### Пример №2
Будет работать аналогично примеру с continue (Пример №2)
```PowerShell
1..5 | Foreach {
    $i = $_
    9..5 | Foreach {
        $j = $_
        if ($j -eq 7){break}
        Write-Host "i = $i || j = $j"
    }
}
```
#### Пример №3
При соблюдении условия (j == 7), будет произведен выход в тегированную точку
Таким образом можно выйти из нескольких (выбранных) циклов
Аналогичным образом будет работать do\until, for и while 

```PowerShell
:quit Foreach($i in @(1..5)) {
    Foreach($j in @(9..5)) {
        if ($j -eq 7){break quit}
        Write-Host "i = $i || j = $j"
    }
}
```