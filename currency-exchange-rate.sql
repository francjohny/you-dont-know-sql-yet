-- There are two tables. The first table name is sales_amount. The second table name is exchange_rate. When the exchange rate changes, a new row is inserted in the exchange_rate table with a new effective start date.

-- Write a query to get the total sales amount in USD (two decimal points) for each sales_date, ordered by sales_date.

-- Table: sales_amount
-- sales_date	sales_amount	currency
-- 2020-01-01	500	            INR
-- 2020-01-01	100	            GBP
-- 2020-01-02	1000	        INR
-- 2020-01-02	500	            GBP
-- 2020-01-03	500	            INR
-- 2020-01-17	200	            GBP
 

-- Table: exchange_rate
-- source_currency	target_currency	exchange_rate	effective_start_date
-- INR	            USD	            0.14	        2019-12-31
-- INR	            USD	            0.15	        2020-01-02
-- GBP	            USD	            1.32	        2019-12-20
-- GBP	            USD	            1.3	            2020-01-01
-- GBP	            USD	            1.35	        2020-01-16

SELECT sales_date, ROUND(SUM(sales_amount * er.exchange_rate), 2)
FROM sales_amount
JOIN (
SELECT *, IFNULL(DATE_ADD(LEAD(effective_start_date) OVER (PARTITION BY source_currency ORDER BY effective_start_date), INTERVAL -1 DAY), '9999-12-31') as effective_end_date
FROM exchange_rate
) AS er ON sales_amount.currency=er.source_currency
WHERE er.target_currency = 'USD' AND sales_date BETWEEN er.effective_start_date AND er.effective_end_date
GROUP BY sales_date
