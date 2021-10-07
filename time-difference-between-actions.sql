-- From the following table of user actions, write a query to return for each user the time elapsed between the last action and the second-to-last action, in ascending order by user ID.

-- Table users
-- user_id      action      action_date
-- 1            start       20-2-12
-- 1            cancel      20-2-13
-- 2            start       20-2-11
-- 2            publish     20-2-14
-- 3            start       20-2-15
-- 3            cancel      20-2-15
-- 4            start       20-2-18
-- 1            publish     20-2-19

WITH cte1 AS (
SELECT user_id, action, action_date, ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY action_date DESC) AS date_rank FROM users
),
latest AS (
SELECT user_id, action_date FROM cte1
WHERE date_rank = 1
),
second_latest AS (
SELECT user_id, action_date FROM cte1
WHERE date_rank = 2
)
SELECT latest.user_id, DATEDIFF(latest.action_date, second_latest.action_date) AS days_elapsed
FROM latest
LEFT JOIN second_latest
ON latest.user_id = second_latest.user_id
ORDER BY 1
