# Bootstrap — pipeline orchestration

Orchestrates database initialization: DDL loaders, Services, optional DataSeed tiers, and sanity checks.

**Structural definitions** live in `../Schema/`. **Datasets** live in `../DataSeed/`.

## Docker entry

`init.sql` (this folder root) runs on first container start when `Bootstrap/` is mounted to `/docker-entrypoint-initdb.d`.

Default profile: `Profiles/init_demo.sql` (MasterData + DemoData + sanity).

## Loaders (`Loaders/`)

| Loader | Role |
|--------|------|
| `00_Extensions` | pg_cron, btree_gist |
| `01_Structure` | Tables only (`00_Tables_Mod*.sql`) |
| `02_ForeignKeys` | Foreign keys (`01_ForeignKeys_Mod*.sql`) |
| `03_Integrity` | Functions, triggers, indexes, views, procedures, jobs |
| `04_Data_Migration` | ETL placeholder / tier docs |
| `05_Comments` | COMMENT ON schema objects (`DataBase/Comments/Schema/`) |
| `08_Service_Comments` | COMMENT ON service functions (`DataBase/Comments/Services/`) |
| `06_Services` | Application PL/pgSQL |
| `07_Sanity_Check` | Light post-init catalog smoke |
| `09_DevelopmentData` | Gated dev tier (manual) |
| `10_Official_Bootstrap` | Master + Demo (composite) |
| `11_MasterData` | Delegate → DataSeed |
| `12_DemoData` | Delegate → DataSeed |
| `13_TestData` | Delegate → DataSeed (QA manual) |

## Profiles (`Profiles/`)

| Profile | Contents |
|---------|----------|
| `init_core.sql` | DDL + services only (shared base) |
| `init_minimal.sql` | core + sanity |
| `init_master.sql` | core + MasterData + sanity |
| `init_demo.sql` | core + Master + Demo + sanity (**Docker default**) |
| `init_dev.sql` | core + Master + Development + sanity |
| `init_test.sql` | core + Master + TestData + sanity |
| `init_full_qa.sql` | init_test + hint to run `Tests/runners/` |

Manual example:

```bash
psql -U postgres -d miacaomigo -f /docker-entrypoint-initdb.d/Profiles/init_test.sql
```

## Reset

```bash
docker compose down -v
docker compose up --build -d
```
