CREATE DATABASE RESTAURANTANDCONSUMERDATA;
USE RESTAURANTANDCONSUMERDATA;

CREATE TABLE CONSUMERS (
    CONSUMER_ID VARCHAR(10) PRIMARY KEY,
    CITY VARCHAR(50),
    STATE VARCHAR(50),
    COUNTRY VARCHAR(50),
    LATITUDE DECIMAL(9,6),
    LONGITUDE DECIMAL(9,6),
    SMOKER VARCHAR(10),
    DRINK_LEVEL VARCHAR(20),
    TRANSPORTATION_METHOD VARCHAR(30),
    MARITAL_STATUS VARCHAR(20),
    CHILDREN VARCHAR(20),
    AGE INT,
    OCCUPATION VARCHAR(50),
    BUDGET VARCHAR(20)
);
CREATE TABLE CONSUMER_PREFERENCES (
    CONSUMER_ID VARCHAR(10),
    PREFERRED_CUISINE VARCHAR(50),
    FOREIGN KEY (CONSUMER_ID) REFERENCES CONSUMERS(CONSUMER_ID)
);
CREATE TABLE RESTAURANTS (
    RESTAURANT_ID VARCHAR(10) PRIMARY KEY,
    NAME VARCHAR(100),
    CITY VARCHAR(50),
    STATE VARCHAR(50),
    COUNTRY VARCHAR(50),
    ZIP_CODE VARCHAR(10),
    LATITUDE DECIMAL(9,6),
    LONGITUDE DECIMAL(9,6),
    ALCOHOL_SERVICE VARCHAR(50),
    SMOKING_ALLOWED VARCHAR(50),
    PRICE VARCHAR(20),
    FRANCHISE VARCHAR(10),
    AREA VARCHAR(50),
    PARKING VARCHAR(50)
);
CREATE TABLE RESTAURANT_CUISINES (
    RESTAURANT_ID VARCHAR(10),
    CUISINE VARCHAR(50),
    FOREIGN KEY (RESTAURANT_ID) REFERENCES RESTAURANTS(RESTAURANT_ID)
);
CREATE TABLE RATINGS (
    CONSUMER_ID VARCHAR(10),
    RESTAURANT_ID VARCHAR(10),
    OVERALL_RATING INT,
    FOOD_RATING INT,
    SERVICE_RATING INT,
    FOREIGN KEY (CONSUMER_ID) REFERENCES CONSUMERS(CONSUMER_ID),
    FOREIGN KEY (RESTAURANT_ID) REFERENCES RESTAURANTS(RESTAURANT_ID)
);
SHOW TABLES;
SELECT * FROM CONSUMERS;
SELECT * FROM CONSUMER_PREFERENCES;
SELECT * FROM RESTAURANTS;
SELECT * FROM RESTAURANT_CUISINES;
SELECT * FROM RATINGS;

-- 1.List all details of consumers who live in the city of 'Cuernavaca'.

SELECT * FROM CONSUMERS
WHERE CITY = 'Cuernavaca';

-- Find the Consumer_ID, Age, and Occupation of all consumers who are 'Students' AND are 'Smokers'.

SELECT CONSUMER_ID, AGE, OCCUPATION FROM CONSUMERS
WHERE OCCUPATION = 'Student' AND SMOKER = 'Yes';

-- List the Name, City, Alcohol_Service, and Price of all restaurants that serve 'Wine & Beer' and have a 'Medium' price level

SELECT NAME, CITY, ALCOHOL_SERVICE, PRICE FROM RESTAURANTS
WHERE ALCOHOL_SERVICE = "Wine & Beer" AND PRICE = "Medium";

-- Find the names and cities of all restaurants that are part of a 'Franchise'.

SELECT NAME, CITY FROM RESTAURANTS
WHERE FRANCHISE = 'Yes';

