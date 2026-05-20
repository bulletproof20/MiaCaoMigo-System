# Stress datasets

Stress **data** lives in `DataSeed/01_TestData/`:

| Script | Role |
|--------|------|
| `01_Module1/02_CreationStress.sql` | Default Mod1 fixture hub (stable IDs) |
| `01_Module1/01_AuthenticationStress.sql` | Auth volume (mutually exclusive with CreationStress) |
| `03_Module3/01_Module3_VolumeStress.sql` | Commercial volume (isolated DB) |

Load via:

```bash
cd 01_DB/DataSeed
psql -v ON_ERROR_STOP=1 -f 04_Loaders/03_TestData.sql
```

Or use `runners/run_test_data.ps1`.

Stress **validation** scripts belong in `01_Integrity/` or `05_Regression/` when automated.
