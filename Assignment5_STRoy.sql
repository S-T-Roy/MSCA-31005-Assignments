/***********************************************
**	File: Assignment5.sql 

**	Desc: Assignment 5 

**	Auth: Suryoday Tarit Roy	

**	Date: 9 Nov 2017

************************************************/ 

########################## ASSIGNMENT 5 ##########################

#	Using the Sakila database, provide both the SQL queries you used and the output to the following queries ( screenshot ). If there is more than one solution, provide only one solution. 

########################## QUESTION 1 ########################## 

#	a) List the actors (firstName, lastName) who acted in more then 25 movies. 
select
a.first_name, 
a.last_name,
count(f.actor_id) as NoOfFilms
from 
actor a
	inner join 
    film_actor f on a.actor_id=f.actor_id
group by f.actor_id
having NoOfFilms>25;      #count(f.actor_id)>25;

#	Note: Also show the count of movies against each actor 

#	b) List the actors who have worked in the German language movies. 
SET SQL_SAFE_UPDATES=0;
UPDATE film SET language_id=6 WHERE title LIKE "%ACADEMY%";
SELECT
a.first_name, a.last_name
FROM actor a
	INNER JOIN film_actor f on a.actor_id=f.actor_id
		INNER JOIN film fi on fi.film_id=f.film_id 
			INNER JOIN language l on l.language_id=fi.language_id
where l.language_id=6;

#	c) List the actors who acted in horror movies. 
SELECT
a.first_name, a.last_name
FROM actor a
	INNER JOIN film_actor f on a.actor_id=f.actor_id
		INNER JOIN film fi on fi.film_id=f.film_id 
			INNER JOIN film_category fc on fc.film_id=fi.film_id
				INNER JOIN category c on c.category_id=fc.category_id
WHERE 
c.name="Horror";

#	d) List all customers who rented more than 3 horror movies. 

select
first_name,last_name,count(c.first_name) as sum
from customer c 
	inner join rental r on r.customer_id=c.customer_id
		inner join inventory i on i.inventory_id=r.inventory_id
			inner join film f on f.film_id=i.film_id
				inner join film_category fc on fc.film_id=f.film_id
					inner join category cc on cc.category_id=fc.category_id
where cc.name='horror'
group by (c.first_name)
having count(c.first_name)>=3;

#	Note: Show the count of movies against each actor in the result set. 

#	e) List all customers who rented the movie which starred SCARLETT BENING 
select distinct c.first_name, c.last_name
from customer c
	inner join rental r on r.customer_id=c.customer_id
		inner join inventory i on i.inventory_id=r.inventory_id
			inner join film_actor fa on fa.film_id=i.film_id
				inner join actor a on a.actor_id=fa.actor_id
where a.first_name='Scarlett' AND a.last_name='Bening';
                
				
#	f) Which customers residing at postal code 62703 rented movies that were Documentaries. 
select
first_name,last_name
from customer c 
inner join address a on a.address_id=c.address_id
	inner join rental r on r.customer_id=c.customer_id
		inner join inventory i on i.inventory_id=r.inventory_id
			inner join film f on f.film_id=i.film_id
				inner join film_category fc on fc.film_id=f.film_id
					inner join category cc on cc.category_id=fc.category_id
where cc.name='documentary' AND a.postal_code=62703;

#	g) Find all the addresses where the second address line is not empty (i.e., contains some text), and return these second addresses sorted. 
select * 
from address a
where a.address2 is null
order by a.address2;

#	h) How many films involve a “Crocodile” and a “Shark” based on film description ? 
select count(*) 
from film
where description like '%Shark%'
and description like '%Crocodile%';

#	i) List the actors who played in a film involving a “Crocodile” and a “Shark”, along with the release year of the movie, sorted by the actors’ last names. 
select a.first_name, a.last_name, ff.release_year
from actor a
	inner join film_actor f on f.actor_id=a.actor_id
		inner join film ff on ff.film_id=f.film_id
where ff.description like '%Shark%'
and ff.description like '%Crocodile%'
order by a.last_name; 

#	j) Find all the film categories in which there are between 55 and 65 films. Return the names of categories and the number of films per category, sorted from highest to lowest by the number of films. 
select c.name,count(c.category_id)  as repeats
from category c
	inner join film_category fc on c.category_id=fc.category_id
group by c.name
having repeats between 55 and 65
order by repeats desc;
#	k) In which of the film categories is the average difference between the film replacement cost and the rental rate larger than 17$? 
select c.name, avg( f.replacement_cost - f.rental_rate) as Diff 
from category c 
	inner join film_category fc on fc.film_id= c.category_id
		inner join film f on f.film_id=fc.film_id
