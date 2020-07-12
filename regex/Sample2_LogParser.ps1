$LogPath = "$PSScriptRoot\LongRead.log"
$LogContent = Get-Content $LogPath
$LogContentParsed = $LogContent | ForEach-Object {
    if ($_ -match '(?''DateTime''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}Z) : User ''(?''UserName''[^'']+)'' from (?''IP''(\d{1,3}\.){3}\d{1,3}) (?''Status''\w+)'){
        [pscustomobject]@{
            DateTime = [datetime]$Matches.DateTime
            UserName = $Matches.UserName
            Status = $Matches.Status
            IP = $Matches.IP
        }
    }
}

$LogContentParsed | Group-Object UserName | ForEach-Object {
    $TotalWorkingTime = 0
    $_.Group | Where-Object {$_.IP -match '10\.10(1|2)\.2\.\d+'} | Sort-Object DateTime | ForEach-Object {
        if ($_.Status -eq 'connected'){
            $StartTime = $_.DateTime
        } else {
            $TotalWorkingTime += $_.DateTime - $StartTime
        }
    }
    [PSCustomObject]@{
        Username = $_.Name
        TotalWorkingDays = [math]::Round(($TotalWorkingTime.TotalHours / 8), 2)
    }
}