. .\TP01-MachineDescription\model.ps1

$computerInfo = [WindowsMachine]::new()

$computerInfo.WriteComputerInfo()