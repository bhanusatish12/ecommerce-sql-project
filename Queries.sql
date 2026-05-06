## retrive all customers
SELECT * 
FROM customers;

## Retrieve all products with price greater than 1000.
SELECT * 
FROM products
WHERE price > 1000;

## Find products that are out of stock.
SELECT *
FROM products 
WHERE stock_quantity = 0; 

## Get all orders placed in the last 30 days.
SELECT *
FROM orders
WHERE order_date >= curdate() - interval 30 day; 

## Count total number of customers.
SELECT count(*) AS No_of_Customers
FROM customers;

## Count total number of orders.
SELECT count(order_id) AS No_of_Orders
FROM orders;

## Find distinct product categories.
SELECT DISTINCT category 
FROM products;

## Get total stock available.
SELECT SUM(stock_quantity) AS Total_Stock 
FROM products;

## Show customers from a specific city.
SELECT name, city  
FROM customers
WHERE city = 'Hyderabad';

## Get orders with status = 'Delivered'.
SELECT * 
FROM orders
WHERE status = 'Delivered';

## Find total number of products in each category.
SELECT category, COUNT(product_id) AS Total_Products
FROM products
GROUP BY category; 

## Find the highest priced product.
SELECT product_name, price 
FROM products
ORDER BY price DESC
LIMIT 1; 

## Find the cheapest product.
SELECT product_name, price
FROM products
ORDER BY price
LIMIT 1; 

## Show total number of orders per customer.
SELECT customer_id, COUNT(order_id) AS Total_Orders
FROM orders
GROUP BY customer_id; 

## List products sorted by price (highest to lowest).
SELECT product_name, price 
FROM products
ORDER BY price DESC;


## Find total amount of each order.
SELECT order_id, SUM(quantity * price_per_unit) AS Total_Amount_orders
FROM order_items
GROUP BY order_id;

## Find total revenue generated.
SELECT SUM(quantity * price_per_unit) AS Total_revenue  
FROM order_items;

## Get top 5 highest selling products (by quantity).
SELECT * 
FROM products
ORDER BY stock_quantity DESC
LIMIT 5; 

## Find customers who never placed an order.
SELECT c.customer_id, c.name 
FROM customers c
LEFT JOIN orders o 
	ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

## Find customers who placed more than 5 orders.
SELECT customer_id, count(order_id) AS Total_orders
FROM orders 
GROUP BY customer_id
HAVING count(order_id) > 5; 

## Get monthly revenue report.
SELECT 
	year(o.order_date) as Year, 
    month(o.order_date) AS Month, 
    SUM(oi.quantity * oi.price_per_unit) AS Monthly_Revenue
FROM orders o
JOIN order_items oi 
	ON o.order_id = oi.order_id
GROUP BY year(order_date), month(order_date)
ORDER BY year, month; 

## Find average order value.
SELECT SUM(quantity * price_per_unit) / COUNT(DISTINCT order_id) AS Avg_order_value  
FROM order_items; 

## Find total revenue per category.
SELECT p.category, SUM(oi.quantity * oi.price_per_unit) AS Total_revenue 
FROM products p
JOIN order_items oi 
	ON  p.product_id = oi.product_id
GROUP BY p.category;

## Get most popular payment method.
SELECT payment_method, count(order_id) AS Total_orders
FROM payments
GROUP BY payment_method
ORDER BY Total_orders DESC
LIMIT 1;

## Find customer who spent the most money.
SELECT c.customer_id, c.name, SUM(oi.quantity * oi.price_per_unit) AS Total_Spent
FROM customers c
JOIN orders o 
	ON c.customer_id = o.customer_id
JOIN order_items oi
	ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name
ORDER BY Total_Spent DESC
LIMIT 1;

## Get repeat customers (more than 1 order).
SELECT customer_id, COUNT(order_id) AS Total_orders 
FROM orders
GROUP BY customer_id 
HAVING COUNT(order_id) > 1;