-- Show the Consumer_ID, Restaurant_ID, and Overall_Rating for all ratings where the Overall_Rating was 'Highly Satisfactory' (which corresponds to a value of 2, according to the data dictionary).

SELECT CONSUMER_ID, RESTAURANT_ID, OVERALL_RATING FROM RATINGS
WHERE OVERALL_RATING = 2;

-- JOINS WITH SUBQUERIES
-- List the names and cities of all restaurants that have an Overall_Rating of 2 (Highly Satisfactory) from at least one consumer.

SELECT NAME, CITY FROM RESTAURANTS RE
JOIN RATINGS RT 
ON RE.RESTAURANT_ID = RT.RESTAURANT_ID
WHERE OVERALL_RATING = 2;

-- Find the Consumer_ID and Age of consumers who have rated restaurants located in 'San Luis Potosi'.

SELECT C.CONSUMER_ID, C.AGE FROM CONSUMERS C
JOIN
RATINGS RT 
ON C.CONSUMER_ID = RT.CONSUMER_ID
JOIN
RESTAURANTS R
ON R.RESTAURANT_ID = RT.RESTAURANT_ID
WHERE R.CITY = 'San Luis Potosi';

-- List the names of restaurants that serve 'Mexican' cuisine and have been rated by consumer 'U1001'.

SELECT RE.NAME FROM RESTAURANTS RE
JOIN
RESTAURANT_CUISINES RC
ON RE.RESTAURANT_ID = RC.RESTAURANT_ID
JOIN 
RATINGS RT
ON RE.RESTAURANT_ID = RT.RESTAURANT_ID
WHERE CUISINE = 'Mexican' AND RT.CONSUMER_ID = 'U1001';

-- Find all details of consumers who prefer 'American' cuisine AND have a 'Medium' budget.

SELECT * FROM CONSUMERS C
JOIN
CONSUMER_PREFERENCES CP
ON C.CONSUMER_ID = CP.CONSUMER_ID
WHERE PREFERRED_CUISINE = 'American' AND C.BUDGET = 'Medium';

-- List restaurants (Name, City) that have received a Food_Rating lower than the average Food_Rating across all rated restaurants.

SELECT NAME, CITY FROM RESTAURANTS RE
JOIN
RATINGS RT
ON RE.RESTAURANT_ID = RT.RESTAURANT_ID
WHERE RT.FOOD_RATING < (SELECT AVG(FOOD_RATING) FROM RATINGS);

-- Find consumers (Consumer_ID, Age, Occupation) who have rated at least one restaurant but have NOT rated any restaurant that serves 'Italian' cuisine.

SELECT C.CONSUMER_ID, C.AGE, C.OCCUPATION
FROM CONSUMERS C
JOIN RATINGS RT
    ON C.CONSUMER_ID = RT.CONSUMER_ID
LEFT JOIN RESTAURANT_CUISINES RC
    ON RT.RESTAURANT_ID = RC.RESTAURANT_ID
GROUP BY
C.CONSUMER_ID, C.AGE, C.OCCUPATION
HAVING SUM(CASE WHEN RC.CUISINE = 'Italian' THEN 1 ELSE 0 END) = 0;

-- List restaurants (Name) that have received ratings from consumers older than 30.

SELECT * FROM RATINGS;
SELECT * FROM RESTAURANTS;

SELECT RE.NAME FROM RESTAURANTS RE
JOIN RATINGS RT
    ON RE.RESTAURANT_ID = RT.RESTAURANT_ID
JOIN CONSUMERS C
    ON RT.CONSUMER_ID = C.CONSUMER_ID
WHERE C.AGE > 30;

-- Find the Consumer_ID and Occupation of consumers whose preferred cuisine is 'Mexican' and who have given an Overall_Rating of 0 to at least one restaurant (any restaurant).

