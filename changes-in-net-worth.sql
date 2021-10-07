-- From the following table of transactions between two users, write a query to return the change in net worth for each user, ordered by decreasing net change.

-- Table: transactions
-- sender   receiver    amount  transaction_date
-- 5        2           10      2-12-20
-- 1        3           15      2-13-20
-- 2        1           20      2-13-20
-- 2        3           25      2-14-20
-- 3        1           20      2-15-20
-- 3        2           15      2-15-20
-- 1        4           5       2-16-20

WITH 
debits AS (
SELECT sender, SUM(amount) FROM transactions
GROUP BY sender
),
credits AS (
SELECT receiver, SUM(amount) FROM transactions
GROUP BY receiver
)
SELECT coalesce(sender, receiver) AS user, coalesce(credit_amount, 0) - coalesce(debit_amount, 0) AS net_change
FROM debits
FULL OUTER JOIN credits
ON debits.sender = credits.receiver
ORDER BY net_change DESC
