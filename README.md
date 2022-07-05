# dannysqlchallenge-week-2

# Introduction
Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

# Available Data
Because Danny had a few years of experience as a data scientist - he was very aware that data collection was going to be critical for his business’ growth.

He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

All datasets exist within the pizza_runner database schema - be sure to include this reference within your SQL scripts as you start exploring the data and answering the case study questions.

# Entity Relationship Diagram

![Pizza Runner](https://user-images.githubusercontent.com/107050974/177214282-1259a54e-ff6b-4c9e-82ce-f99605a55542.png)

# Case Study Questions
This case study has LOTS of questions - they are broken up by area of focus including:

## Pizza Metrics
Runner and Customer Experience
Ingredient Optimisation
Pricing and Ratings
Bonus DML Challenges (DML = Data Manipulation Language)
Each of the following case study questions can be answered using a single SQL statement.

Again, there are many questions in this case study - please feel free to pick and choose which ones you’d like to try!

Before you start writing your SQL queries however - you might want to investigate the data, you may want to do something with some of those null values and data types in the customer_orders and runner_orders tables!

## A. Pizza Metrics
1. How many pizzas were ordered?

![1](https://user-images.githubusercontent.com/107050974/177214892-01c6adde-f604-4a9a-80e0-1c3877244ee9.png)

2. How many unique customer orders were made?

![2](https://user-images.githubusercontent.com/107050974/177214904-36c8ea1a-ffb7-4cf4-a1c9-ffb390f75b66.png)

3. How many successful orders were delivered by each runner?

![3](https://user-images.githubusercontent.com/107050974/177216931-531e057c-f547-412a-9f56-c4a13b066947.png)

4. How many of each type of pizza was delivered?

![4](https://user-images.githubusercontent.com/107050974/177216961-3eb1fb61-eda3-4073-9dc8-4c3a1af5befb.png)

5. How many Vegetarian and Meatlovers were ordered by each customer?

![5](https://user-images.githubusercontent.com/107050974/177214936-e7e04865-4ba0-4cea-9d02-8b511fb2208c.png)

6. What was the maximum number of pizzas delivered in a single order?

![6](https://user-images.githubusercontent.com/107050974/177215040-23600d1a-d7a3-46ef-81d7-d1b8354b91ff.png)

7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

![7](https://user-images.githubusercontent.com/107050974/177215048-5a10175c-545e-4a3a-9706-0aa62ee08b3d.png)

8. How many pizzas were delivered that had both exclusions and extras?

![8](https://user-images.githubusercontent.com/107050974/177215060-c5717b7a-3aa4-4e68-813f-a794b2c5f30d.png)

9. What was the total volume of pizzas ordered for each hour of the day?

![9](https://user-images.githubusercontent.com/107050974/177215072-5dba5789-ac07-439b-afcb-f72a0fa9a5bf.png)

10. What was the volume of orders for each day of the week?

![10](https://user-images.githubusercontent.com/107050974/177215092-e625b48b-cb26-46e6-a20c-ea7ffd94507e.png)

## B. Runner and Customer Experience
1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

![1](https://user-images.githubusercontent.com/107050974/177215204-2bd770bd-0e68-4418-a9f8-b76817d475d4.png)

2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

![2](https://user-images.githubusercontent.com/107050974/177215218-40419b43-64ef-4706-bb3f-fb65c079b97a.png)

3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

![3](https://user-images.githubusercontent.com/107050974/177215237-7967c4cf-ab14-4c60-ae1c-4b8e3ec784d1.png)

4. What was the average distance travelled for each customer?

![4](https://user-images.githubusercontent.com/107050974/177215252-ef64ca28-70d9-4a7a-b490-d97c32bbe04a.png)

5. What was the difference between the longest and shortest delivery times for all orders?

![5](https://user-images.githubusercontent.com/107050974/177215262-5f683469-8df9-4505-b62b-a02bcc1b6b08.png)

6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

![6](https://user-images.githubusercontent.com/107050974/177215275-12bf2107-5425-4ca9-8462-cd9ce445d119.png)

7. What is the successful delivery percentage for each runner?

![7](https://user-images.githubusercontent.com/107050974/177215284-4c544af8-990d-4b57-a86d-f8a55356d01e.png)

## C. Ingredient Optimisation
1. What are the standard ingredients for each pizza?

![1](https://user-images.githubusercontent.com/107050974/177215437-2ac45c34-9d83-4436-9cce-b87063b2ce74.png)

2. What was the most commonly added extra?

![2](https://user-images.githubusercontent.com/107050974/177215458-104c0a97-4600-45f0-a273-307b2dde414e.png)

3. What was the most common exclusion?

![3](https://user-images.githubusercontent.com/107050974/177215468-cd564f38-6f82-49d3-bc2a-571b1ab0a700.png)

4. Generate an order item for each record in the customers_orders table in the format of one of the following:
Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

![4](https://user-images.githubusercontent.com/107050974/177215485-48e42dfa-d5d0-438d-8f11-b867e25e80e4.png)

5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

![5](https://user-images.githubusercontent.com/107050974/177215493-4bae38a9-c50c-454b-acc2-7dd8601dc75c.png)

6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

![6](https://user-images.githubusercontent.com/107050974/177225470-e10750d3-16d4-4f22-a238-f27c35f37180.png)

## D. Pricing and Ratings
1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

![1](https://user-images.githubusercontent.com/107050974/177215667-c980a1e9-9e44-4f21-9d03-00b4e161d9d9.png)

2. What if there was an additional $1 charge for any pizza extras?
Add cheese is $1 extra

![2](https://user-images.githubusercontent.com/107050974/177215691-dd9cf4eb-493b-4850-89d1-50e5a0e1c9a1.png)

3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

![3](https://user-images.githubusercontent.com/107050974/177215704-c6928c2f-996c-4832-9413-ec79073538b3.png)

4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
*customer_id
*order_id
*runner_id
*rating
*order_time
*pickup_time
*Time between order and pickup
*Delivery duration
*Average speed
*Total number of pizzas

![1](https://user-images.githubusercontent.com/107050974/177216216-97bcbfcc-89ee-4899-bc42-01b1ebe2ad38.png)


5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

![5](https://user-images.githubusercontent.com/107050974/177215731-93d3320a-2fcd-4130-8955-2d8abc74976e.png)
