
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

SELECT 
    order_id,
    ROUND(SUM(sale_price) / 1.2::NUMERIC, 2) AS net_sales_rounded
FROM order_items
GROUP BY order_id
ORDER BY order_id;

-- Multiple tiered CTEs
-- Data is cleaned to show net sales for each complete order in the UK states/region
-- Join the user, order and order items tables
-- Excluded non-completed orders
-- Calculate net revenue for each order
-- The organised data from the first CTE is used to calculate the rfm value
-- and determine customer segments

WITH retail_fact_table AS (
    SELECT
	oi.user_id,
    oi.order_id,
    oi.product_id,
    u.state,
	u.city,
    DATE(o.created_at) AS order_date,
    ROUND(SUM(oi.sale_price) / 1.2, 2) as net_sales_rounded
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
	u.city,
    order_date
	),

-- Find the RFM values
customer_summary AS(
	SELECT
		user_id,
		state,
	-- Recency: Number of days since last purchase: (Latest day in dataset - user's last purchase date)
	((SELECT MAX(order_date) FROM retail_fact_table) - MAX(order_date))  AS recency_days,
	
	
	-- Frequency: How often they purchase
	COUNT(DISTINCT order_id) AS frequency,
	
	-- Monetary: How much users spent
	SUM(net_sales_rounded) AS monetary_value
		
	FROM retail_fact_table 
	--GROUP BY user_id, state
	--ORDER BY recency_days
	),

customer_rank_score AS(
	SELECT user_id,
	state,
	recency_days,
	frequency,
	monetary_value,

	-- Recency: Lower score is better as lower (more recent) days are better
	-- 1 = most recent, 5 = least recent
	NTILE(5) OVER (ORDER BY recency_days ASC) AS r_score,

	-- Frequency: Higher frequency is better, so a lower score is better because of 
	-- the descending order
	-- 1 = highest frequency, 5 = least frequency
	NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,

	-- Monetary: Higher monetary value is better, so a lower score is better because of the
	-- descending order
	-- 1 = highest monetary, 5 = least monetary
	NTILE(5) OVER (ORDER BY monetary_value DESC) AS m_score

	FROM

	customer_summary
	)
SELECT *,
	CONCAT(r_score,f_score,m_score) AS rfm_score,
CASE
	WHEN r_score <= 2 AND f_score <= 2 AND m_score <= 2 THEN 'Top Value'
	WHEN f_score <= 2 THEN 'Loyal Customers'
	WHEN r_score >= 4 AND m_score <= 2 THEN 'At Risk High Value'
	WHEN r_score >= 4 AND f_score >= 4 THEN 'Churned'
	WHEN r_score <= 2 AND f_score >= 4 THEN 'New Customers'
  ELSE 'Potential'
END AS customer_segment
FROM customer_rank_score
;

