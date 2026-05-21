# Run stress suite (metrics via STRESS NOTICE — SQL errors fail the run)
param(
    [string]$Container = "miacaomigo-db",
    [string]$Db = "miacaomigo",
    [string]$User = "postgres",
    [ValidateSet("0", "1", "2", "3", "4", "all")]
    [string]$Module = "all"
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "lib/Invoke-QaSqlRunner.ps1")

$Tests = Split-Path $PSScriptRoot -Parent
$Stress = Join-Path $Tests "02_Stress"
$allScripts = [ordered]@{
    "1" = @(
        "01_Module1/01_Login_Concurrency.sql",
        "01_Module1/02_Clocking_Concurrency.sql"
    )
    "2" = @("02_Module2/01_Concurrent_Adoption.sql")
    "3" = @(
        "03_Module3/01_Concurrent_Sales.sql",
        "03_Module3/02_High_Volume_Invoice_Lines.sql",
        "03_Module3/03_FIFO_Consumption.sql",
        "03_Module3/04_Return_Storm.sql"
    )
    "4" = @(
        "04_Module4/01_Concurrent_Appointment_Booking.sql",
        "04_Module4/02_Appointment_Lifecycle_Load.sql"
    )
}

if ($Module -eq "all") {
    $scripts = @()
    foreach ($k in $allScripts.Keys) {
        $scripts += $allScripts[$k]
    }
} else {
    $scripts = $allScripts[$Module]
}

Write-Host "========================================"
Write-Host "STRESS SUITE - $($scripts.Count) script(s)  Module: $Module"
Write-Host "Container: $Container  Database: $Db"
Write-Host "========================================"

Write-Host ""
Write-Host ">>> (preflight) QA fixtures (all modules + stress commercial)"
& (Join-Path $PSScriptRoot "run_fixtures.ps1") -Container $Container -Db $Db -User $User -Module all -IncludeStress
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$scriptsRun = 0
$scriptsFailed = 0
$totalFail = 0
$totalError = 0
$totalFatal = 0

foreach ($rel in $scripts) {
    Write-Host ""
    Write-Host ">>> $rel"
    $path = Join-Path $Stress $rel
    $result = Invoke-QaSqlScript -Container $Container -DatabaseName $Db -User $User -FilePath $path
    $result.Output | Write-Host

    $scriptsRun++
    $totalFail += $result.Metrics.FailCount
    $totalError += $result.Metrics.ErrorCount
    $totalFatal += $result.Metrics.FatalCount

    if (-not $result.Success) {
        $scriptsFailed++
        Write-Host "ERROR: stress script failed - $rel"
    }
}

$passed = Write-QaRunSummary `
    -SuiteName "STRESS" `
    -ScriptsRun $scriptsRun `
    -ScriptsFailed $scriptsFailed `
    -TotalFailNotices $totalFail `
    -TotalPassNotices -1 `
    -TotalSqlErrors $totalError `
    -TotalFatals $totalFatal

if (-not $passed) { exit 1 }
