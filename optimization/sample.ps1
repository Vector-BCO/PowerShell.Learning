# Пример №1 - 1 sec 712 msec
Write-Host "[$(Get-Date)] Минимум операций - считаем от 0 до 1000000"
Measure-Command {
    $iteration = 0
    $NeedToStop = $false
    do {
        if( $iteration -ge 1000000 ){ $NeedToStop = $true }
        $iteration++
    } until ($NeedToStop)
}


# Пример №2 - 11 min 21 sec 590 msec
Write-Host "[$(Get-Date)] Cчитаем от 0 до 1000000 и выводим значение `$iteration в консоль"
Measure-Command {
    $iteration = 0
    $NeedToStop = $false
    do {
        if( $iteration -ge 1000000 ){ $NeedToStop = $true }
        $iteration++
        Write-Host $iteration #[1]
    } until ($NeedToStop)
}


# Пример №3 - XX min XX sec XX msec
Write-Host "[$(Get-Date)] Cчитаем от 0 до 1000000 и дозаписываем результат каждой операции в файл"
Measure-Command {
    $iteration = 0
    $NeedToStop = $false
    $TestFile1 = New-TemporaryFile #[2]
    Write-Host "[DBG] Outputfile path '$TestFile1'"
    do {
        if( $iteration -ge 1000000 ){ $NeedToStop = $true }
        $iteration++
        $iteration | Out-File $TestFile1 -Append #[2]
    } until ($NeedToStop)
}


# Пример №4 - XX min XX sec XX msec
Write-Host "[$(Get-Date)] Значения счетчика считывается из файла, к нему добавляется 1 после чего оно записывается в файл (1м раз)"
Measure-Command {
    $iteration = 0
    $NeedToStop = $false
    $TestFile2 = New-TemporaryFile #[3]
    $iteration | Out-File $TestFile2 #[3]
    Write-Host "[DBG] Outputfile path '$TestFile2'"
    do {
        if( $iteration -ge 1000000 ){ $NeedToStop = $true }
        $iteration = [int](Get-Content $TestFile2) #[3]
        $iteration++
        $iteration | Out-File $TestFile2 #[3]
    } until ($NeedToStop)
}