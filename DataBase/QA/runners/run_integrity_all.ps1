# Run full integrity suite (Module1 -> Module4) with FAIL: parsing.
# Prerequisites:
#   - Bootstrap pipeline applied (init_demo: Master + Demo)
#   - run_fixtures.ps1 (included below unless -SkipFixtures)
param(
    [string]$Container = "miacaomigo-db",
    [string]$Db = "miacaomigo",
    [string]$User = "postgres",
    [switch]$SkipFixtures
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "lib/Invoke-QaSqlRunner.ps1")

$Tests = Split-Path $PSScriptRoot -Parent
$Integrity = Join-Path $Tests "01_Integrity"
$Fixtures = Join-Path $Tests "fixtures"

$scripts = @(
    @{ Path = "01_Module1/01_Email_Nif_Uniqueness.sql" }
    @{ Path = "01_Module1/02_Login_Session_Rules.sql" }
    @{ Path = "01_Module1/03_Clocking_Rules.sql" }
    @{ Path = "01_Module1/04_Absence_Overlap.sql" }
    @{ Path = "01_Module1/05_Role_Disjunction.sql" }
    @{ Path = "01_Module1/06_Schedule_Exclusion.sql" }
    @{ Path = "02_Module2/01_Duplicate_Ownership.sql"; Cleanup = "cleanup/02_Reset_Module2_Animal1.sql" }
    @{ Path = "02_Module2/02_Ownership_Lifecycle.sql" }
    @{ Path = "02_Module2/03_Breed_Species_Consistency.sql" }
    @{ Path = "02_Module2/04_Delivery_Date_Consistency.sql" }
    @{ Path = "02_Module2/05_Concession_And_Inactive.sql" }
    @{ Path = "03_Module3/01_Stock_Before_Sale.sql" }
    @{ Path = "03_Module3/02_Inactive_Product_Sale.sql" }
    @{ Path = "03_Module3/03_Return_Quantity.sql" }
    @{ Path = "03_Module3/04_Invoice_Total_Update.sql" }
    @{ Path = "04_Module4/01_Appointment_Scheduling.sql" }
    @{ Path = "04_Module4/02_Appointment_Overlap.sql" }
    @{ Path = "04_Module4/03_Vet_Absence.sql" }
    @{ Path = "04_Module4/04_Appointment_Lifecycle.sql" }
    @{ Path = "04_Module4/05_Prescription_Timing.sql" }
    @{ Path = "04_Module4/06_Notifications.sql" }
)

Write-Host "========================================"
Write-Host "INTEGRITY SUITE - $($scripts.Count) scripts"
Write-Host "Container: $Container  Database: $Db"
Write-Host "========================================"

if (-not $SkipFixtures) {
    Write-Host ""
    Write-Host ">>> (preflight) QA contracts + fixtures"
    & (Join-Path $PSScriptRoot "run_fixtures.ps1") -Container $Container -Db $Db -User $User
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

$scriptsRun = 0
$scriptsFailed = 0
$totalFail = 0
$totalPass = 0
$totalError = 0
$totalFatal = 0

foreach ($entry in $scripts) {
    $rel = $entry.Path

    if ($entry.Cleanup) {
        $cleanupRel = $entry.Cleanup
        Write-Host ""
        Write-Host ">>> (cleanup) $cleanupRel"
        $cleanupPath = Join-Path $Fixtures $cleanupRel
        if (Test-Path $cleanupPath) {
            $cr = Invoke-QaSqlScript -Container $Container -DatabaseName $Db -User $User -FilePath $cleanupPath
            $cr.Output | Write-Host
            if (-not $cr.Success) { $scriptsFailed++ }
        }
    }

    Write-Host ""
    Write-Host ">>> $rel"
    $path = Join-Path $Integrity $rel
    $result = Invoke-QaSqlScript -Container $Container -DatabaseName $Db -User $User -FilePath $path -CountPass
    $result.Output | Write-Host

    $scriptsRun++
    $totalFail += $result.Metrics.FailCount
    $totalPass += $result.Metrics.PassCount
    $totalError += $result.Metrics.ErrorCount
    $totalFatal += $result.Metrics.FatalCount

    if (-not $result.Success) {
        $scriptsFailed++
        Write-Host "ERROR: integrity script failed - $rel"
    }
}

$passed = Write-QaRunSummary `
    -SuiteName "INTEGRITY" `
    -ScriptsRun $scriptsRun `
    -ScriptsFailed $scriptsFailed `
    -TotalFailNotices $totalFail `
    -TotalPassNotices $totalPass `
    -TotalSqlErrors $totalError `
    -TotalFatals $totalFatal

if (-not $passed) { exit 1 }
