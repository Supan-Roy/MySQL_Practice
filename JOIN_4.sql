CREATE DATABASE joinreturns
USE joinreturns;
-- Create the students table
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(255),
    department VARCHAR(255)
);

-- Insert data into the students table
INSERT INTO students (student_id, name, department) VALUES
(1, 'Arisu', 'CSE'),
(2, 'Eleven', 'EEE'),
(3, 'Eisenberg', 'CSE'),
(4, 'Chishiya', 'BBA'),
(5, 'Roy', 'CSE');

-- Create the courses table
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(255),
    instructor VARCHAR(255)
);

-- Insert data into the courses table
INSERT INTO courses (course_id, course_name, instructor) VALUES
(101, 'Database Systems', 'Dr. Smith'),
(102, 'Algorithms', 'Dr. Adams'),
(103, 'Marketing Basics', 'Dr. Khan');

-- Create the enrollments table
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    score INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Insert data into the enrollments table
INSERT INTO enrollments (enrollment_id, student_id, course_id, score) VALUES
(1, 1, 101, 88),
(2, 1, 102, 75),
(3, 2, 101, 90),
(4, 3, 101, 55),
(5, 3, 102, 60),
(6, 4, 103, 95),
(7, 5, 101, 85),
(8, 5, 102, 92),
(9, 2, 102, 58),
(10, 1, 103, 70);

-- Query 1: Total score for each student (only if total > 200)
SELECT s.name, SUM(e.score) AS total_score
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.name
HAVING total_score > 200;

-- Query 2: Average score per course (only if more than 2 students enrolled)
SELECT c.course_name, AVG(e.score) AS avg_score
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
HAVING COUNT(e.student_id) > 2;

-- Query 3: CSE students with avg score > 85
SELECT s.name, AVG(e.score) AS avg_score
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE s.department = 'CSE'
GROUP BY s.name
HAVING avg_score > 85;

-- Query 4: Instructors who teach more than one course
SELECT instructor, COUNT(*) AS num_courses
FROM courses
GROUP BY instructor
HAVING num_courses > 1;

-- Query 5: Courses where highest score >= 90
SELECT c.course_name, MAX(e.score) AS max_score
FROM courses c
JOIN enrollments e ON c.course_id=e.course_id
GROUP BY c.course_name
HAVING max_score >= 90;

-- Query 6: Number of students scoring above 80 in each course
SELECT c.course_name, COUNT(*) AS high_scorers
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
WHERE e.score > 80
GROUP BY c.course_name;

-- Query 7: Students enrolled in courses from at least 2 different instructors
SELECT s.name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
GROUP BY s.name
HAVING COUNT(DISTINCT c.instructor) >= 2;

-- Query 8: Departments where avg score < 80
SELECT s.department, AVG(e.score) AS avg_score
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.department
HAVING avg_score < 80;

-- Query 9: Student who took the most number of courses
SELECT s.name, COUNT(e.course_id) AS total_courses
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.name
ORDER BY total_courses DESC
LIMIT 1;

-- Query 10: Courses where all students scored above 60
SELECT c.course_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
HAVING MIN(e.score) > 60;

-- Query 11: Find students who got the highest score in any course
SELECT DISTINCT s.name, c.course_name, e.score
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
WHERE e.score = (
SELECT MAX(score)
FROM enrollments
WHERE course_id = e.course_id
);

-- Query 12: Course with largest gap between highest and lowest scores
SELECT c.course_name,
MAX(e.score) - MIN(e.score) AS score_gap
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY score_gap DESC
LIMIT 1;

-- Query 13: Students who scored above average in all their courses
SELECT s.name
FROM students s
WHERE NOT EXISTS (
SELECT 1
FROM enrollments e
JOIN (
SELECT course_id, AVG(score) AS avg_score
FROM enrollments
GROUP BY course_id
) avg_data ON e.course_id = avg_data.course_id
WHERE e.student_id = s.student_id AND e.score <= avg_data.avg_score
);

-- Query 14: Courses where same score was given to more than one student
SELECT c.course_name, e.score, COUNT(*) AS student_count
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_name, e.score
HAVING COUNT(*) > 1;

-- Query 15: Students who took all available courses
SELECT s.name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.name
HAVING COUNT(DISTINCT e.course_id) = (SELECT COUNT(*) FROM courses);
