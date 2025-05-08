iTahun = INPUTBOX("Input Tahun","Data Transaksi - Pengguna Jasa",ALLTRIM(STR(YEAR(DATE()))),5000)
IF LEN(iTAHUN) = 4
	mTahun = VAL(iTahun)
	IF TYPE('konek') = 'N'
		IF konek = 1
			WAIT WINDOW NOWAIT 'Tunggu sedang menyiapkan data ......'
			TEXT TO M.LSQL NOSHOW PRETEXT 7
				SELECT 
					A.ID,
					CONCAT(A.work_name, " ( ", CASE
								WHEN A.category_id = 1 THEN "Biasa"
								WHEN A.category_id = 2 THEN "Sedang"
								WHEN A.category_id = 3 THEN "Pep"
								ELSE ""
							END, " )") AS work_name,
					(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
								   LEFT JOIN M_CUSTOMER AS C
								   ON B.CUSTOMER_ID = C.ID
								   LEFT JOIN M_CUSTOMER_WORK AS D
								   ON C.WORK_ID = D.ID
								   WHERE YEAR(B.TR_DATE) = ?mTahun
								   AND MONTH(B.TR_DATE) = 1
								   AND B.status = 3
								   AND D.id = A.id) AS BLN01,
					(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
								   LEFT JOIN M_CUSTOMER AS C
								   ON B.CUSTOMER_ID = C.ID
   								   LEFT JOIN M_CUSTOMER_WORK AS D
								   ON C.WORK_ID = D.ID
								   WHERE YEAR(B.TR_DATE) = ?mTahun 
								   AND MONTH(B.TR_DATE) = 2
								   AND B.status = 3
								   AND D.id = A.id) AS BLN02,
					(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
								   LEFT JOIN M_CUSTOMER AS C
								   ON B.CUSTOMER_ID = C.ID
   								   LEFT JOIN M_CUSTOMER_WORK AS D
								   ON C.WORK_ID = D.ID								   
								   WHERE YEAR(B.TR_DATE) = ?mTahun 
								   AND MONTH(B.TR_DATE) = 3
								   AND B.status = 3
								   AND D.id = A.id) AS BLN03,
					(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
								   LEFT JOIN M_CUSTOMER AS C
								   ON B.CUSTOMER_ID = C.ID
   								   LEFT JOIN M_CUSTOMER_WORK AS D
								   ON C.WORK_ID = D.ID
								   WHERE YEAR(B.TR_DATE) = ?mTahun 
								   AND MONTH(B.TR_DATE) = 4
								   AND B.status = 3
								   AND D.id = A.id) AS BLN04,
					(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
								   LEFT JOIN M_CUSTOMER AS C
								   ON B.CUSTOMER_ID = C.ID
   								   LEFT JOIN M_CUSTOMER_WORK AS D
								   ON C.WORK_ID = D.ID				   
								   WHERE YEAR(B.TR_DATE) = ?mTahun 
								   AND MONTH(B.TR_DATE) = 5
								   AND B.status = 3
								   AND D.id = A.id) AS BLN05,
					(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
								   LEFT JOIN M_CUSTOMER AS C
								   ON B.CUSTOMER_ID = C.ID
   								   LEFT JOIN M_CUSTOMER_WORK AS D
								   ON C.WORK_ID = D.ID				   
								   WHERE YEAR(B.TR_DATE) = ?mTahun 
								   AND MONTH(B.TR_DATE) = 6
								   AND B.status = 3
								   AND D.id = A.id) AS BLN06,
					(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
								   LEFT JOIN M_CUSTOMER AS C
								   ON B.CUSTOMER_ID = C.ID
   								   LEFT JOIN M_CUSTOMER_WORK AS D
								   ON C.WORK_ID = D.ID
								   WHERE YEAR(B.TR_DATE) = ?mTahun 
								   AND MONTH(B.TR_DATE) = 7
								   AND B.status = 3
								   AND D.id = A.id) AS BLN07,
					(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
								   LEFT JOIN M_CUSTOMER AS C
								   ON B.CUSTOMER_ID = C.ID
   								   LEFT JOIN M_CUSTOMER_WORK AS D
								   ON C.WORK_ID = D.ID				   
								   WHERE YEAR(B.TR_DATE) = ?mTahun 
								   AND MONTH(B.TR_DATE) = 8
								   AND B.status = 3
								   AND D.id = A.id) AS BLN08,
					(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
								   LEFT JOIN M_CUSTOMER AS C
								   ON B.CUSTOMER_ID = C.ID
   								   LEFT JOIN M_CUSTOMER_WORK AS D
								   ON C.WORK_ID = D.ID				   
								   WHERE YEAR(B.TR_DATE) = ?mTahun 
								   AND MONTH(B.TR_DATE) = 9
								   AND B.status = 3
								   AND D.id = A.id) AS BLN09,
					(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
								   LEFT JOIN M_CUSTOMER AS C
								   ON B.CUSTOMER_ID = C.ID
   								   LEFT JOIN M_CUSTOMER_WORK AS D
								   ON C.WORK_ID = D.ID
								   WHERE YEAR(B.TR_DATE) = ?mTahun 
								   AND MONTH(B.TR_DATE) = 10
								   AND B.status = 3
								   AND D.id = A.id) AS BLN10,
					(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
								   LEFT JOIN M_CUSTOMER AS C
								   ON B.CUSTOMER_ID = C.ID
   								   LEFT JOIN M_CUSTOMER_WORK AS D
								   ON C.WORK_ID = D.ID				   
								   WHERE YEAR(B.TR_DATE) = ?mTahun 
								   AND MONTH(B.TR_DATE) = 11
								   AND B.status = 3
								   AND D.id = A.id) AS BLN11,
					(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
								   LEFT JOIN M_CUSTOMER AS C
								   ON B.CUSTOMER_ID = C.ID
   								   LEFT JOIN M_CUSTOMER_WORK AS D
								   ON C.WORK_ID = D.ID				   
								   WHERE YEAR(B.TR_DATE) = ?mTahun 
								   AND MONTH(B.TR_DATE) = 12
								   AND B.status = 3
								   AND D.id = A.id) AS BLN12		    			   								   
				FROM m_customer_work AS A
				ORDER BY A.id ASC
			ENDTEXT
			xx=SQLEXEC(KONEK,M.LSQL,'Tmp')
			IF xx <= 0 THEN 
				DO 'program\cek_error_sql.prg'	
			ENDIF 	
			IF USED('Tmp')
				SELECT Tmp
				IF RECCOUNT() > 0
				REPLACE ALL work_name WITH PROPER(ALLTRIM(work_name))
				DO 'program\update_field.prg'
				LOCAL oExcel,lcCursorName
				oExcel = Createobject("Excel.Application")	
				IF TYPE('oExcel')='O'
					#define xlMaximized -4137
					DO 'program\fungsi.prg'
					oExcel.DisplayAlerts = .F.
					oExcel.Workbooks.Add()
					oExcel.Visible = .F.					
					IF oExcel.ActiveWorkBook.sheets.Count > 1
						oExcel.WorkSheets("sheet2").Delete
						oExcel.WorkSheets("sheet3").Delete
					ENDIF		
