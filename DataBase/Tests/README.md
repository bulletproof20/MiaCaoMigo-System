# Database Tests

SQL-centric QA for the Data Layer. **Not** in Docker `init.sql`.

## Structure

```
Tests/
├── contracts/     # qa_*() lookups
├── fixtures/      # official QA data (replaces DataSeed TestData)
├── 01_Integrity/  # PASS/FAIL rules
├── 02_Stress/     # metrics
├── 03_Manual/     # workflows
├── 05_Regression/ # CI alias
└── runners/
```

## Quick start

```powershell
# 1. Stack (init_demo = Master + Demo)
docker compose up -d --build

# 2. Regression gate
cd DataBase/Tests/runners
.\run_regression.ps1
```

## Prerequisites

| Item | Source |
|------|--------|
| Schema + services | Bootstrap `init_demo` |
| QA entities | `run_fixtures.ps1` |
| Demo products (Mod3) | DemoData tier |

## Docs

- `MATRIX.md` — layers and flows
- `fixtures/README.md` — module fixtures
- `contracts/README.md` — entity contracts
- `runners/README.md` — FAIL parser, exit codes
