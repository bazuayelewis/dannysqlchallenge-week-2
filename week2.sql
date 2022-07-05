DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
    runner_id INT,
    registration_date DATE,
    PRIMARY KEY (runner_id)
);

INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');
  SELECT * FROM runners;

DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  order_id INTEGER,
  runner_id INTEGER,
  pickup_time TIMESTAMP,
  distance_KM float4,
  duration TIME,
  cancellation VARCHAR(23),
  PRIMARY KEY (order_id),
  FOREIGN KEY (runner_id) REFERENCES runners(runner_id) ON DELETE SET NULL
);

INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance_KM, duration, cancellation)
VALUES
  (1, 1, '2020-01-01 18:15:34', 20, '00:32:00', NULL),
  (2, 1, '2020-01-01 19:10:54', 20, '00:27:00', NULL),
  (3, 1, '2020-01-03 00:12:37', 13.4, '00:20:00', NULL),
  (4, 2, '2020-01-04 13:53:03', 23.4, '00:40:00', NULL),
  (5, 3, '2020-01-08 21:10:57', 10, '00:15:00', NULL),
  (6, 3, NULL, NULL, NULL, 'Restaurant Cancellation'),
  (7, 2, '2020-01-08 21:30:45', 25, '00:25:00', NULL),
  (8, 2, '2020-01-10 00:15:02', 23.4, '00:15:00', NULL),
  (9, 2, NULL, NULL, NULL, 'Customer Cancellation'),
  (10, 1, '2020-01-11 18:50:20', 10, '00:10:00', NULL);
SELECT* FROM runner_orders;

DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  pizza_id INTEGER,
  pizza_name TEXT,
  toppings TEXT,
  PRIMARY KEY (pizza_id)
);
INSERT INTO pizza_names
  (pizza_id, pizza_name, toppings)
VALUES
  (1, 'Meatlovers','1, 2, 3, 4, 5, 6, 8, 10'),
  (2, 'Vegetarian','4, 6, 7, 9, 11, 12');
SELECT * FROM pizza_names;

DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  unique_id VARCHAR (1),
  order_id INTEGER,
  customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP,
  PRIMARY KEY (unique_id),
  FOREIGN KEY (order_id) REFERENCES runner_orders(order_id) ON DELETE SET NULL,
  FOREIGN KEY (pizza_id) REFERENCES pizza_names(pizza_id) ON DELETE SET NULL
);
INSERT INTO customer_orders
  (unique_id, order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ("A", 1, 101, 1, NULL, NULL, '2020-01-01 18:05:02'),
  ("B", 2, 101, 1, NULL, NULL, '2020-01-01 19:00:52'),
  ("C", 3, 102, 1, NULL, NULL, '2020-01-02 23:51:23'),
  ("D", 3, 102, 2, NULL, NULL, '2020-01-02 23:51:23'),
  ("E", 4, 103, 1, '4', NULL, '2020-01-04 13:23:46'),
  ("F", 4, 103, 1, '4', NULL, '2020-01-04 13:23:46'),
  ("G", 4, 103, 2, '4', NULL, '2020-01-04 13:23:46'),
  ("H", 5, 104, 1, NULL, '1', '2020-01-08 21:00:29'),
  ("I", 6, 101, 2, NULL, NULL, '2020-01-08 21:03:13'),
  ("J", 7, 105, 2, NULL, '1', '2020-01-08 21:20:29'),
  ("K", 8, 102, 1, NULL, NULL, '2020-01-09 23:54:33'),
  ("L", 9, 103, 1, '4', '1, 5', '2020-01-10 11:22:59'),
  ("M", 10, 104, 1, NULL, NULL, '2020-01-11 18:34:49'),
  ("N", 10, 104, 1, '2, 6', '1, 4', '2020-01-11 18:34:49');
SELECT * FROM customer_orders;

DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  topping_id INTEGER,
  topping_name TEXT
);
INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');

-- A. Pizza Metrics
-- 1. How many pizza were ordered
SELECT COUNT(pizza_id) as pizza_ordered
FROM customer_orders;

-- 2. How many unique customer orders where made?
SELECT COUNT(DISTINCT(order_id)) as unique_orders
FROM customer_orders;

-- 3. How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(order_id) as successful_orders
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;

