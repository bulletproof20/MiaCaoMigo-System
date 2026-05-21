# Run manual workflow scripts (human-reviewed output)
# Prerequisites: Bootstrap init_demo; recommended run_fixtures.ps1
param(
    [string]$Container = "miacaomigo-db",
    [string]$Db = "miacaomigo",
    [string]$User = "postgres",
    [ValidateSet("1", "2", "3", "4")]
    [string]$Module = "",
    [string]$Workflow = ""
)

$ErrorActionPreference = "Stop"
$Tests = Split-Path $PSScriptRoot -Parent
$Manual = Join-Path $Tests "03_Manual"

$workflows = [ordered]@{
    "1" = @(
        "01_Authentication_Session_Workflow.sql",
        "02_User_Onboarding_Workflow.sql",
        "03_Attendance_Operations_Workflow.sql",
        "04_Employee_Veterinarian_Workflow.sql"
    )
    "2" = @(
        "01_Animal_Ownership_Lifecycle_Workflow.sql",
        "02_Delivery_Concession_Workflow.sql"
    )
    "3" = @(
        "01_Procurement_Stock_Workflow.sql",
        "02_Invoice_And_Returns_Workflow.sql"
    )
    "4" = @(
        "01_Appointment_Lifecycle_Workflow.sql",
        "02_Operational_Appointments_Workflow.sql"
    )
}

function Invoke-ManualSql {
    param([string]$RelativePath)
    $path = Join-Path $Manual $RelativePath
    if (-not (Test-Path $path)) {
        Write-Host "Missing: $path"
        return 1
    }
    Write-Host ""
    Write-Host ">>> $RelativePath"
    Get-Content -Path $path -Raw -Encoding UTF8 | docker exec -i $Container psql -U $User -d $Db -v ON_ERROR_STOP=1 2>&1 | Out-Host
    return $LASTEXITCODE
}

function Show-Menu {
    Write-Host ""
    Write-Host "Manual workflows (03_Manual)"
    Write-Host "----------------------------"
    foreach ($m in $workflows.Keys) {
        Write-Host "  Module $m :"
        $i = 0
        foreach ($w in $workflows[$m]) {
            $i++
            Write-Host "    [$m.$i] $w"
        }
    }
    Write-Host ""
}

if (-not $Module) {
    Show-Menu
    $Module = Read-Host "Module (1-4)"
}

if (-not $Workflow) {
    Show-Menu
    $pick = Read-Host "Workflow file name or index (e.g. 1.2 or 02_User_Onboarding_Workflow.sql)"
    if ($pick -match '^\d+\.\d+$') {
        $parts = $pick.Split('.')
        $Workflow = $workflows[$parts[0]][[int]$parts[1] - 1]
    } elseif ($pick -match '\.sql$') {
        $Workflow = $pick
    } else {
        $Workflow = $workflows[$Module][[int]$pick - 1]
    }
}

$rel = Join-Path "0$Module`_Module$Module" $Workflow
Write-Host "========================================"
Write-Host "MANUAL WORKFLOW"
Write-Host "  $rel"
Write-Host "Container: $Container  Database: $Db"
Write-Host "========================================"

$code = Invoke-ManualSql -RelativePath $rel
if ($code -ne 0) {
    Write-Host "Workflow finished with errors (exit $code)."
    exit $code
}

Write-Host ""
Write-Host "Workflow finished. Review NOTICE lines and SELECT result sets above."
exit 0
