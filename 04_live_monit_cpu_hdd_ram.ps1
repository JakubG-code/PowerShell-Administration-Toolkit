# Create the CSV file with a header if it does not exist.
if (!(Test-Path "monitor.csv")) {
    "Time,CPU,RAM_Used_GB,Disk_Free_GB" | Out-File monitor.csv
}

while ($true) {

    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $cpu = (Get-CimInstance Win32_Processor).LoadPercentage

    $ram = Get-CimInstance Win32_OperatingSystem

    $totalRam = [math]::Round($ram.TotalVisibleMemorySize / 1MB, 2)
    $freeRam  = [math]::Round($ram.FreePhysicalMemory / 1MB, 2)

    $usedRam = [math]::Round($totalRam - $freeRam, 2)

    $disk = Get-PSDrive C
    $freeDisk = [math]::Round($disk.Free / 1GB, 2)

    Write-Host "$time CPU: $cpu% | RAM: ${usedRam}GB/${totalRam}GB | Free Disk C: ${freeDisk}GB"

    "$time,$cpu,$usedRam,$freeDisk" | Add-Content monitor.csv

    Start-Sleep -Seconds 2
}