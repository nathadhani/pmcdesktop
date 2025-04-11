iTahun = INPUTBOX("Input Tahun","Data Transaksi - Beli & Jual ( Rekap )",ALLTRIM(STR(YEAR(DATE()))),5000)
IF LEN(iTAHUN) = 4
	mTahun = VAL(iTahun)
	IF TYPE('konek') = 'N'
		IF konek = 1
			IF TYPE('xUSERGROUP') == 'N'
				IF ALLTRIM(STR(xUSERGROUP)) $ '1,2'
					WAIT WINDOW NOWAIT 'Tunggu sedang menyiapkan data ......'
					TEXT TO m.lsql NOSHOW
						SELECT
						(SELECT valas_code FROM m_valas WHERE m_valas.id = tr_detail.valas_id) AS valas_code,
						(SELECT valas_name FROM m_valas WHERE m_valas.id = tr_detail.valas_id) AS valas_name,
						SUM(IF(tr_detail.tr_id = 1 AND tr_detail.status = 3, tr_detail.qty,0)) AS qty_buy,
						SUM(IF(tr_detail.tr_id = 1 AND tr_detail.status = 3, (tr_detail.qty*tr_detail.price),0)) AS value_buy,
						SUM(IF(tr_detail.tr_id = 2 AND tr_detail.status = 3, tr_detail.qty,0)) AS qty_sale,
						SUM(IF(tr_detail.tr_id = 2 AND tr_detail.status = 3, (tr_detail.qty*tr_detail.price),0)) AS value_sale,
						YEAR(tr_detail.tr_date) AS trx_year,
						MONTH(tr_detail.tr_date) AS trx_month
						FROM tr_detail
						WHERE YEAR(tr_detail.tr_date) = ?mTahun
						AND tr_detail.status = 3
						AND tr_detail.company_id = ?xCOMPANYID
						GROUP BY tr_detail.valas_id,YEAR(tr_detail.tr_date),MONTH(tr_detail.tr_date)
						ORDER BY tr_detail.valas_id,YEAR(tr_detail.tr_date),MONTH(tr_detail.tr_date) ASC
					ENDTEXT
					xx=SQLEXEC(konek,m.lsql,'tmp')
					IF xx <=0 THEN
					   DO 'program\cek_error_sql.prg'	   
					ENDIF
					IF USED('tmp')
						SELECT tmp
						IF RECCOUNT() > 0
							DO 'program\update_field.prg'
							LOCAL oExcel,lcCursorName
							oExcel = Createobject("Excel.Application")
							IF .NOT. TYPE('oExcel') = 'O'
								MESSAGEBOX('cannot export data, object not found!',64,'message',5000)
							ENDIF
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
								oExcel.ActiveWorkBook()
								oExcel.ActiveWindow.DisplayZeros = .F.
								oExcelApp = oExcel.Application
								oExcelApp.WindowState = xlMaximized
									
								lcCursorName = 'tmp'	
								oExcel.WorkSheets("sheet1").Name = "temp"	
								DBF2Excel(m.lcCursorName, oExcel.WorkSheets("temp"),"A1" ) 
								WITH oExcel.WorkSheets(1)
									.Activate()		
									.Range("A1:H1").Interior.ColorIndex = 37
									.Range("A1:H1").Font.Bold = .T.
									.Range("A1:H1").HorizontalAlignment = 3
									.UsedRange.EntireColumn.VerticalAlignment = 2		
									.UsedRange.EntireColumn.Font.Size   = 10
									.Columns("C:F").NumberFormatLocal = '#,##0_);[Red](#,##0)'
									.Range('A1').value = 'Kode'
									.Range('B1').value = 'Nama'
									.Range('C1').value = 'Jumlah Beli'
									.Range('D1').value = 'Rupiah Beli'
									.Range('E1').value = 'Jumlah Jual'
									.Range('F1').value = 'Rupiah Jual'
									.Range('G1').value = 'Tahun'
									.Range('H1').value = 'Bulan'														
									.UsedRange.EntireColumn.Autofit	
								ENDWITH 
								oExcel.Visible = .T.
								USE IN tmp		
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
ENDIF