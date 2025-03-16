create table ztrh select * from tr_header order by company_id,tr_date,customer_id asc 

create table ztrh select customer_id_old,created from tr_header group by customer_id_old order by customer_id_old,created asc 

select * from tr_header order by tr_id,tr_date,tr_number asc 