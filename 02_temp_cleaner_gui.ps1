Add-Type -AssemblyName System.Windows.Forms 
Add-Type -AssemblyName System.Drawing

# ===== GUI =====
$form = New-Object System.Windows.Forms.Form
$form.Text = "TEMP Cleaner - GUI"
$form.Size = New-Object System.Drawing.Size(700,500)
$form.StartPosition = "CenterScreen"

$logBox = New-Object System.Windows.Forms.RichTextBox
$logBox.Multiline = $true
$logBox.ScrollBars = "Vertical"
$logBox.Size = New-Object System.Drawing.Size(660,350)
$logBox.Location = New-Object System.Drawing.Point(10,10)
$logBox.ReadOnly = $true

$btn = New-Object System.Windows.Forms.Button
$btn.Text = "Czysc TEMP"
$btn.Size = New-Object System.Drawing.Size(200,40)
$btn.Location = New-Object System.Drawing.Point(10,370)

$chkPrefetch = New-Object System.Windows.Forms.CheckBox
$chkPrefetch.Text = "Czysc Prefetch (ryzykowne)"
$chkPrefetch.Location = New-Object System.Drawing.Point(230,380)
$chkPrefetch.Size = New-Object System.Drawing.Size(250,20)

$form.Controls.Add($logBox)
$form.Controls.Add($btn)
$form.Controls.Add($chkPrefetch)

# ===== LOG =====
function Log($text, $color = "Black") {
    $logBox.SelectionColor = [System.Drawing.Color]::$color
    $logBox.AppendText("$text`r`n")
    $logBox.ScrollToCaret()
}

# ===== CLEAN =====
function Clean-Folder($path) {

    if (!(Test-Path $path)) {
        Log "Nie istnieje: $path" "Red"
        return
    }

    Log "`n--- Czyszczenie: $path ---"

    Get-ChildItem -Path $path -Force -ErrorAction SilentlyContinue | ForEach-Object {

        $file = $_

        try {
            Remove-Item $file.FullName -Recurse -Force -ErrorAction Stop
            Log "OK: $($file.FullName)" "Green"
        }
        catch {
            Log "BLAD: $($file.FullName)" "Red"
        }
    }
}

# ===== BUTTON =====
$btn.Add_Click({

    $logBox.Clear()

    Log "Start czyszczenia..."

    $paths = @(
        $env:TEMP,
        "C:\Windows\Temp"
    )

    foreach ($p in $paths) {
        Clean-Folder $p
    }

    if ($chkPrefetch.Checked) {
        Clean-Folder "C:\Windows\Prefetch"
    }

    Log "`nZakonczono."
})

$form.ShowDialog()