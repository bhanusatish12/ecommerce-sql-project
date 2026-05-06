CREATE DATABASE ecommerce_db;
 
USE ecommerce_db; 

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price_per_unit DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATE,
    payment_method VARCHAR(30),
    amount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


DELIMITER //
CREATE PROCEDURE insert_customers()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 1000 DO
        INSERT INTO customers(name, email, city, signup_date)
        VALUES (
            CONCAT('Customer_', i),
            CONCAT('customer', i, '@gmail.com'),
            ELT(FLOOR(1 + (RAND()*5)), 'Hyderabad', 'Mumbai', 'Delhi', 'Chennai', 'Bangalore'),
            DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*1000) DAY)
        );
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
CALL insert_customers();

DELIMITER //
CREATE PROCEDURE insert_products()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 300 DO
        INSERT INTO products(product_name, category, price, stock_quantity)
        VALUES (
            CONCAT('Product_', i),
            ELT(FLOOR(1 + (RAND()*4)), 'Electronics', 'Clothing', 'Home', 'Sports'),
            ROUND(100 + (RAND()*5000),2),
            FLOOR(10 + (RAND()*200))
        );
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
CALL insert_products();


DELIMITER //
CREATE PROCEDURE insert_orders()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 2000 DO
        INSERT INTO orders(customer_id, order_date, status)
        VALUES (
            FLOOR(1 + (RAND()*1000)),
            DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY),
            ELT(FLOOR(1 + (RAND()*3)), 'Delivered', 'Shipped', 'Cancelled')
        );
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
CALL insert_orders();

DELIMITER //
CREATE PROCEDURE insert_order_items()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 4000 DO
        INSERT INTO order_items(order_id, product_id, quantity, price_per_unit)
        VALUES (
            FLOOR(1 + (RAND()*2000)),
            FLOOR(1 + (RAND()*300)),
            FLOOR(1 + (RAND()*5)),
            ROUND(100 + (RAND()*5000),2)
        );
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
CALL insert_order_items();

DELIMITER //
CREATE PROCEDURE insert_payments()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 2000 DO
        INSERT INTO payments(order_id, payment_date, payment_method, amount)
        VALUES (
            i,
            DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY),
            ELT(FLOOR(1 + (RAND()*3)), 'UPI', 'Credit Card', 'Net Banking'),
            ROUND(500 + (RAND()*10000),2)
        );
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
CALL insert_payments(); 


