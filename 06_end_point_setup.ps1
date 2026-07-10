# =================================================================================================================
# Endpoint point setup script v.1
# =================================================================================================================

Write-Host "Starting workstation configuration..." -ForegroundColor Cyan

# ============================================
# VARIABLES
# ============================================

$Date = Get-Date -Format "yyyy-MM-dd_HH-mm"
$ReportPath = ".\reports"
$FileServer = "fileserver.company.local"

# Create reports folder
if (!(Test-Path $ReportPath)) {
    New-Item -ItemType Directory -Path $ReportPath
}

# ============================================
# NETWORK TESTS
# ============================================

Write-Host "`n[1] Testing network connectivity..." -ForegroundColor Yellow

$Targets = @(
    "8.8.8.8",
    "google.com",
    $FileServer
)

$NetworkResults = foreach ($Target in $Targets) {

    $Result = Test-Connection `
        -ComputerName $Target `
        -Count 1 `
        -Quiet

    if ($Result) {
        Write-Host "[OK] Connection to $Target successful" -ForegroundColor Green
    }
    else {
        Write-Host "[FAIL] Cannot reach $Target" -ForegroundColor Red
    }

    [PSCustomObject]@{
        Target = $Target
        Reachable = $Result
        Timestamp = Get-Date
    }
}

$NetworkResults | Export-Csv `
    "$ReportPath\NetworkTests_$Date.csv" `
    -NoTypeInformation `
    -Encoding UTF8

# ============================================
# MAP NETWORK DRIVES
# ============================================

Write-Host "`n[2] Mapping network drives..." -ForegroundColor Yellow

$Drives = @(
    @{Letter="H";Path="\\fileserver\home"},
    @{Letter="S";Path="\\fileserver\shared"},
    @{Letter="P";Path="\\fileserver\projects"}
)

$DriveResults = foreach ($Drive in $Drives) {

    try {

        New-PSDrive `
            -Name $Drive.Letter `
            -PSProvider FileSystem `
            -Root $Drive.Path `
            -Persist `
            -ErrorAction Stop

        Write-Host "[OK] Drive $($Drive.Letter): mapped" -ForegroundColor Green

        [PSCustomObject]@{
            DriveLetter = $Drive.Letter
            Path = $Drive.Path
            Status = "Mapped"
            Timestamp = Get-Date
        }
    }
    catch {

        Write-Host "[FAIL] Could not map $($Drive.Letter):" -ForegroundColor Red

        [PSCustomObject]@{
            DriveLetter = $Drive.Letter
            Path = $Drive.Path
            Status = "Failed"
            Timestamp = Get-Date
        }
    }
}

$DriveResults | Export-Csv `
    "$ReportPath\MappedDrives_$Date.csv" `
    -NoTypeInformation `
    -Encoding UTF8

# ============================================
# CHECK BITLOCKER
# ============================================

Write-Host "`n[3] Checking BitLocker..." -ForegroundColor Yellow

$Bitlocker = Get-BitLockerVolume -MountPoint "C:"

$BitlockerInfo = [PSCustomObject]@{
    MountPoint = $Bitlocker.MountPoint
    VolumeStatus = $Bitlocker.VolumeStatus
    ProtectionStatus = $Bitlocker.ProtectionStatus
    Timestamp = Get-Date
}

$BitlockerInfo | Export-Csv `
    "$ReportPath\BitLockerStatus_$Date.csv" `
    -NoTypeInformation `
    -Encoding UTF8

Write-Host "BitLocker Status: $($Bitlocker.VolumeStatus)"

# ============================================
# FIREWALL STATUS
# ============================================

Write-Host "`n[4] Checking Windows Firewall..." -ForegroundColor Yellow

$FirewallStatus = Get-NetFirewallProfile |
Select-Object `
    Name,
    Enabled

$FirewallStatus | Export-Csv `
    "$ReportPath\FirewallStatus_$Date.csv" `
    -NoTypeInformation `
    -Encoding UTF8

$FirewallStatus | Format-Table

# ============================================
# INSTALLED SOFTWARE CHECK
# ============================================

Write-Host "`n[5] Checking required applications..." -ForegroundColor Yellow

$RequiredApps = @(
    "Google Chrome",
    "Microsoft Teams",
    "7-Zip"
)

$InstalledApps = Get-ItemProperty `
HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*,
HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
Select-Object DisplayName

$SoftwareResults = foreach ($App in $RequiredApps) {

    $Installed = $InstalledApps.DisplayName -match $App

    if ($Installed) {
        Write-Host "[OK] $App installed" -ForegroundColor Green
    }
    else {
        Write-Host "[MISSING] $App not installed" -ForegroundColor Red
    }

    [PSCustomObject]@{
        Application = $App
        Installed = $Installed
        Timestamp = Get-Date
    }
}

$SoftwareResults | Export-Csv `
    "$ReportPath\InstalledApps_$Date.csv" `
    -NoTypeInformation `
    -Encoding UTF8

# ============================================
# SYSTEM INFO
# ============================================

Write-Host "`n[6] System Information..." -ForegroundColor Yellow

$SystemInfo = Get-ComputerInfo |
Select-Object `
    CsName,
    WindowsProductName,
    WindowsVersion,
    CsDomain,
    CsUserName

$SystemInfo | Export-Csv `
    "$ReportPath\SystemInfo_$Date.csv" `
    -NoTypeInformation `
    -Encoding UTF8

$SystemInfo | Format-List

# ============================================
# SUMMARY
# ============================================

Write-Host "`nSetup completed." -ForegroundColor Cyan
Write-Host "Reports exported to: $ReportPath" -ForegroundColor Green