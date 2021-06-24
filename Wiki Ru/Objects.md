[К списку тем](https://github.com/Vector-BCO/PowerShell.Learning/wiki)

# Объект в PowerShell
## Определение
[Wiki](https://ru.wikipedia.org/wiki/%D0%9E%D0%B1%D1%8A%D0%B5%D0%BA%D1%82_(%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5)): Объект — некоторая сущность в цифровом пространстве, обладающая определённым состоянием и поведением, имеющая определенные свойства (атрибуты) и операции над ними (методы). 

## Методы создания

### Получение объекта или списка объектов как результат выполнения cmdlet\функции\скрипта
```PowerShell
# $Service будет содержать первый объект(сервис по имени) 
$Service = Get-Service | Select-Object -First 1 

# $Services содержать список (array) объектов
$Services = Get-Service | Where-Object {$_.Status -eq 'Running'}
```

### Создание копии объекта и его модификация
```PowerShell
$Service = Get-Service | Select-Object Name, ServiceName, StartupType, BinaryPathName -First 1
$Service_Copy = $Service | Select-Object Name, ServiceName, @{N="StartupType";E={"JustMagic"}}, BinaryPathName

# При сравнении 2х объектов сохраненных в $Service и $Service_Copy можно увидеть что они отличаются в одном параметре но совпадают в 3х других
Compare-Object -ReferenceObject $Service -DifferenceObject $Service_Copy -Property Name, ServiceName, StartupType, BinaryPathName
```

### Создание объекта
```PowerShell
# New-Object\Add-Member - Дорого-богато (Много вариантов конфигурации параметров)
$Object_1 = New-Object -TypeName PSObject
$Object_1 | Add-Member -MemberType NoteProperty -Name Name -Value "TestObject" -Force
$Object_1 | Add-Member -MemberType AliasProperty -Name RefName -Value Name -Force
$Object_1 | Add-Member -MemberType NoteProperty -Name Description -Value "Some Description" -Force
$Object_1 | Add-Member -MemberType NoteProperty -Name StartupType -Value "JustMagic" -Force

# Хеш таблица - быстро и удобно 
$Object_2 = [PsCustomObject]@{ Name = "TestObject"; RefName = "TestObject"; Description = "Some Other Description"; StartupType = "JustMagic" }

# При сравнении 2х объектов сохраненных в $Service и $Service_Copy можно увидеть что они отличаются в одном параметре но совпадают в 3х других
Compare-Object -ReferenceObject $Object_1 -DifferenceObject $Object_2 -Property Name, RefName, Description, StartupType

# Создание объекта при помощи Select-Object 
$Bike = "" | Select-Object @{N="Name"; E={"Bike"}}, @{N="Producent"; E={"Yamaha"}}, @{N="Model"; E={"YZF-R1"}}, @{N="Color"; E={"Krasnenkiy"}}
```

### Просмотр параметров и методов объектов
```PowerShell
# Get-Member показывает свойства всех *уникальных* объектов если их более одного
# Если типы всех объектов идентичны, Get-Member покажет всего 1 набор параметров и методов
$Services = Get-Service
$Services.Count
$Services | Get-Member

# Если типы объектов перемешаны (более одного), Get-Member покажет 2 или более наборов параметров и методов
$DifferentObjArray = @()
$DifferentObjArray += $Services
$DifferentObjArray += (Get-Process)
$DifferentObjArray.Count
$DifferentObjArray | Get-Member

# Если название параметра не известно, то можно использовать Format-List * и поиск названия параметра по его значению
# Выбираем 1 объект из списка и проверяем 
$Services | Select -First 1 | Format-List *
```

### Просмотр типа объекта
Помимо Get-Member тип объекта можно проверить при помощи метода GetType()
Важно понимать что GetType() в отличии от Get-Member покажет не только класс объекта в массиве, но и то что мы проверяем непосредственно массив
```PowerShell
# Типы будут различаться
($Services) | Get-Member
($Services).GetType()

# Типы будут совпадать
($Services | Select -First 1) | Get-Member
($Services | Select -First 1).GetType()
```