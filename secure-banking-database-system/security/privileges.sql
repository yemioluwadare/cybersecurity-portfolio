-- Part 1: Create User Roles
DO $$ 
BEGIN
    -- Create bank_manager role if it does not exist
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'bank_manager') THEN
        CREATE ROLE bank_manager;
    END IF;
    
    -- Create loan_officer role if it does not exist
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'loan_officer') THEN
        CREATE ROLE loan_officer;
    END IF;

    -- Create teller role if it does not exist
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'teller') THEN
        CREATE ROLE teller;
    END IF;

    -- Create customer role if it does not exist
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'customer') THEN
        CREATE ROLE customer;
    END IF;
END $$;

-- Part 2: Assign Privileges to Roles

-- Bank Manager: Full access to all tables and sequences
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO bank_manager;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO bank_manager;
GRANT SELECT ON Customers TO bank_manager;
GRANT SELECT ON Transactions TO bank_manager;

-- Loan Officer: Can view customers and loans, but cannot modify transactions
GRANT SELECT ON Customers TO loan_officer;
GRANT SELECT, INSERT, UPDATE ON Loans TO loan_officer;
GRANT SELECT ON Loans TO loan_officer;

-- Teller: Can view customer accounts and process transactions
GRANT SELECT ON Customers TO teller;
GRANT SELECT, INSERT, UPDATE ON Customer_Accounts TO teller;
GRANT SELECT, INSERT, UPDATE ON Transactions TO teller;
GRANT SELECT, UPDATE ON Transactions TO teller;

-- Customer: Can only view their own accounts and transactions
GRANT SELECT (AccountID, AccountType, Balance, Status) ON Customer_Accounts TO customer;
GRANT SELECT (TransactionID, TransactionType, Amount, Timestamp) ON Transactions TO customer;

-- Part 3: Ensure Privileges are Set Correctly

-- Remove all privileges from PUBLIC to enforce access control
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;

-- Part 4: Assign Users to Their Roles

DO $$ 
BEGIN
    -- Assign 'bank_manager' role to postgres if not already assigned
    IF NOT EXISTS (
        SELECT 1 FROM pg_auth_members m
        JOIN pg_roles r ON m.roleid = r.oid
        JOIN pg_roles u ON m.member = u.oid
        WHERE u.rolname = 'postgres' AND r.rolname = 'bank_manager'
    ) THEN
        GRANT bank_manager TO postgres;
    END IF;

    -- Assign 'loan_officer' role to postgres if not already assigned
    IF NOT EXISTS (
        SELECT 1 FROM pg_auth_members m
        JOIN pg_roles r ON m.roleid = r.oid
        JOIN pg_roles u ON m.member = u.oid
        WHERE u.rolname = 'postgres' AND r.rolname = 'loan_officer'
    ) THEN
        GRANT loan_officer TO postgres;
    END IF;

    -- Assign 'teller' role to postgres if not already assigned
    IF NOT EXISTS (
        SELECT 1 FROM pg_auth_members m
        JOIN pg_roles r ON m.roleid = r.oid
        JOIN pg_roles u ON m.member = u.oid
        WHERE u.rolname = 'postgres' AND r.rolname = 'teller'
    ) THEN
        GRANT teller TO postgres;
    END IF;

    -- Assign 'customer' role to postgres if not already assigned
    IF NOT EXISTS (
        SELECT 1 FROM pg_auth_members m
        JOIN pg_roles r ON m.roleid = r.oid
        JOIN pg_roles u ON m.member = u.oid
        WHERE u.rolname = 'postgres' AND r.rolname = 'customer'
    ) THEN
        GRANT customer TO postgres;
    END IF;
END $$;