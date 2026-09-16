Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Export File Names to TXT"
$form.Size = New-Object System.Drawing.Size(600,250)
$form.StartPosition = "CenterScreen"

$label = New-Object System.Windows.Forms.Label
$label.Text = "No folder selected"
$label.Size = New-Object System.Drawing.Size(560,20)
$label.Location = New-Object System.Drawing.Point(10,20)

$btnBrowse = New-Object System.Windows.Forms.Button
$btnBrowse.Text = "Select Folder"
$btnBrowse.Size = New-Object System.Drawing.Size(150,40)
$btnBrowse.Location = New-Object System.Drawing.Point(10,60)

$btnSave = New-Object System.Windows.Forms.Button
$btnSave.Text = "Save to TXT"
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

$global:folderPath = $null

# Append messages to the log window.
function Log($text) {
    $log.AppendText("$text`r`n")
}

$btnBrowse.Add_Click({

    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = "Select a folder"

    if ($dialog.ShowDialog() -eq "OK") {
        $global:folderPath = $dialog.SelectedPath
        $label.Text = "Selected folder: $global:folderPath"
        Log "Selected: $global:folderPath"
    }
})

$btnSave.Add_Click({

    if (-not $global:folderPath) {
        Log "No folder selected!"
        return
    }

    try {
        $outputFile = Join-Path $global:folderPath "file_list.txt"

        Get-ChildItem -Path $global:folderPath -File |
            Select-Object -ExpandProperty Name |
            Out-File -Encoding UTF8 $outputFile

        Log "Saved: $outputFile"
    }
    catch {
        Log "ERROR: $($_.Exception.Message)"
    }
})

$form.ShowDialog()