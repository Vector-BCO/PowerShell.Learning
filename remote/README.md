[К списку тем](https://github.com/Vector-BCO/PowerShell.Learning/wiki)

# Установка ПО на удаленные ПК
Необходимо установить [Notepad++](https://notepad-plus-plus.org/downloads/) на те ПК из [списка](./computers.csv) где он не установлен
Установка должна производиться в [Silent](https://community.notepad-plus-plus.org/topic/17824/how-to-silent-install-npp-7-7-mdt-installation) режиме

После установки должны получить отчет следующего вида:
```PowerShell
ComputerName  PCReady  SoftwareStatus
------------  -------  --------------
PC1              True  Installed
PC2              True  Nothing todo
PC3             False  Unknown
```

# Проверка настроек DNS
На ПК из [списка](./computers.csv) необходимо проверить настройки DNS на всех интерфейсах и заменить адрес 8.8.4.4 на адрес 8.8.8.8 

Вывод команды должен быть приблизительно таким
```PowerShell
ComputerName  PCReady  SoftwareStatus
------------  -------  --------------
PC1              True  DNS Modified
PC2              True  Nothing todo
PC3             False  Unknown
```