-- 4. How many of each type of pizza was delivered?
SELECT  c.pizza_id, COUNT(r.order_id) AS sucessful_delivery
FROM runner_orders as r
JOIN customer_orders as c ON r.order_id = c.order_id
WHERE cancellation IS NULL
GROUP BY c.pizza_id;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT  c.customer_id, p.pizza_name, COUNT(c.order_id) AS pizza_orderded
FROM runner_orders as r
JOIN customer_orders as c ON r.order_id = c.order_id
JOIN pizza_names as p  ON c.pizza_id = p.pizza_id
GROUP BY c.customer_id,c.pizza_id
ORDER BY c.customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT r.order_id, COUNT(pizza_id) as max_delivery_per_order
FROM customer_orders c
JOIN runner_orders r ON c.order_id=r.order_id
WHERE cancellation IS NULL
GROUP BY r.order_id
ORDER BY max_delivery_per_order DESC;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
WITH delivered_pizzas AS (SELECT c.*, r.cancellation
		FROM customer_orders c
		LEFT JOIN runner_orders r ON c.order_id = r.order_id
		WHERE cancellation IS NULL)
SELECT customer_id,
 CASE WHEN exclusions IS NULL AND extras IS NULL THEN count(pizza_id)
 END AS no_change_made,
 CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN count(pizza_id)
END AS changes_made
FROM delivered_pizzas
GROUP BY customer_id;

-- 8.How many pizzas were delivered that had both exclusions and extras?
WITH delivered_pizzas AS (SELECT c.*, r.cancellation
		FROM customer_orders c
		LEFT JOIN runner_orders r ON c.order_id = r.order_id
		WHERE cancellation IS NULL)
SELECT COUNT(pizza_id) AS delivered_pizzas
FROM delivered_pizzas
WHERE exclusions IS NOT NULL AND extras IS NOT NULL;

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT EXTRACT(HOUR FROM order_time) AS hours, COUNT(pizza_id) as no_of_orders
FROM customer_orders
GROUP BY hours
ORDER BY hours;

-- 10. What was the volume of orders for each day of the week?
WITH cte as (SELECT DATE(order_time) AS days, pizza_id
		FROM customer_orders)
SELECT DAYNAME(days) as weekly_orders, COUNT(pizza_id) as no_of_orders
FROM cte
GROUP BY weekly_orders
ORDER BY no_of_orders;

-- PART B
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01) 
WITH cte AS (SELECT registration_date, week(registration_date,1) as weeks
		FROM runners)
SELECT weeks, COUNT(weeks) AS no_of_runners
FROM cte
group by weeks;

-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
WITH cte as (SELECT timediff(pickup_time,order_time) as arrival_time, r.runner_id, c.order_id
		FROM customer_orders c
		JOIN runner_orders r ON c.order_id=r.order_id 
		WHERE pickup_time IS NOT NULL),
testing as (
		SELECT time_to_sec(arrival_time)/60 as arrival_mins, runner_id
		FROM cte
		GROUP BY runner_id)
SELECT runner_id, CAST(avg(arrival_mins) AS DECIMAL(4,2)) AS average_arrival_time
FROM testing
GROUP BY runner_id;

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT timediff(pickup_time,order_time) as prep_time, c.order_id, COUNT(c.pizza_id) AS no_of_pizza
FROM customer_orders c
JOIN runner_orders r ON c.order_id=r.order_id 
WHERE pickup_time IS NOT NULL
GROUP BY order_id
ORDER BY prep_time
/*Yes, there is a relationship between number of pizzas ordered and how long to prepare.
This is because multiple pizzas take longer to pickup*/;

-- 4. What was the average distance travelled for each customer?
SELECT c.customer_id, CAST(AVG(r.distance_KM) AS FLOAT) AS average_distance
FROM runner_orders r
JOIN customer_orders c ON r.order_id=c.order_id
WHERE r.distance_KM IS NOT NULL
GROUP BY c.customer_id;

-- 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT TIMEDIFF(MAX(duration),MIN(duration)) AS delivery_time
FROM runner_orders;

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
WITH cte AS (
		SELECT distance_KM*1000 as distance, time_to_sec(duration) as duration_sec,order_id, runner_id
		FROM runner_orders
		WHERE distance_KM IS NOT NULL
		GROUP BY order_id
)
SELECT runner_id, CAST(avg(distance/duration_sec) AS DECIMAL(4,2)) as speed_m_s
FROM cte
GROUP BY runner_id;

