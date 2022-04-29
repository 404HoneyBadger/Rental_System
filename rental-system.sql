-- 1. Customer 'Angel' has rented 'SBA1111A' from today for 10 days
insert into rental_records(veh_reg_no, customer_id, start_date, end_date)
Values ('SBA1111A',
(select customer_id
from customers
where name='Angel'),
(select curdate()),
(date_add(curdate(), interval 10 day)));

-- 2. Customer 'Kumar' has rented 'GA5555E' from tomorrow for 3 months.
insert into rental_records(veh_reg_no, customer_id, start_date, end_date)
Values ('GA5555E',
(select customer_id
from customers
where name='Kumar'),
(select curdate()+1),
(date_add(curdate()+1, interval 3 MONTH)));

-- 3. List all rental records (start date, end date) with vehicle's registration number, brand, and customer name, sorted by vehicle's categories followed by start date
drop view all_rental_records;

create view all_rental_records
as select start_date, end_date, vehicles.veh_reg_no, brand, name
from vehicles, rental_records, customers
where vehicles.veh_reg_no=rental_records.veh_reg_no
and rental_records.customer_id=customers.customer_id
order by vehicles.category, start_date;

select * from all_rental_records;

-- 4. List all the expired rental records (end_date before CURDATE()).
select *
from rental_records
where end_date<curdate();

-- 5. List the vehicles rented out on '2012-01-10', in columns of vehicle registration no, customer name, start date and end date
drop view not_available;

create view not_available
as select rental_records.veh_reg_no, name, start_date, end_date
from rental_records, customers
where rental_records.customer_id=customers.customer_id
and start_date>'2012-01-10'<end_date;

select * from not_available;

-- 6. List all vehicles rented out today, in columns registration number, customer name, start date, end date.
select veh_reg_no, name, start_date, end_date
from rental_records, customers
where rental_records.customer_id=customers.customer_id
and start_date=curdate();

-- 7. Similarly, list the vehicles rented out (not available for rental) for the period from '2012-01-03' to '2012-01-18'
select veh_reg_no, name, start_date, end_date
from rental_records, customers
where rental_records.customer_id=customers.customer_id
and start_date between '2012-01-03' and '2012-01-18';

-- 8. List the vehicles (registration number, brand and description) available for rental (not rented out) on '2012-01-10'
drop view date_available;

select distinct rental_records.veh_reg_no, brand, vehicles.desc
from vehicles
left join rental_records
on vehicles.veh_reg_no=rental_records.veh_reg_no
and not (start_date<'2012-01-10' and end_date>'2012-01-10');

-- 9. Similarly, list the vehicles available for rental for the period from '2012-01-03' to '2012-01-18'.
select distinct rental_records.veh_reg_no, brand, vehicles.desc
from vehicles
left join rental_records
on vehicles.veh_reg_no=rental_records.veh_reg_no
and not ((start_date between '2012-01-03' AND '2012-01-18')
 OR (end_date between '2012-01-03' AND end_date > '2012-01-18')
 OR (start_date < '2012-01-03' AND end_date > '2012-01-18'));

-- 10. Similarly, list the vehicles available for rental from today for 10 days
SELECT distinct r.veh_reg_no, v.brand, v.desc
 FROM vehicles AS v LEFT JOIN rental_records AS r 
 ON  v.veh_reg_no = r.veh_reg_no
 AND NOT ((start_date between curdate() AND (date_add(curdate(), interval 10 day)))
 OR (end_date between curdate() AND end_date (date_add(curdate(), interval 10 day)))
 OR (start_date < curdate() AND end_date > (date_add(curdate(), interval 10 day))) );