## Find orders that have more than 3 items.
SELECT order_id, SUM(quantity) AS Total_items
FROM order_items
GROUP BY order_id 
HAVING SUM(quantity) > 3;

## Find products that were never ordered.
SELECT p.product_id, p.product_name 
FROM products p 
LEFT JOIN order_items oi
	ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

## Get daily sales report.
SELECT DATE(o.order_date) AS Sales_date, SUM(oi.quantity * oi.price_per_unit) AS Daily_sales
FROM orders o
JOIN order_items oi
	ON o.order_id = oi.order_id
GROUP BY DATE(o.order_date)
ORDER BY Sales_date; 

## Find revenue between two dates.
SELECT SUM(oi.quantity * oi.price_per_unit) AS Total_Revenue
FROM orders o
JOIN order_items oi
	ON o.order_id = oi.order_id
WHERE order_date BETWEEN '2025-03-01' AND '2025-03-31'; 

## Get top 3 cities by number of customers.
SELECT city, COUNT(customer_id) AS Number_of_Customers 
FROM customers
GROUP BY city
ORDER BY Number_of_Customers DESC
LIMIT 3;

## Find average product price per category.
SELECT category, AVG(price) AS Average_price
FROM products
GROUP BY category;

## Find customers who ordered a specific product.
SELECT DISTINCT c.customer_id, c.name 
FROM customers c
JOIN orders o 
	ON c.customer_id = o.customer_id
JOIN order_items oi
	ON o.order_id = oi.order_id
WHERE oi.product_id = 101;

## Find total number of items sold.
SELECT SUM(quantity) AS Total_items_sold 
FROM order_items;

## Get customers who signed up but never purchased.
SELECT c.customer_id, c.name, c.signup_date 
FROM customers c 
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL; 


## Rank products based on total sales
SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_sold,
    RANK() OVER (ORDER BY SUM(oi.quantity) DESC) AS sales_rank
FROM products p
JOIN order_items oi 
    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name; 

-- Top 3 selling products in each category
WITH product_sales AS (
	SELECT 
		p.product_id,
        p.product_name,
        p.category,
        SUM(oi.quantity) AS Total_sold
    FROM products p
    JOIN order_items oi 
		ON p.product_id = oi.product_id
	GROUP BY p.product_id, p.product_name, p.category
)
SELECT * 
FROM (
	SELECT *,
			RANK() OVER(PARTITION BY category ORDER BY Total_sold DESC) AS rnk
	FROM product_sales
) ranked 
WHERE rnk <=3; 

-- Running total of revenue by date
SELECT order_date, SUM(Daily_revenue) OVER(ORDER BY order_date) AS Running_total
FROM (
	SELECT o.order_date, SUM(oi.quantity * oi.price_per_unit) AS Daily_revenue 
	FROM orders o
	JOIN order_items oi
		ON o.order_id = oi.order_id
	GROUP BY o.order_date
) t;

-- Month-over-Month Revenue Growth
WITH monthly_revenue AS (
	SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS Month, SUM(oi.quantity * oi.price_per_unit) AS Revenue 
	FROM orders o
	JOIN order_items oi
		ON o.order_id = oi.order_id
	GROUP BY Month 
)
SELECT Month, Revenue, LAG(Revenue) OVER(ORDER BY Month) AS prev_month_revenue,
ROUND(
	((Revenue - LAG(Revenue) OVER(ORDER BY Month)) 
    / LAG(Revenue) OVER(ORDER BY Month))*100, 2
) AS mom_growth_percent
FROM monthly_revenue; 

-- Customers whose spending is above average
WITH customer_spending AS (
SELECT c.customer_id, c.name, SUM(oi.quantity * oi.price_per_unit) AS Total_spent
FROM customers c
JOIN orders o 
	ON c.customer_id = o.customer_id
JOIN order_items oi
	ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name
) 
SELECT * 
FROM customer_spending 
WHERE total_spent > (
	SELECT AVG(total_spent) FROM customer_spending
);   

