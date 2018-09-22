USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
-- SELECT actor.first_name, actor.last_name FROM actor;
SELECT first_name, last_name FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. 
-- Name the column Actor Name.
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS "Actor Name" FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:
-- The % is a wildcard for any character...use LIKE instead of = 
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%GEN%'; 

-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order (alphabetical) the rows by last name and first name, in that order:
SELECT actor.last_name, actor.first_name FROM actor WHERE last_name LIKE '%LI%' 
	ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
-- SELECT * FROM sakila.country WHERE country = "Afghanistan" OR country = "Bangladesh" OR country = "China";
SELECT country_id, country FROM sakila.country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. 
-- You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description and use the data type BLOB 
-- (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
-- limits to lengths and memory...BLOB type saves memory
-- https://dev.mysql.com/doc/refman/5.7/en/blob.html  
ALTER TABLE actor ADD COLUMN description BLOB;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the description column.
ALTER TABLE actor DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) AS 'last_name_frequency' FROM actor GROUP BY last_name;  

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) AS 'last_name_frequency' FROM actor GROUP BY actor.last_name HAVING COUNT(last_name) > 1;  

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.
-- Turn off safe updates... WHY? to prevent major changes.
SET SQL_SAFE_UPDATES = 0;
UPDATE actor SET first_name = "HARPO" WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";
SELECT * FROM actor WHERE first_name = "HARPO";

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor SET first_name = "GROUCHO" WHERE first_name = "HARPO";

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- option:  
SHOW CREATE TABLE sakila.address; 
-- for the SQL statement that can be used to create a table.
-- DESCRIBE sakila.address;  
-- for formatted output
-- What is a schema?
-- It's like a plan or a blueprint. 
-- A database schema is the collection of relation schemas for a whole database. 
-- A table is a structure with a bunch of rows (aka "tuples"), 
-- each of which has the attributes defined by the schema. 
-- Usually a schema is a collection of tables and a Database is a collection of schemas.

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON
staff.address_id=address.address_id; 

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.
SELECT staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff
INNER JOIN payment ON
staff.staff_id=payment.staff_id
WHERE month(payment.payment_date) = 08 AND year(payment.payment_date) = 2005
GROUP BY staff.staff_id; 

-- 6c. List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. Use inner join.
SELECT film.title, COUNT(film_actor.actor_id) AS "Number of Actors"
FROM film_actor
INNER JOIN film ON
film_actor.film_id=film.film_id
GROUP BY film.title; 

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?  6
-- get it from film_id = 439?
SELECT film.title, COUNT(inventory.film_id) AS "Number of Copies"
FROM inventory
INNER JOIN film ON
inventory.film_id=film.film_id
WHERE film.title = "Hunchback Impossible"
GROUP BY film.film_id; 

-- 6e. Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT customer.first_name, customer.last_name, SUM(payment.amount)
FROM payment
INNER JOIN customer ON
payment.customer_id=customer.customer_id
GROUP BY customer.customer_id
ORDER BY last_name, first_name; 

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title FROM film WHERE title LIKE 'K%' OR 'Q%' AND language_id IN (SELECT language_id FROM language WHERE name = "English");

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
( SELECT actor_id
  FROM film_actor
  WHERE film_id IN
  (SELECT film_id
   FROM film
   WHERE title = 'Alone Trip'));

-- 7c. You want to run an email marketing campaign in Canada, 
-- for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
SELECT customer.first_name, customer.last_name, customer.email, country.country
FROM customer
INNER JOIN address ON
customer.address_id=address.address_id
INNER JOIN city
ON (address.city_id = city.city_id)
INNER JOIN country
ON (city.country_id = country.country_id)
WHERE country.country = 'canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films... 
SELECT title FROM film WHERE film_id IN
  (SELECT film_id
   FROM film_category
   WHERE category_id IN
	(SELECT category_id
	 FROM category
     WHERE category_id=8));  

-- 7e. Display the most frequently rented movies in descending order.

SELECT film.title, COUNT(film.title) AS "Rental_Count"
FROM film
INNER JOIN inventory ON
film.film_id=inventory.film_id
INNER JOIN rental ON rental.inventory_id = inventory.inventory_id 
GROUP BY (film.title) 
ORDER BY Rental_Count desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT store.store_id, SUM(payment.amount) AS "Total_Revenue"
FROM payment
INNER JOIN rental 
ON rental.rental_id=payment.rental_id
INNER JOIN inventory 
ON rental.inventory_id=inventory.inventory_id
INNER JOIN store 
ON store.store_id=inventory.store_id
GROUP BY (store.store_id);

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address 
ON store.address_id=address.address_id
INNER JOIN city 
ON address.city_id=city.city_id
INNER JOIN country 
ON city.country_id=country.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT category.name, SUM(payment.amount) AS "Gross_Revenue"
FROM category
INNER JOIN film_category 
ON category.category_id=film_category.category_id
INNER JOIN inventory
ON inventory.film_id=film_category.film_id
INNER JOIN rental
ON inventory.inventory_id=rental.inventory_id
INNER JOIN payment
ON payment.rental_id=rental.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) desc;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing 
-- the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW top_five_genres AS
SELECT category.name, SUM(payment.amount) AS "Gross_Revenue"
FROM category
INNER JOIN film_category 
ON category.category_id=film_category.category_id
INNER JOIN inventory
ON inventory.film_id=film_category.film_id
INNER JOIN rental
ON inventory.inventory_id=rental.inventory_id
INNER JOIN payment
ON payment.rental_id=rental.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) desc
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM top_five_genres;
  
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW top_five_genres; 

-- A schema is also available as sakila_schema.svg. Open it with a browser to view.
-- .svg = scale vector graphics...  right click to open
-- for engaging visualizations using D3 = Javascript library 
-- d3js.org 
