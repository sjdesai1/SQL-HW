#1a

use sakila;

select first_name, last_name from actor;

#1b

use sakila;

select concat(first_name, " ", last_name) as 'Actor Name' from actor;


#2a

use sakila;
select actor_id, first_name, last_name from actor where first_name='Joe';

#2b

use sakila;
select * from actor where last_name Like '%gen%';

#2c

select last_name, first_name from actor where last_name Like '%li%';

#2d

select country_id, country from country where country in ('Afghanistan', 'Bangladesh', 'China');

#3a

Alter table actor
	add middle_name varchar(50);

#3b

ALTER TABLE `sakila`.`actor` 
CHANGE COLUMN `middle_name` `middle_name` BLOB NULL DEFAULT NULL AFTER `first_name`;

#3c

ALTER TABLE `sakila`.`actor` 
DROP COLUMN `middle_name`;

#4a

select last_name, count(last_name) from actor group by last_name;

#4b

select last_name, count(last_name) from actor group by last_name having count(last_name) > 1; 

#4c

update actor
set first_name = 'Harpo'
where first_name = 'Groucho' and last_name = 'Williams';

select first_name, last_name from actor where first_name = 'Harpo';

#4d

UPDATE actor 
SET first_name =
CASE
 WHEN first_name = 'HARPO'THEN 'GROUCHO'
 ELSE 'MUCHO GROUCHO'
END
WHERE actor_id = 172;
COMMIT;


#5a

show create table address;

#6a

select staff.address_id, staff.first_name, staff.last_name, address.address
from staff
inner join address on address.address_id=staff.address_id;

#6b

select staff.staff_id, staff.first_name, staff.last_name, sum(payment.amount)
from staff 
inner join payment on staff.staff_id=payment.staff_id
where payment_date like '%2005-08%' group by staff_id;

#6c

select film.film_id, film.title, count(actor_id)
from film_actor
inner join film on film.film_id=film_actor.film_id
group by title;

#6d

select count(film.film_id), film.title
from film
inner join inventory on film.film_id=inventory.film_id
where title='Hunchback Impossible';

#6e

select customer.last_name, sum(amount)
from payment
inner join customer on customer.customer_id=payment.customer_id
group by last_name;

#7a

select film.title, language.name 
from film
inner join language on film.language_id=language.language_id
where title like 'Q%' or title like 'K%';

#7b

select first_name, last_name
from actor
where actor_id in
(
	select actor_id
    from film_actor
    where film_id in
    (
		select film_id
        from film
        where title = 'Alone Trip'
)
);

#7c

SELECT first_name, last_name, email, country
  FROM customer cus
  JOIN address a
  ON (cus.address_id = a.address_id)
  JOIN city cit
  ON (a.city_id = cit.city_id)
  JOIN country ctr
  ON (cit.country_id = ctr.country_id)
  WHERE ctr.country = 'canada';

#7d

select title
from film
where film_id in
(
	select film_id
	from film_category
	where category_id in
	(
		select category_id
		from category
		where name = 'Family'
)
);


#7e

select title, count(title)
from rental
inner join inventory on rental.inventory_id=inventory.inventory_id
right join film on film.film_id=inventory.film_id
group by title
order by count(title) DESC;

#7f

SELECT s.store_id, SUM(amount) AS Gross
  FROM payment p
  JOIN rental r
  ON (p.rental_id = r.rental_id)
  JOIN inventory i
  ON (i.inventory_id = r.inventory_id)
  JOIN store s
  ON (s.store_id = i.store_id)
  GROUP BY s.store_id; 
  
  #7g
  
  SELECT store_id, city, country
  FROM store s
  JOIN address a
  ON (s.address_id = a.address_id)
  JOIN city cit
  ON (cit.city_id = a.city_id)
  JOIN country ctr
  ON(cit.country_id = ctr.country_id);  
  
  #7h
  
	SELECT SUM(amount) AS 'Total Sales', c.name AS 'Genre'
  FROM payment p
  JOIN rental r
  ON (p.rental_id = r.rental_id)
  JOIN inventory i
  ON (r.inventory_id = i.inventory_id)
  JOIN film_category fc
  ON (i.film_id = fc.film_id)
  JOIN category c
  ON (fc.category_id = c.category_id)
  GROUP BY c.name
  ORDER BY SUM(amount) DESC;
  
  #8a
  
   CREATE VIEW top_five_genres AS
  SELECT SUM(amount) AS 'Total Sales', c.name AS 'Genre'
  FROM payment p
  JOIN rental r
  ON (p.rental_id = r.rental_id)
  JOIN inventory i
  ON (r.inventory_id = i.inventory_id)
  JOIN film_category fc
  ON (i.film_id = fc.film_id)
  JOIN category c
  ON (fc.category_id = c.category_id)
  GROUP BY c.name
  ORDER BY SUM(amount) DESC
  LIMIT 5;
  
  #8b
  
   SELECT * 
  FROM top_five_genres;
  
  #8c
  
  DROP VIEW top_five_genres;