-- College Management Sample Database
-- Compatible with MySQL 5.7+ / 8.0+ / 9.0+ / Workbench

SET @start_time = NOW();

DROP DATABASE IF EXISTS college_management;
CREATE DATABASE IF NOT EXISTS college_management;
USE college_management;

SELECT 'CREATING DATABASE STRUCTURE' as 'INFO';

DROP TABLE IF EXISTS exam_results, exams, attendance, enrollments, sections, courses, students, staff, departments;

/*!50503 set default_storage_engine = InnoDB */;

CREATE TABLE departments (
    dept_id INT NOT NULL AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL,
    building VARCHAR(50) NOT NULL,
    PRIMARY KEY (dept_id),
    UNIQUE KEY (dept_name)
);

CREATE TABLE staff (
    staff_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    dept_id INT,
    PRIMARY KEY (staff_id),
    UNIQUE KEY (email),
    FOREIGN KEY (dept_id) REFERENCES departments (dept_id) ON DELETE SET NULL
);

CREATE TABLE students (
    student_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    enrollment_date DATE NOT NULL,
    dept_id INT,
    PRIMARY KEY (student_id),
    UNIQUE KEY (email),
    FOREIGN KEY (dept_id) REFERENCES departments (dept_id) ON DELETE SET NULL
);

CREATE TABLE courses (
    course_id INT NOT NULL AUTO_INCREMENT,
    course_code VARCHAR(15) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    dept_id INT NOT NULL,
    PRIMARY KEY (course_id),
    UNIQUE KEY (course_code),
    FOREIGN KEY (dept_id) REFERENCES departments (dept_id) ON DELETE CASCADE
);

CREATE TABLE sections (
    section_id INT NOT NULL AUTO_INCREMENT,
    course_id INT NOT NULL,
    staff_id INT,
    semester VARCHAR(10) NOT NULL,
    year INT NOT NULL,
    room_number VARCHAR(20),
    PRIMARY KEY (section_id),
    FOREIGN KEY (course_id) REFERENCES courses (course_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON DELETE SET NULL
);

CREATE TABLE enrollments (
    enrollment_id INT NOT NULL AUTO_INCREMENT,
    student_id INT NOT NULL,
    section_id INT NOT NULL,
    grade VARCHAR(2),
    PRIMARY KEY (enrollment_id),
    UNIQUE KEY (student_id, section_id),
    FOREIGN KEY (student_id) REFERENCES students (student_id) ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES sections (section_id) ON DELETE CASCADE
);

CREATE TABLE exams (
    exam_id INT NOT NULL AUTO_INCREMENT,
    section_id INT NOT NULL,
    exam_type ENUM('Midterm', 'Final', 'Quiz') NOT NULL,
    exam_date DATE NOT NULL,
    max_marks INT NOT NULL DEFAULT 100,
    PRIMARY KEY (exam_id),
    FOREIGN KEY (section_id) REFERENCES sections (section_id) ON DELETE CASCADE
);

-- Creating Convenience Views
CREATE OR REPLACE VIEW v_student_transcript AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.course_code,
    c.course_name,
    sec.semester,
    sec.year,
    e.grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN sections sec ON e.section_id = sec.section_id
JOIN courses c ON sec.course_id = c.course_id;

-- Loading Sample Data Directly
SELECT 'LOADING departments' as 'INFO';
INSERT INTO `departments` VALUES 
(1, 'Computer Science', 'Turing Hall'),
(2, 'Electrical Engineering', 'Tesla Wing'),
(3, 'Mathematics', 'Euler Building');

SELECT 'LOADING staff' as 'INFO';
INSERT INTO `staff` VALUES 
(1, 'Alan', 'Turing', 'alan.turing@college.edu', 'Professor', 95000.00, 1),
(2, 'Ada', 'Lovelace', 'ada.lovelace@college.edu', 'Associate Professor', 85000.00, 1),
(3, 'Nikola', 'Tesla', 'nikola.tesla@college.edu', 'Professor', 90000.00, 2);

SELECT 'LOADING students' as 'INFO';
INSERT INTO `students` VALUES 
(1, 'John', 'Doe', 'john.doe@student.edu', '2002-05-14', '2021-09-01', 1),
(2, 'Jane', 'Smith', 'jane.smith@student.edu', '2001-11-20', '2020-09-01', 1),
(3, 'Alice', 'Johnson', 'alice.j@student.edu', '2003-02-10', '2022-09-01', 2);

SELECT 'LOADING courses' as 'INFO';
INSERT INTO `courses` VALUES 
(1, 'CS101', 'Introduction to Computer Science', 4, 1),
(2, 'CS201', 'Data Structures & Algorithms', 4, 1),
(3, 'EE101', 'Circuit Analysis', 3, 2);

SELECT 'LOADING sections' as 'INFO';
INSERT INTO `sections` VALUES 
(1, 1, 1, 'Fall', 2026, 'Room 101'),
(2, 2, 2, 'Fall', 2026, 'Room 203'),
(3, 3, 3, 'Fall', 2026, 'Lab B');

SELECT 'LOADING enrollments' as 'INFO';
INSERT INTO `enrollments` VALUES 
(1, 1, 1, 'A'),
(2, 2, 1, 'B+'),
(3, 2, 2, 'A'),
(4, 3, 3, 'A-');

SELECT 'LOADING exams' as 'INFO';
INSERT INTO `exams` VALUES 
(1, 1, 'Midterm', '2026-10-15', 100),
(2, 1, 'Final', '2026-12-10', 100);

SELECT CONCAT('Loading finished in: ', TIME_TO_SEC(TIMEDIFF(NOW(), @start_time)), ' seconds') AS 'INFO';