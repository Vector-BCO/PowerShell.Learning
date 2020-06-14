$dbfn = ''
$srv = ''
$db = ''
$ConfigContent = Get-Content $PSScriptRoot\1c.config -Encoding UTF8
$DBs = $ConfigContent | ForEach-Object { 
    <#
        (?''dbFriendlyName'' XXX ) - everything that would match with regex placed instead XXX will be saved into $Matches['dbFriendlyName']
        ^ - begin of the string 
        \[ - '[' character
        .+ - one or more of any characters
        \] - ']' character
        $ - end of the string
    #> 
    if ($_ -match '(?''dbFriendlyName''^\[.+\]$)'){
        $dbfn = $Matches['dbFriendlyName']
    }
    <#
        Connect=Srvr=" - char sequence that mean exactly that you see here (nothing more)
        (?''Srv'' XXX ) - same construction as in previous block that will save XXX regex result into $Matches['Srv']
        [^"]+ - one or more characters that not in a set (any char except " char). 
            Example: [^ABC] - any char except A or B or C
                     [^\^] - any char except ^
        ";Ref=" - char sequence that mean exactly that you see here (nothing more)
        (?''db'' XXX ) - known construction described few times
        [^"]+ - known construction described few times
        "; - char sequence that mean exactly that you see here (nothing more)
    #>
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

ForEach ($DB in $DBs) {
    Write-Host "Starting working with $($DB.DBFriendlyName)"
    # '\d+$' - one or more digit char at the end of the string
    if ($DB.ServerName -match '\d+$'){
        $ServerID = [int]($Matches[0])
        if (($ServerID -eq 1) -and ($DB.DBName -match '\d+$')){
            $DBNameID = [int]($Matches[0])
            $ServerName = $DB.ServerName -replace '1','3'
            # '^(.+)$' - full string
            # $1 - saved result for (.+) block
            $DBName = $DB.DBName -replace '^(.+)$','Test_$1' -replace '\d+$',$($DBNameID + 11)
            Write-Host "DB will be reconfigured" -ForegroundColor Yellow
            Write-Host "$($DB.ServerName) => $ServerName" -ForegroundColor Yellow
            Write-Host "$($DB.DBName) => $DBName" -ForegroundColor Yellow
            $ConfigContent = $ConfigContent -replace [regex]::Escape("Connect=Srvr=""$($DB.ServerName)"";Ref=""$($DB.DBName)"""), "Connect=Srvr=""$ServerName"";Ref=""$DBName"""
        }
    }
}
$ConfigContent | Out-File "$PSScriptRoot\New_1c.Config" -Force -Encoding utf8