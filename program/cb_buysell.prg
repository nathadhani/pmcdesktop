IF TYPE('konek')= 'N'
	IF konek = 1		
		TEXT TO m.lsql NOSHOW 
			SELECT
			tr_header.tr_date,
			tr_header.tr_number,
			tr_header.id AS buysell_id,
			tr_bayar.payment_type AS buysell_payment_type,
			cb_pos.cb_id,
			cb_pos.id AS cb_pos_id,
			cb_pos.cb_pos_in_out,
			tr_bayar.amount,
			tr_bayar.description
			FROM tr_bayar
			JOIN tr_header ON tr_bayar.tr_id = tr_header.tr_id
			JOIN cb_pos ON tr_header.tr_id = cb_pos.buysell_tr_id AND IF(tr_bayar.payment_type = 1 ,1 ,2) = cb_pos.cb_id 
			AND tr_bayar.tr_number = tr_header.tr_number
			WHERE tr_header.company_id = ?xCOMPANYID
			AND tr_header.tr_date >= ?mTgl1
			AND tr_header.tr_date <= ?mTgl2
			AND tr_bayar.status = 3
			AND tr_bayar.amount > 0
			ORDER BY tr_header.tr_date, tr_header.tr_number,tr_bayar.payment_type ASC
		ENDTEXT
		xx=SQLEXEC(konek,m.lsql,"tmp_bayar")
		IF xx <= 0 THEN
		   DO 'program\cek_error_sql.prg'
		ENDIF
		IF USED('tmp_bayar')
			SELECT tmp_bayar
			IF RECCOUNT() > 0
				DO 'program\update_field.prg'
				GO TOP 
				NREK = 0
	   	   		DO WHILE .NOT. EOF()	    	   						  		   	   		
	   	   			NREK = NREK + 1
	   	   			WAIT WINDOW NOWAIT ALLTRIM(STR(NREK)) + '/' + ALLTRIM(STR(RECCOUNT()))
	   	   			IF tmp_bayar->amount = 0 .OR. .NOT. ALLTRIM(STR(tmp_bayar->buysell_payment_type)) $ '1,2'
	   	   				SKIP 
	   	   				LOOP 
	   	   			ENDIF
	   	   			
	   	   			xHeader_ID = ''
	   	   			xcb_id = tmp_bayar->cb_id
	   	   			xcb_pos_id = tmp_bayar->cb_pos_id
	   	   			xtr_date = tmp_bayar->tr_date	   
	   	   			xtr_number = getnomor_cb()
	   	   			xbuysell_id = tmp_bayar->buysell_id	   	   			
	   	   			xbuysell_payment_type = tmp_bayar->buysell_payment_type
	   	   			xdescription = PROPER(ALLTRIM(tmp_bayar->description)) + SPACE(1) + ALLTRIM(tmp_bayar->tr_number)
	   	   			xamount = tmp_bayar->amount	   	   			
   	   			
	   	   			TEXT TO m.lsql NOSHOW 
						SELECT * FROM cb_header
						WHERE company_id = ?xcompanyid
							AND buysell_id = ?xbuysell_id
							AND buysell_payment_type = ?xbuysell_payment_type
							AND status = 3
						LIMIT 1
					ENDTEXT
					xx=SQLEXEC(konek,m.lsql,"cek_header")
					IF xx <= 0 THEN
					   DO 'program\cek_error_sql.prg'	
					ENDIF 
					IF USED('cek_header')
						SELECT cek_header
						IF RECCOUNT() > 0
							xHeader_ID = ALLTRIM(cek_header->id)
						ENDIF
						IF RECCOUNT() <= 0
							TEXT TO M.LSQL NOSHOW
								SELECT MAX(ID) AS MAXID FROM cb_header
							ENDTEXT
							xx=SQLEXEC(KONEK,M.LSQL,"NMAX")					
							IF xx <= 0 THEN
							   DO 'program\cek_error_sql.prg'	
							ENDIF					
							IF USED('NMAX')							
								_ID = IIF(ISNULL(nMAX->MAXID).OR.EMPTY(nMAX->MAXID),1,VAL(nMAX->MAXID)+1)		
								IF _ID > 0 									
									xHeader_ID = _ID
									TEXT TO M.LSQL NOSHOW
										INSERT INTO cb_header(id,
														company_id,
													    cb_id,
														cb_pos_id,
														tr_date,
														tr_number,
														buysell_id,
														buysell_payment_type,
														status,
														created,
														createdby)
													VALUES
													   (?_ID,		
													    ?xcompanyid,
													    ?xcb_id,
													    ?xcb_pos_id,
													    ?xtr_date,
													    ?xtr_number,
													    ?xbuysell_id,
													    ?xbuysell_payment_type,											
														3,
														?DATETIME(),
													    ?xIDUSER)																   
									ENDTEXT
									xx=SQLEXEC(konek,m.lsql)
									IF xx <= 0
										DO 'program\cek_error_sql.prg'
										DO 'program\cek_error_sql_crud.prg'
										=SQLROLLBACK(konek)   
									ELSE 
										=SQLCOMMIT(konek)
									ENDIF
								ENDIF	
							ENDIF
						ENDIF
						*******************************************************************************************************************
						IF .NOT. EMPTY(xheader_id)
							TEXT TO M.LSQL NOSHOW
								SELECT header_id FROM cb_detail WHERE header_id = ?xheader_id LIMIT 1
							ENDTEXT
							xx=SQLEXEC(KONEK,M.LSQL,"cekdetail")					
							IF xx <= 0 THEN
							   DO 'program\cek_error_sql.prg'	
							ENDIF
							IF USED('cekdetail')
								SELECT cekdetail
								IF RECCOUNT() <= 0
									TEXT TO M.LSQL NOSHOW
										SELECT MAX(ID) AS MAXID FROM cb_detail LIMIT 1
									ENDTEXT
									xx=SQLEXEC(KONEK,M.LSQL,"NMAX")					
									IF xx <= 0 THEN
									   DO 'program\cek_error_sql.prg'	
									ENDIF					
									IF USED('NMAX')							
										_ID = IIF(ISNULL(nMAX->MAXID).OR.EMPTY(nMAX->MAXID),1,VAL(nMAX->MAXID)+1)
										TEXT TO m.LSQL NOSHOW 
											INSERT INTO cb_detail(id,
															header_id,
															description,
															amount,
															status,
															created,
															createdby)											 
															VALUES
															(?_ID,
															?xHeader_ID,
															?xdescription,
															?xamount,
															3,
															?DATETIME(),
														    ?xIDUSER)
										ENDTEXT 
										xx=SQLEXEC(konek,m.lsql)					
										IF xx <= 0
											DO 'program\cek_error_sql.prg'
											DO 'program\cek_error_sql_crud.prg'
											=SQLROLLBACK(konek)   
										ELSE 
											=SQLCOMMIT(konek)
										ENDIF
										USE IN NMAX
									ENDIF								
								ENDIF
								USE IN cekdetail
							ENDIF
						ENDIF
						USE IN cek_header
					ENDIF		   	   				 	  
			   	    							
					SELECT tmp_bayar
					SKIP
	   	   		ENDDO	
				MESSAGEBOX('selesai',64,'message',5000)		
	   	   	ENDIF
	   	   	USE IN tmp_bayar
	   	  ENDIF
	ENDIF
