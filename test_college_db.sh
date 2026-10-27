#!/usr/bin/env bash
# Test execution wrapper script for College Management DB

DB_USER=${1:-root}
DB_HOST=${2:-localhost}

echo "=========================================="
echo " Importing College Management Database    "
echo "=========================================="
mysql -u "$DB_USER" -h "$DB_HOST" -p < college_management.sql

if [ $? -eq 0 ]; then
    echo "=========================================="
    echo " Running Integrity Verification (SHA-256) "
    echo "=========================================="
    mysql -u "$DB_USER" -h "$DB_HOST" -p -t < test_college_db_sha2.sql
else
    echo "Database import failed!"
    exit 1
fi