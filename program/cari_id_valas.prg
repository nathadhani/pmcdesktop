TEXT TO m.lsql NOSHOW
	SELECT
		v_st3.valas_code AS no,
		v_st3.valas_code,
		v_st3.valas_name,
		v_st3.qty_first,
		v_st3.qty_buy,
		v_st3.qty_sale,
		v_st3.qty_last,
		v_st3.valas_id
	FROM v_st3
	WHERE v_st3.company_id = ?xcompanyid
	AND v_st3.st_year = ?mTahun
	AND v_st3.st_month = ?mBulan
	AND v_st3.valas_id = ?getVALASID
    LIMIT 1
ENDTEXT 
xx=SQLEXEC(konek,m.lsql,'tmpstock')
IF xx <= 0 THEN
   DO 'program\cek_error_sql.prg'	
ELSE
	IF USED('tmpstock')
		IF RECCOUNT('tmpstock') > 0
			SELECT tmpstock
			DO 'program\update_field.prg'
			GO TOP
		ELSE
			TEXT TO m.lsql NOSHOW
				SELECT
					m_valas.valas_code AS no,
					m_valas.valas_code,
					m_valas.valas_name,
					0 AS qty_first,
					0 AS qty_buy,
					0 AS qty_sale,
					0 AS qty_last,
					m_valas.id AS valas_id
				FROM m_valas
				WHERE id = ?getVALASID
			    LIMIT 1
			ENDTEXT 
			xx=SQLEXEC(konek,m.lsql,'tmpstock')
			IF xx <= 0 THEN
			   DO 'program\cek_error_sql.prg'	
			ELSE
				IF USED('tmpstock')
					IF RECCOUNT('tmpstock') > 0
						SELECT tmpstock
						DO 'program\update_field.prg'
						GO TOP
					ENDIF
				ENDIF
			ENDIF		
		ENDIF
	ENDIF
ENDIF
		