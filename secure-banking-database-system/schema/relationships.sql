-- Customer_Accounts references Customers
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_customer_accounts_customer'
    ) THEN
        ALTER TABLE Customer_Accounts
        ADD CONSTRAINT fk_customer_accounts_customer
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE;
    END IF;
END $$;

-- Transactions references Customer_Accounts
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_transactions_account'
    ) THEN
        ALTER TABLE Transactions
        ADD CONSTRAINT fk_transactions_account
        FOREIGN KEY (AccountID) REFERENCES Customer_Accounts(AccountID) ON DELETE CASCADE;
    END IF;
END $$;

-- Loans references Customers
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_loans_customer'
    ) THEN
        ALTER TABLE Loans
        ADD CONSTRAINT fk_loans_customer
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE;
    END IF;
END $$;

-- Audit_Trail references Users
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_audit_trail_user'
    ) THEN
        ALTER TABLE Audit_Trail
        ADD CONSTRAINT fk_audit_trail_user
        FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE;
    END IF;
END $$;