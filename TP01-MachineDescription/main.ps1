# ================================================================
# Script : Machine Description
# ================================================================

# Get computer name
[string]$computerName = $env:computerName
# Get Windows version
[string]$windowsVersion = Get-ComputerInfo WindowsProductName
# Get information model
$cimInstance = Get-CimInstance Win32_Processor
# Get CPU name
$cpu = $cimInstance.Name
# Get the computer core number
$coreNumber = $cimInstance.NumberOfCores
# Get Random Access Memory
$ramInstance = Get-CimInstance Win32_PhysicalMemory
$ramCapacity = [int]($ramInstance.Capacity / [Math]::Pow(10, 9)) 
# Get disk space information
$diskInstance = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"
$diskInfo = @(($diskInstance | Measure-Object -Property Size -Sum), ($diskInstance | Measure-Object -Property FreeSpace -Sum))
$diskSize = [uint]($diskInfo[0].Sum / [Math]::Pow(10, 9))
$diskFreeSpace = [uint]($diskInfo[1].Sum / [Math]::Pow(10, 9))


$computerInfo = [PSCustomObject]@{
    ComputerName = $computerName
    WindowsVersion = $windowsVersion
    CpuName = $cpu
    CoreNumber = $coreNumber
    RamCapacity = $ramCapacity
    DiskTotal = $diskSize
    DiskFree = $diskFreeSpace
}

function DisplayComputerInfo {
    Write-Host "=== Machine Summary ==="

    Write-Output "Computer Name : " $ComputerInfo.ComputerName
    Write-Output "Windows       : " $ComputerInfo.WindowsVersion
    Write-Output "CPU           : " $ComputerInfo.CpuName
    Write-Output "Cores         : " $ComputerInfo.CoreNumber
    Write-Output "RAM           : " $ComputerInfo.RamCapacity " Go"
    Write-Output "Disk Total    : " $ComputerInfo.DiskTotal " Go"
    Write-Output "Disk Free     : " $ComputerInfo.DiskTotal " Go"
}

DisplayComputerInfo

