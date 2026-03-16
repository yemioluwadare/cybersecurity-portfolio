DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'unique_customer_email'
    ) THEN
        ALTER TABLE Customers ADD CONSTRAINT unique_customer_email UNIQUE (Email);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'unique_employee_email'
    ) THEN
        ALTER TABLE Employees ADD CONSTRAINT unique_employee_email UNIQUE (Email);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'unique_customer_phone'
    ) THEN
        ALTER TABLE Customers ADD CONSTRAINT unique_customer_phone UNIQUE (Phone);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'unique_employee_phone'
    ) THEN
        ALTER TABLE Employees ADD CONSTRAINT unique_employee_phone UNIQUE (Phone);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.check_constraints 
        WHERE constraint_name = 'check_account_type'
    ) THEN
        ALTER TABLE Customer_Accounts ADD CONSTRAINT check_account_type CHECK (AccountType IN ('Savings', 'Checking', 'Business'));
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.check_constraints 
        WHERE constraint_name = 'check_account_status'
    ) THEN
        ALTER TABLE Customer_Accounts ADD CONSTRAINT check_account_status CHECK (Status IN ('Active', 'Frozen', 'Closed'));
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.check_constraints 
        WHERE constraint_name = 'check_transaction_type'
    ) THEN
        ALTER TABLE Transactions ADD CONSTRAINT check_transaction_type CHECK (TransactionType IN ('Deposit', 'Withdraw', 'Transfer', 'Payment'));
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.check_constraints 
        WHERE constraint_name = 'check_loan_status'
    ) THEN
        ALTER TABLE Loans ADD CONSTRAINT check_loan_status CHECK (Status IN ('Pending', 'Approved', 'Rejected', 'Paid'));
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.check_constraints 
        WHERE constraint_name = 'check_positive_balance'
    ) THEN
        ALTER TABLE Customer_Accounts ADD CONSTRAINT check_positive_balance CHECK (Balance >= 0);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.check_constraints 
        WHERE constraint_name = 'check_positive_loan_amount'
    ) THEN
        ALTER TABLE Loans ADD CONSTRAINT check_positive_loan_amount CHECK (LoanAmount > 0);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.check_constraints 
        WHERE constraint_name = 'check_valid_interest_rate'
    ) THEN
        ALTER TABLE Loans ADD CONSTRAINT check_valid_interest_rate CHECK (InterestRate > 0 AND InterestRate <= 100);
    END IF;
END $$;