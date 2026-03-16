-- Insert Customers
INSERT INTO Customers (FullName, Email, Phone, Address) VALUES
('Alice Johnson', 'alice@example.com', '123-456-7890', '123 Elm Street'),
('Bob Smith', 'bob@example.com', '987-654-3210', '456 Oak Avenue');

-- Insert Customer Accounts
INSERT INTO Customer_Accounts (CustomerID, AccountType, Balance, Status) VALUES
(1, 'Savings', 5000.00, 'Active'),
(1, 'Checking', 1500.00, 'Active'),
(2, 'Business', 10000.00, 'Active');

-- Insert Transactions
INSERT INTO Transactions (AccountID, TransactionType, Amount) VALUES
(1, 'Deposit', 2000.00),
(2, 'Withdraw', 500.00),
(3, 'Payment', 1200.00);

-- Insert Loans
INSERT INTO Loans (CustomerID, LoanAmount, InterestRate, LoanTerm, Status) VALUES
(1, 10000.00, 5.5, 24, 'Approved'),
(2, 5000.00, 4.2, 12, 'Pending');

-- Insert Employees
INSERT INTO Employees (FullName, Role, Email, Phone) VALUES
('Clara Evans', 'BankManager', 'clara.manager@example.com', '555-111-2222'),
('David Brown', 'Teller', 'david.teller@example.com', '555-333-4444');

-- Insert Users (Hashed passwords should be handled by application logic)
INSERT INTO Users (Username, PasswordHash, Role) VALUES
('alicej', crypt('password123', gen_salt('bf')), 'Customer'),
('bobs', crypt('securepass', gen_salt('bf')), 'Customer'),
('claram', crypt('adminpass', gen_salt('bf')), 'BankManager'),
('davidb', crypt('tellerpass', gen_salt('bf')), 'Teller');
