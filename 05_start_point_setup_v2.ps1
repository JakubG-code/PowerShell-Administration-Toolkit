# ============================================
# Start point setup script v.2
# ============================================

$ReportPath = ".\reports"

if (!(Test-Path $ReportPath)) {
    New-Item -ItemType Directory -Path $ReportPath | Out-Null
}

$Date = Get-Date -Format "yyyy-MM-dd_HH-mm"
$ComputerName = $env:COMPUTERNAME

# ============================================
# DISK INFORMATION
# ============================================

$DiskReport = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
    [PSCustomObject]@{
        ComputerName  = $ComputerName
        DeviceID      = $_.DeviceID
        VolumeName    = $_.VolumeName
        SizeGB        = [math]::Round($_.Size / 1GB, 2)
        FreeSpaceGB   = [math]::Round($_.FreeSpace / 1GB, 2)
        UsedSpaceGB   = [math]::Round(($_.Size - $_.FreeSpace) / 1GB, 2)
    }
}

$DiskReport | Export-Csv -Path "$ReportPath\DiskReport_$ComputerName_$Date.csv" -NoTypeInformation -Encoding UTF8

# ============================================
# SYSTEM INFORMATION (PC / RAM / OS / BIOS)
# ============================================

$System = Get-WmiObject Win32_ComputerSystem
$OS     = Get-WmiObject Win32_OperatingSystem
$BIOS   = Get-WmiObject Win32_BIOS
$CPU    = Get-WmiObject Win32_Processor

$SystemInfo = [PSCustomObject]@{
    ComputerName   = $ComputerName
    Manufacturer   = $System.Manufacturer
    Model          = $System.Model
    TotalRAM_GB    = [math]::Round($System.TotalPhysicalMemory / 1GB, 2)
    CPU            = $CPU.Name
    CPU_Cores      = $CPU.NumberOfCores
    CPU_Threads    = $CPU.NumberOfLogicalProcessors
    OS             = $OS.Caption
    OS_Version     = $OS.Version
    BuildNumber    = $OS.BuildNumber
    SerialNumber   = $BIOS.SerialNumber
    BIOSVersion    = $BIOS.SMBIOSBIOSVersion
}

$SystemInfo | Export-Csv -Path "$ReportPath\SystemInfo_$ComputerName_$Date.csv" -NoTypeInformation -Encoding UTF8

# ============================================
# NETWORK INFORMATION
# ============================================

$Network = Get-WmiObject Win32_NetworkAdapterConfiguration |
Where-Object { $_.IPEnabled -eq $true } |
ForEach-Object {
    [PSCustomObject]@{
        ComputerName = $ComputerName
        Description  = $_.Description
        MACAddress   = $_.MACAddress
        IPAddress    = ($_.IPAddress -join ", ")
        Subnet       = ($_.IPSubnet -join ", ")
        Gateway      = ($_.DefaultIPGateway -join ", ")
        DHCPEnabled  = $_.DHCPEnabled
        DNSServers   = ($_.DNSServerSearchOrder -join ", ")
    }
}

$Network | Export-Csv -Path "$ReportPath\Network_$ComputerName_$Date.csv" -NoTypeInformation -Encoding UTF8

# ============================================
# INSTALLED APPLICATIONS
# ============================================

$Apps = Get-WmiObject -Class Win32_Product -ErrorAction SilentlyContinue |
ForEach-Object {
    [PSCustomObject]@{
        ComputerName   = $ComputerName
        Name           = $_.Name
        Version        = $_.Version
        Vendor         = $_.Vendor
    }
}

$Apps | Export-Csv -Path "$ReportPath\InstalledApps_$ComputerName_$Date.csv" -NoTypeInformation -Encoding UTF8

# ============================================
# SUMMARY
# ============================================

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "Audit completed successfully"
Write-Host "Computer: $ComputerName"
Write-Host "Disk entries: $($DiskReport.Count)"
Write-Host "Apps: $($Apps.Count)"
Write-Host "Reports: $ReportPath"
Write-Host "===================================" -ForegroundColor Cyan