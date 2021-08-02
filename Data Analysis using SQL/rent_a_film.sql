SHOW DATABASES;
USE `rent_a_film`;

#get the details First, Last name, and Email address of customers from Store 2. These details are in customer table.
show tables;
select first_name,last_name,email from customer where store_id=2;

#movies with a rental rate of 0.99$

select title from film where rental_rate=0.99;

#Your objective is to show the rental rate and how many movies are in each rental rate categories
select rental_rate,count(rental_rate) as 'No of movies' from film group by rental_rate;

#Which rating do we have the most films in?

select rating,count(rating) as 'freq'
from film
group by rating
order by freq desc
limit 1;

# Which rating is most prevalent in each store?

select store_id, rating, max(freq)
from (select store_id,rating,count(rating) as 'freq' from film inner join inventory on film.film_id = inventory.film_id
group by store_id,rating
order by store_id,freq desc) as temp group by store_id;

# We want to mail the customers about the upcoming promotion.

select email from customer;

#List of films by Film Name, Category, Languag

select * from film;

SELECT TITLE,CATEGORY_ID,NAME AS LANGUAGE 
FROM FILM
INNER JOIN FILM_CATEGORY ON FILM.FILM_ID = FILM_CATEGORY.FILM_ID
INNER JOIN LANGUAGE
ON FILM.LANGUAGE_ID = LANGUAGE.LANGUAGE_ID;

#How many times each movie has been rented out?

SELECT TITLE,COUNT(TITLE) AS 'TIMES RENTED'
FROM RENTAL
INNER JOIN INVENTORY ON RENTAL.INVENTORY_ID = INVENTORY.INVENTORY_ID
INNER JOIN FILM ON INVENTORY.FILM_ID = FILM.FILM_ID
GROUP BY TITLE;

#What is the Revenue per Movie?
SELECT TITLE,SUM(AMOUNT) AS 'REVENUE IN $'
FROM PAYMENT
INNER JOIN RENTAL ON PAYMENT.RENTAL_ID = RENTAL.RENTAL_ID
INNER JOIN INVENTORY ON INVENTORY.INVENTORY_ID = RENTAL.INVENTORY_ID
INNER JOIN FILM ON INVENTORY.FILM_ID = FILM.FILM_ID
GROUP BY TITLE;

#Most Spending Customer so that we can send him/her rewards or debate points

SELECT FIRST_NAME,LAST_NAME,EMAIL,SUM(AMOUNT) AS 'AMOUNT_SPENT'
FROM CUSTOMER
INNER JOIN PAYMENT ON PAYMENT.CUSTOMER_ID = CUSTOMER.CUSTOMER_ID
GROUP BY EMAIL
ORDER BY AMOUNT_SPENT DESC
LIMIT 1;

#What Store has historically brought the most revenue?
SELECT STORE_ID, SUM(AMOUNT) AS 'TOTAL_REVENUE'
FROM PAYMENT
INNER JOIN RENTAL ON PAYMENT.RENTAL_ID = RENTAL.RENTAL_ID
INNER JOIN INVENTORY ON INVENTORY.INVENTORY_ID = RENTAL.INVENTORY_ID
GROUP BY STORE_ID
ORDER BY TOTAL_REVENUE DESC LIMIT 1;

# How many rentals do we have for each month?
SELECT YEAR(RENTAL_DATE) AS 'YEAR',MONTH(RENTAL_DATE) AS 'MONTH', COUNT(RENTAL_ID) 'NO. OF RENTALS'
FROM RENTAL
GROUP BY YEAR(RENTAL_DATE), MONTH(RENTAL_DATE);

# Which date the first movie was rented out?

SELECT DATE(RENTAL_DATE) AS RENT_DATE
FROM RENTAL
ORDER BY RENT_DATE
LIMIT 1;

# Which date the last movie was rented out?

SELECT DATE(RENTAL_DATE) AS RENT_DATE
FROM RENTAL
ORDER BY RENT_DATE DESC
LIMIT 1;

# For each movie, when was the first time and last time it was rented out?

SELECT TITLE,MIN(RENTAL_DATE),MAX(RENTAL_DATE) AS 'FIRST_LAST_DATE'
FROM RENTAL
INNER JOIN INVENTORY ON INVENTORY.INVENTORY_ID = RENTAL.INVENTORY_ID
INNER JOIN FILM ON INVENTORY.FILM_ID = FILM.FILM_ID
GROUP BY TITLE;

