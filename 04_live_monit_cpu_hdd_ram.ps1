# Utworzenie nagłówka CSV jeśli plik nie istnieje
if (!(Test-Path "monitor.csv")) {
    "Time,CPU,RAM_Used_GB,Disk_Free_GB" | Out-File monitor.csv
}

while ($true) {

    # Aktualny czas
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # CPU
    $cpu = (Get-CimInstance Win32_Processor).LoadPercentage

    # RAM
    $ram = Get-CimInstance Win32_OperatingSystem

    $totalRam = [math]::Round($ram.TotalVisibleMemorySize / 1MB, 2)
    $freeRam  = [math]::Round($ram.FreePhysicalMemory / 1MB, 2)

    $usedRam = [math]::Round($totalRam - $freeRam, 2)

    # Dysk
    $disk = Get-PSDrive C
    $freeDisk = [math]::Round($disk.Free / 1GB, 2)

    # Konsola
    Write-Host "$time CPU: $cpu% | RAM: ${usedRam}GB/${totalRam}GB | Free Disk C: ${freeDisk}GB"

    # CSV
    "$time,$cpu,$usedRam,$freeDisk" | Add-Content monitor.csv

    Start-Sleep -Seconds 2
}