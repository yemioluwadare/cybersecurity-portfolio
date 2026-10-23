# Secure Banking Database System

## Overview

This project implements a secure banking database using **PostgreSQL**.  
The system models customers, bank accounts, and financial transactions while enforcing strong **data integrity and security controls**.

Security mechanisms such as **Role-Based Access Control (RBAC)**, **Row-Level Security (RLS)**, encryption functions, and audit logging are used to protect sensitive financial data and restrict access based on user roles.

The project demonstrates practical database design, access control implementation, and security-focused data management.

---

## Key Features

- **Role-Based Access Control (RBAC)** for structured privilege management  
- **Row-Level Security (RLS)** policies on accounts and transactions, so customers see only their own rows (see "Policy fix" below)  
- **Column-Level Restrictions** to protect sensitive fields  
- **Encryption using pgcrypto** for sensitive data  
- **Audit logging triggers** to track critical database modifications  
- **SQL constraints and relationships** enforcing transactional integrity  

---

## Repository Structure

```
secure-banking-database-system/
│
├── config/        # PostgreSQL configuration and authentication settings
├── schema/        # Table definitions, relationships, constraints, indexes
├── security/      # RBAC policies, row-level security, encryption logic
├── logic/         # Stored procedures, triggers, audit logging
├── data/          # Sample data and database export
├── test_scripts/  # Security and constraint validation tests
│
├── setup_db.sql   # Automated database setup script
├── IM.sql         # Data reset and sequence management
└── README.md
```

---

## Setup

Prerequisites:

- PostgreSQL
- pgcrypto extension enabled

Create the database and run the setup script:

```bash
psql -U postgres -d bank_db -f setup_db.sql
```

Load schema components:

```bash
psql -U postgres -d bank_db -f schema/tables.sql
psql -U postgres -d bank_db -f schema/relationships.sql
psql -U postgres -d bank_db -f schema/constraints.sql
```

---

## Security Controls Implemented

| Control | Purpose |
|------|------|
| RBAC | Restricts database access based on user roles |
| Row-Level Security | Limits which rows each role can read (see Policy fix) |
| Column Restrictions | Prevents exposure of sensitive attributes |
| Encryption | Protects sensitive data using pgcrypto |
| Audit Logging | Tracks INSERT, UPDATE, DELETE activity |
| Constraints & Triggers | Maintains transactional integrity |

---

## Policy fix

The first version of `security/access_control.sql` had no `TO teller` clause on
the teller policy, so it applied to every role. PostgreSQL combines permissive
policies with OR, so customers could also read every Active account. Three
changes, tested on a scratch database, fixed it:

1. `TO teller` on `teller_can_see_active_accounts`.
2. `TO customer` on `customer_can_only_see_their_accounts` and
   `customer_can_only_see_their_transactions`.
3. `GRANT SELECT (CustomerID) ON Customer_Accounts TO customer;` in
   `security/privileges.sql`, because the transactions policy reads that column.

Now customers see only their own accounts and transactions, and the teller sees
Active accounts only. Tellers have no transaction policy, so they see no
transactions.

The policies are created only if no policy of that name exists. On a database
built from the earlier version, drop the three policies and run the file again.

---

## Purpose

This project demonstrates **secure relational database design**, combining structured SQL schema development with practical **access control and data protection mechanisms** commonly required in financial systems.