-- 7. What is the successful delivery percentage for each runner?
WITH cte AS(
	SELECT count(order_id) AS total, count(pickup_time) AS successful, count(cancellation) AS cancelled, runner_id
	FROM runner_orders
	GROUP BY runner_id
    )
SELECT runner_id, CAST((successful/total) AS FLOAT)*100 as percent_successful_order
FROM cte
GROUP BY runner_id; 

-- PART C
-- 1. What are the standard ingredients for each pizza?
WITH cte AS (SELECT topping_name as meat_lovers, topping_id
		FROM pizza_toppings
		WHERE topping_id != 7 AND topping_id !=9 AND topping_id !=11 AND topping_id != 12),
testing AS ( SELECT topping_name as vegeterian, topping_id
		FROM pizza_toppings
		WHERE topping_id != 1 AND topping_id !=2 AND topping_id !=3 AND topping_id!= 5 AND topping_id != 8 AND topping_id !=10)
SELECT c.meat_lovers, t.vegeterian
FROM cte c
LEFT JOIN testing t ON c.topping_id=t.topping_id
UNION
SELECT c.meat_lovers, t.vegeterian
FROM cte c
RIGHT JOIN testing t ON c.topping_id=t.topping_id;

-- 2. What was the most commonly added extra?
/*This is the best I can do, could not get a better query*/
WITH cte AS (SELECT COUNT(extras) AS no_bacon
		FROM customer_orders
		WHERE extras NOT LIKE '1%' 
),
testing AS (SELECT COUNT(extras) as orders_with_bacon
		FROM customer_orders
		WHERE extras LIKE '1%')
SELECT no_bacon,orders_with_bacon
FROM cte, testing;

-- 3. What was the most common exclusion?
/* Still have not found a better way to query this*/
WITH cte AS (SELECT COUNT(exclusions) AS exclusions_without_cheese
		FROM customer_orders
		WHERE exclusions NOT LIKE '4%' 
),
testing AS (SELECT COUNT(exclusions) AS exclusions_with_cheese
		FROM customer_orders
		WHERE exclusions LIKE '4%')
SELECT exclusions_without_cheese,exclusions_with_cheese
FROM cte, testing;

/* 4. Generate an order item for each record in the customers_orders table in the format of one of the following: 
Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers*/

SELECT *, 
	CASE WHEN pizza_id=1 AND exclusions IS NULL AND extras IS NULL THEN 'Meat Lovers'
	WHEN  pizza_id=2 AND exclusions IS NULL AND extras IS NULL THEN 'Vegeterian'
	WHEN pizza_id=1 AND exclusions='4' AND extras IS NULL THEN 'Meat Lovers-Exclude Cheese'
	WHEN pizza_id=2 AND exclusions='4'AND extras IS NULL THEN 'Vegeterian-Exclude Cheese'
	WHEN pizza_id=1 AND extras='1, 5' AND exclusions='4' THEN 'Meat Lovers-Exclude Cheese - Extra Bacon,Chicken'
	WHEN pizza_id=1 AND extras='1, 4' AND exclusions='2, 6' THEN 'Meat Lovers-Exclude BBQ Sauce,Mushrooms - Extra Bacon,Cheese'
	WHEN pizza_id=1 AND extras='1' AND exclusions IS NULL THEN 'Meat Lovers-Extra Bacon'
	WHEN pizza_id=2 AND extras='1' AND exclusions IS NULL THEN 'Vegeterian-Extra Bacon'
		END AS orders
FROM customer_orders;
            
