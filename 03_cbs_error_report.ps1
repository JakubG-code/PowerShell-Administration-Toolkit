$results = @()

Get-Content ".\CBS_sample.log" | ForEach-Object { # Update this path

    $line = $_

    if ($line -match 'Error') {

        $category = "Other"

        switch -Regex ($line) {

            "corrupt|corruption" {
                $category = "Corruption"
                break
            }

            "access denied" {
                $category = "Permission"
                break
            }

            "package" {
                $category = "Package Failure"
                break
            }

            "dism" {
                $category = "DISM Failure"
                break
            }
        }

        $severity = switch ($category) {

            "Corruption"   { "Critical" }
            "DISM Failure" { "High" }
            "Permission"   { "Medium" }
            default        { "Low" }
        }

        $results += [PSCustomObject]@{
            Category = $category
            Severity = $severity
            Message  = $line
        }
    }
}

Write-Host ""
Write-Host "Total errors found: $($results.Count)"
Write-Host ""

$results | Format-Table -AutoSize

Read-Host "Press Enter to exit"