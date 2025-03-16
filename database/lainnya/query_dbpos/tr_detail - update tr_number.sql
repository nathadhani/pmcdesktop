update tr_detail,tr_header set tr_detail.tr_number = tr_header.tr_number
where tr_detail.tr_id = tr_header.tr_id 
AND tr_detail.tr_number_old = tr_header.tr_number_old
AND tr_detail.company_id = tr_header.company_id