/* 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"*/
SELECT *, 
	CASE WHEN pizza_id=1 AND exclusions IS NULL AND extras IS NULL THEN 'Meat Lovers: Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami'
	WHEN  pizza_id=2 AND exclusions IS NULL AND extras IS NULL THEN 'Vegeterian: Cheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce'
	WHEN pizza_id=1 AND exclusions='4' AND extras IS NULL THEN 'Meat Lovers: Bacon, BBQ Sauce, Beef, Chicken, Mushrooms, Pepperoni, Salami'
	WHEN pizza_id=2 AND exclusions='4'AND extras IS NULL THEN 'Vegeterian: Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce'
	WHEN pizza_id=1 AND extras='1, 5' AND exclusions='4' THEN 'Meat Lovers: 2xBacon, BBQ Sauce, Beef, 2xChicken, Mushrooms, Pepperoni, Salami'
	WHEN pizza_id=1 AND extras='1, 4' AND exclusions='2, 6' THEN 'Meat Lovers: 2xBacon, Beef, 2xCheese, Chicken, Pepperoni, Salami'
	WHEN pizza_id=1 AND extras='1' AND exclusions IS NULL THEN 'Meat Lovers: 2xBacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami'
	WHEN pizza_id=2 AND extras='1' AND exclusions IS NULL THEN 'Vegeterian: Bacon, Cheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce'
		END AS orders
FROM customer_orders;

-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
WITH cte AS (SELECT c.*, 
			CASE WHEN pizza_id=1 AND exclusions IS NULL AND extras IS NULL THEN 'Meat Lovers: Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami'
				WHEN  pizza_id=2 AND exclusions IS NULL AND extras IS NULL THEN 'Vegeterian: Cheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce'
				WHEN pizza_id=1 AND exclusions='4' AND extras IS NULL THEN 'Meat Lovers: Bacon, BBQ Sauce, Beef, Chicken, Mushrooms, Pepperoni, Salami'
				WHEN pizza_id=2 AND exclusions='4'AND extras IS NULL THEN 'Vegeterian: Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce'
				WHEN pizza_id=1 AND extras='1, 5' AND exclusions='4' THEN 'Meat Lovers: 2xBacon, BBQ Sauce, Beef, 2xChicken, Mushrooms, Pepperoni, Salami'
				WHEN pizza_id=1 AND extras='1, 4' AND exclusions='2, 6' THEN 'Meat Lovers: 2xBacon, Beef, 2xCheese, Chicken, Pepperoni, Salami'
				WHEN pizza_id=1 AND extras='1' AND exclusions IS NULL THEN 'Meat Lovers: 2xBacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami'
				WHEN pizza_id=2 AND extras='1' AND exclusions IS NULL THEN 'Vegeterian: Bacon, Cheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce'
                END AS orders
	FROM customer_orders c
	JOIN runner_orders r ON c.order_id=r.order_id
	WHERE cancellation IS NULL),
 testing AS (
SELECT *,
	CASE WHEN orders LIKE '%2xBacon%' THEN (COUNT(pizza_id)+1)
	     WHEN orders LIKE '%Bacon%' THEN COUNT(pizza_id) END AS bacon,
	CASE WHEN orders LIKE '%BBQ Sauce%' THEN COUNT(pizza_id) END AS bbq_sauce,
	CASE WHEN orders LIKE '%Beef%' THEN COUNT(pizza_id) END AS beef,
	CASE WHEN orders LIKE '%2xCheese%' THEN COUNT(pizza_id)+1
	     WHEN orders LIKE '%Cheese%' THEN COUNT(pizza_id) END AS cheese,
	CASE WHEN orders LIKE '%Chicken%' THEN COUNT(pizza_id) END AS chicken,
	CASE WHEN orders LIKE '%Mushrooms%' THEN COUNT(pizza_id) END AS mushrooms,
	CASE WHEN orders LIKE '%Onions%' THEN COUNT(pizza_id) END AS onions,
	CASE WHEN orders LIKE '%Pepperoni%' THEN COUNT(pizza_id) END AS pepperoni,
	CASE WHEN orders LIKE '%Peppers%' THEN COUNT(pizza_id) END AS peppers,
	CASE WHEN orders LIKE '%Salami%' THEN COUNT(pizza_id) END AS salami,
	CASE WHEN orders LIKE '%Tomatoes%' THEN COUNT(pizza_id) END AS tomatoes,
	CASE WHEN orders LIKE '%Tomato Sauce%' THEN COUNT(pizza_id) end as tomato_sauce
FROM cte
GROUP BY unique_id)
SELECT 'bacon' ingredients, SUM(bacon) no_of_ingredients FROM testing
UNION ALL 
SELECT 'bbq_sauce' ingredients, SUM(bbq_sauce) no_of_ingredients FROM testing
UNION ALL
SELECT 'beef' ingredients, SUM(beef) no_of_ingredients FROM testing
UNION ALL
SELECT 'cheese' ingredients, SUM(cheese) no_of_ingredients FROM testing
UNION ALL
SELECT 'chicken' ingredients, SUM(chicken) no_of_ingredients FROM testing
UNION ALL
SELECT 'mushrooms' ingredients, SUM(mushrooms) no_of_ingredients FROM testing
UNION ALL
SELECT 'onions' ingredients, SUM(onions) no_of_ingredients FROM testing
UNION ALL
SELECT 'pepperoni' ingredients, SUM(pepperoni) no_of_ingredients FROM testing
UNION ALL
SELECT 'peppers' ingredients, SUM(peppers) no_of_ingredients FROM testing
UNION ALL
SELECT 'salami' ingredients, SUM(salami) no_of_ingredients FROM testing
UNION ALL
SELECT 'tomatoes' ingredients, SUM(tomatoes) no_of_ingredients FROM testing
UNION ALL
SELECT 'tomato_sauce' ingredients, SUM(tomato_sauce) no_of_ingredients FROM testing
ORDER BY no_of_ingredients DESC;
 

