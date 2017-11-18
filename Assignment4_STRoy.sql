/*********************************************** 
** File: Assignment4.sql 
** Desc: Assignment 4 
** Author: Suryoday Tarit Roy	
** Date: 3 Nov 2017
 ************************************************/
 
#################################### QUESTION 1

#	a) Show the list of databases. 
show databases;

#	b) Select sakila database. 
use sakila;

#	c) Show all tables in the sakila database. 
show tables;

#	d) Show each of the columns along with their data types for the actor table. 
describe actor;
#	e) Show the total number of records in the actor table. 
select count(*) from actor;
#	f) What is the first name and last name of all the actors in the actor table ? 
select first_name, last_name from actor;
#	g) Insert your first name and middle initial ( in the last name column ) into the actors table. 
insert into actor (first_name, last_name) values ('Suryoday', 'T.');
select * from actor where first_name='Suryoday';
#	h) Update your middle initial with your last name in the actors table. 
SET SQL_SAFE_UPDATES = 0;
update actor set last_name= 'Roy' where first_name='Suryoday';
select * from actor where first_name='Suryoday';

#	i) Delete the record from the actor table where the first name matches your first name. 
Delete from actor where first_name='Suryoday';
select count(*) from actor;
#	j) Create a table payment_type with the following specifications and appropriate data types 
#	Table Name : “Payment_type” 
#	Primary Key: "payment_type_id” 
#	Column: “Type” 
#	Insert following rows in to the table: 1, “Credit Card” ; 2, “Cash”; 3, “Paypal” ; 4 , “Cheque” 

CREATE TABLE `Payment_Type` (
  `payment_type_id` INT(11) NOT NULL,
  `Type` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`payment_type_id`))
   ENGINE=INNODB DEFAULT CHARSET=LATIN1;
INSERT INTO PAYMENT_TYPE (PAYMENT_TYPE_ID,TYPE) VALUES (
1, 'Credit Card'), 
(2, 'Cash'),
(3, 'Paypal');
select * from Payment_Type;

#	k) Rename table payment_type to payment_types. 
RENAME TABLE pAYMENT_TYPE TO PAYMENT_TYPES;
SELECT * FROM PAYMENT_tYPES;
#	l) Drop the table payment_types. 
drop table payment_types;
select * from payment_types;

################################## QUESTION 2

################################

#	a) List all the movies ( title & description ) that are rated PG-13 ? 
select title, description from film where rating='PG-13';

#	b) List all movies that are either PG OR PG-13 using IN operator ? 
select title,rating from film where rating in ('PG-13', 'PG');
#	c) Report all payments greater than and equal to 2$ and Less than equal to 7$ ? 
describe payment;
select * from payment where amount>=2 AND amount <=7;
#	Note : write 2 separate queries conditional operator and BETWEEN keyword 
select * from payment where amount between 2 and 7;
#	d) List all addresses that have phone number that contain digits 589, start with 140 or end with 589 
select * from address where phone like '%589%'; 
select * from address where phone like '140%';
select * from address where phone like '%589';
#	Note : write 3 different queries 

#	e) List all staff members ( first name, last name, email ) whose password is NULL ? 
select * from staff where password is NULL;
#	f) Select all films that have title names like ZOO and rental duration greater than or equal to 4 
select * from film where title like '%ZOO%' AND rental_duration>=4;
#	g) Display addresses as N/A when the address2 field is NULL 
select address, IF(address2 IS NULL, 'N/A',address2) as address2 from address; 
select address, (CASE when address2 is null then 'N/A' else address2 end) as address2 from address;
#	Note : use IF and CASE statements 

#	h) What is the cost of renting the movie ACADEMY DINOSAUR for 2 weeks ? 
select title, rental_rate as DailyRate, (rental_rate*14) as '2WeeksCost' from film where title='ACADEMY DINOSAUR';
#	Note : use of column alias 

#	i) List all unique districts where the customers, staff, and stores are located 
select distinct district from address where district is not null;
#	Note : check for NOT NULL values 

#	j) List the top 10 newest customers across all stores 
select * from customer order by create_date desc limit 10;
################################## QUESTION 3

################################

#	a) Show total number of movies 
select count(*) from film;
#	b) What is the minimum payment received and max payment received across all transactions ? 
select*from payment order by amount desc limit 1;
select*from payment order by amount asc limit 1;

#	c) Number of customers that rented movies between Feb-2005 and May-2005 ( based on payment date ). 
select count(*) from payment where month(payment_date) between 2 and 5; 
#	d) List all movies where replacement_cost is greater than 15$ or rental_duration is between 6 and 10 days 
select * from film where replacement_cost>15 or rental_duration between 6 and 10;
#	e) What is the total amount spent by customers for movies in the year 2005 ? 
select sum(amount) as 'TotalAmount' from payment where Year(payment_date)=2005;  
#	f) What is the average replacement cost across all movies ? 
select (sum(replacement_cost)/count(*)) as AverageCost from film;
select avg(replacement_cost) from film;
#	g) What is the standard deviation of rental rate across all movies ? 
select std(rental_rate) as SDofRentalRate from film;
# h) What is the midrange of the rental duration for all movies
select (max(rental_duration)+min(rental_duration))/2  as midRange from film;
select avg(rental_duration) from film; # assuming mean
select rental_duration,count(rental_duration) as CountofR from film group by rental_duration order by CountofR desc limit 1; 

################################## QUESTION 4

################################

#	a) Customers sorted by first Name and last name in ascending order. 
select * from customer order by first_name asc;
select * from customer order by last_name asc;
select * from customer order by first_name,last_name asc;

#	b) Group distinct addresses by district. 
select distinct address_id,address, district from address group by district;
#	c) Count of movies that are either G/NC-17/PG-13/PG/R grouped by rating. 
select rating, count(rating) as CountRating from film group by rating having rating in ('G','NC-17','PG-13','PG','R'); 
#	d) Number of addresses in each district. 
select district,count(address) as CountAddress from address group by district;
#	e) Find the movies where rental rate is greater than 1$ and order result set by descending order. 
select * from film where rental_rate>1 order by rental_rate desc;
#	f) Top 2 movies that are rated R with the highest replacement cost ? 
select * from film where rating='R' order by replacement_cost desc limit 2;
#	g) Find the most frequently occurring (mode) rental rate across products. 
select rental_rate,count(rental_rate) as Mode from film group by rental_rate order by Mode desc limit 1;
#	h) Find the top 2 movies with movie length greater than 50mins and which has commentaries as a special features. 
select * from film where length>50 and special_features like '%Commentaries%' order by length desc limit 2;
#	i) List the years with more than 2 movies released. 
select release_year,count(release_year) as YearCount from film group by release_year having YearCount>2;
