$UsersFromCSV = Import-Csv $PSScriptRoot\users.csv
$UsersFromCSV | ForEach-Object {
    $User = $_
    if($User.Email){
        $User.SamAccountName = ($User.Email -split '@')[0]
    } else {
        if ((! [string]::IsNullOrEmpty($User.Firstname)) -and (! [string]::IsNullOrEmpty($User.Lastname))){
            $SamACCountName = (($User.Firstname[0,1] -join '') + '.' + $User.Lastname).ToLower()
        } else {
            # Если мы тут то сразу на верификацию
        }
    }
    $User.SamAccountName = $SamACCountName
    $User.CorpoEmail = "$SamACCountName@ps.learning.com"
    if (-not [string]::IsNullOrEmpty($User.DayOfBirth)){
        $User.Age = [math]::Floor((((Get-Date) - (Get-Date $User.DayOfBirth)).Days / 365))
    }
}