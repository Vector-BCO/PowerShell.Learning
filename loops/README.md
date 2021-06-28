[Goto Topics](https://github.com/Vector-BCO/PowerShell.Learning/wiki)

# Re-entry password check
A piece of code required to check the password entered as SecureString by re-prompting for
password. 
If the passwords do not match, request the Password-Confirmation pair again. 
If the pair does not match, re-request the passwords 3 times.

## Пример
```PowerShell
Enter Password: *********
Re-Enter Password: *********
Passwords did not match... Try again

Enter Password: *********
Re-Enter Password: *********
Password verification succeeded
``` 

# Dynamic timeout
## Problem description
It is a common situation when one has to wait for an external process: 
a remote PC reboot, process start or termination, etc.
Just often in such a situation main idea is to add Start-Sleep -s 60, 
but if the script is used often and modified from time to time, then the slip increases 
to 100 seconds, then to 300, 600, etc.

If the script is long enough, then the number of waits exceeds all reasonable limits increase 
the script execution time from seconds to hours

## Process start/stop dynamic wait (wait timeout)
Write a mechanism that will wait until the notepad.exe process starts with a
file located in temporary folder ($env:Temp)

### Code requirements
- Timeout 120 seconds – if the process status remained unchanged after this time – abort execution
- Wait for the process to start; after start – wait for completion, up to a timeout
- Return to console on how much time was spent waiting for the process status change

### Output example:
```powershell
Process Notepad.exe started after 13 seconds delay
Process Notepad.exe stopped after 106 seconds delay
Process Notepad.exe started after 25 seconds delay
Process Notepad.exe stopped after 8 seconds delay
Process Notepad.exe not started in 120 seconds
Script finished
```

### Verification
Execute your script
In the separate PowerShell console start ProcessGenerator.ps1