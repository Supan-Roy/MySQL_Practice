CREATE DATABASE lab1;
USE lab1;

# Control Statement
CREATE TABLE students (
	student_id INT PRIMARY KEY,
    name varchar(100),
    marks INT
 );

insert into students values
(1, 'sadia', 85),
(2, 'rafiq', 58),
(3, 'lima', 40),
(4, 'nadim', 75),
(5, 'rina', 30);

# Stored Procedure
DELIMITER //
CREATE PROCEDURE checkPassFail(IN mark int)
BEGIN
	IF mark > 50 THEN 
     select 'Pass' as Result;
	ELSE
		select 'Fail' as Result;
	END IF;
END //
DELIMITER ;

CALL checkPassFail(85);

# Performance Check
DELIMITER //
CREATE PROCEDURE checkStudentPerformance(IN mark int)
BEGIN
	IF mark > 80 THEN 
    select 'Excellent' as Result;
    ELSEIF mark > 60 THEN
    select 'Good' as Result;
    ELSE 
		select 'Need''s Improvement' as Result;
	END IF;
	END //
DELIMITER ;

CALL checkStudentPerformance(82);

DELIMITER //
CREATE PROCEDURE isTopper(IN id INT)
BEGIN
	DECLARE student_marks INT;
    DECLARE highest_mark INT;
    SELECT marks INTO student_marks FROM students WHERE student_id = id;
    SELECT MAX(marks) INTO highest_mark FROM students;
    IF 
		student_marks = highest_mark THEN
        SELECT 'is topper' AS Result;
	ELSE
		SELECT 'Not a Topper' as Result;
        END IF;
	END //
DELIMITER ;

DROP procedure isTopper;
CALL isTopper(1);

DELIMITER //
CREATE PROCEDURE Grade(IN marks INT)
BEGIN
	CASE 
    WHEN marks > 80 THEN select 'A+' as Grade;
    WHEN marks > 70 THEN select 'A' as Grade;
    WHEN marks > 60 THEN select 'A-' as Grade;
    WHEN marks > 50 THEN select 'B+' as Grade;
    WHEN marks > 40 THEN select 'B' as Grade;
    ELSE select 'Failed' as Grade;
	END CASE;
END //
DELIMITER ;

CALL Grade(84);

#Another Table
create table student1(
	student_id INT PRIMARY KEY,
    name varchar(100),
    department varchar(50),
    semester int
);

insert into student1 values
(1, 'abir', 'cse', 5),
(2, 'akhi', 'eee', 6);

select * from student1;

#ADD STUDENT IF NOT EXIST
DELIMITER //
CREATE PROCEDURE adsine(IN s_id int, IN s_name varchar(100), IN s_dept varchar(50), IN s_semester int)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM student1 WHERE student_id = s_id) THEN
    INSERT INTO student1 VALUES (s_id, s_name, s_dept, s_semester);
	ELSE 
    SELECT 'Student Already Exists' AS Message;
    END IF;
END //
DELIMITER ;

CALL adsine(3, 'rakib', 'me', 5);

DELIMITER //
CREATE PROCEDURE findcse()
BEGIN
	IF EXISTS (SELECT 1 FROM student1 WHERE department = 'cse') THEN
    SELECT 'EXISTS' as Message;
	ELSE 
    SELECT 'Does not Exist!' AS Message;
    END IF;
END //
DELIMITER ;

CALL findcse();

DELIMITER //
CREATE PROCEDURE findte()
BEGIN
	IF EXISTS (SELECT 1 FROM student1 WHERE department = 'te') THEN
    SELECT 'EXISTS' as Message;
	ELSE 
    SELECT 'Does not Exist!' AS Message;
    END IF;
END //
DELIMITER ;
CALL findte();
