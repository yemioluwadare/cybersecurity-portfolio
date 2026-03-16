-- Procedure to Deposit Money into an Account
CREATE OR REPLACE FUNCTION deposit_money(_account_id INT, _amount DECIMAL)
RETURNS VOID AS $$
BEGIN
    -- Ensure only authorised bank staff can execute this
    IF NOT current_user IN ('bank_manager', 'teller') THEN
        INSERT INTO Audit_Trail (UserID, TableName, Action, RecordID, Timestamp)
        VALUES ((SELECT UserID FROM Users WHERE Username = current_user), 'SECURITY_ALERT', 'Unauthorised Deposit Attempt', _account_id, NOW());
        RAISE EXCEPTION 'Unauthorised access: You do not have permission to deposit funds';
    END IF;

    -- Prevent negative or zero deposits
    IF _amount <= 0 THEN
        RAISE EXCEPTION 'Deposit amount must be positive';
    END IF;
    
    -- Secure transaction block
    BEGIN
        -- Update account balance
        UPDATE Customer_Accounts
        SET Balance = Balance + _amount
        WHERE AccountID = _account_id;

        -- Log transaction
        INSERT INTO Transactions (AccountID, TransactionType, Amount)
        VALUES (_account_id, 'Deposit', _amount);

        -- Log audit trail
        INSERT INTO Audit_Trail (UserID, TableName, Action, RecordID, Timestamp)
        VALUES ((SELECT UserID FROM Users WHERE Username = current_user), 'Customer_Accounts', 'Deposit', _account_id, NOW());
    COMMIT;
    END;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Restrict execution privileges
REVOKE EXECUTE ON FUNCTION deposit_money FROM PUBLIC;
GRANT EXECUTE ON FUNCTION deposit_money TO bank_manager, teller;

-- Procedure to Withdraw Money from an Account
CREATE OR REPLACE FUNCTION withdraw_money(_account_id INT, _amount DECIMAL)
RETURNS VOID AS $$
BEGIN
    -- Ensure only authorised bank staff can execute this
    IF NOT current_user IN ('bank_manager', 'teller') THEN
        INSERT INTO Audit_Trail (UserID, TableName, Action, RecordID, Timestamp)
        VALUES ((SELECT UserID FROM Users WHERE Username = current_user), 'SECURITY_ALERT', 'Unauthorised Withdraw Attempt', _account_id, NOW());
        RAISE EXCEPTION 'Unauthorised access: You do not have permission to withdraw funds';
    END IF;

    -- Prevent negative or zero withdrawals
    IF _amount <= 0 THEN
        RAISE EXCEPTION 'Withdrawal amount must be positive';
    END IF;

    -- Check if balance is sufficient
    IF (SELECT Balance FROM Customer_Accounts WHERE AccountID = _account_id) < _amount THEN
        RAISE EXCEPTION 'Insufficient funds';
    END IF;
    
    -- Secure transaction block
    BEGIN
        -- Update balance
        UPDATE Customer_Accounts
        SET Balance = Balance - _amount
        WHERE AccountID = _account_id;

        -- Log transaction
        INSERT INTO Transactions (AccountID, TransactionType, Amount)
        VALUES (_account_id, 'Withdraw', _amount);

        -- Log audit trail
        INSERT INTO Audit_Trail (UserID, TableName, Action, RecordID, Timestamp)
        VALUES ((SELECT UserID FROM Users WHERE Username = current_user), 'Customer_Accounts', 'Withdraw', _account_id, NOW());
    COMMIT;
    END;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Restrict execution privileges
REVOKE EXECUTE ON FUNCTION withdraw_money FROM PUBLIC;
GRANT EXECUTE ON FUNCTION withdraw_money TO bank_manager, teller;

-- Procedure to Transfer Money Between Accounts
CREATE OR REPLACE FUNCTION transfer_money(_from_account INT, _to_account INT, _amount DECIMAL)
RETURNS VOID AS $$
BEGIN
    -- Ensure only authorised bank staff can execute this
    IF NOT current_user IN ('bank_manager', 'teller') THEN
        INSERT INTO Audit_Trail (UserID, TableName, Action, RecordID, Timestamp)
        VALUES ((SELECT UserID FROM Users WHERE Username = current_user), 'SECURITY_ALERT', 'Unauthorised Transfer Attempt', _from_account, NOW());
        RAISE EXCEPTION 'Unauthorised access: You do not have permission to transfer funds';
    END IF;

    -- Prevent negative or zero transfers
    IF _amount <= 0 THEN
        RAISE EXCEPTION 'Transfer amount must be positive';
    END IF;

    -- Check if sender has enough funds
    IF (SELECT Balance FROM Customer_Accounts WHERE AccountID = _from_account) < _amount THEN
        RAISE EXCEPTION 'Insufficient funds for transfer';
    END IF;
    
    -- Secure transaction block
    BEGIN
        -- Debit sender's account
        UPDATE Customer_Accounts
        SET Balance = Balance - _amount
        WHERE AccountID = _from_account;

        -- Credit recipient's account
        UPDATE Customer_Accounts
        SET Balance = Balance + _amount
        WHERE AccountID = _to_account;

        -- Log transaction
        INSERT INTO Transactions (AccountID, TransactionType, Amount)
        VALUES (_from_account, 'Transfer', _amount),
               (_to_account, 'Transfer', _amount);

        -- Log audit trail for both accounts
        INSERT INTO Audit_Trail (UserID, TableName, Action, RecordID, Timestamp)
        VALUES 
            ((SELECT UserID FROM Users WHERE Username = current_user), 'Customer_Accounts', 'Transfer Out', _from_account, NOW()),
            ((SELECT UserID FROM Users WHERE Username = current_user), 'Customer_Accounts', 'Transfer In', _to_account, NOW());
    COMMIT;
    END;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Restrict execution privileges
REVOKE EXECUTE ON FUNCTION transfer_money FROM PUBLIC;
GRANT EXECUTE ON FUNCTION transfer_money TO bank_manager, teller;
