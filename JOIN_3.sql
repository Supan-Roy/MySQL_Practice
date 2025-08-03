CREATE DATABASE joins;
USE joins;
-- Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    department VARCHAR(50)
);
-- Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    credits INT
);
-- Enrollments table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Insert students
INSERT INTO Students VALUES
(1, 'Alice', 'CSE'),
(2, 'Bob', 'EEE'),
(3, 'Charlie', 'CSE'),
(4, 'Diana', 'BBA');

-- Insert courses
INSERT INTO Courses VALUES
(101, 'Database Systems', 3),
(102, 'Data Structures', 4),
(103, 'Marketing', 2);

-- Insert enrollments
INSERT INTO Enrollments VALUES
(1, 1, 101, 'A'),
(2, 1, 102, 'B+'),
(3, 2, 103, 'A-'),
(4, 3, 101, 'B'),
(5, 4, 103, 'A');

SELECT * FROM Students;
SELECT * FROM Courses;
SELECT * FROM Enrollments;

-- Returns only students who enrolled in a course (Inner Join)
SELECT s.student_name, c.course_name, e.grade
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;

-- Shows all students, even those not enrolled in any course (Left Join)
SELECT s.student_name, c.course_name
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
LEFT JOIN Courses c ON e.course_id = c.course_id;

-- Shows all enrollments/courses, even if student info is missing (Right Join)
SELECT s.student_name, c.course_name
FROM Students s
RIGHT JOIN Enrollments e ON s.student_id = e.student_id
RIGHT JOIN Courses c ON e.course_id = c.course_id;

-- Find students from the same department (Self Join)
SELECT a.student_name AS Student1, b.student_name AS Student2, a.department
FROM Students a
JOIN Students b ON a.department = b.department AND a.student_id < b.student_id;

SELECT s.student_name, c.course_name, e.grade
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE s.department = 'CSE' AND e.grade = 'A';

-- Get only CSE students with grade A or A+
SELECT s.student_name, c.course_name, e.grade
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE s.department = 'CSE' AND e.grade = 'A' OR e.grade = 'A+';

-- Show only CSE students who enrolled in any course
SELECT s.student_name AS Student, c.course_name AS Course, e.grade AS GRADE
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE s.department = 'CSE';

-- Show only enrollments for Database Systems (course_id = 101)
SELECT s.student_name AS Student, c.course_name AS Course, e.grade AS GRADE
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id AND c.course_id = 101;

-- Show students from CSE department who got grade A in Database Systems
SELECT s.student_name AS Student, c.course_name AS Course, e.grade AS GRADE
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id AND e.grade = 'A'
JOIN Courses c ON e.course_id = c.course_id AND c.course_name = 'Database Systems'
WHERE s.department = 'CSE';

-- UPDATING TABLES
-- Add columns to Students
ALTER TABLE Students
ADD email VARCHAR(100) NULL,
ADD admission_year INT;

-- Add columns to Courses
ALTER TABLE Courses
ADD department VARCHAR(50),
ADD prerequisite_course_id INT NULL;

-- Add columns to Enrollments
ALTER TABLE Enrollments
ADD enroll_date DATE,
ADD remarks VARCHAR(255) NULL;

-- Update Students with new data
UPDATE Students SET 
    email = 'alice@university.edu', admission_year = 2023 WHERE student_id = 1;
UPDATE Students SET 
    email = 'bob@university.edu', admission_year = 2022 WHERE student_id = 2;
UPDATE Students SET 
    email = NULL, admission_year = 2023 WHERE student_id = 3; -- NULL email
UPDATE Students SET 
    email = 'diana@university.edu', admission_year = 2024 WHERE student_id = 4;

-- Update Courses
UPDATE Courses SET 
    department = 'CSE', prerequisite_course_id = NULL WHERE course_id = 101;
UPDATE Courses SET 
    department = 'CSE', prerequisite_course_id = 101 WHERE course_id = 102;
UPDATE Courses SET 
    department = 'BBA', prerequisite_course_id = NULL WHERE course_id = 103;

-- Update Enrollments
UPDATE Enrollments SET 
    enroll_date = '2025-02-15', remarks = 'Excellent' WHERE enrollment_id = 1;
UPDATE Enrollments SET 
    enroll_date = '2025-03-01', remarks = NULL WHERE enrollment_id = 2;
UPDATE Enrollments SET 
    enroll_date = '2025-01-20', remarks = 'Good' WHERE enrollment_id = 3;
UPDATE Enrollments SET 
    enroll_date = '2025-04-10', remarks = NULL WHERE enrollment_id = 4; 
UPDATE Enrollments SET 
    enroll_date = '2025-02-28', remarks = 'Outstanding' WHERE enrollment_id = 5;

SELECT * FROM students;
-- MORE JOIN OPERATIONS

-- Students Without Email, along with any courses they may have taken.
SELECT s.student_name, s.email, c.course_name
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
LEFT JOIN Courses c ON e.course_id = c.course_id
WHERE s.email IS NULL;

-- Finds CSE courses taken in first quarter of 2025
SELECT s.student_name, c.course_name, e.enroll_date
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE c.department = 'CSE'
  AND e.enroll_date BETWEEN '2025-01-01' AND '2025-03-31';

-- Shows each course with its prerequisite (if any)
SELECT c.course_name AS Course, p.course_name AS Prerequisite
FROM Courses c
LEFT JOIN Courses p ON c.prerequisite_course_id = p.course_id;

-- Only A or B+ grades, At least some extra info (remarks or email), Courses must have 3 or more credits
SELECT s.student_name, c.course_name, e.grade, e.remarks
FROM Students s
JOIN Enrollments e 
    ON s.student_id = e.student_id 
    AND (e.grade = 'A' OR e.grade = 'B+')
JOIN Courses c 
    ON e.course_id = c.course_id
WHERE (e.remarks IS NOT NULL OR s.email IS NOT NULL)
  AND c.credits >= 3
ORDER BY s.student_name;
