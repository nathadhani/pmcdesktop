IF TYPE('konek') = 'N'
	IF konek = 1
		xx = SQLEXEC(konek,'SELECT MIN(tr_date) AS tr_date FROM m_transaction WHERE id IN(1,2) AND status = 1','TglClosing')
		IF xx <= 0 THEN
		   DO 'program\cek_error_sql.prg'	
		ELSE 
			IF USED('TglClosing')
				SELECT TglClosing
				IF RECCOUNT() > 0
					GO TOP
					SET DATE DMY 
					Cek_tgl = TglClosing->tr_date
					IF Cek_tgl < (DATE() - 1)
						lClosing = .F.
						MESSAGEBOX('System Belum Closing.!',16,'Peringatan',5000)
					ELSE
						lClosing = .T.				
					ENDIF 
				ELSE
					lClosing = .T.
				ENDIF	
				USE IN TglClosing
			ENDIF
		ENDIF 
	ENDIF
ENDIF 		
