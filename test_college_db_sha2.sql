-- Test College Management Database Integrity using SHA-256 Checksums
USE college_management;

SELECT 'TESTING INSTALLATION' AS 'INFO';

DROP TABLE IF EXISTS expected_values, found_values;

CREATE TABLE expected_values (
    table_name VARCHAR(30) NOT NULL PRIMARY KEY,
    recs INT NOT NULL,
    crc_sha2 VARCHAR(100) NOT NULL
);

CREATE TABLE found_values (LIKE expected_values);

-- Pre-calculated Expected Hashes
INSERT INTO `expected_values` VALUES
('departments', 3, '377c5d727383a32633e2973f8e3411beffe29e2f4cc297c586fa6b24aa7df9ba'),
('staff', 3, '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8'),
('students', 3, '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b'),
('courses', 3, 'd4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666ec13ab110');

DROP TABLE IF EXISTS tchecksum;
CREATE TABLE tchecksum (chk CHAR(100));

-- 1. Departments Check
SET @crc = '';
INSERT INTO tchecksum
SELECT @crc := SHA2(CONCAT_WS('#', @crc, dept_id, dept_name, building), 256) 
FROM departments ORDER BY dept_id;
INSERT INTO found_values VALUES ('departments', (SELECT COUNT(*) FROM departments), @crc);
DELETE FROM tchecksum;

-- 2. Staff Check
SET @crc = '';
INSERT INTO tchecksum
SELECT @crc := SHA2(CONCAT_WS('#', @crc, staff_id, first_name, last_name, email, role, salary, dept_id), 256) 
FROM staff ORDER BY staff_id;
INSERT INTO found_values VALUES ('staff', (SELECT COUNT(*) FROM staff), @crc);
DELETE FROM tchecksum;

-- 3. Students Check
SET @crc = '';
INSERT INTO tchecksum
SELECT @crc := SHA2(CONCAT_WS('#', @crc, student_id, first_name, last_name, email, date_of_birth, enrollment_date, dept_id), 256) 
FROM students ORDER BY student_id;
INSERT INTO found_values VALUES ('students', (SELECT COUNT(*) FROM students), @crc);
DELETE FROM tchecksum;

-- 4. Courses Check
SET @crc = '';
INSERT INTO tchecksum
SELECT @crc := SHA2(CONCAT_WS('#', @crc, course_id, course_code, course_name, credits, dept_id), 256) 
FROM courses ORDER BY course_id;
INSERT INTO found_values VALUES ('courses', (SELECT COUNT(*) FROM courses), @crc);
DELETE FROM tchecksum;

DROP TABLE tchecksum;

-- Output Comparison Verification Results
SELECT 
    e.table_name,
    IF(e.recs = f.recs, 'OK', 'not ok') AS records_match,
    IF(e.crc_sha2 = f.crc_sha2, 'ok', 'not ok') AS crc_match
FROM expected_values e 
INNER JOIN found_values f USING (table_name);

SET @crc_fail = (SELECT COUNT(*) FROM expected_values e INNER JOIN found_values f USING(table_name) WHERE f.crc_sha2 != e.crc_sha2);
SET @count_fail = (SELECT COUNT(*) FROM expected_values e INNER JOIN found_values f USING(table_name) WHERE f.recs != e.recs);

SELECT 'CRC' AS summary, IF(@crc_fail = 0, "OK", "FAIL") AS `result`
UNION ALL
SELECT 'count', IF(@count_fail = 0, "OK", "FAIL") AS `count`;

DROP TABLE expected_values, found_values;