# Last Rental Date of every customer

SELECT FIRST_NAME,LAST_NAME,MAX(RENTAL_DATE) AS 'LAST DATE RENTED'
FROM RENTAL INNER JOIN CUSTOMER ON RENTAL.CUSTOMER_ID = CUSTOMER.CUSTOMER_ID
GROUP BY RENTAL.CUSTOMER_ID;

# Revenue Per Month

SELECT YEAR(PAYMENT_DATE) AS 'YEAR', MONTHNAME(PAYMENT_DATE) AS 'MONTH',SUM(AMOUNT) AS 'REVENUE'
FROM PAYMENT
GROUP BY YEAR(PAYMENT_DATE),MONTH(PAYMENT_DATE);

# How many distinct Renters do we have per month?

SELECT YEAR(RENTAL_DATE) AS 'YEAR',MONTHNAME(RENTAL_DATE) AS 'MONTH',COUNT(DISTINCT CUSTOMER_ID) AS 'UNIQUE RENTALS'
FROM RENTAL
GROUP BY MONTH(RENTAL_DATE);

# Show the Number of Distinct Film Rented Each Month

SELECT MONTHNAME(RENTAL_DATE),COUNT(DISTINCT FILM_ID)
FROM RENTAL
INNER JOIN INVENTORY ON INVENTORY.INVENTORY_ID = RENTAL.INVENTORY_ID
GROUP BY YEAR(RENTAL_DATE),MONTH(RENTAL_DATE);

# Number of Rentals in Comedy, Sports, and Family
SELECT category.name,count(category.name) as 'no. of rentals'
FROM RENTAL
INNER JOIN INVENTORY ON INVENTORY.INVENTORY_ID = RENTAL.INVENTORY_ID
INNER JOIN FILM_CATEGORY ON INVENTORY.FILM_ID = FILM_CATEGORY.FILM_ID
INNER JOIN CATEGORY ON CATEGORY.CATEGORY_ID = FILM_CATEGORY.CATEGORY_ID
group by category.name
having CATEGORY.NAME = 'Comedy' or CATEGORY.NAME ='Sports' or CATEGORY.NAME='Family'
order by category.name;

# Users who have been rented at least 3 times

SELECT first_name, last_name, count(rental.customer_id)
FROM RENTAL INNER JOIN CUSTOMER ON RENTAL.CUSTOMER_ID = CUSTOMER.CUSTOMER_ID
group by rental.customer_id
having count(rental.customer_id) >=3;

# How much revenue has one single store made over PG13 and R-rated films?
SELECT STORE_ID,RATING,SUM(RENTAL_RATE) AS 'REVENUE'
FROM PAYMENT
INNER JOIN RENTAL ON RENTAL.RENTAL_ID = PAYMENT.RENTAL_ID
INNER JOIN INVENTORY ON INVENTORY.INVENTORY_ID = RENTAL.INVENTORY_ID
INNER JOIN FILM ON INVENTORY.FILM_ID = FILM.FILM_ID
GROUP BY STORE_ID, RATING
HAVING RATING='PG-13' OR RATING='R';

# Active User where active = 1
SELECT * 
FROM CUSTOMER WHERE CUSTOMER.ACTIVE=1;

# Reward Users: who has rented at least 30 times

SELECT FIRST_NAME,LAST_NAME, EMAIL,COUNT(RENTAL_ID) AS 'FREQ'
FROM RENTAL
INNER JOIN CUSTOMER ON RENTAL.CUSTOMER_ID = CUSTOMER.CUSTOMER_ID
GROUP BY RENTAL.CUSTOMER_ID
HAVING FREQ >= 30;

# Reward Users who are also active

SELECT FIRST_NAME,LAST_NAME, EMAIL,ACTIVE
FROM CUSTOMER WHERE CUSTOMER.ACTIVE=1;

# All Rewards Users with Phone

SELECT FIRST_NAME,LAST_NAME, EMAIL, phone
FROM CUSTOMER
INNER JOIN ADDRESS ON CUSTOMER.ADDRESS_ID = ADDRESS.ADDRESS_ID
WHERE PHONE IS not NULL;