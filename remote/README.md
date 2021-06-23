[Goto Topics](https://github.com/Vector-BCO/PowerShell.Learning/wiki)

# Task 1: Software installation
1 [Notepad++](https://notepad-plus-plus.org/downloads/) should be installed onto Computers from the [list](./computers.csv) where not installed yet.

2 Install process should be performed in [Silent](https://community.notepad-plus-plus.org/topic/17824/how-to-silent-install-npp-7-7-mdt-installation) mode.

3 Report should be received (like below):
```PowerShell
ComputerName  PCReady  SoftwareStatus
------------  -------  --------------
PC1              True  Installed
PC2              True  Nothing todo
PC3             False  Unknown
```

# Task 2: DNS settings verification
1 Verify DNS settings for all interfaces on each Computer from the [list](./computers.csv) and change '8.8.4.4' DNS record to new one '8.8.8.8'

2 Report should be received (like below):
```PowerShell
ComputerName  PCReady  SoftwareStatus
------------  -------  --------------
PC1              True  DNS Modified
PC2              True  Nothing todo
PC3             False  Unknown
```