# QA matrix

## Layers

| Layer | Path | When | CI |
|-------|------|------|-----|
| Bootstrap | `init_demo` | Docker init | Structural |
| Fixtures | `Tests/fixtures/` | `run_fixtures.ps1` | Prerequisite |
| Contracts | `Tests/contracts/` | with fixtures | Lookup |
| Integrity | `01_Integrity/` | `run_integrity_all.ps1` | **Gate** |
| Regression | `run_regression.ps1` | fixtures + integrity | **Recommended** |
| Stress | `02_Stress/` | optional | No |
| Manual | `03_Manual/` | human | No |

## Flows

```powershell
# CI / regression
.\run_regression.ps1

# Developer
.\run_fixtures.ps1
.\run_integrity_all.ps1 -SkipFixtures   # after fixtures loaded

# Stress
.\run_fixtures.ps1 -IncludeStress
.\run_stress_all.ps1
```

## Exit codes

| Runner | Fails on |
|--------|----------|
| `run_integrity_all` | `psql` error, `FAIL:`, `ERROR:`, `FATAL:` |
| `run_regression` | same (after fixtures) |

## Determinism

1. `run_fixtures.ps1` before integrity (includes `00_Reset_QA_State.sql`).
2. Use `qa_*()` in tests, not surrogate IDs.
3. Mod4: fixed `2099-*` timestamps.
