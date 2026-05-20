TestData — dependency chain (fixtures only)
===========================================

DEFAULT QA CHAIN (04_Loaders/03_TestData.sql)
  1. 01_Module1/02_CreationStress.sql
  2. 02_Module2/01_Module2_Fixtures.sql
  3. 04_Module4/01_Module4_Fixtures.sql

ALTERNATIVE (mutually exclusive with CreationStress)
  01_Module1/01_AuthenticationStress.sql — auth volume only

ISOLATED (not in default loader)
  03_Module3/01_Module3_VolumeStress.sql — commercial volume; empty or isolated DB

EXECUTABLE TESTS
  See 01_DB/Tests/README.md and Tests/runners/
