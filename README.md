# Cybersecurity Portfolio

This repository contains a selection of technical projects developed during my Cyber Security degree at the University of Warwick. The projects demonstrate practical work across machine learning, secure application development, relational database design, and security investigation.

The focus of this portfolio is on building and analysing systems with security in mind, combining technical implementation with investigation and evaluation.

---

# Projects

## Machine Learning Intrusion Detection Pipeline
Location: `intrusion-detection-ml-pipeline`

This project implements a reproducible **machine learning pipeline for network intrusion detection** using flow telemetry from the CIC IDS 2017 dataset.

Key aspects of the project include:

- Python-based preprocessing and feature engineering
- Model training using logistic regression and random forest
- Evaluation under **temporal train–test splits** to assess real-world robustness
- Analysis of model performance using precision, recall, and ROC metrics

This project demonstrates the application of **machine learning techniques to cybersecurity monitoring and detection engineering**.

---

## SecureCart – Secure E-Commerce Application
Location: `securecart-secure-ecommerce`

SecureCart is a **Django-based web application** that models a secure e-commerce system.

The system implements:

- Authentication and secure session handling
- Role-based access control for different user types
- Product catalogue browsing and shopping cart functionality
- Order management workflows

The project focuses on **secure web application design**, backend logic, and database integration.

---

## Secure Banking Database System
Location: `secure-banking-database-system`

This project implements a **PostgreSQL banking database** designed with strong security and integrity controls.

The database models customers, accounts, and financial transactions while enforcing strict data protection mechanisms.

Key features include:

- Role-Based Access Control (RBAC)
- Row-Level Security (RLS)
- Encryption using pgcrypto
- SQL triggers for audit logging
- Relational schema enforcing transactional integrity

The project demonstrates **secure relational database design and access control implementation**.

---

# Security Investigation Work

Alongside the engineering projects above, I have also completed practical security investigations including:

- Malware reconstruction and behavioural analysis
- Digital forensic disk image investigation
- Detection engineering and monitoring design using network telemetry

These investigations involved tools such as **Wireshark, Autopsy, FLARE-VM, Procmon, Regshot, Splunk, and YARA rule development**.

---

# Technologies Used

Python  
Machine Learning (scikit-learn, pandas)  
SQL / PostgreSQL  
Django  
Wireshark  
Autopsy  
Splunk  
FLARE-VM  

---

# Author

Yemi Oluwadare  
BSc Cyber Security – University of Warwick
