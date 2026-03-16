-- Encryption & Secure Data Storage
-- Ensure sensitive data like passwords and transactions are securely stored

-- Enable pgcrypto Extension for Encryption
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Secure Password Hashing using bcrypt
UPDATE Users
SET PasswordHash = crypt(PasswordHash, gen_salt('bf'));

-- Function to Insert a New User with Hashed Password
CREATE OR REPLACE FUNCTION create_user(_username TEXT, _password TEXT, _role TEXT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO Users (Username, PasswordHash, Role)
    VALUES (_username, crypt(_password, gen_salt('bf')), _role);
END;
$$ LANGUAGE plpgsql;

-- Encrypt Transaction Details (Sensitive Data Protection)
ALTER TABLE Transactions ADD COLUMN EncryptedDetails BYTEA;

-- Encrypt Transaction Amounts for Additional Security
CREATE OR REPLACE FUNCTION encrypt_transaction(_transaction_id INT, _amount DECIMAL)
RETURNS VOID AS $$
DECLARE
    encrypted_data BYTEA;
BEGIN
    encrypted_data := pgp_sym_encrypt(_amount::TEXT, 'your_secure_key');
    UPDATE Transactions SET EncryptedDetails = encrypted_data WHERE TransactionID = _transaction_id;
END;
$$ LANGUAGE plpgsql;

-- Decrypt Transaction Data (Only for Authorised Users)
CREATE OR REPLACE FUNCTION decrypt_transaction(_transaction_id INT)
RETURNS TEXT AS $$
DECLARE
    decrypted_data TEXT;
BEGIN
    SELECT pgp_sym_decrypt(EncryptedDetails, 'your_secure_key') INTO decrypted_data
    FROM Transactions WHERE TransactionID = _transaction_id;
    RETURN decrypted_data;
END;
$$ LANGUAGE plpgsql;
    