SELECT C.CONSUMER_ID, C.OCCUPATION FROM CONSUMERS C
JOIN
CONSUMER_PREFERENCES CP
ON C.CONSUMER_ID = CP.CONSUMER_ID
JOIN
RATINGS RT
ON C.CONSUMER_ID = RT.CONSUMER_ID
WHERE CP.PREFERRED_CUISINE = 'Mexican' AND RT.OVERALL_RATING = 0;

-- List the names and cities of restaurants that serve 'Pizzeria' cuisine and are located in a city where at least one 'Student' consumer lives

SELECT RE.NAME, RE.CITY FROM RESTAURANTS RE
JOIN
RESTAURANT_CUISINES RC
ON RE.RESTAURANT_ID = RC.RESTAURANT_ID
JOIN
CONSUMERS C
ON RE.CITY = C.CITY
WHERE RC.CUISINE = 'Pizzeria' AND C.OCCUPATION = 'Student';

-- Find consumers (Consumer_ID, Age) who are 'Social Drinkers' and have rated a restaurant that has 'No' parking.

SELECT C.CONSUMER_ID , C.AGE FROM CONSUMERS C
JOIN RATINGS RT
ON C.CONSUMER_ID = RT.CONSUMER_ID
JOIN RESTAURANTS RE
ON RT.RESTAURANT_ID = RE.RESTAURANT_ID
WHERE C.DRINK_LEVEL = 'Social Drinker' AND RE.PARKING = 'No';

select * from  CONSUMERS where occupation is null;
-- SELECT OCCUPATION FROM CONSUMERS

 SELECT IFNULL(OCCUPATION, 'UNKNOWN') FROM CONSUMERS;
 
 UPDATE CONSUMERS
 SET OCCUPATION = 'UNKNOWN'
 WHERE OCCUPATION = '';

select * from  CONSUMERS;

-- List Consumer_IDs and the count of restaurants they've rated, but only for consumers who are 'Students'. Show only students who have rated more than 2 restaurants.

SELECT
C.CONSUMER_ID,
COUNT(DISTINCT RT.RESTAURANT_ID) AS restaurant_count
FROM CONSUMERS C
JOIN RATINGS RT
    ON C.CONSUMER_ID = RT.CONSUMER_ID
WHERE C.OCCUPATION = 'Student'
GROUP BY C.CONSUMER_ID
HAVING COUNT(DISTINCT RT.RESTAURANT_ID) > 2;

-- We want to categorize consumers by an 'Engagement_Score' which is their Age divided by 10 (integer division). List the Consumer_ID, Age, and this calculated Engagement_Score, but only for consumers whose Engagement_Score would be exactly 2 and who use 'Public'

SELECT CONSUMER_ID, AGE,
AGE DIV 10 AS Engagement_Score
FROM CONSUMERS
WHERE AGE DIV 10 = 2
AND TRANSPORTATION_METHOD = 'Public';

-- For each restaurant, calculate its average Overall_Rating. Then, list the restaurant Name, City, and its calculated average Overall_Rating, but only for restaurants located in 'Cuernavaca' AND whose calculated average Overall_Rating is greater than 1.0.

SELECT RE.NAME, AVG(RT.OVERALL_RATING)
FROM RESTAURANTS RE
JOIN RATINGS RT
ON RE.RESTAURANT_ID = RT.RESTAURANT_ID
WHERE CITY = 'Cuernavaca'
GROUP BY RE.NAME
HAVING AVG(RT.OVERALL_RATING) > 1.0;

SELECT RE.NAME, RE.CITY,
AVG(RT.OVERALL_RATING) AS avg_overall_rating
FROM RESTAURANTS RE
JOIN RATINGS RT
    ON RE.RESTAURANT_ID = RT.RESTAURANT_ID
WHERE RE.CITY = 'Cuernavaca'
GROUP BY RE.RESTAURANT_ID, RE.NAME, RE.CITY
HAVING AVG(RT.OVERALL_RATING) > 1.0;

