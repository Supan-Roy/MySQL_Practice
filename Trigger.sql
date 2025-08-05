USE prac2;

create table customer (acc_no integer primary key, cust_name varchar(20),
 avail_balance decimal);
 
create table mini_statement (acc_no integer, avail_balance decimal, foreign key
 (acc_no) references customer(acc_no) on delete cascade);
 
insert into customer values (1000, "Fanny", 7000),(1001, "Peter", 12000);

# Before Update Trigger
DELIMITER //
create trigger update_cus
before update on customer
for each row
begin
 insert into mini_statement values (old.acc_no, old.avail_balance);
end //
DELIMITER ;

update customer set avail_balance = avail_balance + 3000 where acc_no = 1000;
update customer set avail_balance = avail_balance + 3000 where acc_no = 1001;

select *from mini_statement;

# After Update Trigger
create table micro_statement (acc_no integer, avail_balance decimal,
foreign key(acc_no) references customer(acc_no) on delete cascade);

insert into customer values (1002, "Janitor", 4500);
 
DELIMITER //
create trigger update_after
after update on customer
for each row
begin
	insert into micro_statement values(new.acc_no, new.avail_balance); 
end; //
DELIMITER ;

update customer set avail_balance = avail_balance + 1500 where acc_no = 1002;
select *from micro_statement;

# Before Insert Trigger
CREATE TABLE contacts (
    contact_id INT(11) NOT NULL AUTO_INCREMENT,
    last_name VARCHAR(30) NOT NULL,
    first_name VARCHAR(25),
    birthday DATE,
    created_date DATE,
    created_by VARCHAR(30),
    CONSTRAINT contacts_pk PRIMARY KEY (contact_id)
);

DELIMITER //
CREATE TRIGGER contacts_before_insert
BEFORE INSERT ON contacts
FOR EACH ROW
BEGIN
    DECLARE vUser VARCHAR(50);

    -- Find username of person performing INSERT
    SELECT USER() INTO vUser;

    -- Set creation date to current system date
    SET NEW.created_date = SYSDATE();

    -- Set created_by to the current MySQL user
    SET NEW.created_by = vUser;
END;
//
DELIMITER ;

INSERT INTO contacts (last_name, first_name, birthday)
VALUES ('Newton', 'Enigma', '1999-08-19');

SELECT * FROM contacts;

# After Insert Trigger
CREATE TABLE contacts1 (
    contact_id INT(11) NOT NULL AUTO_INCREMENT,
    last_name VARCHAR(30) NOT NULL,
    first_name VARCHAR(25),
    birthday DATE,
    CONSTRAINT contacts1_pk PRIMARY KEY (contact_id)
);

CREATE TABLE contacts1_audit (
    contact_id INT,
    created_date DATE,
    created_by VARCHAR(30)
);

DELIMITER //
CREATE TRIGGER contacts_after_insert
AFTER INSERT ON contacts1
FOR EACH ROW
BEGIN
    DECLARE vUser VARCHAR(50);

    -- Find username of person performing the INSERT
    SELECT USER() INTO vUser;

    -- Insert record into audit table
    INSERT INTO contacts1_audit (contact_id, created_date, created_by)
    VALUES (NEW.contact_id, SYSDATE(), vUser);
END;
//
DELIMITER ;

INSERT INTO contacts1 (last_name, first_name, birthday)
VALUES ('Holmes', 'Sherlock', '1999-06-20');

SELECT * FROM contacts1_audit;

# Before Delete Trigger
CREATE TABLE contacts_audit (
    contact_id INT,
    deleted_date DATE,
    deleted_by VARCHAR(20)
);

DELIMITER //
CREATE TRIGGER contacts_before_delete
BEFORE DELETE ON contacts
FOR EACH ROW
BEGIN
    DECLARE vUser VARCHAR(50);

    -- Find username of the person performing the DELETE
    SELECT USER() INTO vUser;
    
    -- Insert record into audit table before deletion
    INSERT INTO contacts_audit (contact_id, deleted_date, deleted_by)
    VALUES (OLD.contact_id, SYSDATE(), vUser);
END;
//
DELIMITER ;

-- Insert a record
INSERT INTO contacts (last_name, first_name, birthday, created_date, created_by)
VALUES ('Bond', 'Ruskin', STR_TO_DATE('19-08-1995', '%d-%m-%Y'),
        STR_TO_DATE('27-04-2018', '%d-%m-%Y'), 'xyz');

-- Delete the record (trigger will fire)
DELETE FROM contacts WHERE contact_id = 2;

-- View audit log
SELECT * FROM contacts_audit;
select * from contacts;

# After Delete Trigger
DELIMITER //
CREATE TRIGGER contacts_after_delete
AFTER DELETE ON contacts
FOR EACH ROW
BEGIN
    DECLARE vUser VARCHAR(50);

    -- Find username of the person performing the DELETE
    SELECT USER() INTO vUser;

    -- Insert record into audit table after deletion
    INSERT INTO contacts_audit (contact_id, deleted_date, deleted_by)
    VALUES (OLD.contact_id, SYSDATE(), vUser);
END;
//
DELIMITER ;

-- Insert a record
INSERT INTO contacts (last_name, first_name, birthday, created_date, created_by)
VALUES ('Newton', 'Isaac', STR_TO_DATE('19-08-1985', '%d-%m-%Y'),
        STR_TO_DATE('23-07-2018', '%d-%m-%Y'), 'xyz');

-- Delete the record (trigger will fire)
DELETE FROM contacts WHERE contact_id = 3;

-- View audit log
SELECT * FROM contacts_audit;
