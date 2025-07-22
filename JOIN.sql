CREATE DATABASE joins;

-- Creating Course Table
CREATE TABLE Course(
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL
);

-- Creating Student Table
CREATE TABLE Student(
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    course_id INT NULL,
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE SET NULL
);

-- Creating Teacher Table
CREATE TABLE Teacher(
    teacher_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    course_id INT NULL,
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE SET NULL
);

-- Inserting Data into Course Table
INSERT INTO Course (course_id, course_name) VALUES
(101, 'Mathematics'),
(102, 'Physics'),
(103, 'Computer Science'),
(104, 'Biology'),
(105, 'Chemistry');

-- Inserting Data into Student Table
INSERT INTO Student (student_id, name, course_id) VALUES 
(1, 'Supan', 101), 
(2, 'Tamim', 102), 
(3, 'Junayed', 103), 
(4, 'Noman', NULL), 
(5, 'Richil', 101), 
(6, 'Jenny', 102), 
(7, 'Tajim', 103), 
(8, 'digonto', NULL), 
(9, 'Shayan', 104), 
(10, 'Sourav', 105);
-- Inserting Data into Teacher Table
INSERT INTO Teacher (teacher_id, name, course_id) VALUES
(1, 'Dr. Watson', 101),
(2, 'Prof. Jonathan', 102),
(3, 'Dr. Byers', 103),
(4, 'Prof. Williams', 104),
(5, 'Prof. Shonku', NULL);

-- 1. INNER JOIN: List students with their courses
SELECT s.name, c.course_name
FROM Student s
INNER JOIN Course c ON s.course_id = c.course_id;
-- This retrieves only students who have a matching course_id in the Course table.

-- 2. INNER JOIN: List teachers with their courses
SELECT t.name, c.course_name
FROM Teacher t
JOIN Course c ON t.course_id = c.course_id;
-- Returns only teachers who have an assigned course.

-- 3. LEFT JOIN: Show all students and their assigned courses (include students without courses)
SELECT s.name, c.course_name
FROM Student s
LEFT JOIN Course c ON s.course_id = c.course_id;
-- Includes all students, even those who have no assigned course

-- 4. RIGHT JOIN: Show all courses and students (include courses without students)
SELECT s.name, c.course_name
FROM Student s
RIGHT JOIN Course c ON s.course_id = c.course_id;
-- Includes all courses, even those that have no students enrolled.

-- 5. CROSS JOIN: Get all possible student-course combinations
SELECT s.name, c.course_name
FROM Student s
CROSS JOIN Course c;
-- Returns a Cartesian product (all possible combinations of students and courses).

-- 6. INNER JOIN with Three Tables: Show student names, their courses, and respective teachers
SELECT s.name AS students_name, c.course_name, t.name AS teachers_name
FROM Student s
INNER JOIN Course c ON s.course_id = c.course_id
JOIN Teacher t ON c.course_id = t.course_id;
-- Retrieves students, their courses, and respective teachers, but only for matching records in all tables.

-- 7. LEFT JOIN with Three Tables: Show all students and their assigned courses and teachers (even if some data is missing)
SELECT s.name AS students_name, c.course_name, t.name AS teachers_name
FROM Student s
LEFT JOIN Course c ON s.course_id = c.course_id
LEFT JOIN Teacher t ON c.course_id = t.course_id;
-- Returns all students and their courses, even if they have no assigned course or teacher.
