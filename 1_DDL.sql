CREATE DATABASE mydb;

CREATE TABLE Persons (
    PersonID int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255)
);

-- Insert Data into Table
INSERT INTO Persons (PersonID, LastName, FirstName, Address, City)
VALUES
(1, 'Roy', 'Supan', '123 Maple Street', 'Bagerhat'),
(2, 'Yeager', 'Cade', '456 Oak Avenue', 'Los Angeles'),
(3, 'Optimus', 'Prime', '7B Casfig Xerlan', 'Cybertron'),
(4, 'Jesse', 'Eisenberg', '101 River Road', 'Bagerhat'),
(5, 'Garfield', 'Andrew', '202 Lake View', 'Toronto');

-- ALTER TABLE - MODIFY COLUMN
ALTER TABLE Persons
ADD DateOfBirth date;

-- Change Data Type
ALTER TABLE Persons
MODIFY COLUMN DateOfBirth YEAR;

-- Drop Column
ALTER TABLE Persons
DROP COLUMN DateOfBirth;

-- NOT NULL
CREATE TABLE Persons2 (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255) NOT NULL,
    Age int
);

-- NOT NULL on ALTER TABLE
ALTER TABLE Persons2
MODIFY Age int NOT NULL

-- UNIQUE Constraint on CREATE TABLE
CREATE TABLE Persons3 (
    ID int NOT NULL,
    LastName varchar(255),
    FirstName varchar(255),
    Age int,
    UNIQUE (ID)
);

-- Naming a UNIQUE constraint, and to define a UNIQUE constraint on multiple columns
CREATE TABLE Persons3 (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    CONSTRAINT UC_Person UNIQUE (ID,LastName)
);

-- UNIQUE Constraint on ALTER TABLE
ALTER TABLE Persons3
ADD UNIQUE (ID);

-- To name a UNIQUE constraint, and to define a UNIQUE constraint on multiple columns
ALTER TABLE Persons3
ADD CONSTRAINT UC_Person UNIQUE (ID,LastName);

-- Drop a UNIQUE Constraint
ALTER TABLE Persons3
DROP INDEX ID;
-- Drop from Named Constraint
ALTER TABLE Persons3
DROP INDEX UC_Person;

-- PRIMARY KEY on CREATE TABLE
CREATE TABLE Persons4 (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    --PRIMARY KEY (ID)
    CONSTRAINT PK_Person PRIMARY KEY (ID,LastName)
);

-- PRIMARY KEY on ALTER TABLE
ALTER TABLE Persons4
ADD PRIMARY KEY (ID);

ALTER TABLE Persons4
ADD CONSTRAINT PK_Person PRIMARY KEY (ID,LastName);

-- DROP a PRIMARY KEY Constraint
ALTER TABLE Persons4
DROP PRIMARY KEY;

