-- Insert Customers with Existence Check
DO $$ 
BEGIN 
    INSERT INTO Customers (FullName, Email, Phone, Address)
    SELECT FullName, Email, Phone, Address FROM (
        VALUES
        ('Alice Johnson', 'alice@example.com', '123-456-7890', '123 Elm Street'),
        ('Bob Smith', 'bob@example.com', '987-654-3210', '456 Oak Avenue'),
        ('Charlie Davis', 'charlie@example.com', '555-777-9999', '789 Maple Drive'),
        ('Diana Green', 'diana.green@example.com', '555-222-3333', '321 Pine Road'),
        ('Edward Clark', 'edward.clark@example.com', '555-888-9999', '654 Birch Lane'),
        ('Fiona Adams', 'fiona.adams@example.com', '555-444-5555', '852 Cedar Street'),
        ('George Thomas', 'george.thomas@example.com', '555-999-1111', '963 Spruce Drive')
    ) AS c(FullName, Email, Phone, Address)
    WHERE NOT EXISTS (
        SELECT 1 FROM Customers WHERE Customers.Email = c.Email
    );
END $$;

-- Insert Customer Accounts with Correct Foreign Key Handling
DO $$ 
BEGIN 
    INSERT INTO Customer_Accounts (CustomerID, AccountType, Balance, Status)
    SELECT c.CustomerID, ca.AccountType, ca.Balance, ca.Status FROM (
        VALUES
        ('alice@example.com', 'Savings', 5000.00, 'Active'),
        ('bob@example.com', 'Business', 10000.00, 'Active'),
        ('charlie@example.com', 'Checking', 2500.00, 'Frozen'),
        ('diana.green@example.com', 'Savings', 8000.00, 'Active'),
        ('edward.clark@example.com', 'Business', 15000.00, 'Active'),
        ('fiona.adams@example.com', 'Checking', 3200.00, 'Active'),
        ('george.thomas@example.com', 'Savings', 6000.00, 'Frozen')
    ) AS ca(Email, AccountType, Balance, Status)
    JOIN Customers c ON c.Email = ca.Email
    WHERE NOT EXISTS (
        SELECT 1 FROM Customer_Accounts WHERE Customer_Accounts.CustomerID = c.CustomerID AND Customer_Accounts.AccountType = ca.AccountType
    );
END $$;

-- Insert Transactions with Correct Foreign Key Handling
DO $$ 
BEGIN 
    INSERT INTO Transactions (AccountID, TransactionType, Amount)
    SELECT ca.AccountID, t.TransactionType, t.Amount FROM (
        VALUES
        ('alice@example.com', 'Deposit', 2500.00),
        ('bob@example.com', 'Withdraw', 1200.00),
        ('charlie@example.com', 'Payment', 500.00),
        ('diana.green@example.com', 'Deposit', 3000.00),
        ('edward.clark@example.com', 'Withdraw', 700.00)
    ) AS t(Email, TransactionType, Amount)
    JOIN Customers c ON c.Email = t.Email
    JOIN Customer_Accounts ca ON ca.CustomerID = c.CustomerID
    WHERE NOT EXISTS (
        SELECT 1 FROM Transactions WHERE Transactions.AccountID = ca.AccountID AND Transactions.TransactionType = t.TransactionType
    );
END $$;

-- Insert Employees with Existence Check
DO $$ 
BEGIN 
    INSERT INTO Employees (FullName, Role, Email, Phone)
    SELECT FullName, Role, Email, Phone FROM (
        VALUES
        ('Clara Evans', 'BankManager', 'clara.manager@example.com', '555-111-2222'),
        ('David Brown', 'Teller', 'david.teller@example.com', '555-333-4444'),
        ('Emma Wilson', 'LoanOfficer', 'emma.loan@example.com', '555-666-7777')
    ) AS emp(FullName, Role, Email, Phone)
    WHERE NOT EXISTS (
        SELECT 1 FROM Employees WHERE Employees.Email = emp.Email
    );
END $$;

-- Insert Users with Existence Check
DO $$ 
BEGIN 
    INSERT INTO Users (Username, PasswordHash, Role)
    SELECT Username, PasswordHash, Role FROM (
        VALUES
        ('alicej', crypt('password123', gen_salt('bf')), 'Customer'),
        ('bobs', crypt('securepass', gen_salt('bf')), 'Customer'),
        ('charlied', crypt('mypassword', gen_salt('bf')), 'Customer'),
        ('claram', crypt('adminpass', gen_salt('bf')), 'BankManager'),
        ('davidb', crypt('tellerpass', gen_salt('bf')), 'Teller'),
        ('emmaw', crypt('loanpass', gen_salt('bf')), 'LoanOfficer')
    ) AS usr(Username, PasswordHash, Role)
    WHERE NOT EXISTS (
        SELECT 1 FROM Users WHERE Users.Username = usr.Username
    );
END $$;