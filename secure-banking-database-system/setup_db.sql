-- Step 1: Reset Data Before Setup
\i IM.sql  

-- Step 2: Connect to the Database
\c bank_db

-- Step 3: Run Schema & Database Structure
\i schema/tables.sql
\i schema/relationships.sql
\i schema/constraints.sql
\i schema/index.sql

-- Step 4: Create Roles & Apply Security Measures
\i security/privileges.sql  
\i security/access_control.sql
\i security/encryption.sql

-- Step 5: Add Business Logic
\i logic/audit_trail.sql
\i logic/triggers.sql
\i logic/procedures.sql

-- Step 6: Insert Sample Data
\i data/seed.sql

-- Step 7: Run Testing Scripts to Validate Everything
\i test_scripts/constraint_tests.sql
\i test_scripts/role_tests.sql
\i test_scripts/security_tests.sql

-- Completion Message
SELECT 'Database setup complete! Everything is ready to go.' AS status;