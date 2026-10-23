# Cybersecurity portfolio

Projects from my BSc Cyber Security at the University of Warwick (2:1, 2026).
The write-ups, with figures, what I found and what I would do next, are on the
portfolio page: https://yemioluwadare.github.io/portfolio/

## Projects in this repository

- [Intrusion detection pipeline](intrusion-detection-ml-pipeline): a Python
  pipeline that detects DDoS attacks in CIC-IDS network data and evaluates two
  models on a split by time.
- [SecureCart](securecart-secure-ecommerce): a Django and PostgreSQL online
  shop with login, a database-backed cart, a dummy checkout and an admin area.
  Second-year project. Known limits: the interface is plain, and the products
  API lets any logged-in user write (a one-line fix is tested but not applied
  here).
- [Secure banking database](secure-banking-database-system): a PostgreSQL
  database with four roles, row-level security, bcrypt, encrypted amounts and
  audit triggers. Second-year project. Known limit: the row-level security
  policies need three changes before customers see only their own rows (tested
  but not applied here).

## Other work, on the portfolio page

Security investigations (malware analysis, vulnerability analysis with exploit
development, detection engineering, disk image forensics), a final-year AI
compliance agent, a job search data pipeline and a Roblox game. These are not
in this repository.

## Tools

Python (pandas, scikit-learn, Django), SQL and PostgreSQL, Splunk, Wireshark,
FLARE-VM, YARA, Autopsy.

Yemi Oluwadare