group by c.name
having Diff>17;

#	l) Many DVD stores produce a daily list of overdue rentals so that customers can be contacted and asked to return their overdue DVDs. 
#To create such a list, search the rental table for films with a return date that is NULL and where the rental date is further in the past than the rental duration specified in the film table. 
#If so, the film is overdue and we should produce the name of the film along with the customer name and phone number. 
select  
f.title as FilmTitle ,
c.first_name as CustomerFirstName,
c.last_name as CustomerLastName, 
a.phone as CustomerPhNum,
datediff(curdate(),r.rental_date) as RentalLength
from customer c
	inner join address a on a.address_id=c.address_id
		inner join rental r on r.customer_id=c.customer_id
			inner join inventory i on i.inventory_id=r.inventory_id
				inner join film f on f.film_id=i.film_id
where
	r. return_date is NULL
group by f.rental_duration
having RentalLength >f.rental_duration;

#	m) Find the list of all customers and staff given a store id 
(select 
	c.first_name as FName,
	c.last_name as LName,
	s.store_id as StoreIDAffiliation
from
	customer c
		Inner join store s on c.store_id=s.store_id)
UNION ALL ( select
	st.first_name as FName,
	st.last_name as LName,
	s.store_id as StoreIDAffiliation
from 
	staff st
		Inner Join store s on st.store_id=s.store_id);
#	Note : use a set operator, do not remove duplicates 

########################## QUESTION 2 ##########################

#	a) List actors and customers whose first name is the same as the first name of the actor with ID 8. 


(select  distinct 
	c.first_name as FName,
    c.last_name as LName
from
	customer c
		inner join rental r on r.customer_id=c.customer_id
			inner join inventory i on i.inventory_id=r.inventory_id
				inner join film f on f.film_id=i.film_id
					inner join film_actor fa on fa.film_id=f.film_id
						inner join actor a on a.actor_id=fa.actor_id
where
c.first_name= (select first_name from actor where actor_id=8)) union
(select distinct
	a.first_name as Fname,
	a.last_name as LName
from actor a
where 
a.first_name=(select first_name from actor where actor_id=8));

    
#	b) List customers and payment amounts, with payments greater than average the payment amount 
select c.first_name,c.last_name,p.amount
from customer c
	inner join payment p on p.customer_id= c.customer_id
where p.amount > (select avg(amount) from payment);

#	c) List customers who have rented movies atleast once 
select distinct c.first_name,c.last_name
from customer c
where
c.customer_id in (select r.customer_id from rental r);

#	Note: use IN clause 

#	d) Find the floor of the maximum, minimum and average payment amount 

select 
floor(max(amount)) as MAXI,
floor(min(amount)) as MINI,
floor(avg(amount)) as AVER
from payment;
########################## QUESTION 3 ########################## 

#	a) Create a view called actors_portfolio which contains information about actors and films ( including titles and category). 

create view actor_portfolio as
select a.first_name,a.last_name, f.title, cc.name 
from actor a
	inner join film_actor fa on fa.actor_id=a.actor_id
		inner join film f on f.film_id=fa.film_id
			inner join film_category fc on fc.film_id= f.film_id
				inner join category cc on cc.category_id=fc.category_id;
				
#	b) Describe the structure of the view and query the view to get information on the actor ADAM GRANT 
describe actor_portfolio;
select * from actor_portfolio where first_name ='ADAM' and last_name='GRANT';
#	c) Insert a new movie titled Data Hero in Sci-Fi Category starring ADAM GRANT 
# insert into actor_portfolio (first_name,last_name,title,name) values ('Adam','Grant','Data Hero', 'Sci-Fi');
# You cannot delete a row if the view references more than one base table. You can only update columns that belong to a single base table
########################## QUESTION 4 ########################## 

#	a) Extract the street number ( characters 1 through 4 ) from customer addressLine1 
select left(address,4) as StreetNo from address;
#	b) Find out actors whose last name starts with character A, B or C. 
select first_name,last_name, left(last_name,1) as LNInit
from actor
group by last_name
having LNInit in ('A','B','C');
#	c) Find film titles that contains exactly 10 characters 
select title , length(title) as TitleLen
from film
group by title
having TitleLen=10;
#	d) Format a payment_date using the following format e.g "22/1/2016" 
select payment_date , date_format(payment_date, "%d/ %m/ %Y") as newForm from payment;
#	e) Find the number of days between two date values rental_date & return_date 
select rental_id, datediff(rental.return_date,rental.rental_date) as DateDiff from rental;

########################## QUESTION 5 ########################## 

#	Provide five additional queries (not already in the assignment) along with the specific business cases they address. 
