# Runners

Pipe SQL from host into `docker exec … psql`.

## Scripts

| Script | Role |
|--------|------|
| `run_fixtures.ps1` | contracts + fixtures (`-Module`, `-IncludeStress`) |
| `run_integrity_all.ps1` | 21 integrity scripts + summary |
| `run_regression.ps1` | fixtures + integrity (CI) |
| `run_full_qa.ps1` | alias of regression |
| `run_stress_all.ps1` | fixtures (incl. stress) + stress |
| `run_manual_module.ps1` | human workflows |

Removed: `run_test_data.ps1` (TestData tier deleted).

## FAIL parser

`lib/Invoke-QaSqlRunner.ps1` — exit **1** on `FAIL:`, `ERROR:`, `FATAL:`.

## Params

`-Container`, `-Db`, `-User` (defaults: `miacaomigo-db`, `miacaomigo`, `postgres`).
