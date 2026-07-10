Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ===== GUI =====
$form = New-Object System.Windows.Forms.Form
$form.Text = "Eksport nazw plikow do TXT"
$form.Size = New-Object System.Drawing.Size(600,250)
$form.StartPosition = "CenterScreen"

$label = New-Object System.Windows.Forms.Label
$label.Text = "Nie wybrano folderu"
$label.Size = New-Object System.Drawing.Size(560,20)
$label.Location = New-Object System.Drawing.Point(10,20)

$btnBrowse = New-Object System.Windows.Forms.Button
$btnBrowse.Text = "Wybierz folder"
$btnBrowse.Size = New-Object System.Drawing.Size(150,40)
$btnBrowse.Location = New-Object System.Drawing.Point(10,60)

$btnSave = New-Object System.Windows.Forms.Button
$btnSave.Text = "Zapisz do TXT"
$btnSave.Size = New-Object System.Drawing.Size(150,40)
$btnSave.Location = New-Object System.Drawing.Point(170,60)

$log = New-Object System.Windows.Forms.TextBox
$log.Multiline = $true
$log.ScrollBars = "Vertical"
$log.Size = New-Object System.Drawing.Size(560,80)
$log.Location = New-Object System.Drawing.Point(10,110)

$form.Controls.Add($label)
$form.Controls.Add($btnBrowse)
$form.Controls.Add($btnSave)
$form.Controls.Add($log)

# ===== zmienna folderu =====
$global:folderPath = $null

function Log($text) {
    $log.AppendText("$text`r`n")
}

# ===== wybór folderu =====
$btnBrowse.Add_Click({
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = "Wybierz folder"

    if ($dialog.ShowDialog() -eq "OK") {
        $global:folderPath = $dialog.SelectedPath
        $label.Text = "Wybrany folder: $global:folderPath"
        Log "Wybrano: $global:folderPath"
    }
})

# ===== zapis do TXT =====
$btnSave.Add_Click({

    if (-not $global:folderPath) {
        Log "Nie wybrano folderu!"
        return
    }

    try {
        $outputFile = Join-Path $global:folderPath "lista_plikow.txt"

        Get-ChildItem -Path $global:folderPath -File |
            Select-Object -ExpandProperty Name |
            Out-File -Encoding UTF8 $outputFile

        Log "Zapisano: $outputFile"
    }
    catch {
        Log "BLAD: $($_.Exception.Message)"
    }
})

$form.ShowDialog()