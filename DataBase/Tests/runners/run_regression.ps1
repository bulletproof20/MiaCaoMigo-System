# CI regression gate: fixtures + integrity (requires init_demo bootstrap).
param(
    [string]$Container = "miacaomigo-db",
    [string]$Db = "miacaomigo",
    [string]$User = "postgres"
)

$ErrorActionPreference = "Stop"
$Runners = $PSScriptRoot

Write-Host "========================================"
Write-Host "REGRESSION SUITE"
Write-Host "Prerequisite: docker compose up (init_demo)"
Write-Host "========================================"

& (Join-Path $Runners "run_fixtures.ps1") -Container $Container -Db $Db -User $User -Module all
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& (Join-Path $Runners "run_integrity_all.ps1") -Container $Container -Db $Db -User $User -SkipFixtures
exit $LASTEXITCODE
