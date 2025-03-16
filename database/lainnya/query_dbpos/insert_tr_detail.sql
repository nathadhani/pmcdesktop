SET @rownr=0;
insert into tr_detail
(
	id,
	company_id,
	tr_id,
	tr_number,
	tr_number_old,
	tr_date,
	valas_id,
	qty,
	price,
	subtotal,
	status,
	created,
	updated,
	createdby,
	updatedby
)
select
	@rownr:=@rownr+1 AS id, 
	company_id,
	tr_id,
	tr_number,
	tr_number_old,
	tr_date,
	valas_id,
	qty,
	price,
	subtotal,
	status,
	created,
	updated,
	createdby,
	updatedby  
	from ztrd
	