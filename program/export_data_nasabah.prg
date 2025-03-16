IF TYPE('konek') = 'N'
	IF konek = 1
		IF TYPE('xUSERGROUP') == 'N' 
			IF ALLTRIM(STR(xUSERGROUP)) $ '1,2'
				TEXT TO m.lsql NOSHOW
						SELECT 
							m_customer.customer_code,
							m_customer.customer_name,
							m_customer.customer_nick_name,
							m_customer.customer_addres,
							m_customer.rt_rw,
							m_customer.village,
							m_customer.sub_district,
							m_customer.city,
							m_customer.customer_handphone,
							m_customer.customer_phone,
							
							(
							CASE
								WHEN m_customer.customer_type_id = 1 THEN "Perorangan"
								WHEN m_customer.customer_type_id = 2 THEN "Money Changer"
								WHEN m_customer.customer_type_id = 3 THEN "Bank"
								WHEN m_customer.customer_type_id = 4 THEN "Korporasi"
								ELSE ""
							END
							) AS customer_type_name,
							
							(
							CASE
								WHEN m_customer.customer_data_id = 1 THEN "KTP"
								WHEN m_customer.customer_data_id = 2 THEN "KITAS"
								WHEN m_customer.customer_data_id = 3 THEN "SIM"
								WHEN m_customer.customer_data_id = 4 THEN "PASPOR"
								WHEN m_customer.customer_data_id = 5 THEN "LAINNYA"
								ELSE ""
							END
							) AS customer_data_name,
							
							m_customer.customer_data_number,
							m_customer.placeofbirth,
							m_customer.bornday,
							
							CASE
								WHEN m_customer.gender_id = 1 THEN "Laki-Laki"
								WHEN m_customer.gender_id = 2 THEN "Perempuan"
								ELSE ""
							END
							AS gender_name,						
							
							m_customer_nationality.nationality_name,
							m_customer_work.work_name,
							
							CASE
								WHEN m_customer_work.category_id = 1 THEN "Biasa"
								WHEN m_customer_work.category_id = 2 THEN "Sedang"
								WHEN m_customer_work.category_id = 3 THEN "Pep"
								ELSE ""
							END
							AS category_name,															
						
							
							CASE
								WHEN m_customer.status = 1 THEN "Aktif"
								WHEN m_customer.status = 2 THEN "Tidak Aktif"
								ELSE ""
							END
							AS status_name,
							
							
							m_customer.created,
							m_customer.updated,
							(SELECT m_user.user_full_name FROM m_user WHERE (m_user.id = m_customer.createdby) GROUP BY m_user.user_full_name) AS createdby_name,
							(SELECT m_user.user_full_name FROM m_user WHERE (m_user.id = m_customer.updatedby) GROUP BY m_user.user_full_name) AS updatedby_name 
						FROM m_customer						
						LEFT JOIN m_customer_work ON m_customer.work_id = m_customer_work.id
						LEFT JOIN m_customer_nationality ON m_customer.nationality_id = m_customer_nationality.id
						WHERE m_customer.company_id = ?xCOMPANYID
						ORDER BY m_customer.customer_code
					ENDTEXT
					xx=SQLEXEC(konek,m.lsql,'v_customer')
					IF xx <=0 THEN
					   DO 'program\cek_error_sql.prg'	   
					ENDIF
					IF USED('v_customer')
						SELECT v_customer
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
									
								lcCursorName = 'v_customer'	
								oExcel.WorkSheets("sheet1").Name = "temp"	
								DBF2Excel(m.lcCursorName, oExcel.WorkSheets("temp"),"A1" ) 
								WITH oExcel.WorkSheets(1)
									.Activate()		
									.Range("A1:X1").Interior.ColorIndex = 37
									.Range("A1:X1").HorizontalAlignment = 3
									.UsedRange.EntireColumn.VerticalAlignment = 2		
									.UsedRange.EntireColumn.Font.Size   = 10
									.Columns("O").NumberFormatLocal = 'dd-mm-yyyy'
									.Columns("U:V").NumberFormatLocal = 'dd/mm/yyyy hh:mm:ss'
									
									.Range('A1').value = 'Kode'
									.Range('B1').value = 'Nama Pelanggan'
									.Range('C1').value = 'Nama Alias'
									.Range('D1').value = 'Alamat'
									.Range('E1').value = 'Rt/Rw'
									.Range('F1').value = 'Kelurahan/Desa'
									.Range('G1').value = 'Kecamatan'
									.Range('H1').value = 'Kabupaten/Kota'	
									.Range('I1').value = 'No Handphone'
									.Range('J1').value = 'No Telpon Rumah/Kantor'						
									.Range('K1').value = 'Tipe Pelanggan'										
									.Range('L1').value = 'Jenis Identitas'
									.Range('M1').value = 'Nomor Identitas'						
									.Range('N1').value = 'Tempat Lahir'
									.Range('O1').value = 'Tgl Lahir'					
									.Range('P1').value = 'Jenis Kelamin'													
									.Range('Q1').value = 'Kebangsaan'				
									.Range('R1').value = 'Pekerjaan'							
									.Range('S1').value = 'Kategori Resiko'										
									.Range('T1').value = 'Status'					
									.Range('U1').value = 'Tgl Input'					
									.Range('V1').value = 'Tgll Ubah'	
									.Range('W1').value = 'Diinput Oleh'	
									.Range('X1').value = 'Diubah Oleh'							
									.UsedRange.EntireColumn.Autofit	
								ENDWITH 
								oExcel.Visible = .T.
								USE IN v_customer		
							ENDIF
						ENDIF
					ENDIF
			ENDIF
		ENDIF
	ENDIF
ENDIF