/* PART D
1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees? */
WITH cte AS (SELECT
	CASE WHEN pizza_id=1 THEN (count(pizza_id)*12)
		WHEN pizza_id=2 THEN (count(pizza_id)*10)
        END AS prices_per_pizza
FROM customer_orders
GROUP BY pizza_id)
SELECT SUM(prices_per_pizza) AS total_sales
FROM cte;

-- 2. What if there was an additional $1 charge for any pizza extras?
SELECT *,
	CASE WHEN pizza_id=1 AND extras IS NULL THEN (count(pizza_id)*12)
		WHEN pizza_id=1 AND extras LIKE '%,%' THEN ((count(pizza_id)*12)+2)
		WHEN pizza_id=1 AND extras NOT LIKE '%,%' THEN ((count(pizza_id)*12)+1)
		WHEN pizza_id=2 AND extras IS NULL THEN (count(pizza_id)*10)
		WHEN pizza_id=2 AND extras LIKE '%,%' THEN ((count(pizza_id)*10)+2)
		WHEN pizza_id=2 AND extras NOT LIKE '%,%' THEN ((count(pizza_id)*10)+1)
        END AS prices_per_pizza
FROM customer_orders
GROUP BY unique_id;

-- 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
DROP TABLE IF EXISTS runner_ratings;
CREATE TABLE runner_ratings (
	order_id INT AUTO_INCREMENT,
	runner_id INT,
	ratings INT,
	PRIMARY KEY(order_id),
	FOREIGN KEY (runner_id) REFERENCES runners(runner_id) ON DELETE SET NULL);
INSERT INTO runner_ratings (runner_id, ratings)   
VALUES
(1,3),
(1,2),
(1,4),
(2,5),
(3,2),
(3,NULL),
(2,3),
(2,2),
(2,NULL),
(1,5);
SELECT *
FROM runner_ratings;

/* 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
customer_id, order_id, runner_id, rating, order_time, pickup_time, Time between order and pickup, Delivery duration, Average speed, Total number of pizzas*/
SELECT customer_id, r.*, order_time, pickup_time, timediff(pickup_time,order_time) as time_arrival_runner, duration as delivery_duration, CAST(((distance_KM*1000)/time_to_sec(duration))AS DECIMAL(4,2)) as avg_speed, COUNT(pizza_id) as total_pizza_ordered
FROM customer_orders c 
JOIN runner_ratings r ON c.order_id=r.order_id
JOIN runner_orders o ON c.order_id=o.order_id
WHERE pickup_time IS NOT NULL
GROUP BY r.order_id;

/* 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled.
 How much money does Pizza Runner have left over after these deliveries?*/
 WITH cte AS (
	 SELECT distance_KM*0.3 AS distance_cost,
					CASE WHEN pizza_id=1 THEN COUNT(pizza_id)*12
					ELSE COUNT(pizza_id)*10
					END AS total_sales
	FROM customer_orders c 
	JOIN runner_orders o ON c.order_id=o.order_id
	WHERE distance_KM IS NOT NULL
	GROUP BY c.order_id)
 SELECT CAST(SUM(total_sales)-SUM(distance_cost) AS FLOAT4) AS gross_profit
 FROM cte;
