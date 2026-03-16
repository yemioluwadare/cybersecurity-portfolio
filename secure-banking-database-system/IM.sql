-- Disable foreign key constraints temporarily
SET session_replication_role = 'replica';

-- Clear all data in the correct order to prevent foreign key violations
DELETE FROM Audit_Trail;
DELETE FROM Transactions;
DELETE FROM Customer_Accounts;
DELETE FROM Loans;
DELETE FROM Customers;
DELETE FROM Employees;
DELETE FROM Users;

-- Reset auto-increment sequences (fixes the invalid sequence error)
DO $$ 
DECLARE seq_name TEXT;
BEGIN
    FOR seq_name IN 
        SELECT pg_class.relname 
        FROM pg_class 
        JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace 
        WHERE pg_class.relkind = 'S'  -- 'S' = Sequence
        AND pg_namespace.nspname = 'public'  -- Adjust schema if needed
    LOOP
        EXECUTE format('ALTER SEQUENCE %I RESTART WITH 1', seq_name);
    END LOOP;
END $$;

-- Reinsert the default system user to prevent audit trail issues
INSERT INTO Users (Username, PasswordHash, Role)
VALUES ('system_admin', crypt('defaultpass', gen_salt('bf')), 'BankManager')
ON CONFLICT (Username) DO NOTHING;

-- Re-enable foreign key constraints
SET session_replication_role = 'origin';