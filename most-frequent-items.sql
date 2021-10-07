-- From the following table containing a list of dates and items ordered, write a query to return the most frequent item ordered on each date. Return multiple items in the case of a tie.

-- Table items
-- date     item
-- 1-1-20   apple
-- 1-1-20   apple
-- 1-1-20   pear
-- 1-1-20   pear
-- 1-2-20   pear
-- 1-2-20   pear
-- 1-2-20   pear
-- 1-2-20   orange

WITH cte1 AS (
SELECT date, item, count(*) as count FROM items
GROUP BY date,item
ORDER BY date
),
cte2 AS (
SELECT date, item, dense_rank() OVER(PARTITION BY date ORDER BY count desc) AS item_rank FROM cte1 
)
SELECT date, item
FROM cte2
WHERE item_rank = 1
