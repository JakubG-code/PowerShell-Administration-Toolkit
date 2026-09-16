Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

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
$btn.Text = "Clean TEMP"
$btn.Size = New-Object System.Drawing.Size(200,40)
$btn.Location = New-Object System.Drawing.Point(10,370)

$chkPrefetch = New-Object System.Windows.Forms.CheckBox
$chkPrefetch.Text = "Clean Prefetch (use with caution)"
$chkPrefetch.Location = New-Object System.Drawing.Point(230,380)
$chkPrefetch.Size = New-Object System.Drawing.Size(250,20)

$form.Controls.Add($logBox)
$form.Controls.Add($btn)
$form.Controls.Add($chkPrefetch)

# Append colored messages to the log window.
function Log($text, $color = "Black") {
    $logBox.SelectionColor = [System.Drawing.Color]::$color
    $logBox.AppendText("$text`r`n")
    $logBox.ScrollToCaret()
}

function Clean-Folder($path, $displayName) {

    if (!(Test-Path $path)) {
        Log "Folder not found: $displayName" "Red"
        return
    }

    Log "`n--- Cleaning: $displayName ---" "Black"

    Get-ChildItem -Path $path -Force -ErrorAction SilentlyContinue | ForEach-Object {

        $file = $_

        # Display only the item name, without the full path.
        $itemName = $file.Name

        try {
            Remove-Item $file.FullName -Recurse -Force -ErrorAction Stop
            Log "OK: $itemName" "Green"
        }
        catch {
            Log "ERROR: $itemName" "Red"
        }
    }
}

$btn.Add_Click({

    $logBox.Clear()

    Log "Starting cleanup..." "Black"

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

    # Prefetch cleanup is optional because it may temporarily affect application startup performance.
    if ($chkPrefetch.Checked) {
        Clean-Folder "C:\Windows\Prefetch" "Windows Prefetch"
    }

    Log "`nCleanup completed." "Green"
})

$form.ShowDialog()