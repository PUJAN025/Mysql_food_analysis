create database fingertip_mock;
show databases ;
use fingertip_mock;
show tables;
select * from card;
select * from customers;
select * from orders;
select * from dish;
select * from details;
select * from cuisine;
#1)	Details of customers whose name starts with 'A' and have gmail id
select * from customers 
where name like "A%" and email != " ";
#2)	Details of customers containing 3 times 5 in password
select * from customers 
where password like "%5%5%5";
#3)	Name & address of North Indian restaurant which is situated in 456 Elm St
select r_name, address from cuisine
where cuisine="North Indian" and address="456 Elm St";
#4)	Names of restaurant which is either Italian or situated in '433 Oak St'
select r_name from cuisine
where cuisine="Italian" or address="433 Oak St";
#5)	How many orders were palced with amount 650 or more
select count(amount) from orders
where amount>=650;
#6)	Find details of those customers who have never ordered 
select name from customers 
where 
name!=
(
select c.name 
from customers c left join orders o
on c.user_id=o.user_id
);
#7)	Find out details of restaurants having sales greater than x (1000 or any amount)
select distinct(c.r_name) from cuisine c join orders o 
on c.r_id=o.r_id
where amount>=300;
#8)	Show all order details for a particular customer ('Vartika')
select * from customers c join orders o 
on c.user_id=o.user_id
where c.name="Vartika";

#9)	What is the average Price per dish 
select avg(c.price) from card c join dish d
on c.f_id=d.f_id;

#10)Find out number of times each customer ordered food from each restaurants
select user_id,r_id, count(r_id) as number_of_orders_from_each_restaurents from orders 
group by user_id,r_id
order by user_id,r_id;

#11)Find the top restaurant in terms of the number of orders for a given month.
select r_id, dense_rank() over (partition by user_id order by count(r_id)) as rnk
where date = "2022-05-01";

#11)Who is most loyal customer of dominos?
select c.r_name,o.user_id as most_loyal_customer_user_id,o.r_id,count(o.r_id) as number_of_times_ordered from cuisine c join orders o 
where c.r_name="dominos"
group by o.user_id,o.r_id
order by count(o.r_id) desc
limit 1;

#12)	What is the favorite food of each customer?
#or #13) What is the favorite food of each customer along with customer details
# or 14) For each restaurant find out user who has ordered maximum number of times

with cte as 
(
select user_id,r_id, count(r_id) as highest_number_of_orders_from_each_restaurents,
dense_rank() over (partition by user_id order by count(r_id) desc) as rnk 
from orders 
group by user_id,r_id
order by user_id,count(r_id) desc
)
select cte.user_id,cte.rnk,highest_number_of_orders_from_each_restaurents,c.r_name,cu.name as customer_name from cte join cuisine c
on cte.r_id=c.r_id
join customers cu 
on cu.user_id=cte.user_id
where rnk=1;
     






