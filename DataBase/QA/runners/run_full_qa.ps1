# Full QA: fixtures + integrity (FAIL: gate).
param(
    [string]$Container = "miacaomigo-db",
    [string]$Db = "miacaomigo",
    [string]$User = "postgres"
)

$ErrorActionPreference = "Stop"
& (Join-Path $PSScriptRoot "run_regression.ps1") -Container $Container -Db $Db -User $User
exit $LASTEXITCODE
