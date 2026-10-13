class WindowsMachine {
    [string]$name
    [string]$version
    [string]$cpuName
    [uint]$coreNumber
    [uint]$ram
    [uint]$diskSize
    [uint]$diskFreeSpace

    WindowsMachine() {
        $this.name = $env:COMPUTERNAME
        $this.version = (Get-ComputerInfo).WindowsProductName

        try {
            $cimInstance =  Get-CimInstance Win32_Processor
            $this.cpuName = $cimInstance.Name
            $this.coreNumber = $cimInstance.NumberOfCores
            if($this.coreNumber -le 0) {
                throw "Invalid core number"
            }
        }
        catch {
            Write-Error "Error! Impossible to get CPU information"
        }

        try {
            $ramInstance = Get-CimInstance Win32_PhysicalMemory
            $this.ram = [Math]::Round((($ramInstance | Measure-Object Capacity -Sum).Sum) / 1GB, 2)
            
        }
        catch {
            Write-Error "Error! Impossible to get RAM information"
        }  

        try {
            $diskInstance = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"
            $diskInfo = @(($diskInstance | Measure-Object -Property Size -Sum).Sum, ($diskInstance | Measure-Object -Property FreeSpace -Sum).Sum)
            $this.diskSize = [Math]::Round($diskInfo[0]/ 1GB, 2)
            $this.diskFreeSpace = [Math]::Round($diskInfo[1]/ 1GB, 2)
        }
        catch {
            Write-Error "Error! Impossible to get disk information"
        }
    }

    WriteComputerInfo() {
        Write-Host "=== Machine Summary ==="

        Write-Output "Computer Name : $($this.name)"
        Write-Output "Windows       : $($this.version)" 
        Write-Output "CPU           : $($this.cpuName)" 
        Write-Output "Cores         : $($this.coreNumber)" 
        Write-Output "RAM           : $($this.ram)" 
        Write-Output "Disk Total    : $($this.diskSize)" 
        Write-Output "Disk Free     : $($this.diskFreeSpace)" 
    }
}

