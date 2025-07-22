CREATE DATABASE joins2;

-- Table: Customers
CREATE TABLE Customers(
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    country VARCHAR(50) DEFAULT 'Unknown'
 );

-- Table: Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10, 2) CHECK (price >= 0)
);

-- Table: Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE NOT NULL,
    quantity INT CHECK (quantity > 0),
    
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert Data
INSERT INTO Customers VALUES 
  (1, 'Alice', 'alice@example.com', 'USA'),
  (2, 'Bob', 'bob@example.com', 'UK'),
  (3, 'Charlie', 'charlie@example.com', 'Canada'),
  (4, 'Diana', 'diana@example.com', 'India');

INSERT INTO Products VALUES 
  (101, 'Laptop', 'Electronics', 1200.00),
  (102, 'Headphones', 'Electronics', 150.00),
  (103, 'Coffee Mug', 'Kitchen', 12.50),
  (104, 'Notebook', 'Stationery', 4.99);

INSERT INTO Orders VALUES 
  (1001, 1, 101, '2024-01-10', 1),
  (1002, 1, 102, '2024-02-12', 2),
  (1003, 2, 103, '2024-03-05', 3),
  (1004, 3, 101, '2024-04-20', 1);

--  1. INNER JOIN — Show all successful orders with customer and product details
SELECT o.order_id, c.name AS customer_name, p.product_name, o.quantity, o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON o.product_id = p.product_id;

-- 2. LEFT JOIN — Show all customers, even if they never ordered anything
SELECT c.name AS customer_name, o.order_id, p.product_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN Products p ON o.product_id = p.product_id;

-- 3. RIGHT JOIN — Show all products, even if never ordered
SELECT p.product_name, o.order_id, c.name AS customer_name
FROM Orders o
RIGHT JOIN Products p ON o.product_id = p.product_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

-- 4. Orders with total price (quantity × price)
SELECT o.order_id, c.name AS customer_name, p.product_name, o.quantity, p.price, (o.quantity * p.price) AS total_price
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON o.product_id = p.product_id;
