$timeout = 120
$StatusRunning = $false
$prevStaus = $false
$i = 0
do {
    $i++
    Start-Sleep -s 1
    $Proc = (Get-CimInstance Win32_Process | Where-Object {$_.Name -eq 'Notepad.exe' -and $_.CommandLine -match [regex]::Escape($Env:Temp)}).ProcessId
    if ($Proc){
        $StatusRunning = $true
        if ($prevStaus -ne $true){
            $prevStaus = $true
            Write-Host "[$i] Process $Proc started" -ForegroundColor Green
            $i = 0
        }
    } else {
        if ($prevStaus -ne $false){
            $prevStaus = $false
            Write-Host "[$i] Process $Proc stopped" -ForegroundColor Red
            $i = 0
        }
    }
} until ($i -ge $timeout)