*!*						IF oExcel.ActiveWorkBook.sheets.Count < 2
*!*						   oExcel.ActiveWorkBook.sheets.Add(,oExcel.ActiveWorkBook.sheets(oExcel.ActiveWorkBook.sheets.Count))    
*!*						ENDIF					
					oExcel.ActiveWorkBook()
					oExcelApp = oExcel.Application
					oExcelApp.WindowState = xlMaximized
					
					oExcel.WorkSheets(1).Activate()
					oExcel.ActiveWindow.DisplayZeros = .F.
					oExcel.ActiveWindow.DisplayGridlines = .F.
					oExcel.WorkSheets("sheet1").Name = ALLTRIM(STR(MTAHUN))	
					
					SELECT Tmp
					GO TOP
					DO PROGRAM\update_field.prg
					GO TOP
					LNROW = 2
					LNCOL = 0
					NREK = 0
					DO WHILE NOT EOF()
						JTBLN = 0
						FOR TBLN = 1 TO 12
							WBLN = RIGHT('00'+ALLTRIM(STR(TBLN)),2)
							IF VAL(Tmp->BLN&WBLN) > 0
								JTBLN = JTBLN + 1
							ENDIF	
						NEXT
						IF JTBLN = 0
							SKIP 
							LOOP
						ENDIF
						
						lnRow = lnRow + 1       
						IF LNROW  = 3     
							LNROW = 3
							LNCOL = 1
							LNCOL = LNCOL + 1
							lnRow = 4
							lnBeginRange = lnRow
						ENDIF
						NREK = NREK + 1
						WAIT WINDOW NOWAIT 'Reccord : ' + ALLTRIM(STR(NREK)) + " / " + ALLTRIM(STR(RECCOUNT()))
						FOR i = 1 TO 15
							mFIELD = FIELD(i)
							DO CASE 
							CASE i = 1
								oExcel.WorkSheets(1).Cells(lnRow,i).Value = NREK						 
							CASE i = 15
								oExcel.WorkSheets(1).Cells(lnRow,i).Value = '=SUM(C' + ALLTRIM(STR(lnRow)) + ':N' + ALLTRIM(STR(lnRow)) + ')'
							OTHERWISE
								oExcel.WorkSheets(1).Cells(lnRow,i).Value = &mFIELD
							ENDCASE
							oExcel.WorkSheets(1).Cells(lnRow,i).Borders.Linestyle = 1
						ENDFOR 		    
						SKIP
					ENDDO 
					USE IN tmp
					WITH oExcel.WorkSheets(1)
						.Range('A3').value = 'No'						
						.Range('B3').value = 'Pekerjaan'
						.Range('C3').value = 'Jan'
						.Range('D3').value = 'Feb'
						.Range('E3').value = 'Mar'
						.Range('F3').value = 'Apr'
						.Range('G3').value = 'Mei'
						.Range('H3').value = 'Jun'
						.Range('I3').value = 'Jul'
						.Range('J3').value = 'Ags'
						.Range('K3').value = 'Sep'
						.Range('L3').value = 'Okt'
						.Range('M3').value = 'Nop'
						.Range('N3').value = 'Des'
						.Range('O3').value = 'Total'
						.Range("A3:O3").Interior.ColorIndex = 27 
						.Range("A3:O3").Borders.Linestyle = 1
						.Range("A3:O3").Font.Bold = .T.
						.UsedRange.EntireColumn.Autofit													
						.UsedRange.EntireColumn.VerticalAlignment = 2		
						.UsedRange.EntireColumn.Font.Size   = 10
					ENDWITH 			
					
					** Penggunaa Jasa (Biasa, Sedang, Pep)
					*-------------------------------------------------------------------------------------------					
					TEXT TO M.LSQL NOSHOW PRETEXT 7
						SELECT 
							A.category_id,
							(CASE
								WHEN A.category_id = 1 THEN "Biasa"
								WHEN A.category_id = 2 THEN "Sedang"
								WHEN A.category_id = 3 THEN "Pep"
								ELSE ""
							END) AS category_name,							
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 1
										   AND B.status = 3
										   AND D.category_id = A.category_id) AS BLN01,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID										   
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 2
										   AND B.status = 3
										   AND D.category_id = A.category_id) AS BLN02,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID										   
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 3
										   AND B.status = 3
										   AND D.category_id = A.category_id) AS BLN03,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID										  
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 4
										   AND B.status = 3
										   AND D.category_id = A.category_id) AS BLN04,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID										   
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 5
										   AND B.status = 3
										   AND D.category_id = A.category_id) AS BLN05,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID										   
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 6
										   AND B.status = 3
										   AND D.category_id = A.category_id) AS BLN06,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID										   
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 7
										   AND B.status = 3
										   AND D.category_id = A.category_id) AS BLN07,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID										   
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 8
										   AND B.status = 3
										   AND D.category_id = A.category_id) AS BLN08,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID										   
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 9
										   AND B.status = 3
										   AND D.category_id = A.category_id) AS BLN09,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID										   
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 10
										   AND B.status = 3
										   AND D.category_id = A.category_id) AS BLN10,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID										   
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 11
										   AND B.status = 3
										   AND D.category_id = A.category_id) AS BLN11,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID										   
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 12
										   AND B.status = 3
										   AND D.category_id = A.category_id) AS BLN12										   										   										   										   										   										   										   										   										   										   										   			    			   								   
						FROM m_customer_work AS A
						GROUP BY A.category_id
						ORDER BY A.category_id ASC
					ENDTEXT
					xx=SQLEXEC(KONEK,M.LSQL,'Tmp')	
					IF xx <= 0 THEN 
						DO 'program\cek_error_sql.prg'	
					ENDIF 	
					IF USED('Tmp')
						SELECT Tmp
						IF RECCOUNT() > 0
							SELECT Tmp
							REPLACE ALL category_name WITH PROPER(ALLTRIM(category_name))
							DO PROGRAM\update_field.prg
							GO TOP
							lnRow = LNROW + 2
							jdlRow = ALLTRIM(STR(LNROW))
							lnCol = 17
							NREK = 0
							DO WHILE NOT EOF()
								JTBLN = 0
								FOR TBLN = 1 TO 12
									WBLN = RIGHT('00'+ALLTRIM(STR(TBLN)),2)
									JTBLN = JTBLN + VAL(Tmp->BLN&WBLN)
								NEXT
								IF JTBLN = 0
									SKIP 
									LOOP
								ENDIF
								WAIT WINDOW NOWAIT 'Reccord : ' + ALLTRIM(STR(NREK)) + " / " + ALLTRIM(STR(RECCOUNT()))
								lnRow = lnRow + 1
								NREK = NREK + 1
								FOR i = 1 TO 15
									mFIELD = FIELD(i)
									DO CASE
									CASE i = 1
										oExcel.WorkSheets(1).Cells(lnRow,i).Value = NREK
									CASE i = 15
										oExcel.WorkSheets(1).Cells(lnRow,i).Value = '=SUM(C' + ALLTRIM(STR(lnRow)) + ':N' + ALLTRIM(STR(lnRow)) + ')'										
									OTHERWISE
										oExcel.WorkSheets(1).Cells(lnRow,i).Value = &mFIELD
									ENDCASE	
									oExcel.WorkSheets(1).Cells(lnRow,i).Borders.Linestyle = 1
								NEXT	    
								SKIP
							ENDDO 
							USE IN tmp							
							WITH oExcel.WorkSheets(1)
								.Range('A&jdlRow').value = 'No'						
								.Range('B&jdlRow').value = 'Kategori Resiko'
								.Range('C&jdlRow').value = 'Jan'
								.Range('D&jdlRow').value = 'Feb'
								.Range('E&jdlRow').value = 'Mar'
								.Range('F&jdlRow').value = 'Apr'
								.Range('G&jdlRow').value = 'Mei'
								.Range('H&jdlRow').value = 'Jun'
								.Range('I&jdlRow').value = 'Jul'
								.Range('J&jdlRow').value = 'Ags'
								.Range('K&jdlRow').value = 'Sep'
								.Range('L&jdlRow').value = 'Okt'
								.Range('M&jdlRow').value = 'Nop'
								.Range('N&jdlRow').value = 'Des'
								.Range('O&jdlRow').value = 'Total'
								.Range('A&jdlRow:O&jdlRow').Interior.ColorIndex = 27 
								.Range('A&jdlRow:O&jdlRow').Borders.Linestyle = 1
								.Range('A&jdlRow:O&jdlRow').Font.Bold = .T.
								.UsedRange.EntireColumn.Autofit													
								.UsedRange.EntireColumn.VerticalAlignment = 2		
								.UsedRange.EntireColumn.Font.Size   = 10
							ENDWITH 	
						ENDIF	
					ENDIF					
					
					** Penggunaa Jasa m_customer_category ( Pep Domestik & Asing )
					*-------------------------------------------------------------------------------------------
					TEXT TO M.LSQL NOSHOW PRETEXT 7
						SELECT
							1 AS ID,
							'Pep Domestik' AS pep_domestik,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 1
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name LIKE '%INDONESIA%') AS BLN01,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 2
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name LIKE '%INDONESIA%') AS BLN02,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 3
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name LIKE '%INDONESIA%') AS BLN03,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 4
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name LIKE '%INDONESIA%') AS BLN04,		
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 5
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name LIKE '%INDONESIA%') AS BLN05,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 6
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name LIKE '%INDONESIA%') AS BLN06,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 7
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name LIKE '%INDONESIA%') AS BLN07,		
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 8
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name LIKE '%INDONESIA%') AS BLN08,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 9
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name LIKE '%INDONESIA%') AS BLN09,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 10
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name LIKE '%INDONESIA%') AS BLN10,	
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 11
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name LIKE '%INDONESIA%') AS BLN11,		
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 12
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name LIKE '%INDONESIA%') AS BLN12
						FROM m_customer_work AS A							   								   									   										   										   								   										   										   								   										   										   						
						WHERE A.category_id = 3
						GROUP BY A.category_id
						
						UNION  
						
						SELECT
							2 AS ID,
							'Pep Asing' AS pep_asing,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 1
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name NOT LIKE '%INDONESIA%') AS BLN01,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 2
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name NOT LIKE '%INDONESIA%') AS BLN02,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 3
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name NOT LIKE '%INDONESIA%') AS BLN03,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 4
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name NOT LIKE '%INDONESIA%') AS BLN04,		
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 5
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name NOT LIKE '%INDONESIA%') AS BLN05,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 6
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name NOT LIKE '%INDONESIA%') AS BLN06,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 7
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name NOT LIKE '%INDONESIA%') AS BLN07,		
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 8
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name NOT LIKE '%INDONESIA%') AS BLN08,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 9
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name NOT LIKE '%INDONESIA%') AS BLN09,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 10
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name NOT LIKE '%INDONESIA%') AS BLN10,	
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 11
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name NOT LIKE '%INDONESIA%') AS BLN11,		
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN M_CUSTOMER_WORK AS D
										   ON C.WORK_ID = D.ID
										   LEFT JOIN m_customer_nationality AS E
										   ON E.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 12
										   AND B.status = 3
										   AND D.CATEGORY_ID = A.CATEGORY_ID
										   AND E.nationality_name NOT LIKE '%INDONESIA%') AS BLN12
						FROM m_customer_work AS A					   								   									   										   										   								   										   										   								   										   										   						
						WHERE A.category_id = 3
						GROUP BY A.category_id
					ENDTEXT
					xx=SQLEXEC(KONEK,M.LSQL,'Tmp')
					IF xx <= 0 THEN 
						DO 'program\cek_error_sql.prg'	
					ENDIF 	
					IF USED('Tmp')
						SELECT Tmp
						IF RECCOUNT() > 0
							SELECT Tmp
							DO PROGRAM\update_field.prg
							GO TOP
							lnRow = LNROW + 2
							jdlRow = ALLTRIM(STR(LNROW))
							lnCol = 17
							NREK = 0
							DO WHILE NOT EOF()
								JTBLN = 0
								FOR TBLN = 1 TO 12
									WBLN = RIGHT('00'+ALLTRIM(STR(TBLN)),2)
									JTBLN = JTBLN + VAL(Tmp->BLN&WBLN)
								NEXT
