-- Users Table (for Authentication)
CREATE TABLE IF NOT EXISTS Users (
    UserID SERIAL PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    PasswordHash TEXT NOT NULL,
    Role VARCHAR(20) CHECK (Role IN ('BankManager', 'LoanOfficer', 'Teller', 'Customer')) NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customers Table
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID SERIAL PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    Address TEXT NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customer Accounts Table
CREATE TABLE IF NOT EXISTS Customer_Accounts (
    AccountID SERIAL PRIMARY KEY,
    CustomerID INT NOT NULL,
    AccountType VARCHAR(20) CHECK (AccountType IN ('Savings', 'Checking', 'Business')) NOT NULL,
    Balance DECIMAL(15,2) CHECK (Balance >= 0) DEFAULT 0.00,
    Status VARCHAR(10) CHECK (Status IN ('Active', 'Frozen', 'Closed')) NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

-- Transactions Table
CREATE TABLE IF NOT EXISTS Transactions (
    TransactionID SERIAL PRIMARY KEY,
    AccountID INT NOT NULL,
    TransactionType VARCHAR(20) CHECK (TransactionType IN ('Deposit', 'Withdraw', 'Transfer', 'Payment')) NOT NULL,
    Amount DECIMAL(15,2) CHECK (Amount > 0) NOT NULL,
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AccountID) REFERENCES Customer_Accounts(AccountID) ON DELETE CASCADE
);

-- Loans Table
CREATE TABLE IF NOT EXISTS Loans (
    LoanID SERIAL PRIMARY KEY,
    CustomerID INT NOT NULL,
    LoanAmount DECIMAL(15,2) CHECK (LoanAmount > 0) NOT NULL,
    InterestRate DECIMAL(5,2) CHECK (InterestRate > 0 AND InterestRate <= 100) NOT NULL,
    LoanTerm INT CHECK (LoanTerm > 0) NOT NULL, -- in months
    Status VARCHAR(10) CHECK (Status IN ('Pending', 'Approved', 'Rejected', 'Paid')) NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

-- Employees Table
CREATE TABLE IF NOT EXISTS Employees (
    EmployeeID SERIAL PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Role VARCHAR(20) CHECK (Role IN ('BankManager', 'LoanOfficer', 'Teller')) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit Trail Table
CREATE TABLE IF NOT EXISTS Audit_Trail (
    AuditID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    TableName VARCHAR(255) NOT NULL,
    Action VARCHAR(255) NOT NULL,
    RecordID INT,
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Indexes for Performance Optimisation
CREATE INDEX IF NOT EXISTS idx_customer_accounts ON Customer_Accounts(CustomerID);
CREATE INDEX IF NOT EXISTS idx_transactions ON Transactions(AccountID);
CREATE INDEX IF NOT EXISTS idx_loans ON Loans(CustomerID);
CREATE INDEX IF NOT EXISTS idx_users_role ON Users(Role);
CREATE INDEX IF NOT EXISTS idx_audit_trail ON Audit_Trail(UserID);

-- Unique Constraints (If Not Already Exists)
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'unique_customer_email') THEN
        ALTER TABLE Customers ADD CONSTRAINT unique_customer_email UNIQUE (Email);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'unique_employee_email') THEN
        ALTER TABLE Employees ADD CONSTRAINT unique_employee_email UNIQUE (Email);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'unique_customer_phone') THEN
        ALTER TABLE Customers ADD CONSTRAINT unique_customer_phone UNIQUE (Phone);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'unique_employee_phone') THEN
        ALTER TABLE Employees ADD CONSTRAINT unique_employee_phone UNIQUE (Phone);
    END IF;
END $$;

-- Check Constraints (If Not Already Exists)
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.check_constraints WHERE constraint_name = 'check_account_type') THEN
        ALTER TABLE Customer_Accounts ADD CONSTRAINT check_account_type CHECK (AccountType IN ('Savings', 'Checking', 'Business'));
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.check_constraints WHERE constraint_name = 'check_account_status') THEN
        ALTER TABLE Customer_Accounts ADD CONSTRAINT check_account_status CHECK (Status IN ('Active', 'Frozen', 'Closed'));
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.check_constraints WHERE constraint_name = 'check_transaction_type') THEN
        ALTER TABLE Transactions ADD CONSTRAINT check_transaction_type CHECK (TransactionType IN ('Deposit', 'Withdraw', 'Transfer', 'Payment'));
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.check_constraints WHERE constraint_name = 'check_loan_status') THEN
        ALTER TABLE Loans ADD CONSTRAINT check_loan_status CHECK (Status IN ('Pending', 'Approved', 'Rejected', 'Paid'));
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.check_constraints WHERE constraint_name = 'check_positive_balance') THEN
        ALTER TABLE Customer_Accounts ADD CONSTRAINT check_positive_balance CHECK (Balance >= 0);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.check_constraints WHERE constraint_name = 'check_positive_loan_amount') THEN
        ALTER TABLE Loans ADD CONSTRAINT check_positive_loan_amount CHECK (LoanAmount > 0);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.check_constraints WHERE constraint_name = 'check_valid_interest_rate') THEN
        ALTER TABLE Loans ADD CONSTRAINT check_valid_interest_rate CHECK (InterestRate > 0 AND InterestRate <= 100);
    END IF;
END $$;

-- Completion Message
SELECT 'Tables created or verified successfully!' AS status;