# Regression

CI gate — no stress, no manual.

```powershell
.\run_regression.ps1
```

## Steps

1. `run_fixtures.ps1` (contracts + all module fixtures + reset)
2. `01_Integrity/**` (FAIL parser)

## Prerequisite

Docker **init_demo** (Master + Demo).

## Re-run

Always use `run_regression.ps1` or `run_fixtures.ps1` before integrity-only reruns.
