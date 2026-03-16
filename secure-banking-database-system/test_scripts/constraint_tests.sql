-- Test 1: Insert a Customer Account with a Non-Existent CustomerID (Should Fail)
DO $$ 
BEGIN 
    BEGIN 
        INSERT INTO Customer_Accounts (CustomerID, AccountType, Balance, Status)
        VALUES (999, 'Savings', 1000.00, 'Active');  -- Should fail
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'Test 1 Passed: Cannot insert Customer_Account with non-existent CustomerID';
    END;
END $$;

-- Test 2: Insert a Transaction for a Non-Existent Account (Should Fail)
DO $$ 
BEGIN 
    BEGIN 
        INSERT INTO Transactions (AccountID, TransactionType, Amount)
        VALUES (999, 'Deposit', 500.00);  -- Should fail
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'Test 2 Passed: Cannot insert Transaction with non-existent AccountID';
    END;
END $$;

-- Test 3: Insert a Loan with a Negative Amount (Should Fail)
DO $$ 
BEGIN 
    BEGIN 
        INSERT INTO Loans (CustomerID, LoanAmount, InterestRate, LoanTerm, Status)
        VALUES (1, -5000.00, 5.5, 24, 'Approved');  -- Should fail
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE 'Test 3 Passed: Cannot insert Loan with negative amount';
    END;
END $$;

-- Test 4: Insert a User with an Invalid Role (Should Fail)
DO $$ 
BEGIN 
    BEGIN 
        INSERT INTO Users (Username, PasswordHash, Role)
        VALUES ('testuser', crypt('password123', gen_salt('bf')), 'InvalidRole');  -- Should fail
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE 'Test 4 Passed: Cannot insert User with invalid Role';
    END;
END $$;

-- Test 5: Insert an Account with an Invalid Status (Should Fail)
DO $$ 
BEGIN 
    BEGIN 
        INSERT INTO Customer_Accounts (CustomerID, AccountType, Balance, Status)
        VALUES (1, 'Savings', 5000.00, 'Inactive');  -- Should fail
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE 'Test 5 Passed: Cannot insert Customer_Account with invalid Status';
    END;
END $$;

-- Test 6: Update Balance to a Negative Value (Should Fail if Trigger Works)
DO $$ 
BEGIN 
    BEGIN 
        UPDATE Customer_Accounts SET Balance = -500 WHERE AccountID = 1;  -- Should fail
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE 'Test 6 Passed: Cannot update balance to negative';
    END;
END $$;

-- Test 7: Delete a Customer with Active Accounts (Should Fail)
DO $$ 
BEGIN 
    BEGIN 
        DELETE FROM Customers WHERE CustomerID = 1;  -- Should fail
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'Test 7 Passed: Cannot delete Customer with active accounts';
    END;
END $$;