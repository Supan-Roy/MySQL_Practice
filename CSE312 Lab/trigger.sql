CREATE DATABASE trigger_new;
USE trigger_new;

CREATE TABLE Employees(
	emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    department VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Log Table to record changes
CREATE TABLE EmployeeLog(
	log_id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(20),
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    old_department VARCHAR(50),
    new_department VARCHAR(50),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 1.1 BEFORE INSERT Trigger (Validate or modify data before inserting)
DELIMITER //
CREATE TRIGGER before_emp_insert
BEFORE INSERT ON Employees
FOR EACH ROW
BEGIN
	IF NEW.salary <= 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Salary cannot be negative or zero';
    END IF;
END //
DELIMITER ;

INSERT INTO Employees (emp_name, salary, department) VALUES ('John Doe', 50000.00, 'Engineering');
INSERT INTO Employees (emp_name, salary, department) VALUES ('Jane Smith', -100.00, 'Marketing');

-- 1.2 AFTER INSERT Trigger
DELIMITER //
CREATE TRIGGER after_emp_insert
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
	INSERT INTO EmployeeLog (action_type, emp_id, new_salary, new_department)
    VALUES('INSERT', NEW.emp_id, NEW.salary, NEW.department);
END //
DELIMITER ;

INSERT INTO Employees (emp_name, salary, department)
VALUES ('Jane Doe', 65000.00, 'Human Resources');
SELECT * FROM Employees;
SELECT * FROM EmployeeLog;

-- 2.1 BEFORE UPDATE Trigger - Check if the salary is being decreased by more than 10%
DELIMITER //
CREATE TRIGGER before_emp_update
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
	IF NEW.salary < OLD.salary * 0.9 THEN
    SET NEW.salary = OLD.salary * 0.9;
    END IF;
END //
DELIMITER ;

UPDATE Employees SET salary = 40000.00, department = 'Sales' WHERE emp_name = 'John Doe';
SELECT * FROM Employees;

-- 2.2 AFTER UPDATE Trigger - Log changes after update.
DELIMITER //
CREATE TRIGGER after_emp_update
AFTER UPDATE ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO EmployeeLog (action_type, emp_id, old_salary, new_salary, old_department, new_department)
    VALUES ('UPDATE', OLD.emp_id, OLD.salary, NEW.salary, OLD.department, NEW.department);
END //
DELIMITER ;

UPDATE Employees SET salary = 49000.00, department = 'IA' WHERE emp_id = 1;
SELECT * FROM EmployeeLog;

-- 3.1 BEFORE DELETE Trigger -- prevent deletion of employees from a certain department.
DELIMITER //
CREATE TRIGGER before_emp_delete
BEFORE DELETE ON Employees
FOR EACH ROW
BEGIN
	IF OLD.department = 'Management' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot delete Management employees!';
    END IF;
END //
DELIMITER ;

DELETE FROM Employees WHERE emp_id = 3; # (Cannot Delete)

-- 3.2 AFTER DELETE Trigger -- Log deleted employees.
DELIMITER //
CREATE TRIGGER after_emp_delete
AFTER DELETE ON Employees
FOR EACH ROW
BEGIN
	INSERT INTO EmployeeLog (action_type, emp_id, old_salary, old_department)
    VALUES ('DELETE', OLD.emp_id, OLD.salary, OLD.department);
END //
DELIMITER ;

DELETE FROM Employees WHERE emp_id = 1; # (Employee 1 Deleted)
SELECT * FROM EmployeeLog;
