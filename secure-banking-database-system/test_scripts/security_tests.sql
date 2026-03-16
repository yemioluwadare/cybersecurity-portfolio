-- Test 1: Bank Manager Access (Should Have Full Access) 
SET ROLE bank_manager;
SELECT * FROM Customers;  -- Should return all customers
SELECT * FROM Transactions;  -- Should return all transactions
UPDATE Customer_Accounts SET Balance = Balance + 1000 WHERE AccountID = 1;  -- Should be allowed
DELETE FROM Loans WHERE LoanID = 1;  -- Should be allowed

-- Test 2: Loan Officer Access (Should Only View Loans)
SET ROLE loan_officer;
SELECT * FROM Loans;  -- Should return all loans

-- Test 3: Teller Access (Should Only View Active Customer Accounts and Process Transactions)
SET ROLE teller;
SELECT * FROM Customer_Accounts WHERE Status = 'Active';  -- Should return only active accounts
SELECT * FROM Transactions;  -- Should return all transactions
UPDATE Customer_Accounts SET Balance = Balance - 100 WHERE AccountID = 1;  -- Should be allowed (process transaction)

-- Test 4: Customer Access (Should Only See Own Data)
SET ROLE customer;
SELECT * FROM Customer_Accounts WHERE CustomerID = (SELECT UserID FROM Users WHERE Username = current_user);  -- Should return only the customer’s own accounts
SELECT * FROM Transactions WHERE AccountID IN (
    SELECT AccountID FROM Customer_Accounts WHERE CustomerID = (SELECT UserID FROM Users WHERE Username = current_user)
);  -- Should return only the customer’s transactions

-- Reset Role for Safety
RESET ROLE;