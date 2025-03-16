update tr_detail,tr_header set tr_detail.created = tr_header.created, tr_detail.updated = null, tr_detail.updatedby = null
where tr_header.tr_id = tr_detail.tr_id
AND tr_header.tr_number = tr_detail.tr_number
AND tr_header.company_id = tr_detail.company_id