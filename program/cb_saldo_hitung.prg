IF TYPE('KONEK') = 'N'
	IF KONEK = 1		
		LPROSES = .T.
		xx=SQLEXEC(KONEK,'SELECT MIN(tr_date) AS tr_date FROM cb_header WHERE company_id = ?xcompanyid LIMIT 1','MINTGL')
		IF xx <= 0 THEN
		   DO 'program\cek_error_sql.prg'	
		ENDIF	
		IF USED('MINTGL')
			SELECT MINTGL
			IF RECCOUNT() > 0
				_MINTGL = MINTGL->tr_date
				IF dTgl < _MINTGL
					LPROSES = .F.
				ENDIF
			ENDIF			
		ENDIF		
		IF LPROSES = .T.
			**-- Delete
			xx=SQLEXEC(KONEK,'DELETE FROM cb_saldo WHERE cbs_date=?MTGL AND company_id = ?xcompanyid')
			DO 'program\cek_error_sql_crud.prg'			
			
			**-- Get Transaksi Kas & Bank
			DO CALCULATE_CASH_BANK
			
			**-- Update
			xx=SQLEXEC(KONEK,'UPDATE cb_saldo SET UPDATED = ?DATETIME(), UPDATEDBY = ?XIDUSER WHERE cbs_date=?MTGL AND company_id = ?xcompanyid')
			DO 'program\cek_error_sql_crud.prg'
		ENDIF	
		WAIT CLEAR 
	ENDIF 	
ENDIF
	
PROCEDURE CALCULATE_CASH_BANK()
	TEXT TO M.LSQL NOSHOW
		SELECT id AS cb_id, cb_name FROM cb ORDER BY id ASC
	ENDTEXT
	xx=SQLEXEC(KONEK,M.LSQL,"TEMPLATE")
	IF xx <= 0 THEN
	   DO 'program\cek_error_sql.prg'
	ENDIF
	IF USED('TEMPLATE')
		IF RECCOUNT('TEMPLATE') > 0
			SELECT TEMPLATE
			GO TOP
			NREK = 0
			_RECOUNT = RECCOUNT()
			DO WHILE .NOT. EOF()						
				_CB_ID   = TEMPLATE->CB_ID
				_CB_NAME = ALLTRIM(TEMPLATE->cb_name)
				
				nrek = nrek + 1
				wait window nowait 'saldo : ' + _CB_NAME + ' | tanggal : ' + cTGL + ' | reccord :' +	alltrim(str(nrek)) + ' / ' + alltrim(str(_recount))
				
				TEXT TO M.LSQL NOSHOW
					SELECT MAX(ID) AS MAXID FROM cb_saldo LIMIT 1
				ENDTEXT
				xx=SQLEXEC(KONEK,M.LSQL,"NMAX")			
				IF xx <= 0 THEN
				   DO 'program\cek_error_sql.prg'	
				ENDIF					
				IF USED('NMAX')	
					IF ISNULL(NMAX->MAXID)
						_ID = 1
					ELSE
						_ID = VAL(NMAX->MAXID) + 1  
					ENDIF
				ENDIF																

				TEXT TO M.LSQL NOSHOW
					INSERT INTO cb_saldo(ID,
										  company_id,
										  cb_id,
  										  cbs_date,
										  cbs_saldo,
										  status,
										  CREATED,
										  CREATEDBY)
					VALUES(?_ID,
						   ?xcompanyid,
						   ?_CB_ID,
   						   ?MTGL,
						   0,
						   3,
						   ?DATETIME(),
						   ?XIDUSER)
				ENDTEXT
				xx=SQLEXEC(KONEK,M.LSQL)	
				DO 'program\cek_error_sql_crud.prg'
				
				** SALDO AKHIR TANGGAL SEBELUMNYA
				**------------------------------------------------------------------------------------------------
				_SALDO_AWAL = 0
				TEXT TO M.LSQL NOSHOW
					SELECT cbs_saldo FROM cb_saldo
					WHERE company_id = ?xcompanyid 
					AND cb_id = ?_CB_ID
					AND cbs_date < ?MTGL
					ORDER BY cbs_date DESC
					LIMIT 1
				ENDTEXT 
				xx=SQLEXEC(KONEK,M.LSQL,'LASTSALDO')
				IF xx <= 0 THEN
				   DO 'program\cek_error_sql.prg'	
				ENDIF						
				IF USED('LASTSALDO')
					SELECT LASTSALDO
					IF RECCOUNT() > 0
						DO 'program\update_field.prg'
						IF .NOT. ISNULL(LASTSALDO->cbs_saldo)						
							_SALDO_AWAL = LASTSALDO->cbs_saldo
						ENDIF
						TEXT TO M.LSQL NOSHOW
							UPDATE cb_saldo SET cbs_saldo = ?_SALDO_AWAL
							WHERE company_id = ?xcompanyid 
							AND cb_id = ?_CB_ID
							AND cbs_date = ?MTGL
						ENDTEXT 
						xx=SQLEXEC(KONEK,M.LSQL)
						DO 'program\cek_error_sql_crud.prg'
					ENDIF
				ENDIF
				
				** TRANSAKSI
				**------------------------------------------------------------------------------------------------
				TEXT TO M.LSQL NOSHOW
					SELECT SUM(IF(cb_pos.cb_pos_in_out = 'I', cb_detail.amount,0)) AS masuk,
						   SUM(IF(cb_pos.cb_pos_in_out = 'O', cb_detail.amount,0)) AS keluar
					FROM cb_detail
					JOIN cb_header ON cb_detail.header_id = cb_header.id
					JOIN cb_pos ON cb_header.cb_pos_id = cb_pos.id
					WHERE cb_header.company_id = ?xcompanyid
					AND cb_header.tr_date = ?MTGL
					AND cb_header.cb_id = ?_CB_ID
					AND cb_detail.status = 3
					GROUP BY cb_header.tr_date, cb_header.cb_id
				ENDTEXT
				xx=SQLEXEC(KONEK,M.LSQL,'TRX')
				IF xx <= 0 THEN
				   DO 'program\cek_error_sql.prg'
				ENDIF	
				IF USED('TRX')
					SELECT TRX
					IF RECCOUNT() > 0
						DO 'program\update_field.prg'
						_SALDO_AWAL = ( _SALDO_AWAL + TRX->masuk ) - TRX->keluar
						TEXT TO M.LSQL NOSHOW
							UPDATE cb_saldo SET cbs_saldo = ?_SALDO_AWAL
							WHERE company_id = ?xcompanyid 
							AND cb_id = ?_CB_ID
							AND cbs_date = ?MTGL
						ENDTEXT 
						xx=SQLEXEC(KONEK,M.LSQL)
						DO 'program\cek_error_sql_crud.prg'
					ENDIF
					USE IN TRX
				ENDIF
				IF USED('LASTSALDO')
					USE IN LASTSALDO
				ENDIF
				
				SELECT TEMPLATE
				SKIP 
			ENDDO 
		ENDIF 
		USE IN TEMPLATE
	ENDIF
	
	