-- Find consumers (Consumer_ID, Age) who are 'Married' and whose Food_Rating for any restaurant is equal to their Service_Rating for that same restaurant, but only consider ratings where the Overall_Rating was 2.

SELECT DISTINCT C.CONSUMER_ID, C.AGE
FROM CONSUMERS C
JOIN RATINGS RT
    ON C.CONSUMER_ID = RT.CONSUMER_ID
WHERE C.MARITAL_STATUS = 'Married'
AND RT.OVERALL_RATING = 2
AND RT.FOOD_RATING = RT.SERVICE_RATING;

-- List Consumer_ID, Age, and the Name of any restaurant they rated, but only for consumers who are 'Employed' and have given a Food_Rating of 0 to at least one restaurant located in 'Ciudad Victoria'.

SELECT C.CONSUMER_ID, C.AGE, RE.NAME
FROM CONSUMERS C
JOIN RATINGS RT
    ON C.CONSUMER_ID = RT.CONSUMER_ID
JOIN RESTAURANTS RE
    ON RE.RESTAURANT_ID = RT.RESTAURANT_ID
WHERE C.OCCUPATION = 'Employed'
AND RE.CITY = 'Ciudad Victoria'
AND FOOD_RATING = 0;

SELECT DISTINCT C.CONSUMER_ID, C.AGE, RE.NAME
FROM CONSUMERS C
JOIN RATINGS RT
    ON C.CONSUMER_ID = RT.CONSUMER_ID
JOIN RESTAURANTS RE
    ON RE.RESTAURANT_ID = RT.RESTAURANT_ID
WHERE C.OCCUPATION = 'Employed'
  AND RT.FOOD_RATING = 0
  AND RE.CITY = 'Ciudad Victoria';

select * from consumers;

-- Using a CTE, find all consumers who live in 'San Luis Potosi'. Then, list their Consumer_ID, Age, and the Name of any Mexican restaurant they have rated with an Overall_Rating of 2.

WITH slp_consumers AS (
    SELECT CONSUMER_ID, AGE
    FROM CONSUMERS
    WHERE CITY = 'San Luis Potosi'
)
SELECT DISTINCT S.CONSUMER_ID, S.AGE, R.NAME
FROM slp_consumers S
JOIN RATINGS RT
    ON S.CONSUMER_ID = RT.CONSUMER_ID
JOIN RESTAURANTS R
    ON RT.RESTAURANT_ID = R.RESTAURANT_ID
JOIN RESTAURANT_CUISINES RC
    ON R.RESTAURANT_ID = RC.RESTAURANT_ID
WHERE RT.OVERALL_RATING = 2
AND RC.CUISINE = 'Mexican';

-- For each Occupation, find the average age of consumers. Only consider consumers who have made at least one rating. (Use a derived table to get consumers who have rated).

SELECT C.OCCUPATION, AVG(C.AGE) AS avg_age
FROM CONSUMERS C
JOIN 
(SELECT DISTINCT CONSUMER_ID
FROM RATINGS) RATED
    ON C.CONSUMER_ID = RATED.CONSUMER_ID
GROUP BY C.OCCUPATION;

-- Using a CTE to get all ratings for restaurants in 'Cuernavaca', rank these ratings within each restaurant based on Overall_Rating (highest first). Display Restaurant_ID, Consumer_ID, Overall_Rating, and the RatingRank.

WITH Cuernavaca_Ratings AS 
(SELECT RT.RESTAURANT_ID, RT.CONSUMER_ID, RT.OVERALL_RATING
FROM RATINGS RT
JOIN RESTAURANTS RE
	ON RT.RESTAURANT_ID = RE.RESTAURANT_ID
WHERE RE.CITY = 'Cuernavaca')

SELECT RESTAURANT_ID, CONSUMER_ID, OVERALL_RATING,
RANK() OVER (PARTITION BY RESTAURANT_ID 
ORDER BY OVERALL_RATING DESC) AS RatingRank
FROM Cuernavaca_Ratings;

