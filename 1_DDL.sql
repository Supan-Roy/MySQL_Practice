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
(4, 'Jesse', 'Eisenberg', '101 River Road', 'New York'),
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
    LastName varchar(255),
    FirstName varchar(255) NOT NULL,
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
    LastName varchar(255),
    FirstName varchar(255) NOT NULL,
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

-- FOREIGN KEY on CREATE TABLE
CREATE TABLE Orders (
    OrderID int NOT NULL,
    OrderNumber int NOT NULL,
    PersonID int,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (PersonID) REFERENCES Persons4(ID)
);

-- To allow naming of a FOREIGN KEY constraint, and for defining a FOREIGN KEY constraint on multiple columns
CREATE TABLE Orders (
    OrderID int NOT NULL,
    OrderNumber int NOT NULL,
    PersonID int,
    PRIMARY KEY (OrderID),
    CONSTRAINT FK_PersonOrder FOREIGN KEY (PersonID)
    REFERENCES Persons4(ID)
);

-- FOREIGN KEY on ALTER TABLE
ALTER TABLE Orders
ADD FOREIGN KEY (PersonID) REFERENCES Persons4(ID);

-- To allow naming of a FOREIGN KEY constraint, and for defining a FOREIGN KEY constraint on multiple columns
ALTER TABLE Orders
ADD CONSTRAINT FK_PersonOrder
FOREIGN KEY (PersonID) REFERENCES Persons4(ID);

-- DROP a FOREIGN KEY Constraint
ALTER TABLE Orders
DROP FOREIGN KEY FK_PersonOrder;

-- MySQL CHECK Constraint
-- CHECK on CREATE TABLE
CREATE TABLE Persons5 (
    ID int NOT NULL,
    LastName varchar(255),
    FirstName varchar(255) NOT NULL,
    Age int,
    CHECK (Age>=18)
);

-- To allow naming of a CHECK constraint, and for defining a CHECK constraint on multiple columns
CREATE TABLE Persons5 (
    ID int NOT NULL,
    LastName varchar(255),
    FirstName varchar(255) NOT NULL,
    Age int,
    City varchar(255),
    CONSTRAINT CHK_Person CHECK (Age>=18 AND City='Sandnes')
);

-- CHECK on ALTER TABLE
ALTER TABLE Persons5
ADD CHECK (Age>=18);

-- To allow naming of a CHECK constraint, and for defining a CHECK constraint on multiple columns
ALTER TABLE Persons5
ADD CONSTRAINT CHK_PersonAge CHECK (Age>=18 AND City='New York');

-- DROP a CHECK Constraint
ALTER TABLE Persons5
DROP CHECK CHK_PersonAge;

-- DEFAULT on CREATE TABLE
CREATE TABLE Persons6 (
    ID int NOT NULL,
    LastName varchar(55),
    FirstName varchar(55) NOT NULL,
    Age int,
    City varchar(50) DEFAULT 'Bagerhat'
);

-- DEFAULT on ALTER TABLE
ALTER TABLE Persons6
ALTER City SET DEFAULT 'Bagerhat';

-- DROP a DEFAULT Constraint
ALTER TABLE Persons6
ALTER City DROP DEFAULT;

-- CREATE INDEX Syntax
CREATE INDEX ind_lastName
ON Persons6 (LastName);

CREATE INDEX ind_pName
ON Persons6 (LastName, FirstName);

-- CREATE UNIQUE INDEX Syntax (No duplicate values)
CREATE UNIQUE INDEX ind_pName
ON Persons6 (LastName, FirstName);

-- DROP INDEX Statement
ALTER TABLE Persons6
DROP INDEX ind_pName;

-- AUTO INCREMENT
CREATE TABLE Persons7 (
    Personid int NOT NULL AUTO_INCREMENT,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    PRIMARY KEY (Personid)
);

-- To let the AUTO_INCREMENT sequence start with another value
ALTER TABLE Persons7 AUTO_INCREMENT=10;

-- Working with Dates
SELECT * FROM Orders WHERE OrderDate='2008-11-11'

-- CREATE VIEW
CREATE VIEW [Dhaka Customers] AS
SELECT CustomerName, ContactName
FROM Customers
WHERE City = 'Dhaka';

SELECT * FROM [Dhaka Customers];

-- Example
CREATE VIEW [Products Above Average Price] AS
SELECT ProductName, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

SELECT * FROM [Products Above Average Price];