/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Display the first and last names of all actors from the table actor*/
select A.first_name, A.last_name
from sakila.actor A;

/* 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. */
SELECT A.first_name, A.last_name, CONCAT(A.first_name, ' ', A.last_name) AS 'Actor Name'
FROM sakila.actor A;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?*/
select A.actor_id, A.first_name, A.last_name
from sakila.actor  A where A.first_name = "JOE";

/* 2b. Find all actors whose last name contain the letters GEN */
select A.first_name, A.last_name
from sakila.actor A where A.last_name LIKE "%GEN%";

/* 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order */
select A.last_name, A.first_name
from sakila.actor A where A.last_name LIKE "%LI%"
order by A.last_name, A.first_name;

/* 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China */
select C.country_id, C.country from sakila.country C
where upper(C.country) IN ('AFGHANISTAN', 'BANGLADESH', 'CHINA');

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type */
ALTER TABLE sakila.actor 
ADD COLUMN `middle_name` VARCHAR(45) NOT NULL AFTER `first_name`;

/*3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs */
ALTER TABLE sakila.actor
CHANGE COLUMN `middle_name` `middle_name` BLOB NOT NULL ;

/*3c. Now delete the middle_name column */
ALTER TABLE sakila.actor 
DROP COLUMN `middle_name`;

/* 4a. List the last names of actors, as well as how many actors have that last name. */
SELECT  A.last_name, COUNT(*) FROM sakila.actor A GROUP BY A.last_name;

/*4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors */
SELECT  A.last_name, count(A.last_name) as last_count
from sakila.actor A group by A.last_name
having last_count >=2;

/* 4c. Oh, no! The actor Harpo WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, 
the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.*/

update sakila.actor A
set A.first_name = 'Harpo'
where A.first_name LIKE 'Groucho' and A.last_name like 'Williams';

-- Verifying the name update took place properly....
select A.actor_id, A.first_name, A.last_name from sakila.actor A
where A.first_name like 'Harpo';
-- Got the actor ID as 172

/*4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. 
Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 
BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)*/

update sakila.actor A
set A.first_name = 'GROUCHO'
WHERE A.first_name LIKE 'Harpo' and A.actor_id = 172;

-- Verifying the name update took place properly....
select a.actor_id, a.first_name, a.last_name from sakila.actor a
where a.first_name like 'GROUCHO';

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*5a. You cannot locate the schema of the address table. Which query would you use to re-create it? */
describe sakila.address;

-- Command to show the schema SQL query for the table
show create table sakila.address;

/*6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address */

select S.first_name, S.last_name, A.address, A.district, A.postal_code, A.phone
from sakila.staff S, sakila.address A 
where S.address_id = A.address_id;

/* 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. */

select s.first_name, s.last_name,  sum(p.amount) as total_amount
from sakila.staff s , sakila.payment p where  s.staff_id = p.staff_id
and year(p.payment_date) =  '2005'
and month(p.payment_date) = '08'
group by s.first_name, s.last_name;

/* 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join. */

select f.title, count(fa.actor_id)
from sakila.film f, sakila.film_actor fa where  f.film_id = fa.film_id
group by f.title;

/*6d. How many copies of the film Hunchback Impossible exist in the inventory system?*/

select count(I.film_id)  as Hunchback_Impossible_Count
from sakila.inventory I, sakila.film f
where I.film_id = f.film_id
and  f.title LIKE "Hunchback Impossible%";

/* 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name: */
select c.last_name, c.first_name, sum(p.amount)
from sakila.customer c
inner join sakila.payment p on c.customer_id = p.customer_id
group by c.last_name, c.first_name;

/* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies
starting with the letters K and Q whose language is English. */


select f.title from sakila.film f where (f.title LIKE "K%" or f.title LIKE "Q%") and f.language_id in 
(select l.language_id from sakila.language  l where l.name LIKE "English" );

/* 7b. Use subqueries to display all actors who appear in the film Alone Trip. */

select a.first_name, a.last_name
from sakila.actor a 
where a.actor_id IN
( select fa.actor_id from sakila.film_actor fa where fa.film_id IN
 (select f.film_id from sakila.film f where f.title LIKE  "Alone Trip") );


/*7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.*/

SELECT concat(C.first_name, ' ', C.last_name), C.email, D.country FROM sakila.customer C, sakila.address A, sakila.city T, sakila.country D 
where C.address_id = A.address_id and A.city_id = T.city_id and T.country_id = D.country_id and D.country like 'Canada%%';

/*7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.*/

SELECT  F.title, F.description FROM sakila.film_category FC, sakila.category C , sakila.film F
where C.category_id = FC.category_id and C.name like 'Family%'
and F.film_id = FC.film_id;

# Additional query for getting the count of films....

SELECT  count(*) FROM sakila.film_category FC, sakila.category C , sakila.film F
where C.category_id = FC.category_id and C.name like 'Family%'
and F.film_id = FC.film_id;


/* 7e. Display the most frequently rented movies in descending order. */

select F.title, count(F.title) as film_count
from sakila.film F,sakila.inventory I, sakila.rental R
where F.film_id = I.film_id and I.inventory_id = R.inventory_id
group by 1 order by film_count desc;


/* 7f. Write a query to display how much business, in dollars, each store brought in. */

select s.store_id, sum(p.amount) as total_amount 
from
sakila.store s, sakila.payment p, sakila.staff t
where s.store_id = t.store_id and t.staff_id = p.staff_id
group by 1;


-- 7g. Write a query to display for each store its store ID, city, and country.

select s.store_id, c.city, d.country from
sakila.store s, sakila.address a, sakila.city c, sakila.country d
where 
s.address_id = a.address_id and a.city_id = c.city_id and c.country_id = d.country_id;


-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select c.name, sum(p.amount) as gross_revenue from
sakila.payment p, sakila.rental r, sakila.inventory i, sakila.film_category fc, sakila.category c
where
p.rental_id = r.rental_id and r.inventory_id = i.inventory_id and i.film_id = fc.film_id and fc.category_id = c.category_id
group by 1 order by gross_revenue desc limit 5;

-- /*8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

create view  sakila.top_gross_revenue_generes as
(
select c.name, sum(p.amount) as gross_revenue from
sakila.payment p, sakila.rental r, sakila.inventory i, sakila.film_category fc, sakila.category c
where
p.rental_id = r.rental_id and r.inventory_id = i.inventory_id and i.film_id = fc.film_id and fc.category_id = c.category_id
group by 1 order by gross_revenue
);

-- 8b. How would you display the view that you created in 8a, Display the view

select * from sakila.top_gross_revenue_generes order by gross_revenue desc limit 5;


-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW sakila.top_gross_revenue_generes;


