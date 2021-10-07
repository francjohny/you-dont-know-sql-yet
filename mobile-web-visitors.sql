-- With the following two tables, return the fraction of users who only visited mobile, only visited web, and visited both.

-- Table mobile
-- user_id      page_url
-- 1            A
-- 2            B
-- 3            C
-- 4            A
-- 9            B
-- 2            C
-- 10           B

-- Table web
-- user_id      page_url
-- 6            A
-- 2            B
-- 3            C
-- 7            A
-- 4            B
-- 8            C
-- 5            B

-- MySQL does not support Full (Outer) Joins; but you can sure emulate them!

WITH t1 AS (
SELECT m.user_id AS mobile_user, w.user_id AS web_user FROM mobile m
LEFT JOIN web w
ON m.user_id = w.user_id
UNION ALL
SELECT m.user_id AS mobile_user, w.user_id AS web_user FROM mobile m
RIGHT JOIN web w
ON m.user_id = w.user_id
WHERE m.id IS NULL
), 
t2 AS (
SELECT SUM(CASE WHEN mobile_user IS NOT NULL AND web_user IS NULL THEN 1 ELSE 0 END) AS mobile_only,
SUM(CASE WHEN mobile_user IS NULL AND web_user IS NOT NULL THEN 1 ELSE 0 END) AS web_only,
SUM(CASE WHEN mobile_user IS NOT NULL AND web_user IS NOT NULL THEN 1 ELSE 0 END) AS web_mobile,
COUNT(*) AS total
FROM t1
)
SELECT ROUND(1.0 * mobile_only / total, 1) AS mobile_fraction, ROUND(1.0 * web_only / total, 1) AS web_fraction, ROUND(1.0 * web_mobile/total, 1) AS both_fraction
FROM t2