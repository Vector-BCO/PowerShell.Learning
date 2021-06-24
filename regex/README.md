[Goto Topics](https://github.com/Vector-BCO/PowerShell.Learning/wiki)

# 1C Program Config
## Main goal
Receive all DBFriendlyName, DBName and ServerName and prepare new config file with next requirements:
  - DBFriendlyName stores in square brackets 
    * Example: \[1C Powershell Learning\], \[ExtraImportantDB\]
  - ServerName parameter include exact server  name with index at the end (without spaces, minuses "-" and underscores "_" is allowed)
    * Example: Server1, DB-Server2, 1c_Server3 etc.
  - Database names (DBName) contain exact DB name with 2 digit indexes at the end (without spaces, minuses "-" and underscores "_" is allowed)
    * Example: DB10, 1c_Database12, DataBase-23 etc.

## Requirements for new configuration file
  - DBFriendlyName - no changes required
  - DB layout should not be changed
  - Bases from ServerName with index 1 should be changed to ServerName with index 3
  - For each DB from server with index 1 should be added prefix 'Test_'.
    Example: 1c_Database12 => Test_1c_Database12
  - For each DB index from server with index 1 should be added 11.
    Example: 1c_Database12 => 1c_Database23

## Example
Original fragment:

```conf
[1C Data base ABC]
Connect=Srvr="1СServer1";Ref="DB10";
```

should be transformed to:

```conf
[1C Data base ABC]
Connect=Srvr="1СServer3";Ref="Test_DB21";
```
# Calculate total working time for users from specific subnets
Requirements: For each user connected from from subnets 10.101.2.0/24 and 10.102.2.0/24 should be calculated total working (connected) time,
based on LongRead.log

  * Example:
```log
2020-01-10 03:14:37Z : User 'UserC' from 10.102.2.71 connected
2020-01-10 03:24:37Z : User 'UserC' from 10.102.2.71 disconnected
2020-01-10 04:14:37Z : User 'UserC' from 10.102.2.71 connected
2020-01-10 04:24:37Z : User 'UserC' from 10.102.2.71 disconnected
```
  Output: 
```powershell
Username:                 UserC
Total Working time:       20 minutes
```