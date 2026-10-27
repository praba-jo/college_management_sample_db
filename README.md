# College Management System (Database Only)

A robust relational database mini-project modeled after educational ERP samples and benchmark structures like MySQL's `test_db`. This repository covers the complete database lifecycle—from system requirements and 3NF normalization to SQL DDL schema design, constraints, stored procedures, triggers, and SHA-256 data integrity checks.

---

## 🛠️ Tools & Technologies
* **DBMS:** MySQL / PostgreSQL
* **Management Clients:** MySQL Workbench / pgAdmin
* **Diagramming:** Draw.io (for Entity-Relationship Modeling)

---

## 📂 Repository File Structure
```text
college_management_db/
├── .gitignore
├── README.md
├── college_management.sql           # Main entry point: DDL, schema, views, and data insertion
├── show_elapsed.sql                 # Execution timing helper utility
├── test_college_db_sha2.sql         # SHA-256 integrity verification test suite
├── test_college_db.sh               # Automation wrapper shell script
└── assets/                          # ER diagrams and documentation images