-- For each rating, show the Consumer_ID, Restaurant_ID, Overall_Rating, and also display the average Overall_Rating given by that specific consumer across all their ratings.

SELECT CONSUMER_ID, RESTAURANT_ID, OVERALL_RATING,
AVG(OVERALL_RATING) OVER (
PARTITION BY CONSUMER_ID
) AS Avg_Overall_Rating_By_Consumer
FROM RATINGS;

-- Using a CTE, identify students who have a 'Low' budget. Then, for each of these students, list their top 3 most preferred cuisines based on the order they appear in the Consumer_Preferences table (assuming no explicit preference order, use Consumer_ID, Preferred_Cuisine to define order for ROW_NUMBER).

WITH Low_Budget_Students AS (
    SELECT CONSUMER_ID
    FROM CONSUMERS
    WHERE OCCUPATION = 'Student'
      AND BUDGET = 'Low'
),
Ranked_Preferences AS (
    SELECT
        CP.CONSUMER_ID,
        CP.PREFERRED_CUISINE,
        ROW_NUMBER() OVER (
            PARTITION BY CP.CONSUMER_ID
            ORDER BY CP.CONSUMER_ID, CP.PREFERRED_CUISINE
        ) AS rn
    FROM CONSUMER_PREFERENCES CP
    JOIN Low_Budget_Students LBS
        ON CP.CONSUMER_ID = LBS.CONSUMER_ID
)
SELECT
    CONSUMER_ID,
    PREFERRED_CUISINE
FROM Ranked_Preferences
WHERE rn <= 3;

