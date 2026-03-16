-- 1. Retrieve all customer accounts
SELECT * FROM Customer_Accounts;

-- 2. Get all transactions for a specific account
SELECT * FROM Transactions WHERE AccountID = 123;

-- 3. Get the balance of a specific account
SELECT Balance FROM Customer_Accounts WHERE AccountID = 123;

-- 4. List all active loans
SELECT * FROM Loans WHERE Status = 'Approved';

-- 5. Get audit trail logs for a specific user
SELECT * FROM Audit_Trail WHERE UserID = 1 ORDER BY Timestamp DESC;

-- 6. Count total number of customers
SELECT COUNT(*) AS Total_Customers FROM Customers;

-- 7. Find customers with a balance above a certain amount
SELECT * FROM Customer_Accounts WHERE Balance > 5000;

-- 8. Get recent transactions (last 30 days)
SELECT * FROM Transactions WHERE Timestamp >= NOW() - INTERVAL '30 days';

-- 9. Retrieve all employees by role
SELECT * FROM Employees WHERE Role = 'Teller';

-- 10. Check users with failed login attempts (if audit trail logs authentication failures)
SELECT * FROM Audit_Trail WHERE Action LIKE 'Failed Login%' ORDER BY Timestamp DESC;
