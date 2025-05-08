iTahun = INPUTBOX("Input Tahun","Data Transaksi - Frekuensi",ALLTRIM(STR(YEAR(DATE()))),5000)
IF LEN(iTAHUN) = 4
	mTahun = VAL(iTahun)
	IF TYPE('konek') = 'N'
		IF konek = 1
			WAIT WINDOW NOWAIT 'Tunggu sedang menyiapkan data ......'
			TEXT TO M.LSQL NOSHOW PRETEXT 7
				SELECT
					x.valas_id,
					m_valas.valas_code,
					(
						SELECT COUNT( th.customer_id + td.valas_id) FROM tr_detail AS td
						JOIN tr_header AS th ON th.tr_id = td.tr_id AND th.tr_number = td.tr_number
						WHERE YEAR(td.tr_date) = ?mTahun
						AND MONTH(td.tr_date) = 1
						AND td.valas_id = x.valas_id
						AND td.status = 3
					) AS bln01,
					(
						SELECT COUNT( th.customer_id + td.valas_id) FROM tr_detail AS td
						JOIN tr_header AS th ON th.tr_id = td.tr_id AND th.tr_number = td.tr_number
						WHERE YEAR(td.tr_date) = ?mTahun
						AND MONTH(td.tr_date) = 2
						AND td.valas_id = x.valas_id
						AND td.status = 3
					) AS bln02,					
					(
						SELECT COUNT( th.customer_id + td.valas_id) FROM tr_detail AS td
						JOIN tr_header AS th ON th.tr_id = td.tr_id AND th.tr_number = td.tr_number
						WHERE YEAR(td.tr_date) = ?mTahun
						AND MONTH(td.tr_date) = 3
						AND td.valas_id = x.valas_id
						AND td.status = 3
					) AS bln03,
					(
						SELECT COUNT( th.customer_id + td.valas_id) FROM tr_detail AS td
						JOIN tr_header AS th ON th.tr_id = td.tr_id AND th.tr_number = td.tr_number
						WHERE YEAR(td.tr_date) = ?mTahun
						AND MONTH(td.tr_date) = 4
						AND td.valas_id = x.valas_id
						AND td.status = 3
					) AS bln04,
					(
						SELECT COUNT( th.customer_id + td.valas_id) FROM tr_detail AS td
						JOIN tr_header AS th ON th.tr_id = td.tr_id AND th.tr_number = td.tr_number
						WHERE YEAR(td.tr_date) = ?mTahun
						AND MONTH(td.tr_date) = 5
						AND td.valas_id = x.valas_id
						AND td.status = 3
					) AS bln05,
					(
						SELECT COUNT( th.customer_id + td.valas_id) FROM tr_detail AS td
						JOIN tr_header AS th ON th.tr_id = td.tr_id AND th.tr_number = td.tr_number
						WHERE YEAR(td.tr_date) = ?mTahun
						AND MONTH(td.tr_date) = 6
						AND td.valas_id = x.valas_id
						AND td.status = 3
					) AS bln06,
					(
						SELECT COUNT( th.customer_id + td.valas_id) FROM tr_detail AS td
						JOIN tr_header AS th ON th.tr_id = td.tr_id AND th.tr_number = td.tr_number
						WHERE YEAR(td.tr_date) = ?mTahun
						AND MONTH(td.tr_date) = 7
						AND td.valas_id = x.valas_id
						AND td.status = 3
					) AS bln07,
					(
						SELECT COUNT( th.customer_id + td.valas_id) FROM tr_detail AS td
						JOIN tr_header AS th ON th.tr_id = td.tr_id AND th.tr_number = td.tr_number
						WHERE YEAR(td.tr_date) = ?mTahun
						AND MONTH(td.tr_date) = 8
						AND td.valas_id = x.valas_id
						AND td.status = 3
					) AS bln08,
					(
						SELECT COUNT( th.customer_id + td.valas_id) FROM tr_detail AS td
						JOIN tr_header AS th ON th.tr_id = td.tr_id AND th.tr_number = td.tr_number
						WHERE YEAR(td.tr_date) = ?mTahun
						AND MONTH(td.tr_date) = 9
						AND td.valas_id = x.valas_id
						AND td.status = 3
					) AS bln09,
					(
						SELECT COUNT( th.customer_id + td.valas_id) FROM tr_detail AS td
						JOIN tr_header AS th ON th.tr_id = td.tr_id AND th.tr_number = td.tr_number
						WHERE YEAR(td.tr_date) = ?mTahun
						AND MONTH(td.tr_date) = 10
						AND td.valas_id = x.valas_id
						AND td.status = 3
					) AS bln10,
					(
						SELECT COUNT( th.customer_id + td.valas_id) FROM tr_detail AS td
						JOIN tr_header AS th ON th.tr_id = td.tr_id AND th.tr_number = td.tr_number
						WHERE YEAR(td.tr_date) = ?mTahun
						AND MONTH(td.tr_date) = 11
						AND td.valas_id = x.valas_id
						AND td.status = 3
					) AS bln11,
					(
						SELECT COUNT( th.customer_id + td.valas_id) FROM tr_detail AS td
						JOIN tr_header AS th ON th.tr_id = td.tr_id AND th.tr_number = td.tr_number
						WHERE YEAR(td.tr_date) = ?mTahun
						AND MONTH(td.tr_date) = 12
						AND td.valas_id = x.valas_id
						AND td.status = 3
					) AS bln12					
				FROM tr_detail AS x
				JOIN m_valas ON m_valas.id = x.valas_id
				WHERE YEAR(x.tr_date) = ?mTahun	AND x.status = 3
				AND x.company_id = ?xCOMPANYID
				GROUP BY x.valas_id, m_valas.valas_code
			ENDTEXT
			WAIT WINDOW NOWAIT 'Tunggu sedang menyiapkan data ...'
			xx=SQLEXEC(KONEK,M.LSQL,'Tmp')
			IF xx <= 0 THEN
				DO 'program\cek_error_sql.prg'
			ENDIF
			IF USED('Tmp')
				SELECT Tmp
				IF RECCOUNT() > 0
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
						.Range('B3').value = 'Kode Valas'
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
					oExcel.WorkSheets(1).Range('A1').value = 'Data Frekuensi Transaksi Valas Tahun ' + 	ALLTRIM(STR(MTAHUN))	
					oExcel.WorkSheets(1).Range('A1:O1').merge	
					oExcel.WorkSheets(1).Range('A1:O1').Font.Bold = .T.
					oExcel.WorkSheets(1).Range('A1:O1').Font.Size = 12																													
					oExcel.Visible = .T.																	
				ENDIF 	
				ENDIF 
			ENDIF
		ENDIF 
	ENDIF 
ENDIF 