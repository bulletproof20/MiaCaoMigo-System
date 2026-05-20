# Regression suites (future)

Stable, idempotent test chains for CI (e.g. pgTAP or NOTICE parsers).

Candidate flow:

1. `DataSeed/04_Loaders/03_TestData.sql`
2. `01_Integrity/**`
3. Exit non-zero on any `FAIL:` in server logs
