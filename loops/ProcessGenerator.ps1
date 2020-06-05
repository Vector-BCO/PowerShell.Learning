$TmpFile = New-TemporaryFile
$ProcessRunning = $False
1..10 | ForEach-Object {
    if ($ProcessRunning){
        if ([string]::IsNullOrEmpty($Process)){
            $Process = $(Get-CimInstance Win32_Process | Where-Object {$_.CommandLine -match [regex]::Escape($TmpFile)}).ProcessId
        }
        if ([string]::IsNullOrEmpty($Process)){
            Write-Host "Process not running or cannot be identified"
        } else {
            Write-Host "Stopping process" -ForegroundColor Red
            Stop-Process $Process
        }
        $ProcessRunning = $False
    } else {
        Write-Host "Starting process" -ForegroundColor Green
        $Process = Start-Process -FilePath Notepad.exe -ArgumentList $TmpFile -PassThru -WindowStyle Hidden
        $Process = $Process.Id
        $ProcessRunning = $True
    }
    $SleepDelay = $(Get-Random -Minimum 2 -Maximum 10)
    Write-Host "Delay befor next status change: $SleepDelay" -ForegroundColor Yellow
    Start-Sleep -s $SleepDelay
}