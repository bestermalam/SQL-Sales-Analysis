CREATE DATABASE IF NOT EXISTS sales_analysis;
USE sales_analysis;



CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50)
);
INSERT INTO customers
(customer_id, customer_name, city)
VALUES
(1, 'John Banda', 'Lusaka'),
(2, 'Mary Phiri', 'Ndola'),
(3, 'Peter Mwansa', 'Kitwe'),
(4, 'Grace Zulu', 'Lusaka'),
(5, 'Chanda Tembo', 'Livingstone');

-- CREATE PRODUCTS TABLE

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- INSERT FIVE PRODUCTS

INSERT INTO products
(product_id, product_name, category, price)
VALUES
(101, 'Laptop', 'Electronics', 8500.00),
(102, 'Phone', 'Electronics', 3500.00),
(103, 'Desk', 'Furniture', 2200.00),
(104, 'Chair', 'Furniture', 800.00),
(105, 'Printer', 'Electronics', 2800.00);


-- CREATE SALES TABLE

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    sale_date DATE,
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- INSERT TEN SALES TRANSACTIONS

INSERT INTO sales
(sale_id, customer_id, product_id, quantity, sale_date)
VALUES
(1, 1, 101, 2, '2026-01-05'),
(2, 2, 102, 3, '2026-01-06'),
(3, 3, 103, 1, '2026-01-07'),
(4, 4, 104, 4, '2026-01-08'),
(5, 5, 105, 2, '2026-01-09'),
(6, 1, 102, 1, '2026-01-10'),
(7, 2, 101, 1, '2026-01-11'),
(8, 3, 104, 2, '2026-01-12'),
(9, 4, 103, 3, '2026-01-13'),
(10, 5, 102, 2, '2026-01-14');



-- =====================================
-- SQL SALES ANALYSIS
-- =====================================

-- 1. DISPLAY ALL SALES TRANSACTIONS

SELECT * FROM sales;


-- 2. CALCULATE TOTAL SALES REVENUE

SELECT
    COUNT(*) AS total_transactions,
    SUM(sales.quantity) AS total_units_sold,
    SUM(sales.quantity * products.price) AS total_revenue,
    AVG(sales.quantity * products.price) AS average_transaction_value
FROM sales
JOIN products
    ON sales.product_id = products.product_id;


-- 3. REVENUE BY PRODUCT

SELECT
    products.product_name,
    SUM(sales.quantity * products.price) AS total_revenue
FROM sales
JOIN products
    ON sales.product_id = products.product_id
GROUP BY products.product_id, products.product_name
ORDER BY total_revenue DESC;




-- 4. SALES REVENUE BY CITY

SELECT
    customers.city,
    SUM(sales.quantity * products.price) AS total_revenue
FROM sales
JOIN customers
    ON sales.customer_id = customers.customer_id
JOIN products
    ON sales.product_id = products.product_id
GROUP BY customers.city
ORDER BY total_revenue DESC;


-- 5. HIGHEST-SPENDING CUSTOMERS

SELECT
    customers.customer_name,
    customers.city,
    SUM(sales.quantity * products.price) AS total_spent
FROM sales
JOIN customers
    ON sales.customer_id = customers.customer_id
JOIN products
    ON sales.product_id = products.product_id
GROUP BY
    customers.customer_id,
    customers.customer_name,
    customers.city
ORDER BY total_spent DESC;


-- 6. PRODUCTS GENERATING MORE THAN K10,000

SELECT
    products.product_name,
    SUM(sales.quantity * products.price) AS total_revenue
FROM sales
JOIN products
    ON sales.product_id = products.product_id
GROUP BY products.product_id, products.product_name
HAVING SUM(sales.quantity * products.price) > 10000
ORDER BY total_revenue DESC;


-- 7. PRODUCTS PRICED ABOVE AVERAGE

SELECT
    product_name,
    price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);




