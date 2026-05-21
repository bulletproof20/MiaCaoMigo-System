# Shared SQL runner helpers — NOTICE / ERROR / FATAL parsing for MiaCaoMigo QA.
# Dot-source from runners: . (Join-Path $PSScriptRoot "lib/Invoke-QaSqlRunner.ps1")

function Get-SqlOutputMetrics {
    param(
        [string[]]$Lines,
        [switch]$CountPass
    )

    $metrics = [ordered]@{
        FailCount  = 0
        ErrorCount = 0
        FatalCount = 0
        PassCount  = 0
    }

    foreach ($line in $Lines) {
        if ($null -eq $line -or $line.Length -eq 0) { continue }

        if ($line -match '(?i)(^|\s|:)\s*FAIL:') {
            $metrics.FailCount++
            continue
        }

        if ($line -match '(?i)^FATAL:\s') {
            $metrics.FatalCount++
            continue
        }

        if ($line -match '(?i)^ERROR:\s') {
            if ($line -notmatch '(?i)ERROR:\s+script failed') {
                $metrics.ErrorCount++
            }
            continue
        }

        if ($CountPass -and ($line -match '(?i)(^|\s|:)\s*PASS:')) {
            $metrics.PassCount++
        }
    }

    return [pscustomobject]$metrics
}

function Invoke-QaSqlScript {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Container,
        [Parameter(Mandatory = $true)]
        [string]$DatabaseName,
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [string]$FilePath,
        [switch]$CountPass
    )

    $prevEap = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $output = Get-Content -Path $FilePath -Raw -Encoding UTF8 |
            docker exec -i $Container psql -U $User -d $DatabaseName -v ON_ERROR_STOP=1 2>&1
    } finally {
        $ErrorActionPreference = $prevEap
    }

    $text = if ($output -is [array]) { $output -join "`n" } else { [string]$output }
    $lines = $text -split "`r?`n"
    $metrics = Get-SqlOutputMetrics -Lines $lines -CountPass:$CountPass

    $psqlExit = $LASTEXITCODE
    $logicalFail = ($metrics.FailCount -gt 0) -or ($metrics.FatalCount -gt 0)

    [pscustomobject]@{
        PsqlExit     = $psqlExit
        Metrics      = $metrics
        Output       = $text
        Success      = ($psqlExit -eq 0) -and (-not $logicalFail)
        LogicalFail  = $logicalFail
    }
}

function Write-QaRunSummary {
    param(
        [string]$SuiteName,
        [int]$ScriptsRun,
        [int]$ScriptsFailed,
        [int]$TotalFailNotices,
        [int]$TotalPassNotices,
        [int]$TotalSqlErrors,
        [int]$TotalFatals
    )

    Write-Host ""
    Write-Host "========================================"
    Write-Host "$SuiteName - SUMMARY"
    Write-Host "========================================"
    Write-Host "Scripts executed : $ScriptsRun"
    Write-Host "Scripts failed   : $ScriptsFailed (psql exit != 0)"
    Write-Host "FAIL: notices     : $TotalFailNotices"
    if ($TotalPassNotices -ge 0) {
        Write-Host "PASS: notices     : $TotalPassNotices"
    }
    Write-Host "SQL ERROR: lines  : $TotalSqlErrors"
    Write-Host "FATAL: lines      : $TotalFatals"

    $gateFail = ($ScriptsFailed -gt 0) -or ($TotalFailNotices -gt 0) -or ($TotalSqlErrors -gt 0) -or ($TotalFatals -gt 0)
    if ($gateFail) {
        Write-Host "RESULT           : FAILED"
    } else {
        Write-Host "RESULT           : PASSED"
    }
    Write-Host "========================================"

    return (-not $gateFail)
}
