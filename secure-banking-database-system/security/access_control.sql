-- Enable Row-Level Security (RLS) on Sensitive Tables
ALTER TABLE Customer_Accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE Transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE Loans ENABLE ROW LEVEL SECURITY;

-- Row-Level Security Policies

-- Customers can only see their own accounts
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE policyname = 'customer_can_only_see_their_accounts'
    ) THEN
        CREATE POLICY customer_can_only_see_their_accounts
        ON Customer_Accounts
        FOR SELECT
        USING (CustomerID = current_user::int);
    END IF;
END $$;

-- Customers can only see their own transactions
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE policyname = 'customer_can_only_see_their_transactions'
    ) THEN
        CREATE POLICY customer_can_only_see_their_transactions
        ON Transactions
        FOR SELECT
        USING (AccountID IN (SELECT AccountID FROM Customer_Accounts WHERE CustomerID = current_user::int));
    END IF;
END $$;

-- Tellers can only see active accounts
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE policyname = 'teller_can_see_active_accounts'
    ) THEN
        CREATE POLICY teller_can_see_active_accounts
        ON Customer_Accounts
        FOR SELECT
        USING (Status = 'Active');
    END IF;
END $$;

-- Loan Officers can only see loans, not modify them
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE policyname = 'loan_officer_can_see_loans'
    ) THEN
        CREATE POLICY loan_officer_can_see_loans
        ON Loans
        FOR SELECT
        USING (TRUE);
    END IF;
END $$;

-- Bank Managers have full access (Superuser role is needed)
-- No specific policy needed as they have all privileges from `privileges.sql`

-- Column-Level Security (Masking Sensitive Data)
-- Hide full email and phone from tellers, only last 4 digits visible
CREATE OR REPLACE VIEW Teller_View AS
SELECT CustomerID, FullName, 
       CONCAT('***-***-', RIGHT(Phone, 4)) AS MaskedPhone, 
       CONCAT(LEFT(Email, 3), '***@***.com') AS MaskedEmail
FROM Customers;

-- Apply Security Restrictions to the View
REVOKE ALL ON Teller_View FROM PUBLIC;
GRANT SELECT ON Teller_View TO teller;

-- Ensure Security Policies are Applied
ALTER TABLE Customer_Accounts FORCE ROW LEVEL SECURITY;
ALTER TABLE Transactions FORCE ROW LEVEL SECURITY;
ALTER TABLE Loans FORCE ROW LEVEL SECURITY;
