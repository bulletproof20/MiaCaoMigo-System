# Fixtures (official QA context)

Data-only SQL. No `PASS:` / `FAIL:`.

## Layout

```
fixtures/
├── 00_Reset_QA_State.sql      # scoped cleanup (re-run safe)
├── 01_Module1/01_Core_Context.sql
├── 02_Module2/01_Animals_Ownership.sql
├── 03_Module3/
│   ├── 01_Commercial_Product.sql
│   └── 02_Stress_Commercial.sql   # stress runner only
├── 04_Module4/01_Appointment_Slots.sql
└── cleanup/
    ├── 01_Reset_Module1_Clocking.sql
    └── 02_Reset_Module2_Animal1.sql
```

## Load

```powershell
cd DataBase/Tests/runners
.\run_fixtures.ps1              # all modules
.\run_fixtures.ps1 -Module 2    # single module
```

## Prerequisite

`docker compose up` with **init_demo** (Master + Demo). Contracts: `contracts/01_QA_Functions.sql`.

## Rules

| Rule | Detail |
|------|--------|
| Keys | `reg_id_ani`, `ref_pro`, `ema_usr`, `ema_emp`, `num_omv_vet` |
| Time | Mod4 uses `2099-*` slots |
| Scope | Mod2 truncates animal tier only |
| No TestData | Removed from DataSeed |
