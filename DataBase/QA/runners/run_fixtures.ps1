# Load QA contracts + modular fixtures (official QA context; no DataSeed TestData).
param(
    [string]$Container = "miacaomigo-db",
    [string]$Db = "miacaomigo",
    [string]$User = "postgres",
    [ValidateSet("all", "1", "2", "3", "4")]
    [string]$Module = "all",
    [switch]$IncludeStress,
    [switch]$SkipReset
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "lib/Invoke-QaSqlRunner.ps1")

$TestsRoot = Split-Path $PSScriptRoot -Parent

$coreFiles = @(
    "contracts/01_QA_Functions.sql"
)
if (-not $SkipReset) {
    $coreFiles += "fixtures/00_Reset_QA_State.sql"
}

$moduleFiles = @{
    "1" = @("fixtures/01_Module1/01_Core_Context.sql")
    "2" = @("fixtures/02_Module2/01_Animals_Ownership.sql")
    "3" = @("fixtures/03_Module3/01_Commercial_Product.sql")
    "4" = @("fixtures/04_Module4/01_Appointment_Slots.sql")
}

$files = [System.Collections.Generic.List[string]]::new()
foreach ($f in $coreFiles) { $files.Add($f) }

if ($Module -eq "all") {
    foreach ($k in @("1", "2", "3", "4")) {
        foreach ($f in $moduleFiles[$k]) { $files.Add($f) }
    }
} else {
    foreach ($f in $moduleFiles[$Module]) { $files.Add($f) }
}

if ($IncludeStress) {
    $files.Add("fixtures/03_Module3/02_Stress_Commercial.sql")
}

Write-Host "========================================"
Write-Host "QA FIXTURES - $($files.Count) file(s)  Module: $Module"
Write-Host "Container: $Container  Database: $Db"
Write-Host "========================================"

$fail = 0
foreach ($rel in $files) {
    $path = Join-Path $TestsRoot $rel
    if (-not (Test-Path $path)) {
        Write-Host "ERROR: missing file $rel"
        $fail++
        continue
    }
    Write-Host ""
    Write-Host ">>> $rel"
    $result = Invoke-QaSqlScript -Container $Container -DatabaseName $Db -User $User -FilePath $path
    $result.Output | Write-Host
    if (-not $result.Success) {
        $fail++
        Write-Host "ERROR: fixture load failed - $rel"
    }
}

if ($fail -gt 0) { exit 1 }
Write-Host ""
Write-Host "QA fixtures loaded."