*!*									IF JTBLN = 0
*!*										SKIP
*!*										LOOP
*!*									ENDIF
								WAIT WINDOW NOWAIT 'Reccord : ' + ALLTRIM(STR(NREK)) + " / " + ALLTRIM(STR(RECCOUNT()))
								lnRow = lnRow + 1
								NREK = NREK + 1
								FOR i = 1 TO 15
									mFIELD = FIELD(i)
									DO CASE
									CASE i = 1
										oExcel.WorkSheets(1).Cells(lnRow,i).Value = NREK
									CASE i = 15
										oExcel.WorkSheets(1).Cells(lnRow,i).Value = '=SUM(C' + ALLTRIM(STR(lnRow)) + ':N' + ALLTRIM(STR(lnRow)) + ')'										
									OTHERWISE
										oExcel.WorkSheets(1).Cells(lnRow,i).Value = &mFIELD
									ENDCASE	
									oExcel.WorkSheets(1).Cells(lnRow,i).Borders.Linestyle = 1
								NEXT	    
								SKIP
							ENDDO 
							USE IN tmp							
							WITH oExcel.WorkSheets(1)
								.Range('A&jdlRow').value = 'No'						
								.Range('B&jdlRow').value = 'Kategori Pep'
								.Range('C&jdlRow').value = 'Jan'
								.Range('D&jdlRow').value = 'Feb'
								.Range('E&jdlRow').value = 'Mar'
								.Range('F&jdlRow').value = 'Apr'
								.Range('G&jdlRow').value = 'Mei'
								.Range('H&jdlRow').value = 'Jun'
								.Range('I&jdlRow').value = 'Jul'
								.Range('J&jdlRow').value = 'Ags'
								.Range('K&jdlRow').value = 'Sep'
								.Range('L&jdlRow').value = 'Okt'
								.Range('M&jdlRow').value = 'Nop'
								.Range('N&jdlRow').value = 'Des'
								.Range('O&jdlRow').value = 'Total'
								.Range('A&jdlRow:O&jdlRow').Interior.ColorIndex = 27 
								.Range('A&jdlRow:O&jdlRow').Borders.Linestyle = 1
								.Range('A&jdlRow:O&jdlRow').Font.Bold = .T.
								.UsedRange.EntireColumn.Autofit													
								.UsedRange.EntireColumn.VerticalAlignment = 2		
								.UsedRange.EntireColumn.Font.Size   = 10
							ENDWITH 	
						ENDIF	
					ENDIF															
					
					** Penggunaa Jasa m_country
					*-------------------------------------------------------------------------------------------
					TEXT TO M.LSQL NOSHOW PRETEXT 7
						SELECT 
							A.ID,
							A.nationality_name,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 1
										   AND B.status = 3
										   AND C.nationality_id = A.ID) AS BLN01,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   WHERE YEAR(B.TR_DATE) = ?mTahun 
										   AND MONTH(B.TR_DATE) = 2
										   AND B.status = 3
										   AND C.nationality_id = A.ID) AS BLN02,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   WHERE YEAR(B.TR_DATE) = ?mTahun 
										   AND MONTH(B.TR_DATE) = 3
										   AND B.status = 3
										   AND C.nationality_id = A.ID) AS BLN03,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   WHERE YEAR(B.TR_DATE) = ?mTahun 
										   AND MONTH(B.TR_DATE) = 4
										   AND B.status = 3
										   AND C.nationality_id = A.ID) AS BLN04,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   WHERE YEAR(B.TR_DATE) = ?mTahun 
										   AND MONTH(B.TR_DATE) = 5
										   AND B.status = 3
										   AND C.nationality_id = A.ID) AS BLN05,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   WHERE YEAR(B.TR_DATE) = ?mTahun 
										   AND MONTH(B.TR_DATE) = 6
										   AND B.status = 3
										   AND C.nationality_id = A.ID) AS BLN06,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   WHERE YEAR(B.TR_DATE) = ?mTahun 
										   AND MONTH(B.TR_DATE) = 7
										   AND B.status = 3
										   AND C.nationality_id = A.ID) AS BLN07,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   WHERE YEAR(B.TR_DATE) = ?mTahun 
										   AND MONTH(B.TR_DATE) = 8
										   AND B.status = 3
										   AND C.nationality_id = A.ID) AS BLN08,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   WHERE YEAR(B.TR_DATE) = ?mTahun 
										   AND MONTH(B.TR_DATE) = 9
										   AND B.status = 3
										   AND C.nationality_id = A.ID) AS BLN09,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   WHERE YEAR(B.TR_DATE) = ?mTahun 
										   AND MONTH(B.TR_DATE) = 10
										   AND B.status = 3
										   AND C.nationality_id = A.ID) AS BLN10,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   WHERE YEAR(B.TR_DATE) = ?mTahun 
										   AND MONTH(B.TR_DATE) = 11
										   AND B.status = 3
										   AND C.nationality_id = A.ID) AS BLN11,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   WHERE YEAR(B.TR_DATE) = ?mTahun 
										   AND MONTH(B.TR_DATE) = 12
										   AND B.status = 3
										   AND C.nationality_id = A.ID) AS BLN12							   
						FROM m_customer_nationality AS A
						ORDER BY A.nationality_name ASC
					ENDTEXT
					xx=SQLEXEC(KONEK,M.LSQL,'Tmp')
					IF xx <= 0 THEN 
						DO 'program\cek_error_sql.prg'	
					ENDIF 	
					IF USED('Tmp')
						SELECT Tmp
						IF RECCOUNT() > 0
							REPLACE ALL nationality_name WITH PROPER(ALLTRIM(nationality_name))
