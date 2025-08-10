CREATE DATABASE stored_procedure;
USE stored_procedure;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    product_id INT,
    quantity INT DEFAULT 1,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
INSERT INTO Users (username, email) VALUES
('alice', 'alice@example.com'),
('bob', 'bob@example.com'),
('carol', 'carol@example.com');

INSERT INTO Products (product_name, price, stock) VALUES
('Laptop', 1200.00, 10),
('Smartphone', 800.00, 20),
('Headphones', 150.00, 30);

INSERT INTO Orders (user_id, product_id, quantity) VALUES
(1, 1, 1),  -- Alice bought 1 Laptop
(2, 3, 2),  -- Bob bought 2 Headphones
(3, 2, 1);  -- Carol bought 1 Smartphone

SELECT * FROM Users;
SELECT * FROM Products;

-- 1. GET All Products
DELIMITER //
CREATE PROCEDURE GetAllProducts()
BEGIN
    SELECT * FROM Products;
END //
DELIMITER ;

CALL GetAllProducts();

-- 2. Add/Insert New User
DELIMITER %%
CREATE PROCEDURE adduser(IN uname VARCHAR(50), IN uemail VARCHAR(100))
BEGIN
	INSERT INTO Users(username, email) VALUES(uname, uemail);
END %%
DELIMITER ;

CALL adduser('supan', 'sroy21@myemail.com');
SELECT * FROM Users;

-- 3. GET Orders by User ID
DELIMITER //
CREATE PROCEDURE GetUserOrders(IN uid INT)
BEGIN
    SELECT o.order_id, p.product_name, o.quantity, o.order_date
    FROM Orders o 
    JOIN Products p ON o.product_id = p.product_id
    WHERE o.user_id = uid;
END //
DELIMITER ;

CALL GetUserOrders(2);

-- 4. Get total sales per product
DELIMITER //
CREATE PROCEDURE GetTotalSales()
BEGIN
    SELECT
        p.product_name,
        SUM(o.quantity) AS total_quantity_sold,
        SUM(o.quantity * p.price) AS total_revenue
    FROM Orders o
    JOIN Products p ON o.product_id = p.product_id
    GROUP BY p.product_id, p.product_name;
END //
DELIMITER ;

CALL GetTotalSales();

-- 5. Get all users with email filter (LIKE)
DELIMITER //
CREATE PROCEDURE GetUsersByEmail(IN u_email VARCHAR(100))
BEGIN
	SELECT * 
	FROM Users 
	WHERE email LIKE CONCAT('%', u_email, '%');
END //
DELIMITER ;

CALL GetUsersByEmail('example');

-- 6. Count total number of products
DELIMITER //
CREATE PROCEDURE CountProducts(OUT total_products INT)
BEGIN
	SELECT COUNT(*) INTO total_products FROM Products;
END //
DELIMITER ;

CALL CountProducts(@total);
SELECT @total;

-- 7. Get product details by ID
DELIMITER //
CREATE PROCEDURE GetProductByID(IN pid INT)
BEGIN
	SELECT * FROM Products WHERE product_id = pid;
END //
DELIMITER ;

CALL GetProductByID(3);

-- 8. Get total revenue of all orders
DELIMITER //
CREATE PROCEDURE GetTotalRevenue(OUT total DECIMAL(10,2))
BEGIN
	SELECT SUM(o.quantity * p.price) INTO total
    FROM Orders o
    JOIN Products p ON o.product_id = p.product_id;
END //
DELIMITER ;

CALL GetTotalRevenue(@revenue);
SELECT @revenue;

-- 9. Increase stock of a product and return new stock
DELIMITER //
CREATE PROCEDURE IncreaseStock(IN pid INT, IN qty INT, INOUT new_stock INT)
BEGIN
	UPDATE Products SET stock = stock + qty WHERE product_id = pid;
    SELECT stock INTO new_stock FROM Products WHERE product_id = pid;
END //
DELIMITER ;

CALL IncreaseStock(1, 5, @stock);
SELECT @stock;

-- 10. Orders per user
DELIMITER //
CREATE PROCEDURE OrdersPeruser()
BEGIN
	SELECT u.username, COUNT(o.order_id) AS total_orders, SUM(o.quantity) AS total_items
    FROM Users u
    LEFT JOIN Orders o ON u.user_id = o.user_id
    GROUP BY u.user_id, u.username
    ORDER BY total_orders DESC;
END //
DELIMITER ;

CALL OrdersPerUser();

-- 11. Multi-condition filtering with parameters
DELIMITER //
CREATE PROCEDURE FilterProducts(IN min_price DECIMAL(10,2), IN max_price DECIMAL(10,2), IN min_stock INT)
BEGIN
	SELECT * FROM Products
    WHERE price BETWEEN min_price AND max_price
    AND stock >= min_stock;
END //
DELIMITER ;

CALL FilterProducts(100, 1000, 10);

-- 12. Delete a product by ID (with safety check)
DELIMITER //
CREATE PROCEDURE DeleteProduct(IN pid INT, OUT status_msg VARCHAR(100))
BEGIN
	IF EXISTS (SELECT 1 FROM Products WHERE product_id = pid) THEN
		DELETE FROM Orders WHERE product_id = pid;
		DELETE FROM Products WHERE product_id = pid;
		SET status_msg = 'Product deleted success';
    ELSE
		SET status_msg = 'Product not found';
	END IF;
END //
DELIMITER ;

CALL DeleteProduct(2, @msg);
SELECT @msg;
