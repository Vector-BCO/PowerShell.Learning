[Goto Topics](https://github.com/Vector-BCO/PowerShell.Learning/wiki)

# User check prior AD import
Check the required parameters in users list from users.csv,
fill in missing parameters and then upload users into 2 new files:
  - import_ready.csv 
  - validation_required.csv

## Required parameters and generation rules
Mandatory parameters highlighted in bold
  - ***FirstName*** - should not be empty if LastName not provided. At least one of two values should be provided.
  - ***LastName*** - should not be empty if FirstName not provided. At least one of two values should be provided.
  - DayOfBirth 
  - Department
  - Position
  - Phone
  - AdditionalPhone
  - Email
  - Age - if DayOfBirth is not empty, calculate the user’s full years of age
  - **CorpoEmail** - parameter generated via merging SamAccountName with @ps.learning.com corporate domain
  - **SamAccountName** - if Email field is not empty, generate parameter using part before "@" symbol. 
    If Email field is empty, generate parameter using Firstname (first 2 characters) and Lastname, separated with "."
  
At least 4 parameters out of 7 optional DayOfBirth, Department, Position, Phone, AdditionalPhone, Email, Age, should  be filled in for the user to get into import_ready.csv file.


# Output analysis
  - Find employees of about to retiring age (63+)
  - Calculate proportion of users that passed the check and included into import_ready.csv
  - Find employees with a birthday date on next week, in 2 weeks, within a month (3 groups)