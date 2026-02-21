WITH customer_summary AS(
    SELECT
    user_id,
    DATE_DIFF()
    FROM
    retail_fact_table
    )
