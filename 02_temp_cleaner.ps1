# Print messages using optional console colors.
function Log($text, $color = "White") {

    switch ($color) {
        "Green"  { Write-Host $text -ForegroundColor Green }
        "Red"    { Write-Host $text -ForegroundColor Red }
        "Yellow" { Write-Host $text -ForegroundColor Yellow }
        "Cyan"   { Write-Host $text -ForegroundColor Cyan }
        default  { Write-Host $text }
    }
}

function Clean-Folder($path, $displayName) {

    if (!(Test-Path $path)) {
        Log "Folder not found: $displayName" "Red"
        return
    }

    Log "`n--- Cleaning: $displayName ---" "Yellow"

    Get-ChildItem -Path $path -Force -ErrorAction SilentlyContinue | ForEach-Object {

        # Store only the item name, without the full path.
        $itemName = $_.Name

        try {
            Remove-Item $_.FullName -Recurse -Force -ErrorAction Stop
            Log "OK: $itemName" "Green"
        }
        catch {
            Log "ERROR: $itemName" "Red"
        }
    }
}

Write-Host ""
Write-Host "=== TEMP Cleaner ===" -ForegroundColor Cyan
Write-Host ""

$paths = @(
    @{
        Path = $env:TEMP
        Name = "User TEMP"
    },
    @{
        Path = "C:\Windows\Temp"
        Name = "Windows TEMP"
    }
)

foreach ($p in $paths) {
    Clean-Folder $p.Path $p.Name
}

$answer = Read-Host "`nClean the Prefetch folder? (Y/N)"

if ($answer -match '^[TtYy]') {
    Clean-Folder "C:\Windows\Prefetch" "Windows Prefetch"
}

Log "`nCleanup completed." "Green"

Pause