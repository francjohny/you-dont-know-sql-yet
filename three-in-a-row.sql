-- The attendance table logs the number of people counted in a crowd each day an event is held. Write a query to return a table showing the date and visitor count of high-attendance periods, defined as three consecutive entries (not necessarily consecutive dates) with more than 100 visitors.
-- Table attendance
-- event_date       visitors
-- 2020-01-01       10
-- 2020-01-04       109
-- 2020-01-05       150
-- 2020-01-06       99
-- 2020-01-07       145
-- 2020-01-08       1455
-- 2020-01-11       199
-- 2020-01-12       188
WITH cte1 AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            ORDER BY
                (event_date)
        ) AS day_num
    FROM
        attendance
),
cte2 AS (
    SELECT
        *
    FROM
        cte1
    WHERE
        visitors > 100
) cte3 AS (
    SELECT
        a.day_num AS day1,
        b.day_num AS day2,
        c.day_num AS day3
    FROM
        cte2 a
        JOIN cte2 ON a.day_num = b.day_num - 1
        JOIN cte2 c ON a.day_num = c.day_num - 2
)
SELECT
    event_date,
    visitors
FROM
    cte1
WHERE
    day_num IN (
        SELECT
            day1
        FROM
            cte3
    )
    OR day_num IN (
        SELECT
            day2
        FROM
            cte3
    )
    OR day_num IN (
        SELECT
            day3
        FROM
            cte3
    )
