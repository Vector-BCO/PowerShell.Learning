# Output files
$UsersValidationRequired = "$PSScriptRoot\validation_required.csv"
$OKUsers = "$PSScriptRoot\import_ready.csv"
# Remove output files if scritp will be executed few times
Remove-Item $UsersValidationRequired, $OKUsers -ErrorAction SilentlyContinue -Force

# Property groups for verification
$MandatoryProperties = @("CorpoEmail","SamAccountName")
$HalfMandatooryProperties = @("Firstname", "Lastname")
$OptionalProperties = @("DayOfBirth","Department","Position","Phone","AdditionalPhone","Email","Age")

$UsersFromCSV = Import-Csv $PSScriptRoot\users.csv
$UsersFromCSV | ForEach-Object {
    # $User would conatain each user element from the array
    $User = $_
    # Getting SamAccountName
    if(! [string]::IsNullOrEmpty($User.Email)){
        # Based On Email if it`s not empty string
        $User.SamAccountName = ($User.Email -split '@')[0]
    } else {
        # Based on FirstName and Lastname if both parameters not empty
        if ((! [string]::IsNullOrEmpty($User.Firstname)) -and (! [string]::IsNullOrEmpty($User.Lastname))){
            $User.SamAccountName = (($User.Firstname[0,1] -join '') + '.' + $User.Lastname).ToLower()
        }
    }
    # If $User.SamAccountName is not an empty string - fill down corpo email
    if (! [string]::IsNullOrEmpty($User.SamAccountName)){
        $User.CorpoEmail = "$($User.SamAccountName)@ps.learning.com"
    }

    # If $User.DayOfBirth not empty we can count full age
    if (-not [string]::IsNullOrEmpty($User.DayOfBirth)){
        $User.Age = [math]::Floor((((Get-Date) - (Get-Date $User.DayOfBirth)).Days / 365))
    }
    # Construction will return $True if values of all mandatory parameters will not be empty strings
    $MandatoryCriteria = (
        ($User.PSObject.Properties | Where-Object {$_.Name -in $MandatoryProperties}).Value | ForEach-Object `
            -Begin {$i = 0} `
            -Process {if(! [string]::IsNullOrEmpty($_)){$i++}} `
            -End {$i}
    ) -eq $MandatoryProperties.Count
    # Construction will return $True if values of all values from "half mandatory" parameters count will be >= 1
    $HalfMandatoryCriteria = (
        ($User.PSObject.Properties | Where-Object {$_.Name -in $HalfMandatooryProperties}).Value | ForEach-Object `
        -Begin {$i = 0} `
        -Process {if(! [string]::IsNullOrEmpty($_)){$i++}} `
        -End {$i}
    ) -ge 1
    # Construction will return $True if values of all values from optional parameters count will be >= 4
    $OptionalCriteria = (
        ($User.PSObject.Properties | Where-Object {$_.Name -in $OptionalProperties}).Value | ForEach-Object `
        -Begin {$i = 0} `
        -Process {if(! [string]::IsNullOrEmpty($_)){$i++}} `
        -End {$i}
    ) -ge 4

    # If all criteria will be true then export user to import_ready.csv
    if($MandatoryCriteria -and $HalfMandatoryCriteria -and $OptionalCriteria){
        $User | Export-Csv -Path $OKUsers -Append
    } else {
    # If at leat one criteria is not true then export user to validation_required.csv
        $User | Export-Csv -Path $UsersValidationRequired -Append
    }
}