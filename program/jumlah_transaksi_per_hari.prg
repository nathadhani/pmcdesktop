mTahun = INPUTBOX('Input Tahun (4 digit) contoh : '+ALLTRIM(STR(YEAR(DATE()))),'Rekap Total Jual/Beli Per Tanggal Dalam Satu Tahun')
IF LEN(mTAHUN) = 4
	IF TYPE('konek') = 'N'
		IF konek = 1
			LOCAL oExcel,lcCursorName
			oExcel = Createobject("Excel.Application")	
			IF TYPE('oExcel')='O'
				DO 'program\fungsi.prg'
				With oExcel
				  .DisplayAlerts = .F.		  
				  .Workbooks.Add
				  .Visible = .F.   
				  With .ActiveWorkBook					  				
				    FOR ia = 1 To 12					   
					    mBulan = m.ia
						WAIT WINDOW NOWAIT 'tunggu sedang proses data bulan ' + fGetbulan(m.ia) + SPACE(1) + ALLTRIM(mTahun)
					    shtname = RIGHT('00'+ALLTRIM(STR(m.ia)),2)
						TEXT TO m.lsql NOSHOW
							SELECT a.tr_date AS tanggal, 
							(SELECT COUNT(DISTINCT tr_number) FROM tr_header WHERE tr_header.tr_date = a.tr_date AND tr_header.tr_id=1 AND tr_header.status=3) AS jlhbeli,
							(SELECT SUM(subtotal) FROM tr_detail WHERE tr_detail.tr_date = a.tr_date AND tr_detail.tr_id=1 AND tr_detail.status=3) AS valbeli,
							(SELECT COUNT(DISTINCT tr_number) FROM tr_header WHERE tr_header.tr_date = a.tr_date AND tr_header.tr_id=2 AND tr_header.status=3) AS jlhjual,
							(SELECT SUM(subtotal) FROM tr_detail WHERE tr_detail.tr_date = a.tr_date AND tr_detail.tr_id=2 AND tr_detail.status=3) AS valjual
									    FROM tr_header AS a
									    WHERE YEAR(a.tr_date)=?mTahun
									    AND MONTH(a.tr_date)=?mBulan
									    AND a.status = 3
									    GROUP BY a.tr_date
									    ORDER BY tanggal ASC 				 
						ENDTEXT 
						xx=SQLEXEC(konek,m.lsql,'crsToExcel')
						IF xx <= 0 THEN
						   DO 'program\cek_error_sql.prg'	
						ELSE
							IF USED('crsToExcel')
								CREATE CURSOR tmp(tanggal d(8),;
												  jlhbeli n(9,0),;
												  valbeli n(18,0),;
												  jlhjual n(9,0),;
												  valjual n(18,0))

								SELECT crsToExcel
								DO 'program\update_field.prg'      							
								GO TOP 											  
								DO WHILE .NOT. EOF()
									SELECT tmp
									APPEND BLANK  
									REPLACE tanggal WITH crsToExcel->tanggal,;
											jlhbeli WITH VAL(crsToExcel->jlhbeli),;
											valbeli WITH crsToExcel->valbeli,;
											jlhjual WITH VAL(crsToExcel->jlhjual),;
											valjual WITH crsToExcel->valjual
											
									SELECT crsToExcel
									SKIP 
								ENDDO 		
								USE IN 'crsToExcel'
										  								
								SELECT tmp
	   							COUNT TO lsum FOR .NOT. EMPTY(DTOS(tanggal))   	   											
	   							xRec  = ALLTRIM(STR(RECCOUNT()+4))
								xRec2 = ALLTRIM(STR(RECCOUNT()+5))
								xRec3 = ALLTRIM(STR(RECCOUNT()+6))
								sRec  = ALLTRIM(STR(RECCOUNT()+3))
															
							    lcCursorName = 'tmp'
							    IF .sheets.Count < m.ia
							       .sheets.Add(,.sheets(.sheets.Count))    
							    ENDIF

							    .WorkSheets(m.ia).Name = m.shtname
							    oExcel.WorkSheets(m.ia).Range('A1').value = "'"+UPPER(fGetbulan(m.ia)) + SPACE(1) + ALLTRIM(mTahun)	
								oExcel.WorkSheets(m.ia).Range('A1').Font.Bold = .T.
								oExcel.WorkSheets(m.ia).Range("A1").Font.Size = 14
								oExcel.WorkSheets(m.ia).Range('A1:E1').Merge 	
								oExcel.WorkSheets(m.ia).Range('A1:E1').HorizontalAlignment = 3	
								oExcel.WorkSheets(m.ia).Range('A1:E1').Interior.Color = RGB(0,204,255) 

							    DBF2Excel(m.lcCursorName, .WorkSheets(m.ia),"A3") 	 

								WITH .WorkSheets(m.ia)
									.Activate	
									.Range('A3').value = 'TANGGAL'
									.Range('A3:A2').merge
									.Range('B2').value = 'JUMLAH PEMBELIAN'
									.Range('B2:C2').merge
									.Range('D2').value = 'JUMLAH PENJUALAN'
									.Range('D2:E2').merge
									.Range('B3').value = 'NOTA'
									.Range('C3').value = 'RUPIAH'
									.Range('D3').value = 'NOTA'
									.Range('E3').value = 'RUPIAH'

									.Range("A2:E3").HorizontalAlignment = 3
									.Range("A2:E3").Font.Italic = .F.
									.Range("A2").Interior.Color = RGB(255,255,0)
									.Range("B2:C3").Interior.Color = RGB(255,255,0)
									.Range("D2:E3").Interior.Color = RGB(255,255,0)
									.Range("A2:E3").Font.Bold = .T.
									
									IF lsum > 0
										.Range('A&xRec').Value = 'Subtotal'
										.Range('A&xRec').Interior.Color = RGB(216,228,188)
										.Range('B&xRec').Formula = '=SUM(B4:B&sRec)'
										.Range('C&xRec').Formula = '=SUM(C4:C&sRec)'
										.Range('D&xRec').Formula = '=SUM(D4:D&sRec)'
										.Range('E&xRec').Formula = '=SUM(E4:E&sRec)'
										
										** Total Nota
										.Range('A&xRec2').Value = 'Total Nota'
										.Range('A&xRec2').Interior.Color = RGB(216,228,188)
										.Range('A&xRec2:B&xRec2').merge									
										.Range('C&xRec2').Formula = '=B&xRec + D&xRec'									
										.Range('A&xRec:C&xRec2').borderS.linestyle = 1
									ENDIF 

									lcLastCell = oExcel.ActiveCell.SpecialCells(11).Address()			
									.Range("A1" + ":" + lcLastCell).borderS.linestyle = 1
									.Range("A1" + ":" + lcLastCell).borderS.weight = 2
									.Range("A1" + ":" + lcLastCell).borderS.colorindex = 48		

									.Columns("A").NumberFormatLocal = 'DD-MM-YYYY'
									.Columns("B:E").NumberFormatLocal = '#,##0'
									.Columns("B").HorizontalAlignment = 3	
									.Columns("D").HorizontalAlignment = 3			
									
									.UsedRange.EntireColumn.VerticalAlignment = 2																
								ENDWITH									
								oExcel.WorkSheets(m.ia).Range("B4").Select
								oExcel.ActiveWindow.FreezePanes = .T.	
								oExcel.WorkSheets(m.ia).UsedRange.EntireColumn.Autofit
								oExcel.WorkSheets(m.ia).Columns("B:E").ColumnWidth = 14
							  	oExcel.ActiveWindow.DisplayZeros = .F.   
								oExcel.Activewindow.Displaygridlines = 0					    
								USE IN tmp
							ENDIF 	   
						ENDIF	
					ENDFOR
					WAIT WINDOW NOWAIT 'tunggu sedang proses total data ' + ALLTRIM(mTahun)
				  	TEXT TO m.lsql NOSHOW
			  			SELECT month(a.tr_date) AS bulan, 
						(SELECT COUNT(DISTINCT tr_number) FROM tr_header 
													 WHERE month(tr_header.tr_date) = month(a.tr_date) 
													 AND year(tr_header.tr_date) = year(a.tr_date)
													 AND tr_header.tr_id=1 
													 AND tr_header.status=3) AS jlhbeli,
						(SELECT SUM(subtotal) FROM tr_detail 
											  WHERE month(tr_detail.tr_date) = month(a.tr_date) 
											  AND year(tr_detail.tr_date) = year(a.tr_date)
											  AND tr_detail.tr_id=1 
											  AND tr_detail.status=3) AS valbeli,
						(SELECT COUNT(DISTINCT tr_number) FROM tr_header 
													 WHERE month(tr_header.tr_date) = month(a.tr_date) 
													 AND year(tr_header.tr_date) = year(a.tr_date)
													 AND tr_header.tr_id=2 
													 AND tr_header.status=3) AS jlhjual,
						(SELECT SUM(subtotal) FROM tr_detail 
											  WHERE month(tr_detail.tr_date) = month(a.tr_date)
											  AND year(tr_detail.tr_date) = year(a.tr_date) 
											  AND tr_detail.tr_id=2 
											  AND tr_detail.status=3) AS valjual
								    FROM tr_header AS a
								    WHERE YEAR(a.tr_date)=?mTahun
								    AND a.status = 3
								    GROUP BY month(a.tr_date),YEAR(a.tr_date)
								    ORDER BY bulan ASC 				 
					ENDTEXT
					xx=SQLEXEC(konek,m.lsql,'tmpYTD')					
					IF xx <= 0
					   DO 'program\cek_error_sql.prg'	
					ELSE 
						CREATE CURSOR ytd(nmbulan c(15),;
										  jlhbeli n(9,0),;
	  									  valbeli n(18,0),;
										  jlhjual n(9,0),;
										  valjual n(18,0),;
										  bulan n(2))

						IF USED('tmpYTD')
							SELECT tmpYTD
							DO 'program\update_field.prg'      							
							GO TOP 											  
							DO WHILE .NOT. EOF()
								SELECT ytd
								APPEND BLANK  
								REPLACE bulan   WITH tmpYTD->bulan,;
										jlhbeli WITH VAL(tmpYTD->jlhbeli),;
										valbeli WITH tmpYTD->valbeli,;
										jlhjual WITH VAL(tmpYTD->jlhjual),;
										valjual WITH tmpYTD->valjual
										
								SELECT tmpYTD
								SKIP 
							ENDDO 		
							USE IN 'tmpYTD'
						ENDIF 
						SELECT YTD
						REPLACE ALL nmbulan WITH fGetBulan(bulan)
						COUNT TO lsum FOR bulan > 0
						xRec  = ALLTRIM(STR(RECCOUNT()+4))
						xRec2 = ALLTRIM(STR(RECCOUNT()+5))
						xRec3 = ALLTRIM(STR(RECCOUNT()+6))
						sRec  = ALLTRIM(STR(RECCOUNT()+3))
				        .sheets.Add(,.sheets(.sheets.Count))    
					    .WorkSheets(13).Name = mTahun
					    .WorkSheets(13).Tab.ColorIndex = 3
						lcCursorName = 'YTD'
					    DBF2Excel(m.lcCursorName, .WorkSheets(mTahun),"A3") 	 
					    oExcel.WorkSheets(13).Range('A1').value = "'" + ALLTRIM(mTahun)	
						oExcel.WorkSheets(13).Range('A1').Font.Bold = .T.
						oExcel.WorkSheets(13).Range("A1").Font.Size = 14
						oExcel.WorkSheets(13).Range('A1:E1').Merge 	
						oExcel.WorkSheets(13).Range('A1:E1').HorizontalAlignment = 3	
						oExcel.WorkSheets(13).Range('A1:E1').Interior.Color = RGB(0,204,255) 
						WITH .WorkSheets(13)
							.Activate	
							.Range('A3').value = 'BULAN'
							.Range('A3:A2').merge
							.Range('B2').value = 'JUMLAH PEMBELIAN'
							.Range('B2:C2').merge
							.Range('D2').value = 'JUMLAH PENJUALAN'
							.Range('D2:E2').merge
							.Range('B3').value = 'NOTA'
							.Range('C3').value = 'RUPIAH'
							.Range('D3').value = 'NOTA'
							.Range('E3').value = 'RUPIAH'

							.Range("A2:E3").HorizontalAlignment = 3
							.Range("A2:E3").Font.Italic = .F.
							.Range("A2").Interior.Color = RGB(255,255,0)
							.Range("B2:C3").Interior.Color = RGB(255,255,0)
							.Range("D2:E3").Interior.Color = RGB(255,255,0)
							.Range("A2:E3").Font.Bold = .T.
							
							IF lsum > 0
								.Range('A&xRec').Value = 'Subtotal'
								.Range('A&xRec').Interior.Color = RGB(216,228,188)
								.Range('B&xRec').Formula = '=SUM(B4:B&sRec)'
								.Range('C&xRec').Formula = '=SUM(C4:C&sRec)'
								.Range('D&xRec').Formula = '=SUM(D4:D&sRec)'
								.Range('E&xRec').Formula = '=SUM(E4:E&sRec)'
								
								** Total Nota
								.Range('A&xRec2').Value = 'Total Nota'
								.Range('A&xRec2').Interior.Color = RGB(216,228,188)
								.Range('A&xRec2:B&xRec2').merge									
								.Range('C&xRec2').Formula = '=B&xRec + D&xRec'
								.Range('A&xRec:C&xRec2').borderS.linestyle = 1
							ENDIF 

							lcLastCell = oExcel.ActiveCell.SpecialCells(11).Address()			
							.Range("A1" + ":" + lcLastCell).borderS.linestyle = 1
							.Range("A1" + ":" + lcLastCell).borderS.weight = 2
							.Range("A1" + ":" + lcLastCell).borderS.colorindex = 48		

							.Columns("A").NumberFormatLocal = 'DD-MM-YYYY'
							.Columns("B:E").NumberFormatLocal = '#,##0'
							.Columns("B").HorizontalAlignment = 3	
							.Columns("D").HorizontalAlignment = 3			
							.Columns("F").Delete
							
							.UsedRange.EntireColumn.VerticalAlignment = 2																
						ENDWITH									
					ENDIF 		
					*oExcel.WorkSheets(m.ia).Range("B4").Select
					*oExcel.ActiveWindow.FreezePanes = .T.	
					oExcel.WorkSheets(m.ia).UsedRange.EntireColumn.Autofit
					oExcel.WorkSheets(m.ia).Columns("B:E").ColumnWidth = 14
				  	oExcel.ActiveWindow.DisplayZeros = .F.   
					oExcel.Activewindow.Displaygridlines = 0					    
					USE IN YTD
				 ENDWITH	     
				ENDWITH 	
				MESSAGEBOX('Selesai.!',64,'Save To Excel',5000)		
				oExcel.WorkSheets(MONTH(DATE())).Activate
				oExcel.Visible = .T.		
			    oExcelApp = oExcel.Application
				oExcelApp.WindowState = -4137	    		
		ENDIF 		
		ENDIF 
	ENDIF 
ENDIF 