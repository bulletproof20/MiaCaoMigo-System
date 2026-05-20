# Run all integrity test scripts (requires TestData fixtures)
param(
    [string]$Container = "miacaomigo-db",
    [string]$Db = "miacaomigo",
    [string]$User = "postgres"
)

$ErrorActionPreference = "Stop"
$Tests = Split-Path $PSScriptRoot -Parent

docker cp $Tests "${Container}:/tmp/Tests"
$scripts = @(
    "01_Integrity/02_Module2/01_Ownership_Rules.sql",
    "01_Integrity/04_Module4/01_Appointment_Rules.sql",
    "01_Integrity/04_Module4/02_Appointment_Notifications.sql"
)

foreach ($rel in $scripts) {
    Write-Host ">>> $rel"
    docker exec $Container psql -U $User -d $Db -v ON_ERROR_STOP=1 -f "/tmp/Tests/$rel"
}

Write-Host "Integrity scripts finished. Review NOTICE output for PASS/FAIL."
