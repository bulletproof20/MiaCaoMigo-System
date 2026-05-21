# QA contracts

Semantic lookups (`qa_*()`). Loaded by `run_fixtures.ps1`. **Not** in Bootstrap init.

## Functions

| Function | Key |
|----------|-----|
| `qa_client_active_id()` | `goncalo.pratas.cstress@gmail.com` |
| `qa_client_secondary_id()` | `goncalo.machado.cstress@gmail.com` |
| `qa_registrar_emp_id()` | `20@miacaomigo.pt` |
| `qa_vet_primary_id()` | `OMV-PT-2024-CR-00841` |
| `qa_emp_clockable_id()` | `qa.clockable@miacaomigo.pt` |
| `qa_emp_absence_overlap_id()` | `21@miacaomigo.pt` |
| `qa_animal_internal_id()` | `ANI-2026-001` |
| `qa_animal_adopted_id()` | `ANI-2026-003` |
| `qa_animal_stress_internal_id()` | `ANI-2026-005` |
| `qa_product_int_p001_id()` | `INT-P001` |
| `qa_appt_overlap_slot()` | `2099-06-15 10:00` |
| `qa_appt_notification_date()` | `2099-07-11` |

## Catalog

`00_ENTITIES.md` — origin, guarantees, dependencies.

## File

`01_QA_Functions.sql` — `CREATE OR REPLACE`, safe to re-run.
