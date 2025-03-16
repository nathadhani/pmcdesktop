SET @rownr=0;
insert into tr_bayar
(
	id,
	company_id,
	tr_id,
	tr_number,
	tr_date,
	tipe_bayar,
	jumlah,
	description,
	finance_pos_id,
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
	tr_date,
	1 AS tipe_bayar,
	SUM(subtotal) as jumlah,
	'Cash' AS description,
	null AS finance_pos_id,
	3 AS status,
	created,
	updated,
	createdby,
	updatedby
	FROM tr_detail
	GROUP BY tr_id,tr_number