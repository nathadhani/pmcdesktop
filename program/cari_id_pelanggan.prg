TEXT TO m.lsql NOSHOW
	SELECT 
		m_customer.id AS no,
		m_customer.id,
		m_customer.customer_code,
		m_customer.customer_name,
		m_customer.customer_nick_name,
		m_customer.customer_addres,
		m_customer.rt_rw,
		m_customer.village,
		m_customer.sub_district,
		m_customer.city,
		m_customer.customer_handphone,
		m_customer.customer_phone,
		m_customer.customer_type_id,
			
		m_customer.customer_data_id,
		m_customer.customer_data_number,
		
		(
		CASE
			WHEN m_customer.customer_data_id = 1 THEN "KTP"
			WHEN m_customer.customer_data_id = 2 THEN "KITAS"
			WHEN m_customer.customer_data_id = 3 THEN "SIM"
			WHEN m_customer.customer_data_id = 4 THEN "PASPOR"
			WHEN m_customer.customer_data_id = 5 THEN "LAINNYA"
			ELSE ""
		END
		) AS customer_data_name,	
		
		m_customer.placeofbirth,
		m_customer.bornday,
		m_customer.gender_id,	
		
		m_customer.work_id,
		m_customer_work.work_name,
		
		m_customer.nationality_id,
		m_customer_nationality.nationality_name,
		
		m_customer.customerprofil,
		m_customer.status,
		m_customer.created,
		m_customer.updated,
		x.user_full_name AS createdby_name,
		y.user_full_name AS updatedby_name
	
	FROM m_customer 
	LEFT JOIN m_customer_work ON m_customer.work_id = m_customer_work.id
	LEFT JOIN m_customer_nationality ON m_customer.nationality_id = m_customer_nationality.id
	LEFT JOIN m_user AS x ON x.id = m_customer.createdby
	LEFT JOIN m_user AS y ON y.id = m_customer.updatedby
	WHERE m_customer.id = ?getCUSTID LIMIT 1
ENDTEXT
xx=SQLEXEC(konek,m.lsql,'CEKLANG')
IF xx <= 0 THEN
   DO 'program\cek_error_sql.prg'	
ELSE
	IF USED('CEKLANG')
		IF RECCOUNT('CEKLANG') > 0
			SELECT CEKLANG
			DO 'program\update_field.prg'		
			GO TOP 
		ENDIF
	ENDIF
ENDIF
	