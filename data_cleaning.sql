
--check for sales cells are zero or negligent
SELECT id, order_id
FROM order_items
WHERE sale_price <= 0;
-- no sales_price cell has a zero or negligent value

-- display only completed orders
SELECT id, order_id, status
FROM order_items
WHERE status = 'Complete';


--Applying VAT for the UK as 20%
-- Net sales = Gross sales / 1.2
-- Net sales show the profit made from orders after tax

SELECT order_id, ROUND(sale_price / 1.2 , 2) AS _net_sales_price_rounded
FROM order_items
GROUP BY order_id, sale_price
ORDER BY order_id;

-- The fact table
-- Data is cleaned to show net sales for each complete order in the UK states/region
-- Join the user, order and order items tables
-- Excluded non-completed orders
-- Calculate net revenue for each order

WITH retail_fact_table AS (
SELECT
    oi.order_id,
    oi.user_id,
    oi.product_id,
    u.state,
    DATE(o.created_at) AS created_date,
    ROUND(oi.sale_price / 1.2, 2) as net_sales_rounded
    FROM order_items oi
    INNER JOIN orders o
    ON oi.order_id = o.order_id
    INNER JOIN users u
    ON oi.user_id = u.id
WHERE o.status = 'Complete'
AND u.country = 'United Kingdom'
GROUP BY 
    oi.order_id,
    oi.user_id,
    oi.product_id,
    u.state,
    DATE(o.created_at),
    oi.sale_price
  )
SELECT *
FROM retail_fact_table;