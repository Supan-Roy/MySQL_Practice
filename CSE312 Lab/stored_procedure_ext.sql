CREATE DATABASE stored_procedure_v2;
USE stored_procedure_v2;

CREATE TABLE Students (
	student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    grade CHAR(1),
    marks INT 
);

INSERT INTO Students (name, grade, marks) VALUES
('Roy', 'A', 90),
('Millie', 'B', 75),
('Chishiya', 'C', 60),
('Jack', 'D', 45),
('David', 'B', 78);

-- 1. IF...ELSE Statement (Classify a student’s result as Pass/Fail)
DELIMITER //
CREATE PROCEDURE CheckPassFail(IN sid INT, OUT result_msg VARCHAR(50))
BEGIN
	DECLARE student_marks INT;
    SELECT marks INTO student_marks FROM Students WHERE student_id = sid;
    
    IF student_marks >= 50 THEN
		SET result_msg = 'Pass';
	else
		SET result_msg = 'Fail';
	END IF;
END //
DELIMITER ;

CALL CheckPassFail(4, @result);
SELECT @result;

-- 2. CASE (Return a remark based on grade)
DELIMITER //
CREATE PROCEDURE GetRemark(IN sid INT, OUT remark_msg VARCHAR(50))
BEGIN
	DECLARE grade_val CHAR(1);
    SELECT grade INTO grade_val FROM Students WHERE student_id = sid;
    
    CASE grade_val
		WHEN 'A' THEN SET remark_msg = 'Excellent';
        WHEN 'B' THEN SET remark_msg = 'Good';
        WHEN 'C' THEN SET remark_msg = 'Average';
        WHEN 'D' THEN SET remark_msg = 'Need Improvement';
	END CASE;
END //
DELIMITER ;

CALL GetRemark(1, @remark);
SELECT @remark;

-- 3. LOOP (Print numbers up to N (insert into a log table))
CREATE TABLE NumberLog (num INT);
DELIMITER //
CREATE PROCEDURE insert_num_loop(IN n INT)
BEGIN
	DECLARE counter INT DEFAULT 1;
    myloop: LOOP
		INSERT INTO NumberLog VALUES (counter);
		SET counter = counter + 1;
		IF counter > n THEN
			LEAVE myloop;
		END IF;
    END LOOP;
END //
DELIMITER ;

CALL insert_num_loop(5);
SELECT * FROM NumberLog;

-- 4. WHILE LOOP (Sum numbers up to N)
DELIMITER //
CREATE PROCEDURE sumWhile(IN n INT, OUT total INT)
BEGIN
	DECLARE counter INT DEFAULT 1;
    SET total = 0;
    WHILE counter <= n DO
		SET total = total + counter;
        SET counter = counter + 1;
	END WHILE;
END //
DELIMITER ;

CALL sumWhile(5, @sum_result);
SELECT @sum_result;

-- 5. REPEAT Loop (Count from 1 to N using REPEAT)
CREATE TABLE RepeatLog(num INT);
DELIMITER //
CREATE PROCEDURE repeat_count(IN n INT)
BEGIN
	DECLARE counter INT DEFAULT 0;
    REPEAT 
			SET counter = counter + 1;
            INSERT INTO RepeatLog VALUES (counter);
	UNTIL counter >= n
    END REPEAT;
END //
DELIMITER ;

CALL repeat_count(5);
SELECT * FROM RepeatLog;
