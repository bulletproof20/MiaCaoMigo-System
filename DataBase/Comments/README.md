# Comments layer

`COMMENT ON` metadata for Schema and Services objects.

Loaded by `Bootstrap/Loaders/05_Comments.sql` and `08_Service_Comments.sql`.

## Layout

| Path | Mirrors |
|------|---------|
| `Schema/00_Core/` | ENUM types |
| `Schema/01_Module1/` … `04_Module4/` | tables, FKs, functions, triggers, indexes, views, procedures |
| `Services/00_Core/` … `04_Module4/` | application functions |

## Skipped at bootstrap (placeholders)

Not `\i`'d during init: `00_Common_Functions_Comments.sql`, `06_Jobs_Mod2/3_Comments.sql`, empty job narrative files.

Logic and pedagogy live in `Schema/` and `Services/` SQL; see `../DOC_STYLE.md`.
