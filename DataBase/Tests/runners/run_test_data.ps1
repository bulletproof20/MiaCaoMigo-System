# Load TestData fixture chain (never part of init.sql)
param(
    [string]$Container = "miacaomigo-db",
    [string]$Db = "miacaomigo",
    [string]$User = "postgres"
)

$ErrorActionPreference = "Stop"
$Root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$DataSeed = Join-Path $Root "DataSeed"

docker cp $DataSeed "${Container}:/tmp/DataSeed"
docker exec $Container bash -c "cd /tmp/DataSeed && psql -U $User -d $Db -v ON_ERROR_STOP=1 -f 04_Loaders/03_TestData.sql"
Write-Host "TestData loaded."
