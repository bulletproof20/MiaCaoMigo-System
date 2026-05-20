# MiaCaoMigo – Docker Setup

## Purpose

This document explains how to configure and run the Docker environment used in the MiaCaoMigo project.

Its goal is to ensure that any developer can set up the database quickly, consistently, and without manual configuration.

All system-related documentation (requirements, architecture, design decisions) is available in the `00_Planeamento/` directory.

---

## Overview

Docker is used to deploy a fully configured PostgreSQL database in a controlled and reproducible environment.

This setup guarantees that:

* All developers use the same database version and configuration
* The full schema is automatically created
* Business logic (functions, triggers, jobs) is preloaded
* No manual setup is required

The database is initialized automatically on first run using SQL scripts included in the project.

---

## Requirements

Make sure the following tools are installed:

* Docker
* Docker Compose

Verify installation:

```bash
docker --version
docker compose version
```

---

## Project Structure (Relevant to Docker)

```
01_DB/
 ├── Schema/
 │    ├── init.sql              # Entry point for DB initialization
 │    ├── 03_Loaders/          # Ordered phases (extensions → tables → FKs → integrity → …)
 │    ├── 01_Modules/          # Modular domain: 00_Tables … 06_Jobs per module
 │    ├── 02_Comments/        # COMMENT ON metadata mirroring 01_Modules (…_Comments.sql)
 │    └── 03_Loaders/10_Official_Bootstrap.sql  # MasterData + DemoData on first init
 ├── DataSeed/                # Seed tiers (mounted into container)
 │
docker-compose.yml             # Container orchestration
Dockerfile                     # Custom PostgreSQL image (with pg_cron)
```

### Key Concepts

* **init.sql**
  Central script responsible for orchestrating the entire database creation.
  It loads `03_Loaders` in order: extensions → tables → FKs → integrity → comments → services → **official bootstrap** (MasterData + DemoData) → sanity checks.

* **02_Comments/**
  Houses `COMMENT ON` scripts grouped like `01_Modules` (including `00_Core` for shared documentation notes). Cross-module foreign keys remain defined only under each module’s `01_ForeignKeys_ModX.sql`; their descriptions live in the matching `01_ForeignKeys_ModX_Comments.sql` files.

* **01_Modules/**
  Each module uses a fixed layout: `00_Tables`, `01_ForeignKeys`, `02_Functions`, `03_Triggers`, `04_Indexes`, `05_Procedures`, `06_Jobs`, `07_Views`.

* **01_DB/Tests/**
  Central QA layer (integrity, manual, runners). Not loaded by `init.sql`.

* **01_DB/DataSeed/**
  Official bootstrap on first init: MasterData + DemoData via `10_Official_Bootstrap.sql`. TestData and DevelopmentData are manual only.

---

## Running the Environment

From the root of the project:

```bash
docker compose up -d --build
```

This will:

1. Build a custom PostgreSQL image (with `pg_cron`)
2. Start the container
3. Create the database (`miacaomigo`)
4. Execute `init.sql`
5. Load the entire schema automatically

---

## What Happens on First Run

During the first execution:

* PostgreSQL is initialized
* The database `miacaomigo` is created
* The script `init.sql` is executed
* All modules are loaded:

  * Tables (all modules)
  * Foreign keys (all modules)
  * Functions
  * Triggers
  * Indexes
  * Stored procedures
  * Scheduled jobs (via pg_cron)
  * Official seed data: MasterData (truncate + invariants) and DemoData (demo narrative)
  * Sanity smoke checks

⚠️ Init scripts run **only once**, when the volume is empty (`docker compose down -v` resets).

---

## Database Access

Connection parameters:

* Host: `localhost`
* Port: `5433`
* Database: `miacaomigo`
* Username: `postgres`
* Password: `1234`

---

## Port Configuration

The container uses:

* **5432** internally (PostgreSQL default)
* **5433** externally (host machine)

This avoids conflicts with local PostgreSQL installations.

---

## Connecting via Visual Studio Code

Recommended tool: **PostgreSQL extension**

Steps:

1. Open PostgreSQL panel
2. Create new connection
3. Use the credentials above

---

## pg_cron (Scheduled Jobs)

The system includes `pg_cron`, allowing scheduled database jobs.

This enables:

* Automatic data maintenance
* Scheduled processes (e.g., closing records at midnight)
* Background operations inside PostgreSQL

Configuration is handled automatically via:

* Dockerfile (installs pg_cron)
* docker-compose (activates it)
* init.sql (creates jobs)

---

## Initialization Rules

* Only `.sql` files in `/docker-entrypoint-initdb.d` root are executed automatically
* Subfolders are ignored by PostgreSQL
* Therefore, **init.sql must be in the root of Schema/**

---

## Data Persistence

A Docker volume is used:

* Data is preserved between restarts
* Container can be stopped/started without losing data

---

## Resetting the Environment

To fully reset the database:

```bash
docker compose down -v
docker compose up -d --build
```

This will:

* Delete all data
* Recreate the database from scratch
* Re-run all initialization scripts

---

## Manual Alternative (Not Recommended)

```bash
docker run -d \
  --name miacaomigo-db \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=1234 \
  -e POSTGRES_DB=miacaomigo \
  -p 5433:5432 \
  postgres:15
```

⚠️ This does NOT include:

* pg_cron
* automatic schema loading
* project configuration

Use only for debugging.

---

## Notes

* Initialization scripts run only on first container creation
* The database is fully self-contained and reproducible
* pg_cron is pre-configured and ready to use
* The setup is designed for zero manual intervention
* Port 5433 avoids conflicts with local PostgreSQL instances

---

## Summary

With a single command:

```bash
docker compose up
```

You get:

* A running PostgreSQL instance
* Fully built schema
* Business rules enforced (triggers/functions)
* Scheduled jobs configured
* Identical environment across all machines

---
 