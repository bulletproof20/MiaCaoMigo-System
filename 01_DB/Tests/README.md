# MiaCaoMigo — Database Tests

Central home for **executable** validation. Datasets and fixtures live in `DataSeed/01_TestData/` only.

## Separation of concerns

| Layer | Path | Responsibility |
|-------|------|----------------|
| **DataSeed** | `01_TestData/`, `04_Loaders/03_TestData.sql` | Fixtures, stress datasets (no asserts) |
| **Schema** | `Schema/03_Loaders/07_Sanity_Check.sql` | Post-init structural smoke (init pipeline) |
| **Tests** | This folder | Integrity, manual, stress runners, future CI |

## Categories

| Folder | Purpose |
|--------|---------|
| `00_Sanity/` | Optional extra smoke beyond init (future) |
| `01_Integrity/` | PASS/FAIL business rules (triggers, procedures, services) |
| `02_Stress/` | Stress dataset orchestration docs |
| `03_Manual/` | Human-reviewed `SELECT` / exploratory scripts |
| `04_Development/` | Disposable experiments (not CI) |
| `05_Regression/` | Stable suites for future automation |
| `runners/` | PowerShell entry points |

## Prerequisites

1. Apply full pipeline: `Schema/init.sql` (Docker or manual).
2. Load test fixtures:

```bash
cd 01_DB/DataSeed
psql -U postgres -d miacaomigo -v ON_ERROR_STOP=1 -f 04_Loaders/03_TestData.sql
```

3. Run tests from `01_DB/Tests`:

```powershell
.\runners\run_integrity_all.ps1
```

## Manual Module 1 (Services)

After step 2, run in order (see `03_Manual/Services/01_Module1/User_Creation/00_RUN_ORDER.txt`):

```bash
psql -f 03_Manual/Services/01_Module1/User_Creation/01_Client.sql
# … through 05_Verification.sql
psql -f 03_Manual/Services/01_Module1/Authentication/99_Test.sql
```

## ID contracts

`DataSeed/01_TestData/00_Contracts/00_ID_CONTRACT.txt`

## Not in scope here

- `Queries/` — reference SQL only
- `Services/02_Validations.sql` — production helpers
- `DevelopmentData` / `DemoData` — non-QA tiers
