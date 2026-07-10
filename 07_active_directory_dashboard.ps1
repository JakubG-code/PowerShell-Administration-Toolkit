# ============================================
# 6. HTML DASHBOARD
# ============================================

Write-Host "`n[6] Generating HTML dashboard..." -ForegroundColor Yellow

# Statistics
$InactiveUsersCount = $InactiveUsers.Count
$LockedUsersCount = $LockedUsers.Count
$ExpiringPasswordsCount = $ExpiringPasswords.Count
$InactiveComputersCount = $InactiveComputers.Count
$DomainAdminsCount = $DomainAdmins.Count

# HTML Dashboard
$HtmlReport = @"

<html>
<head>
<title>AD Audit Dashboard</title>

<style>

body {
    background-color: #1e1e1e;
    color: white;
    font-family: Arial;
    margin: 40px;
}

h1 {
    color: #4CAF50;
}

.card-container {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
}

.card {
    background-color: #2d2d2d;
    padding: 20px;
    border-radius: 10px;
    width: 250px;
    box-shadow: 0px 0px 10px black;
}

.card h2 {
    margin: 0;
    color: #4CAF50;
}

.card p {
    font-size: 32px;
    margin-top: 10px;
}

table {
    border-collapse: collapse;
    width: 100%;
    margin-top: 30px;
}

th {
    background-color: #4CAF50;
    padding: 10px;
}

td {
    padding: 10px;
    border-bottom: 1px solid #444;
}

.status-ok {
    color: #4CAF50;
    font-weight: bold;
}

.status-warning {
    color: orange;
    font-weight: bold;
}

.status-danger {
    color: red;
    font-weight: bold;
}

</style>
</head>

<body>

<h1>Active Directory Audit Dashboard</h1>

<p>Generated: $(Get-Date)</p>

<div class="card-container">

<div class="card">
<h2>Inactive Users</h2>
<p>$InactiveUsersCount</p>
</div>

<div class="card">
<h2>Locked Accounts</h2>
<p>$LockedUsersCount</p>
</div>

<div class="card">
<h2>Expiring Passwords</h2>
<p>$ExpiringPasswordsCount</p>
</div>

<div class="card">
<h2>Inactive Computers</h2>
<p>$InactiveComputersCount</p>
</div>

<div class="card">
<h2>Domain Admins</h2>
<p>$DomainAdminsCount</p>
</div>

</div>

<h2>Domain Admins Members</h2>

<table>
<tr>
<th>Name</th>
<th>Username</th>
<th>Type</th>
</tr>

$(
foreach ($Admin in $DomainAdmins) {
"
<tr>
<td>$($Admin.Name)</td>
<td>$($Admin.SamAccountName)</td>
<td>$($Admin.ObjectClass)</td>
</tr>
"
}
)

</table>

</body>
</html>

"@

# Save dashboard
$DashboardPath = "$ReportPath\dashboard.html"

$HtmlReport | Out-File `
    -FilePath $DashboardPath `
    -Encoding UTF8

Write-Host "[OK] HTML dashboard generated" -ForegroundColor Green

# Open dashboard automatically
Start-Process $DashboardPath