# MiaCaoMigo – Docker Setup

## Purpose

This README provides guidance for configuring and running the Docker environment used in the MiaCaoMigo project.

All project-related documentation, including system description, requirements, and design decisions, is available in the `00_Planeamento/` directory.

---

## Overview

Docker is used to deploy a PostgreSQL database in a consistent and reproducible manner across all development environments.

This ensures that all team members work with the same database configuration, avoiding inconsistencies caused by local setups.

---

## Requirements

Ensure the following tools are installed:

* Docker
* Docker Compose

Verify installation:

```bash id="wkm8ci"
docker --version
docker compose version
```

---

## Running the Environment

From the root of the project, execute:

```bash id="drq7yx"
docker compose up -d
```

This will start the PostgreSQL container and initialize the database.

---

## Manual Alternative

If the Docker Compose setup does not work as expected, the container can be created manually:

```bash id="mxm8o7"
docker run -d --name miacaomigo-db -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=1234 -e POSTGRES_DB=miacaomigo -p 5433:5432 postgres:15
```

---

## Database Access

Use the following connection parameters:

* Host: localhost
* Port: 5433
* Database: miacaomigo
* Username: postgres
* Password: 1234

---

## Port Configuration Justification

The database is exposed on port **5433** instead of the default PostgreSQL port **5432**.

This avoids conflicts with local PostgreSQL installations, which typically use port 5432. By mapping port 5433 on the host to port 5432 inside the container, multiple PostgreSQL instances can run simultaneously without interference.

---

## Connecting via Visual Studio Code

To interact with the database, it is recommended to use Visual Studio Code with the PostgreSQL extension.

After installing the extension:

1. Open the PostgreSQL panel
2. Create a new connection
3. Use the connection parameters defined above

---

## Initialization Scripts

SQL scripts placed in `01_DB/init/` are executed automatically when the database is created for the first time.

Scripts are executed in alphabetical order, so proper naming is required to maintain dependencies.

---

## Data Persistence

The database uses a Docker volume to ensure that data is preserved across container restarts.

---

## Resetting the Environment

To remove all data and recreate the database:

```bash id="v7l4gl"
docker compose down -v
docker compose up -d
```

This operation deletes all stored data.

---

## Notes

* Initialization scripts run only during the first container creation
* A fixed PostgreSQL version is used to ensure stability
* Port 5433 is used to avoid conflicts with local installations