*!*								oExcel.WorkSheets(1).Activate()
*!*								oExcel.WorkSheets("sheet2").Name = ALLTRIM(STR(MTAHUN))+"_2"
*!*								oExcel.ActiveWindow.DisplayZeros = .F.	
							SELECT Tmp
							DO PROGRAM\update_field.prg
							GO TOP
							lnRow = LNROW + 2
							jdlRow = ALLTRIM(STR(LNROW))
							lnCol = 17
							NREK = 0
							DO WHILE NOT EOF()
								JTBLN = 0
								FOR TBLN = 1 TO 12
									WBLN = RIGHT('00'+ALLTRIM(STR(TBLN)),2)
									JTBLN = JTBLN + VAL(Tmp->BLN&WBLN)
								NEXT
								IF JTBLN = 0
									SKIP 
									LOOP
								ENDIF
								WAIT WINDOW NOWAIT 'Reccord : ' + ALLTRIM(STR(NREK)) + " / " + ALLTRIM(STR(RECCOUNT()))
								lnRow = lnRow + 1
								NREK = NREK + 1
								FOR i = 1 TO 15
									mFIELD = FIELD(i)
									DO CASE
									CASE i = 1
										oExcel.WorkSheets(1).Cells(lnRow,i).Value = NREK
									CASE i = 15
										oExcel.WorkSheets(1).Cells(lnRow,i).Value = '=SUM(C' + ALLTRIM(STR(lnRow)) + ':N' + ALLTRIM(STR(lnRow)) + ')'										
									OTHERWISE
										oExcel.WorkSheets(1).Cells(lnRow,i).Value = &mFIELD
									ENDCASE	
									oExcel.WorkSheets(1).Cells(lnRow,i).Borders.Linestyle = 1
								NEXT	    
								SKIP
							ENDDO 
							USE IN tmp							
							WITH oExcel.WorkSheets(1)
								.Range('A&jdlRow').value = 'No'						
								.Range('B&jdlRow').value = 'Warga Negara'
								.Range('C&jdlRow').value = 'Jan'
								.Range('D&jdlRow').value = 'Feb'
								.Range('E&jdlRow').value = 'Mar'
								.Range('F&jdlRow').value = 'Apr'
								.Range('G&jdlRow').value = 'Mei'
								.Range('H&jdlRow').value = 'Jun'
								.Range('I&jdlRow').value = 'Jul'
								.Range('J&jdlRow').value = 'Ags'
								.Range('K&jdlRow').value = 'Sep'
								.Range('L&jdlRow').value = 'Okt'
								.Range('M&jdlRow').value = 'Nop'
								.Range('N&jdlRow').value = 'Des'
								.Range('O&jdlRow').value = 'Total'
								.Range('A&jdlRow:O&jdlRow').Interior.ColorIndex = 27 
								.Range('A&jdlRow:O&jdlRow').Borders.Linestyle = 1
								.Range('A&jdlRow:O&jdlRow').Font.Bold = .T.
								.UsedRange.EntireColumn.Autofit													
								.UsedRange.EntireColumn.VerticalAlignment = 2		
								.UsedRange.EntireColumn.Font.Size   = 10
							ENDWITH 	
							oExcel.WorkSheets(1).Range('A1').value = 'Data Pengguna Jasa Tahun ' + 	ALLTRIM(STR(MTAHUN))	
							oExcel.WorkSheets(1).Range('A1:O1').merge	
							oExcel.WorkSheets(1).Range('A1:O1').Font.Bold = .T.
							oExcel.WorkSheets(1).Range('A1:O1').Font.Size = 12	
						ENDIF	
					ENDIF
					
					** Penggunaa Jasa m_country ( WNI & WNA )
					*-------------------------------------------------------------------------------------------
					TEXT TO M.LSQL NOSHOW PRETEXT 7
						SELECT
							A.nationality_ID AS ID,
							'WNI' AS wni ,							
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 1
										   AND B.status = 3
										   AND F.nationality_name LIKE '%INDONESIA%') AS BLN01,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 2
										   AND B.status = 3
										   AND F.nationality_name LIKE '%INDONESIA%') AS BLN02,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 3
										   AND B.status = 3
										   AND F.nationality_name LIKE '%INDONESIA%') AS BLN03,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 4
										   AND B.status = 3
										   AND F.nationality_name LIKE '%INDONESIA%') AS BLN04,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 5
										   AND B.status = 3
										   AND F.nationality_name LIKE '%INDONESIA%') AS BLN05,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 6
										   AND B.status = 3
										   AND F.nationality_name LIKE '%INDONESIA%') AS BLN06,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 7
										   AND B.status = 3
										   AND F.nationality_name LIKE '%INDONESIA%') AS BLN07,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 8
										   AND B.status = 3
										   AND F.nationality_name LIKE '%INDONESIA%') AS BLN08,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 9
										   AND B.status = 3
										   AND F.nationality_name LIKE '%INDONESIA%') AS BLN09,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 10
										   AND B.status = 3
										   AND F.nationality_name LIKE '%INDONESIA%') AS BLN10,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 11
										   AND B.status = 3
										   AND F.nationality_name LIKE '%INDONESIA%') AS BLN11,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 12
										   AND B.status = 3
										   AND F.nationality_name LIKE '%INDONESIA%') AS BLN12						   										   										   										   										   										   										   										   										   										   										   										   
						FROM M_CUSTOMER AS A						
						LEFT JOIN m_customer_nationality AS B ON B.ID = A.nationality_id
						WHERE B.nationality_name LIKE '%INDONESIA%'
						GROUP BY A.nationality_id
						
						UNION 
						
						SELECT
							A.nationality_ID AS ID,
							'WNA' AS wni ,							
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 1
										   AND B.status = 3
										   AND F.nationality_name NOT LIKE '%INDONESIA%') AS BLN01,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 2
										   AND B.status = 3
										   AND F.nationality_name NOT LIKE '%INDONESIA%') AS BLN02,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 3
										   AND B.status = 3
										   AND F.nationality_name NOT LIKE '%INDONESIA%') AS BLN03,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 4
										   AND B.status = 3
										   AND F.nationality_name NOT LIKE '%INDONESIA%') AS BLN04,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 5
										   AND B.status = 3
										   AND F.nationality_name NOT LIKE '%INDONESIA%') AS BLN05,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 6
										   AND B.status = 3
										   AND F.nationality_name NOT LIKE '%INDONESIA%') AS BLN06,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 7
										   AND B.status = 3
										   AND F.nationality_name NOT LIKE '%INDONESIA%') AS BLN07,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 8
										   AND B.status = 3
										   AND F.nationality_name NOT LIKE '%INDONESIA%') AS BLN08,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 9
										   AND B.status = 3
										   AND F.nationality_name NOT LIKE '%INDONESIA%') AS BLN09,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 10
										   AND B.status = 3
										   AND F.nationality_name NOT LIKE '%INDONESIA%') AS BLN10,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 11
										   AND B.status = 3
										   AND F.nationality_name NOT LIKE '%INDONESIA%') AS BLN11,
							(SELECT COUNT( DISTINCT CUSTOMER_ID) FROM TR_HEADER AS B
										   LEFT JOIN M_CUSTOMER AS C
										   ON B.CUSTOMER_ID = C.ID
										   LEFT JOIN m_customer_nationality AS F
										   ON F.id = C.nationality_id
										   WHERE YEAR(B.TR_DATE) = ?mTahun
										   AND MONTH(B.TR_DATE) = 12
										   AND B.status = 3
										   AND F.nationality_name NOT LIKE '%INDONESIA%') AS BLN12				   										   										   										   										   										   										   										   										   										   										   										   
						FROM M_CUSTOMER AS A
						LEFT JOIN m_customer_nationality AS B ON B.ID = A.nationality_id
						WHERE B.nationality_name LIKE '%INDONESIA%'
						GROUP BY A.nationality_id		  								   									   										   										   								   										   										   								   										   										   						
					ENDTEXT
					xx=SQLEXEC(KONEK,M.LSQL,'Tmp')
					IF xx <= 0 THEN 
						DO 'program\cek_error_sql.prg'	
					ENDIF 	
					IF USED('Tmp')
						SELECT Tmp
						IF RECCOUNT() > 0
							SELECT Tmp
							DO PROGRAM\update_field.prg
							GO TOP
							lnRow = LNROW + 2
							jdlRow = ALLTRIM(STR(LNROW))
							lnCol = 17
							NREK = 0
							DO WHILE NOT EOF()
								JTBLN = 0
								FOR TBLN = 1 TO 12
									WBLN = RIGHT('00'+ALLTRIM(STR(TBLN)),2)
									JTBLN = JTBLN + VAL(Tmp->BLN&WBLN)
								NEXT
