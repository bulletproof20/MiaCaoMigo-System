# Sanity tests (optional)

`Schema/03_Loaders/07_Sanity_Check.sql` runs automatically at the end of `init.sql`.
It performs **light catalog smoke** only (extensions, ENUMs, table/trigger/view/function listings).

This folder is reserved for **optional** stronger post-init checks that must **not**
bloat the official bootstrap (e.g. minimum row counts after a gated seed).

Do not add heavy business validation or stress tests here.
