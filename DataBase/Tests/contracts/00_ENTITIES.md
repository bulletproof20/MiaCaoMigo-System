# QA entity catalog

Guaranteed entities after `run_fixtures.ps1` (not bulk datasets).

## QA_CLIENT_ACTIVE

| | |
|--|--|
| Key | `goncalo.pratas.cstress@gmail.com` |
| Fixture | `01_Module1/01_Core_Context.sql` |
| Lookup | `qa_client_active_id()` |
| Use | Mod2 adoption owner, Mod4 scheduling |

## QA_CLIENT_SECONDARY

| | |
|--|--|
| Key | `goncalo.machado.cstress@gmail.com` |
| Lookup | `qa_client_secondary_id()` |
| Use | Mod4 client/animal mismatch |

## QA_REGISTRAR

| | |
|--|--|
| Key | `employee.ema_emp = 20@miacaomigo.pt` |
| Lookup | `qa_registrar_emp_id()` |
| Use | ownership, login test 03 |

## QA_VET_PRIMARY

| | |
|--|--|
| Key | `OMV-PT-2024-CR-00841` |
| Lookup | `qa_vet_primary_id()` |
| Expert | medicina interna + medicina felina |

## QA_EMP_CLOCKABLE

| | |
|--|--|
| Key | `qa.clockable@miacaomigo.pt` + open `clock_in` |
| Lookup | `qa_emp_clockable_id()` |

## QA_EMP_ABSENCE_OVERLAP

| | |
|--|--|
| Key | `21@miacaomigo.pt` + pending absence +15d |
| Lookup | `qa_emp_absence_overlap_id()` |

## QA_ANIMAL_*

| Entity | `reg_id_ani` | State |
|--------|--------------|-------|
| Internal | ANI-2026-001 | Interno |
| Adopted | ANI-2026-003 | Adotado |
| Stress internal | ANI-2026-005 | Interno |

Fixture: `02_Module2/01_Animals_Ownership.sql`

## QA_PRODUCT_STOCK

| | |
|--|--|
| Key | `ref_pro = INT-P001` |
| Fixture | `03_Module3/01_Commercial_Product.sql` |

## Time slots (Mod4)

| Contract | Value |
|----------|--------|
| Overlap | `2099-06-15 10:00` |
| Notification | `2099-07-11` |
