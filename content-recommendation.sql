-- Using the following two tables, write a query to return page recommendations to a social media user based on the pages that their friends have liked, but that they have not yet marked as liked. Order the result by ascending user ID.

-- Table friends
-- user_id      friend
-- 1            2
-- 1            3
-- 1            4
-- 2            1
-- 3            1
-- 3            4
-- 4            1
-- 4            3

-- Table likes
-- user_id      page_likes
-- 1            A
-- 1            B
-- 1            C
-- 2            A
-- 3            B
-- 3            C
-- 4            B

-- Solution 1
SELECT * FROM (SELECT DISTINCT friends.user_id as user_id, page_likes 
FROM likes
RIGHT JOIN friends 
ON friends.user_id != likes.user_id AND likes.user_id = friends.friend
ORDER BY 1) AS dt WHERE (dt.user_id, dt.page_likes)
NOT IN
(SELECT user_id, page_likes FROM likes)


-- Solution 2
WITH t1 AS (
SELECT l.user_id, l.page_likes, f.friend
FROM likes l
JOIN friends f
ON l.user_id = f.user_id ),
t2 AS (
SELECT t1.user_id, t1.page_likes, t1.friend, l.page_likes AS friend_likes
FROM t1
LEFT JOIN likes l
ON t1.friend = l.user_id
AND t1.page_likes = l.page_likes )
SELECT DISTINCT friend AS user_id, page_likes AS recommended_page
FROM t2
WHERE friend_likes IS NULL
ORDER BY 1 ASC