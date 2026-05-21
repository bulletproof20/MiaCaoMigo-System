# Stress tests

Load/contention metrics (`STRESS` NOTICE). Not CI-gated by default.

## Prerequisite

```powershell
docker compose up -d --build   # init_demo
cd DataBase/Tests/runners
.\run_stress_all.ps1           # loads fixtures + stress scripts
```

## Layout

| Module | Scripts |
|--------|---------|
| M1 | login, clocking concurrency |
| M2 | concurrent adoption |
| M3 | sales, invoice lines, FIFO, returns |
| M4 | appointment booking, lifecycle load |

## Fixtures

| File | Role |
|------|------|
| `fixtures/03_Module3/02_Stress_Commercial.sql` | `STRESS-M3` product (preflight in runner) |
| All module fixtures | via `run_fixtures.ps1 -IncludeStress` |

## After stress

Re-run `.\run_regression.ps1` for integrity baseline.