-- Slow moving products (low sales) 
SELECT p.product_id, p.product_name, SUM(oi.quantity) AS Total_sold  
FROM products p 
LEFT JOIN order_items oi
	ON p.product_id = oi.product_id
GROUP BY p.product_id,p.product_name
HAVING SUM(oi.quantity) < 10 OR SUM(oi.quantity) IS NULL;

-- Percentage contribution of each category 
WITH category_revenue AS(
SELECT p.category, SUM(oi.quantity * oi.price_per_unit) AS Revenue 
FROM products p
JOIN order_items oi 
	ON p.product_id = oi.product_id
GROUP BY p.category 
) 
SELECT category, Revenue, ROUND((Revenue / SUM(Revenue) OVER()) * 100, 2) AS percentage_contribution 
FROM category_revenue; 

-- Detect payment mismatch
WITH orders_total AS (
SELECT o.order_id, SUM(oi.quantity  * oi.price_per_unit) AS calculated_total 
FROM orders o 
JOIN order_items oi 
	ON o.order_id = oi.order_id
GROUP BY o.order_id
) 
SELECT ot.order_id, ot.calculated_total, p.amount AS payment_amount
FROM orders_total ot
JOIN payments p 
	ON ot.order_id = p.order_id 
WHERE ot.calculated_total <> p.amount;

-- First order date per customer
SELECT customer_id, MIN(order_date) AS first_order_date  
FROM orders
GROUP BY customer_id;

-- Last order date per customer
SELECT customer_id, MAX(order_date) AS last_order_date 
FROM orders
GROUP BY customer_id;

-- Customer Lifetime Value (CLV)
SELECT c.customer_id, c.name, SUM(oi.quantity * oi.price_per_unit) AS lifetime_value  
FROM customers c 
JOIN orders o 
	ON c.customer_id = o.customer_id
JOIN order_items oi 
	ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name
ORDER BY lifetime_value DESC; 

-- Churned customers (no orders in last 6 months)
SELECT c.customer_id, c.name  
FROM customers c
LEFT JOIN orders o 
	ON c.customer_id = o.customer_id 
GROUP BY c.customer_id, c.name
HAVING MAX(order_date) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH) OR MAX(order_date) IS NULL;

-- Products with declining sales trend
WITH monthly_sales AS
(
SELECT p.product_id, DATE_FORMAT(o.order_id, '%Y-%m') AS month, SUM(oi.quantity) AS total_sold 
FROM products p 
JOIN order_items oi 
	ON p.product_id = oi.product_id 
JOIN orders o 
	ON oi.order_id = o.order_id
GROUP BY p.product_id, Month 
)
SELECT * 
FROM (
	SELECT *, LAG(total_sold) OVER(PARTITION BY product_id ORDER BY month) AS prev_month_sales
    FROM monthly_sales
) t
WHERE total_sold < prev_month_sales; 

-- Peak sales month
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month, SUM(oi.quantity * oi.price_per_unit) AS revenue 
FROM orders o
JOIN order_items oi 
	ON o.order_id = oi.order_id
GROUP BY month
ORDER BY revenue DESC
LIMIT 1; 

-- Customer Segmentation (High / Medium / Low) 
WITH customer_spending AS 
(
SELECT c.customer_id, c.name, SUM(oi.quantity * oi.price_per_unit) AS total_spent 
FROM customers c 
JOIN orders o
	ON c.customer_id = o.customer_id 
JOIN order_items oi 
	ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name
) 
SELECT customer_id, name, total_spent, 
CASE 
	WHEN total_spent >= 50000 THEN 'High Value'
    WHEN total_spent BETWEEN 20000 AND 49999 THEN 'Medium Value' 
    ELSE 'Low value'
END AS customer_segment 
FROM customer_spending;  
