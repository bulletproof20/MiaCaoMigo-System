# Bootstrap — orchestration only

Docker runs `init.sql` → default profile `init_demo`.

## Pipeline (init_demo)

```
init_core
  00_Extensions → 01_Types → 01_Structure → 02_FK → 03_Integrity
  → 05_Comments → 06_Services → 08_Service_Comments
11_MasterData
  00_Data_Cleanup (TRUNCATE) → 00_MasterData/*.sql (INSERT)
12_DemoData → 03_DemoData/*.sql (INSERT)
07_Sanity_Check
```

## Loaders

| Loader | Target |
|--------|--------|
| `00_Extensions` | pg_cron, btree_gist |
| `01_Structure` | `Schema/*/00_Tables_Mod*` |
| `02_ForeignKeys` | `Schema/*/01_ForeignKeys_*` |
| `03_Integrity` | functions, triggers, indexes, views, procedures, jobs (M1+M4 only) |
| `05_Comments` | `Comments/Schema/` (skips empty placeholders) |
| `06_Services` | `Services/` |
| `08_Service_Comments` | `Comments/Services/` |
| `07_Sanity_Check` | post-init smoke |
| `11_MasterData` | `00_Data_Cleanup` + `DataSeed/00_MasterData/` |
| `12_DemoData` | `DataSeed/03_DemoData/` |

## Profiles

| Profile | Data tiers |
|---------|------------|
| `init_core` | DDL + services only |
| `init_minimal` | core + sanity |
| `init_master` | core + Master + sanity |
| `init_demo` | core + Master + Demo + sanity (**default**) |
| `init_test` | alias → `init_demo` (QA uses `Tests/fixtures/`) |
| `init_full_qa` | alias → `init_demo` + hint to run `Tests/runners/` |

## Reset

```bash
docker compose down -v && docker compose up --build -d
```

Docs: `../DOC_STYLE.md`, `../DataSeed/contracts/00_ENTITIES.md`, `../PASSWORD_AUTH.md`.
