IF TYPE('KONEK') = 'N'
	IF KONEK = 1		
		LPROSES = .T.
		xx=SQLEXEC(KONEK,'SELECT MIN(cbas_date) AS cbas_date FROM cba_saldo WHERE company_id = ?xcompanyid','MINTGL')
		IF xx <= 0 THEN
		   DO 'program\cek_error_sql.prg'	
		ENDIF	
		IF USED('MINTGL')
			SELECT MINTGL
			IF RECCOUNT() > 0
				_MINTGL = MINTGL->cbas_date
				IF dTgl < _MINTGL
					LPROSES = .F.
				ENDIF
			ENDIF			
		ENDIF		
		IF LPROSES = .T.
			**-- Delete
			xx=SQLEXEC(KONEK,'DELETE FROM cba_saldo WHERE cbas_date=?MTGL AND company_id = ?xcompanyid')
			DO 'program\cek_error_sql_crud.prg'
			
			**-- Get Transaksi Kas & Bank
			DO GET_TRANSAKSI_KAS_BANK
			
			**-- Update
			xx=SQLEXEC(KONEK,'UPDATE cba_saldo SET UPDATED = ?DATETIME(), UPDATEDBY = ?XIDUSER WHERE cbas_date=?MTGL AND company_id = ?xcompanyid')
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
		SELECT ID AS cba_id FROM cba ORDER BY ID ASC
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
				_CBA_ID = TEMPLATE->cba_id
			
			   	** TAMBAH DATA
				** ---------------------------------------------------------------------------------------------------------------------------		
				TEXT TO M.LSQL NOSHOW
					SELECT cba_id, cbas_date
					FROM cba_saldo 
					WHERE company_id = ?xcompanyid 
					AND cba_id = ?_CBA_ID
					AND cbas_date = ?MTGL
				ENDTEXT
				xx=SQLEXEC(KONEK,M.LSQL,"CEK")
				IF xx <= 0 THEN
				   DO 'program\cek_error_sql.prg'	
				ENDIF	
				IF USED('CEK')
					SELECT CEK
					IF RECCOUNT() <= 0
						TEXT TO M.LSQL NOSHOW
							SELECT MAX(ID) AS MAXID FROM cba_saldo WHERE company_id = company_id = ?xcompanyid AND cbas_date = ?MTGL
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
							INSERT INTO cba_saldo(ID,
												  company_id,
												  cba_id,
  												  cbas_date,
												  cbas_in,
												  cbas_out,
												  cbas_saldo,
												  status,
												  CREATED,
												  CREATEDBY)
							VALUES(?_ID,
								   ?xcompanyid,
								   ?_CBA_ID,
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
		SELECT cba_td.cba_tr_date,
			   cba_td.cba_id,
			   (
			   	SELECT CONCAT(cba_code,' - ',cba_name) AS cba_name 
			   	FROM cba 
			   	WHERE cba.id = cba_td.cba_id
			   	GROUP BY cba.cba_code, cba.cba_name
			    ) AS cba_name,			   
			   SUM(cba_td.amount_in) AS amount_in,
			   SUM(cba_td.amount_out) AS amount_out
		FROM cba_td
		WHERE company_id = ?xcompanyid 
		AND cba_td.cba_tr_date = ?MTGL
		AND cba_td.status = 3
		GROUP BY cba_td.cba_tr_date, cba_td.cba_id
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
				_CBA_ID   = TMP->cba_id
				_CBA_NAME = ALLTRIM(TMP->cba_name)
				_amount_in = TMP->amount_in
				_amount_out = TMP->amount_out
				
				nrek = nrek + 1
				wait window nowait 'transaksi kas & bank : ' + _CBA_NAME + ' | tanggal : ' + cTGL + ' | reccord :' +	alltrim(str(nrek)) + ' / ' + alltrim(str(_recount))
				
				IF _amount_in = 0 AND _amount_out = 0
					SKIP 
					LOOP 
				ENDIF 									   
							
				TEXT TO M.LSQL NOSHOW
					UPDATE cba_saldo SET cbas_in = ?_amount_in, cbas_out = ?_amount_out WHERE company_id = ?xcompanyid AND cba_id = ?_CBA_ID AND cbas_date = ?MTGL
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
		SELECT ID AS CBA_ID,
			   CONCAT(cba_code,' - ',cba_name) AS cba_name
 			   FROM cba
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
				_CBA_ID   = TMPSALDO->CBA_ID
				_CBA_NAME = ALLTRIM(TMPSALDO->cba_name)
				
				nrek = nrek + 1
				wait window nowait 'saldo akhir kas & bank : ' + _CBA_NAME + ' | tanggal : ' + cTGL + ' | reccord :' +	alltrim(str(nrek)) + ' / ' + alltrim(str(_recount))
				
								   
				** UPDATE JLH SALDO AKHIR
				** ---------------------------------------------------------------------------------------------------------------------------		
				TEXT TO M.LSQL NOSHOW
					SELECT cbas_saldo FROM cba_saldo
					WHERE company_id = ?xcompanyid 
					AND cba_id = ?_CBA_ID
					AND cbas_date = (
									  SELECT MAX(cbas_date) FROM cba_saldo 
									  WHERE company_id = ?xcompanyid 
									  AND cbas_date < ?MTGL 
									  AND cba_id = ?_CBA_ID
									)
				ENDTEXT 
				xx=SQLEXEC(KONEK,M.LSQL,'LASTSALDO')
				IF xx <= 0 THEN
				   DO 'program\cek_error_sql.prg'	
				ENDIF						
				IF USED('LASTSALDO')
					IF .NOT. ISNULL(LASTSALDO->cbas_saldo)							
						_SALDO = LASTSALDO->cbas_saldo					
					ENDIF
					USE IN LASTSALDO
					TEXT TO M.LSQL NOSHOW
						UPDATE cba_saldo SET cbas_saldo = (?_SALDO + cbas_in) - cbas_out
						WHERE company_id = ?xcompanyid 
						AND cba_id = ?_CBA_ID
						AND cbas_date = ?MTGL
					ENDTEXT 
					xx=SQLEXEC(KONEK,M.LSQL)
					DO 'program\cek_error_sql_crud.prg'	
				ENDIF									
				
				SELECT TMPSALDO
				SKIP 
			ENDDO 
		ENDIF 
	ENDIF