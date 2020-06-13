$Retry = 0
do {
    $PasswrodMatch = $false
    if ($Retry -gt 0){Write-Host "[Retry: $Retry] " -NoNewline}
    $Passwrod1 = Read-Host -Prompt "Provide password" -AsSecureString
    $Passwrod2 = Read-Host -Prompt "Confirm password" -AsSecureString
    $Passwrod1_Unsecure = (New-Object PSCredential "usr",$Passwrod1).GetNetworkCredential().Password
    $Passwrod2_Unsecure = (New-Object PSCredential "usr",$Passwrod2).GetNetworkCredential().Password
    if ($Passwrod1_Unsecure -eq $Passwrod2_Unsecure){
        Write-Host "Passwords verification succeeded" -ForegroundColor Green
        $PasswrodMatch = $true
    } else {
        Write-Host "Passwords did not match. Please try again..." -ForegroundColor Red
        Start-Sleep -s 1
        Clear-Host
    }
    $Retry++
} Until ($PasswrodMatch -or ($Retry -ge 5))

if (($Retry -ge 5) -and (! $PasswrodMatch)) {
    Write-Host "Password did not match for 5 times. Rerun script if needed, and try again..." -ForegroundColor Red
}