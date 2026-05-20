# Comments layer

Independent `COMMENT ON` metadata for the MiaCaoMigo database. Loaded by `Bootstrap/Loaders/05_Comments.sql` and `08_Service_Comments.sql` after DDL and services exist.

## Layout

| Path | Role |
|------|------|
| `Schema/00_Core/` | Types and shared schema function comments |
| `Schema/01_Module1/` … `04_Module4/` | Per-module object comments (tables, FKs, functions, triggers, indexes, views, procedures, jobs) |
| `Services/00_Core/` … `04_Module4/` | Application PL/pgSQL function comments |
| `Bootstrap/`, `DataSeed/`, `Tests/` | Reserved for future split comments |

## Docker mount

`Comments/` is mounted at `/docker-entrypoint-initdb.d/Comments/` (see `docker-compose.yml`).

## Conventions

- File names mirror schema artifacts: `00_Tables_ModX_Comments.sql`, etc.
- Documentation language: **English**
- Technical identifiers follow the same naming rules as `Schema/` and `Services/` (`fn_*`, `sp_*`, `p_id_*`, `v_*`, `ix_*`)
