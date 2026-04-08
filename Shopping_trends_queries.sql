-- 1. DATA EXPLORATION
select * from shopping_trends;

-- 2. DATA CLEANING
select * FROM shopping_trends where customer_id is NULL;
# no null or missing values
ALTER TABLE shopping_trends RENAME COLUMN `Customer ID` TO customer_id;
 ALTER TABLE shopping_trends RENAME COLUMN `Item Purchased` to item_purchased;
  ALTER TABLE shopping_trends RENAME COLUMN `Purchase Amount (USD)` to purchase_amount_USD;
  ALTER TABLE shopping_trends RENAME COLUMN `Review Rating` to review_rating;
  ALTER TABLE shopping_trends RENAME COLUMN `Subscription Status` to subscription_status;
 ALTER TABLE shopping_trends RENAME COLUMN `Payment Method` to payment_method,
RENAME COLUMN `Shipping Type` to shipping_type,
RENAME COLUMN `Discount Applied` to discount_applied,
RENAME COLUMN `Promo Code Used` to promo_code_used,
RENAME COLUMN `Previous Purchases` to previous_purchases,
RENAME COLUMN `Preferred Payment Method` to preferred_payment_method,
RENAME COLUMN `Frequency of Purchases` to frequency_of_purchases;

-- 3. BASIC METRICS
SELECT count(distinct customer_id) as total_customers FROM shopping_trends;
# total customers is 3,900

-- REVENUE ANALYSIS
-- find the total revenue
SELECT count(*) as total_orders, SUM(purchase_amount_USD) as total_revenue, AVG(purchase_amount_USD) AS avg_order_value
 from shopping_trends;
-- total_revenue generated is 233081 USD and avg_order_value is 59.7644

-- B SALES ANALYSIS
-- Revenue by category
SELECT category, SUM(purchase_amount_USD) as revenue from shopping_trends
group by category
order by revenue DESC;
-- the clothing category generated the most revenue with a revenue of 104264

-- C Product Perforrmance
-- Top Selling Products
SELECT item_purchased, count(*) as total_orders, sum(purchase_amount_USD) as revenue
from shopping_trends 
group by item_purchased 
order by revenue DESC 
LIMIT 5;
-- blouse is the top performing product by order volume, 
-- indicating strong customer demand. The business can increase inventory and run targeted promotions to maximize revenue

-- D Customer Behavior
-- Average spending per customer
SELECT customer_id, AVG(purchase_amount_USD) AS avg_spent from shopping_trends
group by customer_id
order by avg_spent DESC;

-- 4. CUSTOMER DEMOGRAPHIC ANALYSIS
-- Revenue by gender; which gender spends more
SELECT gender, SUM(purchase_amount_USD) AS revenue from shopping_trends 
group by gender;
-- Male gender appears to have generated the most revenue with a revenue of 157890

-- Age group analysis; which age group spends the most
SELECT 
CASE
	WHEN age <25 THEN '18-24'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    ELSE '45+'
END AS age_group,
SUM(purchase_amount_USD) AS revenue from shopping_trends 
group by
CASE
	WHEN age <25 THEN '18-24'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    ELSE '45+'
END 
order by revenue DESC;
-- The 45+ age group generated the most revenue with a revenue of 114960

-- 5 LOCATION BASED ANALYSIS
 -- which location generates the most revenue
 SELECT location, SUM(purchase_amount_USD) AS revenue from shopping_trends group by location
order by revenue DESC
limit 5;
-- Montana generates the most revenue compared to other locations with a revenue of 5784

-- 6. PAYMENT AND TRANSACTION ANALYSIS
-- Which payment method is most used?
SELECT payment_method, count(*) as Usage_count,
sum(purchase_amount_USD) as revenue,
avg(purchase_amount_USD) as avg_spent
from shopping_trends
group by payment_method
order by revenue DESC;
-- Credit card was the most used by customers with a usage count of 696, revenue of 42567 and avg spend of 61.1595

-- Which payment method brings the most revenue?
select payment_method, sum(purchase_amount_USD) from shopping_trends
group by payment_method	
order by sum(purchase_amount_USD) DESC;
-- Credit Card payment method generated the most revenue

-- 7.  DISCOUNT AND PROMO IMPACT
-- Do discount increase purchase amount?
select discount_applied, 
count(*) as total_orders,
sum(purchase_amount_USD) as total_revenue,
AVG(purchase_amount_USD) as avg_order_value
from shopping_trends
group by discount_applied;
-- it shows that discount doesn't increase purchase amount as the average for purchase for discount applied happens to be 59.2791 compared to when no discount was applied which had an average of 60.1305

-- Are promo codes effective?
select promo_code_used, SUM(purchase_amount_USD) from shopping_trends
group by promo_code_used;
-- it shows that promo codes doesn't increase purchase amount as the summ for purchase amount for when promo codes was used happens to be 99411 compared  to when no promo codes was used which had a sum of 133670

-- 8. CUSTOMER LOYALTY AND BEHAVIOUR
-- Who are repeat customers?
select customer_id, sum(purchase_amount_USD) as total_spent FROM shopping_trends
group by customer_id
order by total_spent DESC
LIMIT 10;

-- Do previous purchases affect spending?
select previous_purchases, SUM(purchase_amount_USD) FROM shopping_trends
group by previous_purchases
ORDER BY SUM(purchase_amount_USD) DESC;

-- 9 REVIEW AND SATISFACTION ANALYSIS
-- Do higher ratings mean higher spending
select review_rating, AVG(purchase_amount_USD) FROM shopping_trends
group by review_rating
order by review_rating DESC;
-- Higher rating means higher spending because the highest rating has the highest purchase amount although it fluctuates as the ratings reduces

-- 10. SHIPPING AND DELIVERY ANALYSIS
-- Which shipping type is most used?
SELECT shipping_type, count(*) as usage_count from shopping_trends
group by shipping_type
order by usage_count DESC;
-- Free shipping is the most used with usage count of 675

-- does shipping affect purchase amount
select shipping_type, count(*) as usage_count
 FROM shopping_trends
group by shipping_type
order by usage_count DESC;

-- 11. CUSTOMER SEGMENTATION
select customer_id, sum(purchase_amount_USD) AS total_spent,
CASE
	WHEN SUM(purchase_amount_USD) > 500 THEN 'High Value'
    WHEN SUM(purchase_amount_USD) BETWEEN 200 AND 500 THEN 'Mid Value'
    ELSE 'Low Value'
END AS customer_segment
FROM shopping_trends
group by customer_id;

-- SEASON ANALYSIS
SELECT Season, sum(purchase_amount_USD) AS revenue FROM shopping_trends
group by season
order by revenue DESC;
-- The business had the highest revenue during the fall season with a revenue of 60018