-- Consider all ratings made by 'Consumer_ID' = 'U1008'. For each rating, show the Restaurant_ID, Overall_Rating, and the Overall_Rating of the next restaurant they rated (if any), ordered by Restaurant_ID (as a proxy for time if rating time isn't available). Use a derived table to filter for the consumer's ratings first.

SELECT Restaurant_ID, Overall_Rating,
LEAD(Overall_Rating) 
OVER (ORDER BY Restaurant_ID)
AS Next_Overall_Rating
FROM (SELECT
RESTAURANT_ID,
OVERALL_RATING 
FROM RATINGS
WHERE CONSUMER_ID = 'U1008') 
AS Consumer_Ratings;

-- Create a VIEW named HighlyRatedMexicanRestaurants that shows the Restaurant_ID, Name, and City of all Mexican restaurants that have an average Overall_Rating greater than 1.5.

CREATE VIEW HighlyRatedMexicanRestaurants AS
SELECT RE.RESTAURANT_ID, RE.NAME, RE.CITY FROM RESTAURANTS RE
JOIN
RESTAURANT_CUISINES RC
ON RE.RESTAURANT_ID = RC.RESTAURANT_ID
JOIN
RATINGS RT
ON RE.RESTAURANT_ID = RT.RESTAURANT_ID
WHERE RC.CUISINE = "Mexican" AND AVG(RT.OVERALL_RATING)
GROUP BY RT.RESTAURANT_ID
HAVING AVG(RT.OVERALL_RATING) > 1.5;

CREATE VIEW HighlyRatedMexicanRestaurants AS
SELECT
RE.RESTAURANT_ID, RE.NAME, RE.CITY
FROM RESTAURANTS RE
JOIN
RESTAURANT_CUISINES RC
    ON RE.RESTAURANT_ID = RC.RESTAURANT_ID
JOIN RATINGS RT
    ON RE.RESTAURANT_ID = RT.RESTAURANT_ID
WHERE RC.CUISINE = 'Mexican'
GROUP BY
RE.RESTAURANT_ID,
RE.NAME,
RE.CITY
HAVING AVG(RT.OVERALL_RATING) > 1.5;

SELECT * FROM HighlyRatedMexicanRestaurants;

-- First, ensure the HighlyRatedMexicanRestaurants view from Q7 exists. Then, using a CTE to find consumers who prefer 'Mexican' cuisine, list those consumers (Consumer_ID) who have not rated any restaurant listed in the HighlyRatedMexicanRestaurants view.

WITH MexicanPrefConsumers AS 
(SELECT DISTINCT Consumer_ID
FROM Consumer_Preferences
WHERE Preferred_Cuisine = 'Mexican')

SELECT m.Consumer_ID
FROM MexicanPrefConsumers m
WHERE NOT EXISTS (
    SELECT 1
    FROM Ratings r
    JOIN HighlyRatedMexicanRestaurants h
        ON r.Restaurant_ID = h.Restaurant_ID
    WHERE r.Consumer_ID = m.Consumer_ID
);

-- Create a stored procedure GetRestaurantRatingsAboveThreshold that accepts a Restaurant_ID and a minimum Overall_Rating as input. It should return the Consumer_ID, Overall_Rating, Food_Rating, and Service_Rating for that restaurant where the Overall_Rating meets or exceeds the threshold.

DELIMITER //
CREATE PROCEDURE GetRestaurantRatingsAboveThreshold 
(IN p_Restaurant_ID INT,
IN p_MinOverallRating INT)
BEGIN
SELECT 
Consumer_ID,
Overall_Rating,
Food_Rating,
Service_Rating
FROM Ratings
WHERE Restaurant_ID = p_Restaurant_ID
AND Overall_Rating >= p_MinOverallRating;
END //
DELIMITER ;

CALL GetRestaurantRatingsAboveThreshold(101, 2);

-- Identify the top 2 highest-rated (by Overall_Rating) restaurants for each cuisine type. If there are ties in rating, include all tied restaurants. Display Cuisine, Restaurant_Name, City, and Overall_Rating.

SELECT t.Cuisine, t.Restaurant_Name, t.City, t.Overall_Rating
FROM 
(SELECT
rc.Cuisine,
r.Name AS Restaurant_Name,
r.City,
ra.Overall_Rating,
DENSE_RANK() OVER 
(PARTITION BY rc.Cuisine
ORDER BY ra.Overall_Rating DESC) 
AS rating_rank
FROM Restaurants r
JOIN Ratings ra
	ON r.Restaurant_ID = ra.Restaurant_ID
JOIN Restaurant_Cuisines rc
	ON r.Restaurant_ID = rc.Restaurant_ID) t
WHERE t.rating_rank <= 2
ORDER BY t.Cuisine, t.Overall_Rating DESC;

-- First, create a VIEW named ConsumerAverageRatings that lists Consumer_ID and their average Overall_Rating. Then, using this view and a CTE, find the top 5 consumers by their average overall rating. For these top 5 consumers, list their Consumer_ID, their average rating, and the number of 'Mexican' restaurants they have rated.

CREATE VIEW ConsumerAverageRatings AS
SELECT RT.CONSUMER_ID, AVG(RT.OVERALL_RATING) AS Avg_Overall_Rating
FROM RATINGS RT
GROUP BY RT.CONSUMER_ID;

SELECT * FROM ConsumerAverageRatings;

WITH TopConsumers AS 
(SELECT
Consumer_ID,
Avg_Overall_Rating
FROM ConsumerAverageRatings
ORDER BY Avg_Overall_Rating DESC
LIMIT 5)

SELECT
tc.Consumer_ID,
tc.Avg_Overall_Rating,
COUNT(DISTINCT r.Restaurant_ID) AS Mexican_Restaurants_Rated
FROM TopConsumers tc
LEFT JOIN Ratings r
    ON tc.Consumer_ID = r.Consumer_ID
LEFT JOIN Restaurant_Cuisines rc
    ON r.Restaurant_ID = rc.Restaurant_ID
AND rc.Cuisine = 'Mexican'
GROUP BY
tc.Consumer_ID,
tc.Avg_Overall_Rating
ORDER BY tc.Avg_Overall_Rating DESC;