*!*									IF JTBLN = 0
*!*										SKIP 
*!*										LOOP
*!*									ENDIF
								WAIT WINDOW NOWAIT 'Reccord : ' + ALLTRIM(STR(NREK)) + " / " + ALLTRIM(STR(RECCOUNT()))
								lnRow = lnRow + 1
								NREK = NREK + 1
								FOR i = 1 TO 15
									mFIELD = FIELD(i)
									DO CASE
									CASE i = 1
										oExcel.WorkSheets(1).Cells(lnRow,i).Value = NREK
									CASE i = 15
										oExcel.WorkSheets(1).Cells(lnRow,i).Value = '=SUM(C' + ALLTRIM(STR(lnRow)) + ':N' + ALLTRIM(STR(lnRow)) + ')'										
									OTHERWISE
										oExcel.WorkSheets(1).Cells(lnRow,i).Value = &mFIELD
									ENDCASE	
									oExcel.WorkSheets(1).Cells(lnRow,i).Borders.Linestyle = 1
								NEXT	    
								SKIP
							ENDDO 
							USE IN tmp							
							WITH oExcel.WorkSheets(1)
								.Range('A&jdlRow').value = 'No'						
								.Range('B&jdlRow').value = 'WNA & WNI'
								.Range('C&jdlRow').value = 'Jan'
								.Range('D&jdlRow').value = 'Feb'
								.Range('E&jdlRow').value = 'Mar'
								.Range('F&jdlRow').value = 'Apr'
								.Range('G&jdlRow').value = 'Mei'
								.Range('H&jdlRow').value = 'Jun'
								.Range('I&jdlRow').value = 'Jul'
								.Range('J&jdlRow').value = 'Ags'
								.Range('K&jdlRow').value = 'Sep'
								.Range('L&jdlRow').value = 'Okt'
								.Range('M&jdlRow').value = 'Nop'
								.Range('N&jdlRow').value = 'Des'
								.Range('O&jdlRow').value = 'Total'
								.Range('A&jdlRow:O&jdlRow').Interior.ColorIndex = 6 
								.Range('A&jdlRow:O&jdlRow').Borders.Linestyle = 1
								.Range('A&jdlRow:O&jdlRow').Font.Bold = .T.
								.UsedRange.EntireColumn.Autofit													
								.UsedRange.EntireColumn.VerticalAlignment = 2		
								.UsedRange.EntireColumn.Font.Size   = 10
							ENDWITH 								
						ENDIF	
					ENDIF				
					oExcel.Visible = .T.																		
				ENDIF 	
				ENDIF 
			ENDIF
		ENDIF 
	ENDIF 
ENDIF 