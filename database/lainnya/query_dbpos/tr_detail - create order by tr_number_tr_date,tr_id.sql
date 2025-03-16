-- create table ztrd 
-- select tr_detail.* 
-- from tr_detail 
-- join tr_header on tr_header.tr_id = tr_detail.tr_id AND tr_header.tr_number = tr_detail.tr_number
-- order by tr_header.id asc, tr_detail.tr_number 


create table ztrd 
select * 
from tr_detail 
order by company_id ASC, tr_id ASC, tr_number ASC, tr_date ASC