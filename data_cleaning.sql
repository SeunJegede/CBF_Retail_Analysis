
--check for sales cells are zero or negligent
SELECT id, order_id
FROM order_items
WHERE sale_price <= 0;
-- no sales_price cell has a zero or negligent value

-- display only completed orders
SELECT id, order_id, status
FROM order_items
WHERE status = 'Complete';

-- create the fact table that informs analysis
WITH retail_fact_table AS (
    SELECT
    oi.order_id,
    oi.user_id,
    oi.product_id,
    DATE(o.created_at) AS created_date,
    ROUND(p.retail_price * o.num_of_item, 2) AS Sales_Price
    FROM order_items oi
    INNER JOIN orders o
		ON oi.order_id = o.order_id
	INNER JOIN products p
		ON p.id = oi.product_id
    WHERE o.status = 'Complete'
	)
SELECT *
FROM retail_fact_table;