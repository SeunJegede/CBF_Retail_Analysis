INSERT INTO final_rfm_results (
    user_id,
    order_id,
    order_date,
    net_sales,
    state,
    city,
    recency_days,
    frequency,
    monetary_value,
    r_score,
    f_score,
    m_score,
    rfm_score,
    customer_segment
)

WITH retail_fact_table AS (
    SELECT
        oi.user_id,
        oi.order_id,
        u.state,
        u.city,
        DATE(o.created_at) AS order_date,
        ROUND(SUM(oi.sale_price) / 1.2, 2) AS net_sales
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    JOIN users u ON oi.user_id = u.id
    WHERE o.status = 'Complete'
      AND u.country = 'United Kingdom'
    GROUP BY
        oi.user_id,
        oi.order_id,
        u.state,
        u.city,
        order_date
),

customer_summary AS (
    SELECT
        user_id,

        -- Recency
        (SELECT MAX(order_date) FROM retail_fact_table)
        - MAX(order_date) AS recency_days,

        -- Frequency
        COUNT(DISTINCT order_id) AS frequency,

        -- Monetary
        SUM(net_sales) AS monetary_value

    FROM retail_fact_table
    GROUP BY user_id
),

customer_rank_score AS (
    SELECT
        user_id,
        recency_days,
        frequency,
        monetary_value,

        NTILE(5) OVER (ORDER BY recency_days ASC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary_value DESC) AS m_score

    FROM customer_summary
)

SELECT
    rft.user_id,
    rft.order_id,
    rft.order_date,
    rft.net_sales,
    rft.state,
    rft.city,

    crs.recency_days,
    crs.frequency,
    crs.monetary_value,
    crs.r_score,
    crs.f_score,
    crs.m_score,

    CONCAT(crs.r_score, crs.f_score, crs.m_score)::INT AS rfm_score,

    CASE
        WHEN crs.r_score <= 2 AND crs.f_score <= 2 AND crs.m_score <= 2 THEN 'Top Value'
        WHEN crs.f_score <= 2 THEN 'Loyal Customers'
        WHEN crs.r_score >= 4 AND crs.m_score <= 2 THEN 'At Risk High Value'
        WHEN crs.r_score >= 4 AND crs.f_score >= 4 THEN 'Churned'
        WHEN crs.r_score <= 2 AND crs.f_score >= 4 THEN 'New Customers'
        ELSE 'Potential'
    END AS customer_segment

FROM retail_fact_table rft
JOIN customer_rank_score crs
    ON rft.user_id = crs.user_id;

SELECT recency_days, frequency, monetary_value
FROM final_rfm_results
ORDER BY monetary_value desc


-- -- Count the number of customers in each segment
SELECT customer_segment,
COUNT(customer_segment) as counted
FROM
final_rfm_results
GROUP BY customer_segment
ORDER BY COUNT(customer_segment) desc;

SELECT * final_rfm_results


-- Check recency per region(state)
-- Retention rate = retained / total customer
SELECT 
	state,
	
	COUNT(DISTINCT user_id) AS total_customers_percent,
	
	COUNT(DISTINCT CASE 
	WHEN recency_days <= 90  THEN user_id
	END)
	AS retained_customers,

	ROUND(COUNT(DISTINCT CASE 
	WHEN recency_days <= 90 THEN user_id END)::numeric /
	COUNT(DISTINCT user_id)* 100,2
	) AS retention_rate
	
FROM final_rfm_results
GROUP BY state
ORDER BY retention_rate DESC;






