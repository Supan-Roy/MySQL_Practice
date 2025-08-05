CREATE DATABASE prac2;
USE prac2;

CREATE TABLE students ( 
id INT AUTO_INCREMENT PRIMARY KEY, 
name VARCHAR(100) NOT NULL, 
age INT NOT NULL 
);

INSERT INTO students (name, age) VALUES  
('Alice Johnson', 20), 
('Bob Smith', 22), 
('Charlie Brown', 21), 
('David Lee', 23), 
('Emma Wilson', 19);

# 1. Creating a Simple Stored Procedure (Without Parameters)
DELIMITER //
CREATE PROCEDURE get_all_students()
BEGIN
	SELECT * FROM students;
END //
DELIMITER ;

CALL get_all_students();

# 2. Stored Procedure with (IN) Input Parameter
DELIMITER $$
CREATE PROCEDURE show_by_id(IN student_id INT)
BEGIN
	SELECT * FROM students WHERE id = student_id;
END $$
DELIMITER ;

CALL show_by_id(2);

# 3. Stored Procedure with (OUT) Output Parameter
DELIMITER $$ 
CREATE PROCEDURE GetTotalStudents(OUT total INT) 
BEGIN 
SELECT COUNT(*) INTO total FROM students; 
END $$ 
DELIMITER ;

CALL GetTotalStudents(@student_count); 
SELECT @student_count;

# 4. Stored Procedure with Multiple Parameters
DELIMITER $$ 
CREATE PROCEDURE insert_student(IN student_name VARCHAR(100), IN student_age INT) 
BEGIN 
INSERT INTO students (name, age) VALUES (student_name, student_age); 
END $$ 
DELIMITER ; 

CALL insert_student('Supan Roy', 21);
SELECT * FROM students;

# Using INOUT for Student Age Update
DELIMITER $$ 
CREATE PROCEDURE IncreaseStudentAge(IN student_id INT, INOUT student_age INT) 
BEGIN 
UPDATE students SET age = age + 1 WHERE id = student_id; 
SELECT age INTO student_age FROM students WHERE id = student_id; 
END $$ 
DELIMITER ; 

SET @age = 20;  -- Assume the initial age is 20 (Not Needed Always)
CALL IncreaseStudentAge(1, @age);
SELECT @age; 

#THANK YOU#
