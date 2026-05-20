MiaCaoMigo — SQL Tests
======================

PURPOSE
-------
Manual and future automated validation scripts, separated from
operational DDL (Schema/) and application functions (Services/).

STRUCTURE
---------
Tests/Services/<module>/   — service-layer manual tests (SELECT fn_* …)

LOADING
-------
NOT included in Docker init.sql. Run after full pipeline:

  psql -U postgres -d miacaomigo -f Tests/Services/01_Module1/User_Creation/01_Client.sql

FUTURE
------
Candidates: pgTAP, smoke scripts under Tests/Smoke/, CI validation jobs.
Keep tests idempotent where possible or document required seed data
(see DataSeed/).
