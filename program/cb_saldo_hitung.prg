IF TYPE('KONEK') = 'N'
	IF KONEK = 1		
		LPROSES = .T.
		xx=SQLEXEC(KONEK,'SELECT MIN(cbs_date) AS cbs_date FROM cb_saldo WHERE company_id = ?xcompanyid','MINTGL')
		IF xx <= 0 THEN
		   DO 'program\cek_error_sql.prg'	
		ENDIF	
		IF USED('MINTGL')
			SELECT MINTGL
			IF RECCOUNT() > 0
				_MINTGL = MINTGL->cbs_date
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
			DO GET_TRANSAKSI_KAS_BANK
			
			**-- Update
			xx=SQLEXEC(KONEK,'UPDATE cb_saldo SET UPDATED = ?DATETIME(), UPDATEDBY = ?XIDUSER WHERE cbs_date=?MTGL AND company_id = ?xcompanyid')
			DO 'program\cek_error_sql_crud.prg'
		ENDIF	
		WAIT CLEAR 
	ENDIF 	
ENDIF
	
** DATA TRANSAKSI
** ------------------------------------------------------------------------------------------------------------------------------------------ 
PROCEDURE GET_TRANSAKSI_KAS_BANK()	
	** TEMPLATE
	** ---------------------------------------------------------------------------
	TEXT TO M.LSQL NOSHOW
		SELECT ID AS cb_id FROM cb ORDER BY ID ASC
	ENDTEXT
	xx=SQLEXEC(KONEK,M.LSQL,"TEMPLATE")		
	IF xx <= 0 THEN
	   DO 'program\cek_error_sql.prg'	
	ENDIF	
	IF USED('TEMPLATE')
		SELECT TEMPLATE
		IF RECCOUNT() > 0
			SELECT TEMPLATE
			GO TOP 
			NREK = 0
			_RECOUNT = RECCOUNT()
			DO WHILE .NOT. EOF()						
				_CB_ID = TEMPLATE->cb_id
			
			   	** TAMBAH DATA
				** ---------------------------------------------------------------------------------------------------------------------------		
				TEXT TO M.LSQL NOSHOW
					SELECT cb_id, cbs_date
					FROM cb_saldo 
					WHERE company_id = ?xcompanyid 
					AND cb_id = ?_CB_ID
					AND cbs_date = ?MTGL
				ENDTEXT
				xx=SQLEXEC(KONEK,M.LSQL,"CEK")
				IF xx <= 0 THEN
				   DO 'program\cek_error_sql.prg'	
				ENDIF	
				IF USED('CEK')
					SELECT CEK
					IF RECCOUNT() <= 0
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
												  cbs_in,
												  cbs_out,
												  cbs_saldo,
												  status,
												  CREATED,
												  CREATEDBY)
							VALUES(?_ID,
								   ?xcompanyid,
								   ?_CB_ID,
   								   ?MTGL,
								   0,
								   0,
								   0,	
								   3,
								   ?DATETIME(),
								   ?XIDUSER)
						ENDTEXT
						xx=SQLEXEC(KONEK,M.LSQL)	
						DO 'program\cek_error_sql_crud.prg'
					ENDIF		
				ENDIF				   
				SELECT TEMPLATE
				SKIP
			ENDDO	
		ENDIF
		USE IN TEMPLATE
	ENDIF

	** TRANSAKASI KAS & BANK
	** ---------------------------------------------------------------------------		
	TEXT TO M.LSQL NOSHOW
		SELECT cb_header.tr_date,
			   cb_header.cb_id,
			   cb.cb_name,			   
			   SUM(IF(cb_pos.cb_pos_in_out = 'I', cb_detail.amount,0)) AS masuk,
			   SUM(IF(cb_pos.cb_pos_in_out = 'O', cb_detail.amount,0)) AS keluar
		FROM cb_detail
		JOIN cb_header ON cb_detail.header_id = cb_header.id
		JOIN cb ON cb_header.cb_id = cb.id
		JOIN cb_pos ON cb_header.cb_pos_id = cb_pos.id
		WHERE cb_header.company_id = ?xcompanyid 
		AND cb_header.tr_date = ?MTGL
		AND cb_detail.status = 3
		GROUP BY cb_header.tr_date, cb_header.cb_id
	ENDTEXT 
	xx=SQLEXEC(KONEK,M.LSQL,'TMP')
	IF xx <= 0 THEN
	   DO 'program\cek_error_sql.prg'	
	ENDIF	
	IF USED('TMP')
		SELECT TMP
		IF RECCOUNT() > 0		
			SELECT TMP
			DO 'program\update_field.prg'
			GO TOP 
			NREK = 0
			_RECOUNT = RECCOUNT()
			DO WHILE .NOT. EOF()					
				_CB_ID   = TMP->cb_id
				_CB_NAME = ALLTRIM(TMP->cb_name)
				_masuk = TMP->masuk
				_keluar = TMP->keluar
				
				nrek = nrek + 1
				wait window nowait 'transaksi kas & bank : ' + _CB_NAME + ' | tanggal : ' + cTGL + ' | reccord :' +	alltrim(str(nrek)) + ' / ' + alltrim(str(_recount))
				
				IF _masuk = 0 AND _keluar = 0
					SKIP 
					LOOP 
				ENDIF 									   
							
				TEXT TO M.LSQL NOSHOW
					UPDATE cb_saldo SET cbs_in = ?_masuk, cbs_out = ?_keluar WHERE company_id = ?xcompanyid AND cb_id = ?_CB_ID AND cbs_date = ?MTGL
				ENDTEXT
				xx=SQLEXEC(KONEK,M.LSQL)
				DO 'program\cek_error_sql_crud.prg'
			
				SELECT TMP
				SKIP 
			ENDDO 
		ENDIF 
		USE IN TMP
	ENDIF

	
	** SALDO AKHIR 
	** ------------------------------------------------------------------------------------------------------------------------------------------ 	
	TEXT TO M.LSQL NOSHOW
		SELECT ID AS CB_ID,
			   cb_name
 			   FROM cb
			   ORDER BY ID ASC
	ENDTEXT
	xx=SQLEXEC(KONEK,M.LSQL,"TMPSALDO")		
	IF xx <= 0 THEN
	   DO 'program\cek_error_sql.prg'	
	ENDIF	
	IF USED('TMPSALDO')
		IF RECCOUNT('TMPSALDO') > 0
			SELECT TMPSALDO
			GO TOP 
			NREK = 0
			_RECOUNT = RECCOUNT()
			DO WHILE .NOT. EOF()						
				_CB_ID   = TMPSALDO->CB_ID
				_CB_NAME = ALLTRIM(TMPSALDO->cb_name)
				
				nrek = nrek + 1
				wait window nowait 'saldo akhir kas & bank : ' + _CB_NAME + ' | tanggal : ' + cTGL + ' | reccord :' +	alltrim(str(nrek)) + ' / ' + alltrim(str(_recount))
				
								   
				** UPDATE JLH SALDO AKHIR
				** ---------------------------------------------------------------------------------------------------------------------------		
				TEXT TO M.LSQL NOSHOW
					SELECT cbs_saldo FROM cb_saldo
					WHERE company_id = ?xcompanyid 
					AND cb_id = ?_CB_ID
					AND cbs_date = (
									  SELECT MAX(cbs_date) FROM cb_saldo 
									  WHERE company_id = ?xcompanyid 
									  AND cbs_date < ?MTGL 
									  AND cb_id = ?_CB_ID
									)
				ENDTEXT 
				xx=SQLEXEC(KONEK,M.LSQL,'LASTSALDO')
				IF xx <= 0 THEN
				   DO 'program\cek_error_sql.prg'	
				ENDIF						
				IF USED('LASTSALDO')
					IF .NOT. ISNULL(LASTSALDO->cbs_saldo)						
						_SALDO = LASTSALDO->cbs_saldo					
					ENDIF
					USE IN LASTSALDO
					TEXT TO M.LSQL NOSHOW
						UPDATE cb_saldo SET cbs_saldo = (?_SALDO + cbs_in) - cbs_out
						WHERE company_id = ?xcompanyid 
						AND cb_id = ?_CB_ID
						AND cbs_date = ?MTGL
					ENDTEXT 
					xx=SQLEXEC(KONEK,M.LSQL)
					DO 'program\cek_error_sql_crud.prg'	
				ENDIF									
				
				SELECT TMPSALDO
				SKIP 
			ENDDO 
		ENDIF 
	ENDIF