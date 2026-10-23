# Secure Banking Database System

## Overview

This project implements a secure banking database using **PostgreSQL**.  
The system models customers, bank accounts, and financial transactions while enforcing strong **data integrity and security controls**.

Security mechanisms such as **Role-Based Access Control (RBAC)**, **Row-Level Security (RLS)**, encryption functions, and audit logging are used to protect sensitive financial data and restrict access based on user roles.

The project demonstrates practical database design, access control implementation, and security-focused data management.

---

## Key Features

- **Role-Based Access Control (RBAC)** for structured privilege management  
- **Row-Level Security (RLS)** policies on accounts and transactions (see "Known issue" below: customers see only their own rows once the policy fix is applied)  
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
| Row-Level Security | Limits which rows each role can read (see Known issue) |
| Column Restrictions | Prevents exposure of sensitive attributes |
| Encryption | Protects sensitive data using pgcrypto |
| Audit Logging | Tracks INSERT, UPDATE, DELETE activity |
| Constraints & Triggers | Maintains transactional integrity |

---

## Known issue

In `security/access_control.sql` the teller policy has no `TO teller` clause, so
it applies to every role. PostgreSQL combines permissive policies with OR, so
customers can also read every Active account. Three changes fix it, tested on a
scratch database:

1. Add `TO teller` to `teller_can_see_active_accounts`.
2. Add `TO customer` to `customer_can_only_see_their_accounts` and
   `customer_can_only_see_their_transactions`.
3. Add `GRANT SELECT (CustomerID) ON Customer_Accounts TO customer;` to
   `security/privileges.sql`.

After these, customers see only their own accounts and transactions, and the
teller sees Active accounts only. Tellers have no transaction policy, so they
see no transactions.

---

## Purpose

This project demonstrates **secure relational database design**, combining structured SQL schema development with practical **access control and data protection mechanisms** commonly required in financial systems.