# Example №1 - 1 sec 712 msec
Measure-Command {
    Write-Host "[$(Get-Date)] Minimum operations - iterate from 0 to 1000000" -ForegroundColor Magenta
    $iteration = 0
    $NeedToStop = $false
    do {
        if( $iteration -ge 1000000 ){ $NeedToStop = $true }
        $iteration++
    } until ($NeedToStop)
}


# Example №2 - 11 min 21 sec 590 msec
Measure-Command {
    Write-Host "[$(Get-Date)] Iterate from 0 to 1000000 and return value of `$iteration to the console" -ForegroundColor Magenta
    $iteration = 0
    $NeedToStop = $false
    do {
        if( $iteration -ge 1000000 ){ $NeedToStop = $true }
        $iteration++
        Write-Host $iteration #[1]
    } until ($NeedToStop)
}


# Example №3 - 8 hours 57 min 43 sec 284 msec
Measure-Command {
    Write-Host "[$(Get-Date)] Iterate from 0 to 1000000 and appending each value into the file" -ForegroundColor Magenta
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


# Example №4 - > 130 hours
Measure-Command {
    Write-Host "[$(Get-Date)] Reading value for iteration from the file, iterate value and write it back to the file (1m times)"  -ForegroundColor Magenta
    $iteration = 0
    $NeedToStop = $false
    $TestFile2 = New-TemporaryFile #[3]
    $iteration | Out-File $TestFile2 #[3]
    Write-Host "[DBG] Outputfile path '$TestFile2'"
    do {
        if( $iteration -ge 1000000 ){ $NeedToStop = $true }
        $iteration = [int]((Get-Content $TestFile2)[-1] -replace '\D') #[3]
        $iteration++
        $iteration | Out-File $TestFile2 -Append #[3]
    } until ($NeedToStop)
}