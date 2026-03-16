-- Index on CustomerID for faster lookups in Customer_Accounts

DO $$ BEGIN 
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_customer_accounts') THEN
        CREATE INDEX idx_customer_accounts ON Customer_Accounts(CustomerID);
    END IF;
END $$;

-- Index on AccountID for faster transaction queries
DO $$ BEGIN 
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_transactions') THEN
        CREATE INDEX idx_transactions ON Transactions(AccountID);
    END IF;
END $$;

-- Index on CustomerID for faster loan lookups
DO $$ BEGIN 
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_loans') THEN
        CREATE INDEX idx_loans ON Loans(CustomerID);
    END IF;
END $$;

-- Index on Username for quick user authentication lookup
DO $$ BEGIN 
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_users_username') THEN
        CREATE UNIQUE INDEX idx_users_username ON Users(Username);
    END IF;
END $$;

-- Index on Email for employees and customers to speed up searches
DO $$ BEGIN 
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_customers_email') THEN
        CREATE UNIQUE INDEX idx_customers_email ON Customers(Email);
    END IF;
END $$;
DO $$ BEGIN 
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_employees_email') THEN
        CREATE UNIQUE INDEX idx_employees_email ON Employees(Email);
    END IF;
END $$;

-- Index on Audit_Trail for tracking recent activity efficiently
DO $$ BEGIN 
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_audit_trail') THEN
        CREATE INDEX idx_audit_trail ON Audit_Trail(Timestamp DESC);
    END IF;
END $$;
