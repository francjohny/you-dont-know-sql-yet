-- A company defines its super users as those who have made at least two transactions. From the following table, write a query to return, for each user, the date when they become a super user, ordered by oldest super users first. Users who are not super users should also be present in the table.

-- Table users
-- user_id      product_id      transaction_date
-- 1            101             2020-2-12
-- 2            105             2020-2-13
-- 1            111             2020-2-14
-- 3            121             2020-2-15
-- 1            101             2020-2-16
-- 2            105             2020-2-17
-- 4            101             2020-2-16
-- 3            105             2020-2-15

WITH cte1 AS (
SELECT user_id, transaction_date, ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS transaction_count
FROM users1
),
cte2 AS (
SELECT DISTINCT user_id
FROM users
),
cte3 AS (
SELECT user_id, transaction_date, transaction_count FROM cte1
WHERE cte1.transaction_count =2
)
SELECT cte2.user_id, transaction_date AS superuser_date
FROM cte3
RIGHT JOIN cte2 ON cte2.user_id = cte3.user_id
ORDER BY 2
