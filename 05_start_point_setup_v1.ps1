# ============================================
# Start point setup script v.1
# ============================================

# Report folder
$ReportPath = ".\reports"

# Create report folder if not exists
if (!(Test-Path $ReportPath)) {
    New-Item -ItemType Directory -Path $ReportPath
}

# Current date
$Date = Get-Date -Format "yyyy-MM-dd_HH-mm"

# Computer name
$ComputerName = $env:COMPUTERNAME

# ============================================
# DISK INFORMATION
# ============================================

$DiskReport = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" |
Select-Object `
    @{Name="ComputerName";Expression={$ComputerName}},
    DeviceID,
    VolumeName,
    @{Name="SizeGB";Expression={[math]::Round($_.Size / 1GB, 2)}},
    @{Name="FreeSpaceGB";Expression={[math]::Round($_.FreeSpace / 1GB, 2)}},
    @{Name="UsedSpaceGB";Expression={[math]::Round(($_.Size - $_.FreeSpace) / 1GB, 2)}}

# Export disk report
$DiskReport | Export-Csv `
    -Path "$ReportPath\DiskReport_$ComputerName_$Date.csv" `
    -NoTypeInformation `
    -Encoding UTF8

# ============================================
# INSTALLED APPLICATIONS
# ============================================

$Apps = Get-ItemProperty `
    HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*,
    HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
Where-Object { $_.DisplayName } |
Select-Object `
    @{Name="ComputerName";Expression={$ComputerName}},
    DisplayName,
    DisplayVersion,
    Publisher,
    InstallDate

# Export apps report
$Apps | Export-Csv `
    -Path "$ReportPath\InstalledApps_$ComputerName_$Date.csv" `
    -NoTypeInformation `
    -Encoding UTF8

Write-Host "Reports generated successfully!" -ForegroundColor Green