CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    ContactName VARCHAR(100),
    Address VARCHAR(100),
    City VARCHAR(50),
    PostalCode VARCHAR(20),
    Country VARCHAR(50)
);


INSERT INTO Customers (CustomerID, CustomerName, ContactName, Address, City, PostalCode, Country)
VALUES 
(1, 'Alfreds Futterkiste', 'Maria Anders', 'Obere Str. 57', 'Berlin', '12209', 'Germany'),
(2, 'Ana Trujillo Emparedados y helados', 'Ana Trujillo', 'Avda. de la Constitución 2222', 'México D.F.', '05021', 'Mexico'),
(3, 'Antonio Moreno Taquería', 'Antonio Moreno', 'Mataderos 2312', 'México D.F.', '05023', 'Mexico'),
(4, 'Around the Horn', 'Thomas Hardy', '120 Hanover Sq.', 'London', 'WA1 1DP', 'UK'),
(5, 'Berglunds snabbköp', 'Christina Berglund', 'Berguvsvägen 8', 'Luleå', 'S-958 22', 'Sweden'),
(6, 'Supan Roy', 'Jonathan Byers', '223 University Ave', 'Dhaka', '1219', 'Bangladesh');


-- SELECT Columns
SELECT CustomerName, City, Country FROM Customers;

-- SELECT DISTINCT Values
SELECT DISTINCT Country, City FROM Customers;

-- Count Distinct Values
SELECT COUNT(DISTINCT Country) FROM Customers;

--WHERE Clause
SELECT * FROM Customers
WHERE Country = 'Mexico';

SELECT CustomerName FROM Customers
WHERE CustomerID = 1;

-- AND, OR and NOT Operators
SELECT * FROM Customers
WHERE Country = 'Germany' AND City = 'Berlin';

SELECT * FROM Customers
WHERE Country = 'Germany' OR Country = 'UK';

SELECT * FROM Customers
WHERE NOT Country = 'UK';

SELECT * FROM Customers
WHERE Country = 'Germany' AND (City = 'Berlin' OR City = 'Stuttgart');

-- Order By Descending
SELECT * FROM Customers
ORDER BY Country DESC;

SELECT * FROM Customers
ORDER BY Country ASC, CustomerName DESC;

-- NULL/NOT NULL Values
SELECT CustomerName, ContactName, Address
FROM Customers
WHERE Address IS NOT NULL;

-- Update Table
UPDATE Customers
SET ContactName = 'Alfred Schmidt'
WHERE CustomerID = 1;

-- UPDATE Multiple Records
UPDATE Customers
SET PostalCode = 52511
WHERE Country = 'Mexico';

-- DELETE Statement
DELETE FROM Customers WHERE CustomerID = 6;

-- LIMIT Clause
SELECT * FROM Customers
ORDER BY Country
LIMIT 3;

-- MIN() and MAX() Functions
SELECT MAX(CustomerID) AS LongestValue
FROM Customers;

-- COUNT(), AVG() and SUM() Functions
SELECT COUNT(CustomerID)
FROM Customers;

SELECT AVG(CustomerID)
FROM Customers;

SELECT SUM(CustomerID)
FROM Customers;

-- LIKE Operator
SELECT * FROM Customers
WHERE CustomerName LIKE 'A%';

SELECT * FROM Customers
WHERE CustomerName LIKE '_n%';

-- IN Operator
SELECT * FROM Customers
WHERE Country IN ('Germany', 'France', 'UK');

-- Between
SELECT * FROM Customers
WHERE CustomerID BETWEEN 2 AND 4;

-- Aliases
SELECT CustomerID AS Cid, CustomerName AS Cname
FROM Customer;

-- GROUP BY
SELECT COUNT(CustomerID), Country
FROM Customers
GROUP BY Country;

SELECT COUNT(CustomerID), Country
FROM Customers
GROUP BY Country
ORDER BY COUNT(CustomerID) DESC;

-- HAVING
SELECT COUNT(CustomerID), Country
FROM Customers
GROUP BY Country
HAVING COUNT(CustomerID) > 1;

-- EXISTS Syntax demo
SELECT SupplierName
FROM Suppliers
WHERE EXISTS (SELECT ProductName FROM Products WHERE Products.SupplierID = Suppliers.supplierID AND Price < 20);

-- ANY/ ALL demo
SELECT ProductName
FROM Products
WHERE ProductID = ANY
  (SELECT ProductID
  FROM OrderDetails
  WHERE Quantity = 10);

SELECT ProductName
FROM Products
WHERE ProductID = ALL
  (SELECT ProductID
  FROM OrderDetails
  WHERE Quantity = 10);

-- INSERT INTO SELECT Syntax
INSERT INTO Customers (CustomerName, City, Country)
SELECT SupplierName, City, Country FROM Suppliers;
