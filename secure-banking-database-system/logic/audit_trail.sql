CREATE OR REPLACE FUNCTION log_audit() RETURNS TRIGGER AS $$ 
DECLARE
    record_id INT;
    user_id INT;
    admin_exists BOOLEAN;
BEGIN
    -- Check if admin user exists
    SELECT EXISTS(SELECT 1 FROM Users WHERE Username = 'admin') INTO admin_exists;
    
    -- Fetch UserID based on current user session
    SELECT UserID INTO user_id FROM Users WHERE Username = current_user;

    -- If UserID is NULL (e.g., system operations), use the admin user if available
    IF user_id IS NULL THEN
        IF admin_exists THEN
            -- Use admin user ID
            SELECT UserID INTO user_id FROM Users WHERE Username = 'admin' LIMIT 1;
        ELSE
            -- Skip audit logging if no valid user ID is available
            -- or create a system user at this point
            RETURN NEW;
        END IF;
    END IF;

    -- Dynamically set RecordID based on affected table
    IF TG_TABLE_NAME = 'customer_accounts' THEN
        record_id := COALESCE(NEW.AccountID, OLD.AccountID);
    ELSIF TG_TABLE_NAME = 'transactions' THEN
        record_id := COALESCE(NEW.TransactionID, OLD.TransactionID);
    ELSIF TG_TABLE_NAME = 'loans' THEN
        record_id := COALESCE(NEW.LoanID, OLD.LoanID);
    ELSE
        record_id := NULL;
    END IF;

    -- Insert audit log - only if we have a valid user_id
    IF user_id IS NOT NULL THEN
        INSERT INTO Audit_Trail (UserID, TableName, Action, RecordID, Timestamp)
        VALUES (user_id, TG_TABLE_NAME, TG_OP, record_id, NOW());
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;