ENDIF

FUNCTION getnomor_cb()
	xtr_number = ''
	mTahun = YEAR(xtr_date)
	mBulan = MONTH(xtr_date)
	mDays  = DAY(xtr_date)
	cab = RIGHT('00'+ALLTRIM(STR(xcompanyid)),2)
	mcb_id = RIGHT('00'+ALLTRIM(STR(xcb_id)),2)
	mcb_pos_id = RIGHT('00'+ALLTRIM(STR(xcb_pos_id)),2)

	TEXT TO m.lsql NOSHOW 
		SELECT MAX(RIGHT(RTRIM(tr_number),4)) AS maxurut
		FROM cb_header
		WHERE company_id = ?xcompanyid 
		AND cb_id = ?xcb_id
		AND cb_pos_id = ?xcb_pos_id
		AND YEAR(tr_date) = ?mTahun
		AND MONTH(tr_date) = ?mBulan
		AND DAY(tr_date) = ?mDays
	ENDTEXT
	xx=SQLEXEC(konek,m.lsql,"cek1")
	IF xx <= 0 THEN
	   DO 'program\cek_error_sql.prg'	
	ENDIF 
	IF USED('cek1')
		SELECT cek1
		IF RECCOUNT() > 0								
			IF .NOT. ISNULL(cek1->maxurut) .OR. .NOT. cek1->maxurut = '0'
				 nLast = VAL(cek1->maxurut) + 1
				 urut = RIGHT('0000'+ ALLTRIM(STR(nlast)),4)
				 xtr_number = RIGHT('00'+ALLTRIM(STR(mTahun)),2) + RIGHT('00'+ALLTRIM(STR(mBulan)),2) + RIGHT('00'+ALLTRIM(STR(mDays)),2) + cab + mcb_id + mcb_pos_id + urut
			ELSE
 				 xtr_number = RIGHT('00'+ALLTRIM(STR(mTahun)),2) + RIGHT('00'+ALLTRIM(STR(mBulan)),2) + RIGHT('00'+ALLTRIM(STR(mDays)),2) + cab + mcb_id + mcb_pos_id + '0001'
			ENDIF			
		ENDIF 		
		USE IN CEK1
	ENDIF
	RETURN xtr_number
	
