IF TYPE('konek')= 'N'
	IF konek = 1		
		TEXT TO m.lsql NOSHOW 
			SELECT
			tr_header.id AS buysell_id,
			tr_header.tr_date,
			tr_header.tr_number,
			cb_pos.cb_id,
			cb_pos.id AS cb_pos_id,
			cb_pos.cb_pos_in_out,
			tr_bayar.payment_type AS buysell_payment_type,
			tr_bayar.amount
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
	   	   		DO WHILE .NOT. EOF()	    	   						  		   	   		
	   	   			IF tmp_bayar->amount = 0 .OR. .NOT. ALLTRIM(STR(tmp_bayar->buysell_payment_type)) $ '1,2'
	   	   				SKIP 
	   	   				LOOP 
	   	   			ENDIF
	   	   			
	   	   			xHeader_ID = 0
	   	   			xcb_id = tmp_bayar->cb_id
	   	   			xcb_pos_id = tmp_bayar->cb_pos_id
	   	   			xtr_date = tmp_bayar->tr_date	   
	   	   			xtr_number = getnomor_cb()	   			
	   	   			xbuysell_id = tmp_bayar->buysell_id	   	   			
	   	   			xbuysell_payment_type = tmp_bayar->buysell_payment_type
	   	   			xdescription = PROPER(ALLTRIM(tmp_bayar->description)) + SPACE(1) + ALLTRIM(tmp_bayar->tr_number)
	   	   			xmamount = tmp_bayar->amount
	   	   			
	   	   			TEXT TO m.lsql NOSHOW 
						SELECT * FROM cb_header
						WHERE company_id = ?xCOMPANYID
							AND buysell_id = ?_buysell_id
							AND buysell_payment_type = ?_payment_type
							AND status = 3
						LIMIT 1
					ENDTEXT
					xx=SQLEXEC(konek,m.lsql,"cek_header")
					IF xx <= 0 THEN
					   DO 'program\cek_error_sql.prg'	
					ENDIF 
					IF USED('cek_header')
						SELECT cek_header
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
										TEXT TO M.LSQL NOSHOW
											SELECT MAX(ID) AS MAXID FROM cb_detail
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
								ENDIF	
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
	mTahun = YEAR(Thisform.txt_tanggal.Value)
	mBulan = MONTH(Thisform.txt_tanggal.Value)
	mDays  = DAY(Thisform.txt_tanggal.Value)
	cab = RIGHT('00'+ALLTRIM(STR(xCOMPANYID)),2)	

	TEXT TO m.lsql NOSHOW 
		SELECT MAX(RIGHT(RTRIM(cba_tr_number),4)) AS maxurut, cba_tr_date
		FROM cb_header
		WHERE company_id = ?xcompanyid 
		AND cba_id = ?tmp_cba_id
		AND cba_pos_id = ?tmp_cba_pos_id
		AND YEAR(cba_tr_date) = ?mTahun
		AND MONTH(cba_tr_date) = ?mBulan
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
				 IF Nlast < 10
				 	urut = '000' + ALLTRIM(STR(nlast))
				 ELSE
					 IF Nlast < 100
						urut = '00' + ALLTRIM(STR(nlast))
				 	 ELSE
						 IF Nlast < 1000
						 	 urut = '0' + ALLTRIM(STR(nlast))
						 ELSE
						 	 urut = ALLTRIM(STR(nlast))	 					 	 
						 ENDIF
					 ENDIF
				 ENDIF
				 tmp_tr_number = RIGHT('00'+ALLTRIM(STR(mTahun)),2) + RIGHT('00'+ALLTRIM(STR(mBulan)),2) + RIGHT('00'+ALLTRIM(STR(mDays)),2) + cab + mcba_id + mcba_pos_id + urut
				 tmp_tr_date = Thisform.txt_tanggal.Value
			ELSE
		 				 tmp_tr_number = RIGHT('00'+ALLTRIM(STR(mTahun)),2) + RIGHT('00'+ALLTRIM(STR(mBulan)),2) + RIGHT('00'+ALLTRIM(STR(mDays)),2) + cab + mcba_id + mcba_pos_id + '0001'
				 tmp_tr_date = Thisform.txt_tanggal.Value
			ENDIF			
		ENDIF 		
		USE IN CEK1
	ENDIF	
	
