# Secure Banking Database System

## Overview

This project implements a secure banking database using **PostgreSQL**.  
The system models customers, bank accounts, and financial transactions while enforcing strong **data integrity and security controls**.

Security mechanisms such as **Role-Based Access Control (RBAC)**, **Row-Level Security (RLS)**, encryption functions, and audit logging are used to protect sensitive financial data and restrict access based on user roles.

The project demonstrates practical database design, access control implementation, and security-focused data management.

---

## Key Features

- **Role-Based Access Control (RBAC)** for structured privilege management  
- **Row-Level Security (RLS)** ensuring customers can only view their own records  
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
| Row-Level Security | Ensures customers only access their own accounts |
| Column Restrictions | Prevents exposure of sensitive attributes |
| Encryption | Protects sensitive data using pgcrypto |
| Audit Logging | Tracks INSERT, UPDATE, DELETE activity |
| Constraints & Triggers | Maintains transactional integrity |

---

## Purpose

This project demonstrates **secure relational database design**, combining structured SQL schema development with practical **access control and data protection mechanisms** commonly required in financial systems.