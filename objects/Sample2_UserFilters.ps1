$OKUsers = Import-Csv "$PSScriptRoot\import_ready.csv"
$AllUsers = Import-Csv "$PSScriptRoot\users.csv"

# Users older than 63 years old
$OKUsers | Where-Object {$_.Age -ge 63}

# % successfully verified users
Write-Host "$($OKUsers.Count * 100 / $AllUsers.Count)% users successfully passed verification"

# Birthday next week
$OKUsers | Where-Object {
    if ($_.DayOfBirth){
        $TmpDate = [datetime]($_.DayOfBirth -replace '\d{4}',(Get-Date).Year)
        ($TmpDate -ge (Get-Date)) -and ($TmpDate -le (Get-Date).AddDays(7))
    }
}

# Birthday next 2 weeks (exclude previous group)
$OKUsers | Where-Object {
    if ($_.DayOfBirth){
        $TmpDate = [datetime]($_.DayOfBirth -replace '\d{4}',(Get-Date).Year)
        ($TmpDate -ge (Get-Date).AddDays(7)) -and ($TmpDate -le (Get-Date).AddDays(14))
    }
}

# Birthday next month (exclude previous groups)
$OKUsers | Where-Object {
    if ($_.DayOfBirth){
        $TmpDate = [datetime]($_.DayOfBirth -replace '\d{4}',(Get-Date).Year)
        ($TmpDate -ge (Get-Date).AddDays(14)) -and ($TmpDate -le (Get-Date).AddMonths(1))
    }
}