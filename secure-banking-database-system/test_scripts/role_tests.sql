-- Grant Necessary Privileges Before Running Tests
GRANT SELECT ON Loans TO loan_officer; 
GRANT SELECT, UPDATE ON Transactions TO teller;
GRANT SELECT, INSERT, UPDATE ON Customer_Accounts TO teller;


-- Test 1: Bank Manager Access (Full Access)

SET ROLE bank_manager;  
SELECT * FROM Customers;
SELECT * FROM Transactions;

-- Perform an update (Increase Balance)
UPDATE Customer_Accounts SET Balance = Balance + 1000 WHERE AccountID = 1;

-- Validate that the update is logged in the audit trail
SELECT * FROM Audit_Trail 
WHERE TableName = 'Customer_Accounts' AND Action = 'UPDATE' 
AND RecordID = 1 ORDER BY Timestamp DESC LIMIT 1;

-- Perform a delete operation
DELETE FROM Loans WHERE LoanID = 1;

-- Validate that the delete action is logged
SELECT * FROM Audit_Trail 
WHERE TableName = 'Loans' AND Action = 'DELETE' 
AND RecordID = 1 ORDER BY Timestamp DESC LIMIT 1;


-- Test 2: Loan Officer Access (Read-Only on Loans)

SET ROLE loan_officer;  
SELECT * FROM Loans;

-- Unauthorised Update (Should Fail)
DO $$ BEGIN 
    BEGIN UPDATE Loans SET Status = 'Approved' WHERE LoanID = 1;  
    EXCEPTION WHEN insufficient_privilege THEN RAISE NOTICE 'Test Passed: Loan Officer cannot update loans';
    END;
END $$;

-- Unauthorised Delete (Should Fail)
DO $$ BEGIN 
    BEGIN DELETE FROM Loans WHERE LoanID = 1;  
    EXCEPTION WHEN insufficient_privilege THEN RAISE NOTICE 'Test Passed: Loan Officer cannot delete loans';
    END;
END $$;


-- Test 3: Teller Access (View Accounts and Process Transactions)

SET ROLE teller;  
SELECT * FROM Customer_Accounts WHERE Status = 'Active';
SELECT * FROM Transactions;

-- Unauthorised Delete (Expected to Fail)
DO $$ BEGIN 
    BEGIN DELETE FROM Customers WHERE CustomerID = 1;  
    EXCEPTION WHEN insufficient_privilege THEN RAISE NOTICE 'Test Passed: Teller cannot delete customers';
    END;
END $$;

-- Validate that teller updates are logged
SELECT * FROM Audit_Trail 
WHERE TableName = 'Transactions' AND Action = 'UPDATE'
ORDER BY Timestamp DESC LIMIT 1;

-- Test 4: Customer Access (Restricted to Own Data)

SET ROLE customer;  
SELECT * FROM Customer_Accounts 
WHERE CustomerID = (SELECT UserID FROM Users WHERE Username = current_user);
SELECT * FROM Transactions 
WHERE AccountID IN (SELECT AccountID FROM Customer_Accounts 
WHERE CustomerID = (SELECT UserID FROM Users WHERE Username = current_user));

-- Unauthorised Balance Update (Expected to Fail)
DO $$ BEGIN 
    BEGIN UPDATE Customer_Accounts SET Balance = 5000 WHERE AccountID = 1;  
    EXCEPTION WHEN insufficient_privilege THEN RAISE NOTICE 'Test Passed: Customer cannot update balance';
    END;
END $$;

-- Validate unauthorised attempts are logged
SELECT * FROM Audit_Trail 
WHERE TableName = 'Customer_Accounts' AND Action = 'UPDATE'
ORDER BY Timestamp DESC LIMIT 1;

-- Reset Role to Default
RESET ROLE;