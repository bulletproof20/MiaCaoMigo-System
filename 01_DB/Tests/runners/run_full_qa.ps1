# Full QA: TestData fixtures + integrity suite
param(
    [string]$Container = "miacaomigo-db",
    [string]$Db = "miacaomigo",
    [string]$User = "postgres"
)

$ErrorActionPreference = "Stop"
$Runners = $PSScriptRoot

& (Join-Path $Runners "run_test_data.ps1") -Container $Container -Db $Db -User $User
& (Join-Path $Runners "run_integrity_all.ps1") -Container $Container -Db $Db -User $User

Write-Host "Full QA run complete."
