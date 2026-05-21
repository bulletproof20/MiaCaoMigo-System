# DataSeed — datasets only

SQL data files grouped by tier. **No loaders here** — orchestration lives in `../Bootstrap/Loaders/`.

| Folder | Tier | Bootstrap loader |
|--------|------|------------------|
| `00_MasterData/` | System invariants (TRUNCATE + seed) | `11_MasterData.sql` |
| `03_DemoData/` | Presentation / staging narrative | `12_DemoData.sql` |
| `02_DevelopmentData/` | Local dev comfort rows | `09_DevelopmentData.sql` |

QA entities: `../Tests/fixtures/` via `../Tests/runners/run_fixtures.ps1`.
