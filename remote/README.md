[К списку тем](https://github.com/Vector-BCO/PowerShell.Learning/wiki)

# Установка ПО на удаленные ПК
Необходимо установить [Notepad++](https://notepad-plus-plus.org/downloads/) на те ПК из списка где он не установлен
Установка должна производиться в [Silent](https://community.notepad-plus-plus.org/topic/17824/how-to-silent-install-npp-7-7-mdt-installation) режиме

После установки должны получить отчет следующего вида:
```PowerShell
ComputerName  PCReady  SoftwareStatus
------------  -------  --------------
PC1              True  PreInstalled
PC2              True  Installed
PC3             False  Unknown
```

# Проверка настроек DNS
На ПК из списка необходимо проверить настройки DNS на всех интерфейсах и заменить адрес 8.8.4.4 на адрес 8.8.8.8 