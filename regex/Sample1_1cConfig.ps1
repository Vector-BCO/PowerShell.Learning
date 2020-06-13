$dbfn = ''
$srv = ''
$db = ''
Get-Content $PSScriptRoot\1c.config -Encoding UTF8  | foreach { 
    
    if ($_ -match '(?''dbFriendlyName''^\[.+\]$)'){
        $dbfn = $Matches['dbFriendlyName']
    }
    if ($_ -match 'Connect=Srvr="(?''Srv''[^"]+)";Ref="(?''db''[^"]+)";'){
        $srv = $Matches['srv']
        $db = $Matches['DB']
    }
    if ($db -and $dbfn -and $srv){
        [pscustomobject]@{
            DBFriendlyName = $dbfn
            ServerName = $srv
            DBName = $db
        }
        $dbfn = ''
        $srv = ''
        $db = ''
    }
}