# ===== LOG =====
function Log($text, $color = "White") {

    switch ($color) {
        "Green" { Write-Host $text -ForegroundColor Green }
        "Red"   { Write-Host $text -ForegroundColor Red }
        "Yellow"{ Write-Host $text -ForegroundColor Yellow }
        default { Write-Host $text }
    }
}

# ===== CLEAN =====
function Clean-Folder($path) {

    if (!(Test-Path $path)) {
        Log "Nie istnieje: $path" "Red"
        return
    }

    Log "`n--- Czyszczenie: $path ---" "Yellow"

    Get-ChildItem -Path $path -Force -ErrorAction SilentlyContinue | ForEach-Object {

        try {
            Remove-Item $_.FullName -Recurse -Force -ErrorAction Stop
            Log "OK: $($_.FullName)" "Green"
        }
        catch {
            Log "BLAD: $($_.FullName)" "Red"
        }
    }
}

# ===== START =====

Write-Host ""
Write-Host "=== TEMP Cleaner ===" -ForegroundColor Cyan
Write-Host ""

$paths = @(
    $env:TEMP,
    "C:\Windows\Temp"
)

foreach ($p in $paths) {
    Clean-Folder $p
}

$answer = Read-Host "`nCzy wyczyscic Prefetch? (T/N)"

if ($answer -match '^[TtYy]') {
    Clean-Folder "C:\Windows\Prefetch"
}

Log "`nZakonczono." "Green"

Pause