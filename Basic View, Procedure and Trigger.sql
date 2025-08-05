CREATE DATABASE db1;
USE db1;

-- Students Table
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department VARCHAR(50)
);

-- Courses Table
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(50) NOT NULL,
    credit_hours INT
);

-- Enrollments Table
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Insert Sample Data
INSERT INTO students (name, email, department) VALUES
('Alice Johnson', 'alice@example.com', 'Computer Science'),
('Bob Smith', 'bob@example.com', 'Electrical Engineering'),
('Charlie Brown', 'charlie@example.com', 'Mathematics');

INSERT INTO courses (course_name, credit_hours) VALUES
('Database Systems', 3),
('Computer Networks', 3),
('Calculus', 4);

INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES
(1, 1, '2025-08-01'),
(1, 2, '2025-08-02'),
(2, 2, '2025-08-03'),
(3, 3, '2025-08-04');

-- VIEW
CREATE VIEW student_course_view AS
SELECT s.student_id, s.name AS student_name, c.course_name, e.enrollment_date
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

SELECT * FROM student_course_view;

CREATE VIEW cs_students_view AS
SELECT s.name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.department = 'Computer Science';

SELECT * FROM cs_students_view;

-- UPDATE VIEW
CREATE OR REPLACE VIEW cs_students_view AS
SELECT s.name, c.course_name, e.enrollment_date
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.department = 'Computer Science'
  AND e.enrollment_date > '2025-08-01';

-- DROP VIEW
DROP VIEW cs_students_view;

-- STORED PROCEDURE
-- Show all students
DELIMITER $$
CREATE PROCEDURE get_all_students()
BEGIN
     SELECT * FROM students;
END $$
DELIMITER ;

CALL get_all_students();

-- Find Student by id (IN Parameter)
DELIMITER //
CREATE PROCEDURE find_student(IN id INT)
BEGIN
	SELECT * FROM students
    WHERE student_id = id;
END //
DELIMITER ;

CALL find_student(2);

DROP PROCEDURE find_student;

-- Get courses for a specific student
DELIMITER //
CREATE PROCEDURE get_courses_by_student(IN studentName VARCHAR(50))
BEGIN
    SELECT c.course_name, e.enrollment_date
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN courses c ON e.course_id = c.course_id
    WHERE s.name = studentName;
END //
DELIMITER ;

CALL get_courses_by_student('Alice Johnson');

-- Get total number of students (OUT Parameter)

DELIMITER %%
CREATE PROCEDURE count_students(OUT total INT)
BEGIN
	SELECT COUNT(*) INTO total FROM students;
END %%
DELIMITER ;

CALL count_students(@total);
SELECT @total AS total_students;

-- Add a new enrollment
DELIMITER //
CREATE PROCEDURE add_enrollment(IN stu_id INT, IN course_id INT, IN enroll_date DATE)
BEGIN
    INSERT INTO enrollments(student_id, course_id, enrollment_date)
    VALUES (stu_id, course_id, enroll_date);
END //
DELIMITER ;

CALL add_enrollment(1, 3, '2025-08-05');
SELECT * FROM enrollments;

-- Count Students by Department (IN, OUT Parameter)
DELIMITER //
CREATE PROCEDURE disp_department(OUT total_students INT, IN dept_name VARCHAR(50))
BEGIN
    SELECT COUNT(*) INTO total_students
    FROM students
    WHERE department = dept_name;
END //
DELIMITER ;
SET @total := 0;
CALL disp_department(@total, 'Electrical Engineering');
SELECT @total AS total_students_in_department;

-- Count Students by Course Name (INOUT Parameter)
DELIMITER //
CREATE PROCEDURE disp_course_students(INOUT total_students INT, IN courseName VARCHAR(100))
BEGIN
    SELECT COUNT(e.student_id) INTO total_students
    FROM courses c
    LEFT JOIN enrollments e ON c.course_id = e.course_id
    WHERE c.course_name = courseName;
END //
DELIMITER ;

SET @total := 0;
CALL disp_course_students(@total, 'Database Systems');
SELECT @total AS total_students_in_course;

-- TRIGGER
-- Create a log table
CREATE TABLE student_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    action VARCHAR(50),
    student_name VARCHAR(50),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Trigger (Log Student Insertions)
DELIMITER //
CREATE TRIGGER after_student_insert
AFTER INSERT ON students
FOR EACH ROW
BEGIN
    INSERT INTO student_log (action, student_name)
    VALUES ('INSERT', NEW.name);
END //
DELIMITER ;

-- Test Trigger
INSERT INTO students (name, email, department)
VALUES ('David Lee', 'david@example.com', 'Physics');

INSERT INTO students (name, email, department)
VALUES ('Supan Roy', 'roycss990@gmail.com', 'Chemistry');

SELECT * FROM student_log;
