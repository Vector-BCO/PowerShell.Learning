$OKUsers = Import-Csv "$PSScriptRoot\import_ready.csv"
$AllUsers = Import-Csv "$PSScriptRoot\users.csv"

# Users older than 63 years old
$OKUsers | Where-Object {$_.Age -ge 63}

# % successfully verified users
Write-Host "$($OKUsers.Count * 100 / $AllUsers.Count)% users successfully passed verification"

# Birthday next week
$OKUsers | Select-Object *, @{n= 'TmpDate'; e={[datetime]($_.DayOfBirth -replace '\d{4}',(Get-Date).Year)}} | Where-Object {($_.TmpDate -ge (Get-Date)) -and ($_.TmpDate -le (Get-Date).AddDays(7))}

# Birthday next 2 weeks (exclude previous group)
$OKUsers | Select-Object *, @{n= 'TmpDate'; e={[datetime]($_.DayOfBirth -replace '\d{4}',(Get-Date).Year)}} | Where-Object {($_.TmpDate -ge (Get-Date).AddDays(7)) -and ($_.TmpDate -le (Get-Date).AddDays(14))}

# Birthday next month (exclude previous groups)
$OKUsers | Select-Object *, @{n= 'TmpDate'; e={[datetime]($_.DayOfBirth -replace '\d{4}',(Get-Date).Year)}} | Where-Object {($_.TmpDate -ge (Get-Date).AddDays(14)) -and ($_.TmpDate -le (Get-Date).AddMonths(1))}