-- Trigger to Log Account Balance Changes in Audit Trail
CREATE OR REPLACE FUNCTION log_balance_changes() RETURNS TRIGGER AS $$
DECLARE 
    user_id INT;
BEGIN
    -- Get the UserID of the current user
    SELECT u.UserID INTO user_id FROM Users u WHERE u.Username = current_user;

    -- Insert into Audit_Trail
    INSERT INTO Audit_Trail (UserID, TableName, Action, RecordID, Timestamp)
    VALUES (COALESCE(user_id, 0), 'Customer_Accounts', 'Balance Updated', NEW.AccountID, NOW());

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create Trigger for Balance Changes
DROP TRIGGER IF EXISTS balance_change_audit ON Customer_Accounts;
CREATE TRIGGER balance_change_audit
AFTER UPDATE ON Customer_Accounts
FOR EACH ROW
WHEN (OLD.Balance <> NEW.Balance)
EXECUTE FUNCTION log_balance_changes();

-- Trigger to Prevent Negative Balances
CREATE OR REPLACE FUNCTION prevent_negative_balance() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Balance < 0 THEN
        RAISE EXCEPTION 'Balance cannot be negative';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create Trigger to Enforce Non-Negative Balance
DROP TRIGGER IF EXISTS enforce_non_negative_balance ON Customer_Accounts;
CREATE TRIGGER enforce_non_negative_balance
BEFORE UPDATE ON Customer_Accounts
FOR EACH ROW
EXECUTE FUNCTION prevent_negative_balance();

-- Trigger to Log Transactions
CREATE OR REPLACE FUNCTION log_transaction() RETURNS TRIGGER AS $$
DECLARE 
    user_id INT;
BEGIN
    -- Get the UserID of the current user
    SELECT u.UserID INTO user_id FROM Users u WHERE u.Username = current_user;

    -- Insert into Audit_Trail
    INSERT INTO Audit_Trail (UserID, TableName, Action, RecordID, Timestamp)
    VALUES (COALESCE(user_id, 0), 'Transactions', 'Transaction Created', NEW.TransactionID, NOW());

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create Trigger for Logging Transactions
DROP TRIGGER IF EXISTS transaction_logging ON Transactions;
CREATE TRIGGER transaction_logging
AFTER INSERT ON Transactions
FOR EACH ROW
EXECUTE FUNCTION log_transaction();