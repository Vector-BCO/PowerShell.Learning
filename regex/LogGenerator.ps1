$DateTimeArray = @(0..3 | foreach {Get-Date "2020.01.01 12:00:00"})
$UsersArray = @("UserA","UserB","UserC","UserD")
$login = $true
$IPs = [string[]]@(0..3)
$Log = foreach ($i in @(1..100)){
    foreach($j in @(0..3)){
        $DateTimeArray[$j] =$DateTimeArray[$j].AddHours($(Get-Random 24)).AddMinutes($(Get-Random 60)).AddSeconds($(Get-Random 60))
        if ($login){
            $IPAddress = Get-Random -InputObject @('10.101.2.', '10.101.8.', '10.102.2.', '10.102.8.')
            $IPAddress += Get-Random 255
            $IPs[$j] = $IPAddress
        }
        "$($DateTimeArray[$j].GetDateTimeFormats()[-7]) : User '$($UsersArray[$j])' from $($IPs[$j]) $(if($login){'connected'}else{'disconnected'})"
        if ($j -eq 3 -and $login){
            $login = $false
        } elseif($j -eq 3 -and ! $login) {
            $login = $true
        }
    }
}
$Log | Out-File "$PSScriptRoot\LongRead.log"