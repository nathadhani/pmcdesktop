LPARAMETERS LNOTA
#include 'include\PRINT.CH'
DO 'program\fungsi.prg'
cNota = ''
IF TYPE('LNOTA') <> 'U'
	cNota = LNOTA
ENDIF 
LOCAL lsql
lsql = ''
TEXT TO m.lsql NOSHOW ADDITIVE TEXTMERGE PRETEXT 7
	SELECT TR_HEADER.ID,
			TR_HEADER.TR_ID AS TR_ID,
			TR_HEADER.TR_NUMBER AS TR_NUMBER,
			TR_HEADER.TR_DATE AS TR_DATE,
			TR_HEADER.CUSTOMER_ID AS CUSTOMER_ID,			
			M_CUSTOMER.CUSTOMER_CODE AS CUSTOMER_CODE,
			M_CUSTOMER.CUSTOMER_NAME AS CUSTOMER_NAME,
			M_CUSTOMER.CUSTOMER_ADDRES AS CUSTOMER_ADDRES,
			M_CUSTOMER.CUSTOMER_HANDPHONE AS CUSTOMER_HANDPHONE,
			M_CUSTOMER.CUSTOMER_DATA_NUMBER AS CUSTOMER_DATA_NUMBER,
			TR_HEADER.COUNTER_ID AS COUNTER_ID,
			X.USER_FULL_NAME AS COUNTER_NAME,
			TR_HEADER.CASHIER_ID AS CASHIER_ID,
			Y.USER_FULL_NAME AS CASHIER_NAME,
			TR_HEADER.NUMBEROFCOPIES AS NUMBEROFCOPIES,
			TR_HEADER.DESCRIPTION AS DESCRIPTION,
			TR_HEADER.SUMBER_DANA AS SUMBER_DANA,
			TR_HEADER.TUJUAN_TRANSAKSI AS TUJUAN_TRANSAKSI,			
			TR_HEADER.RELATION_CUSTOMER_ID,
			BO.CUSTOMER_NAME AS BO_NAME,
			BO.CUSTOMER_ADDRES AS BO_ADDRES,
			(
				SELECT SUM(amount) FROM tr_bayar
				WHERE tr_bayar.tr_id = tr_header.tr_id AND tr_bayar.tr_number = tr_header.tr_number AND tr_bayar.payment_type = 1 AND tr_bayar.status = 3
			) AS CASH,			
			(
				SELECT SUM(amount) FROM tr_bayar
				WHERE tr_bayar.tr_id = tr_header.tr_id AND tr_bayar.tr_number = tr_header.tr_number AND tr_bayar.payment_type = 2 AND tr_bayar.status = 3
			) AS TRANSFER
	FROM TR_HEADER
	LEFT JOIN M_CUSTOMER         ON M_CUSTOMER.ID         = TR_HEADER.CUSTOMER_ID
	LEFT JOIN M_CUSTOMER AS BO   ON BO.ID                 = TR_HEADER.RELATION_CUSTOMER_ID	
	LEFT JOIN M_CUSTOMER_WORK    ON M_CUSTOMER_WORK.ID    = M_CUSTOMER.WORK_ID 
	LEFT JOIN M_USER AS X        ON X.ID 			      = TR_HEADER.COUNTER_ID
	LEFT JOIN M_USER AS Y        ON Y.ID 			      = TR_HEADER.CASHIER_ID	
	WHERE RTRIM(TR_HEADER.TR_NUMBER) = ?RTRIM(CNOTA) AND TR_HEADER.TR_ID = ?MJNSID
	LIMIT 1
ENDTEXT
xx=SQLEXEC(konek,m.lsql,"temp_header")
IF xx <= 0 THEN
   DO 'program\cek_error_sql.prg'	
ELSE
	IF USED('temp_header')
		SELECT temp_header
		IF RECCOUNT() > 0	
			DO 'program\update_field.prg'
			GO TOP 			
			DO 'program\update_field.prg'
			SELECT temp_header
			GO TOP
			_tr_id                  = temp_header.tr_id
			_title                  = IIF(temp_header.tr_id = 1 , 'BELI/BUY',IIF(temp_header.tr_id = 2, 'JUAL/SELL', '')) 
			_tr_number              = RTRIM(temp_header.tr_number) 				
			_tr_date                = SUBSTR(DTOS(temp_header.tr_date),7,2)+'-'+SUBSTR(DTOS(temp_header.tr_date),5,2)+'-'+SUBSTR(DTOS(temp_header.tr_date),1,4)	
			_customer_code          = RTRIM(temp_header.customer_code)
			_customer_name          = RTRIM(temp_header.customer_name)
			_customer_addres        = RTRIM(temp_header.customer_addres)
			_customer_data_number   = IIF(ISNULL(temp_header.customer_data_number) OR EMPTY(temp_header.customer_data_number),'-',RTRIM(temp_header.customer_data_number)) 
			_customer_phone         = IIF(ISNULL(temp_header.customer_handphone) OR EMPTY(temp_header.customer_handphone),RTRIM(temp_header.customer_phone),RTRIM(temp_header.customer_handphone)) 
			_description            = PROPER(SUBSTR(RTRIM(temp_header.description),1,60))
			_sumber_dana      	    = PROPER(RTRIM(temp_header.sumber_dana))
			_tujuan_transaksi 	    = PROPER(RTRIM(temp_header.tujuan_transaksi))
			_bo_name                = RTRIM(temp_header.bo_name)
			_bo_addres              = RTRIM(temp_header.bo_addres)
			_numberofcopies         = ''
			IF temp_header->numberofcopies > 0
				_numberofcopies = '(C-'+ALLTRIM(STR(temp_header->numberofcopies))+')' &&Keterangan Copy Jika dicetak lebih dari satu kali 
			ENDIF 				
			
			** update insull jlh_cetak
			TEXT TO m.lsql NOSHOW
				UPDATE tr_header SET numberofcopies = 0
				WHERE ISNULL(numberofcopies) 
				AND RTRIM(tr_number)=?_tr_number
				AND tr_id = ?_tr_id
			ENDTEXT 
			xx=SQLEXEC(konek,m.lsql)
			DO 'program\cek_error_sql_crud.prg'
			
			** update jlh_cetak tambah 1 
			TEXT TO m.lsql NOSHOW
				UPDATE tr_header SET numberofcopies = numberofcopies + 1
				WHERE RTRIM(tr_number)=?_tr_number
				AND tr_id = ?_tr_id
			ENDTEXT 
			xx=SQLEXEC(konek,m.lsql)	
			DO 'program\cek_error_sql_crud.prg'
			
			** --------------------------------------------------------------------------------------------------------------------------------
			
			lsql = ''
			TEXT TO m.lsql NOSHOW ADDITIVE TEXTMERGE PRETEXT 7
				SELECT TR_DETAIL.ID,
					    TR_DETAIL.VALAS_ID AS VALAS_ID,
						M_VALAS.VALAS_CODE AS VALAS_CODE,
						M_VALAS.VALAS_NAME AS VALAS_NAME,
						TR_DETAIL.QTY AS QTY,
						TR_DETAIL.PRICE AS PRICE,
						TR_DETAIL.SUBTOTAL AS SUBTOTAL
				FROM TR_DETAIL
				LEFT JOIN M_VALAS
				ON M_VALAS.ID = TR_DETAIL.VALAS_ID
				WHERE RTRIM(TR_DETAIL.TR_NUMBER) = ?RTRIM(CNOTA)
				AND TR_DETAIL.TR_ID = ?MJNSID
				ORDER BY TR_DETAIL.VALAS_ID,TR_DETAIL.PRICE ASC
			ENDTEXT
			xx=SQLEXEC(konek,m.lsql,"temp_detail")
			IF xx <= 0 THEN
			   DO 'program\cek_error_sql.prg'	
			ELSE
				IF USED('temp_detail')
					SELECT temp_detail
					IF RECCOUNT() > 0
						SELECT temp_detail
						GO TOP
						DO 'program\update_field.prg'
						Tmp = temp_+SYS(2015)+'.prn'
						IF RECCOUNT() > 4
							SELECT temp_detail
							GO TOP 
							NREK = 0
							subtot = 0
							SCAN 
								NREK = NREK + 1
								REPLACE ID WITH ALLTRIM(STR(NREK))
								subtot = subtot + (price*qty)
							ENDSCAN  
							SELECT * FROM temp_detail WHERE VAL(id) BETWEEN 1 .AND. 5 INTO CURSOR temp_detail1 READWRITE ORDER BY valas_id,price ASC 
							SELECT * FROM temp_detail WHERE VAL(id) BETWEEN 6 .AND. 10 INTO CURSOR temp_detail2 READWRITE ORDER BY valas_id,price ASC
							SELECT * FROM temp_detail WHERE VAL(id) BETWEEN 11 .AND. 15 INTO CURSOR temp_detail3 READWRITE ORDER BY valas_id,price ASC 
							FOR I = 1 TO 3
								ni = ALLTRIM(STR(i))
								SELECT temp_detail&ni
								GO TOP 
								NREK = 0
								SCAN 
									NREK = NREK + 1
									REPLACE ID WITH ALLTRIM(STR(NREK))
								ENDSCAN 
							ENDFOR
							** --------------------------------------------------------------------------------------------------------------------------------
							lCetak =  .F.		
							Cprinter=GETPRINTER()
							IF !EMPTY(Cprinter)		
								SET PRINTER TO NAME(cprinter)
								SET DEVICE TO FILE(Tmp)
								SET CONSOLE OFF		
								IF .NOT. lCetak
									@ 0,0 Say CHR(27) + 'C' + CHR(33) + CHR(27) + "x" + CHR(0) && Buat kembali ke posisi 33 baris dan Draft Mode
									lCetak = .T.
								ELSE
									@ 0,0 Say CHR(27) + 'C' + CHR(66) + CHR(27) + "x" + CHR(0) && Buat kembali ke posisi 66 baris dan Draft Mode
								ENDIF															
								SELECT temp_detail1
								GO TOP		
								I = 0
								nLebar = 110
								DO WHILE !EOF()	
									*------------------------------------				
									IF I = 0 					   
										DO _header_nota_title
										DO _header_nota_kolom_currency
										nRow = 14
									ENDIF
									
									*------------------------------------
									I = I + 1
									DO _detail_kolom1
									
									*------------------------------------
									SELECT temp_detail2	
									GO TOP 			
									LOCATE FOR id = I
									IF FOUND()
										DO _detail_kolom2
									ENDIF
									
									*------------------------------------
									SELECT temp_detail3	
									GO TOP 			
									LOCATE FOR id = I
									IF FOUND()
										DO _detail_kolom3
									ENDIF
						
									*------------------------------------
									nRow = nRow + 1							
									SELECT temp_detail1		
									SKIP
								ENDDO							
								DO _footer_nota
								SET DEVICE TO SCREEN
								xx = FILETOSTR(Tmp)
								???xx+CHR(13)
								EJECT
								SET PRINTER TO	
								SET CONSOLE ON
							ENDIF
							*@ 0,0 Say CHR(27) + 'C' + CHR(66) + CHR(27) + "x" + CHR(0) && Buat kembali ke posisi 66 baris dan Draft Mode						
							USE IN temp_detail1
							USE IN temp_detail2
							USE IN temp_detail3							
						ELSE
							lCetak =  .F.		
							Cprinter=GETPRINTER()
							IF !EMPTY(Cprinter)						
								SET PRINTER TO NAME(cprinter)
								SET DEVICE TO FILE(Tmp)	
								SET CONSOLE OFF		
								IF .NOT. lCetak 
									@ 0,0 Say CHR(27) + 'C' + CHR(33) + CHR(27) + "x" + CHR(0) && Buat kembali ke posisi 33 baris dan Draft Mode
									lCetak = .T.
								ELSE
									@ 0,0 Say CHR(27) + 'C' + CHR(66) + CHR(27) + "x" + CHR(0) && Buat kembali ke posisi 66 baris dan Draft Mode
								ENDIF 							
								SELECT temp_detail	
								_tot_record = ALLTRIM(STR(RECCOUNT()))		
								GO TOP 									
								subtot = 0
								_nbaris = 1
								I = 0
								nLebar = 110
								DO WHILE !EOF()
									IF _nbaris = 1 .OR. _nbaris = 5 .OR. _nbaris = 9 .OR. _nbaris = 13								   
										DO _header_nota_title
										DO _header_nota_kolom
										nRow = 15
									ENDIF	
									I = I + 1	
									_nbaris = _nbaris + 1
									nHarga = temp_detail.price
									nQty   = temp_detail.qty					
									DO _detail_nota			   											
									nRow = nRow + 1
									subtot = subtot + (nHarga*nQty)							
									SELECT temp_detail		
									SKIP
								ENDDO
								DO _footer_nota
								SET DEVICE TO SCREEN	
								xx = FILETOSTR(Tmp)
								???xx+CHR(13)
								EJECT
								SET PRINTER TO	
								SET CONSOLE ON
							ENDIF 
							*@ 0,0 Say CHR(27) + 'C' + CHR(66) + CHR(27) + "x" + CHR(0) && Buat kembali ke posisi 66 baris dan Draft Mode						
						ENDIF	
					ENDIF
				ENDIF
				USE IN temp_detail 
			ENDIF			
		ENDIF
		USE IN temp_header		
	ENDIF 	
ENDIF

*--------------------------------------------------------------------------------------------------------
PROCEDURE _header_nota_title()
	** Print Logo
	*@ 1,2 Say 'img/Graphicloads-Polygon-Dollar.ico' bitmap SIZE 10, 10 ISOMETRIC 
	
	** Judul Bon Beli / Jual				
	@ 1,4 Say fKECIL10() + SPACE(80) + fWideON() + fTEBAL() + fUnderON() + _title + fUnderOFF() + fUnTEBAL() + fWideOFF() + fKECIL10() 

	** Merk Dagang
	IF TYPE('xMERKUSAHA')<>'U'
		IF LEN(xMERKUSAHA) > 0
			** Merk Dagang
			**@ 2,4 Say fBESAR12() + fHiON() + fWideON() + fTEBAL() + IIF(TYPE('xMERKUSAHA')<>'U',RTRIM(xMERKUSAHA),'') + fUnTEBAL() + fWideOFF() + fHiOFF() + fUnBESAR12() + fKECIL10() 
			@ 2,4 Say fBESAR12() + fWideON() + fTEBAL() + IIF(TYPE('xMERKUSAHA')<>'U',RTRIM(xMERKUSAHA),'') + fUnTEBAL() + fWideOFF() + fUnBESAR12() + fKECIL10() 
			IF TYPE('xIZINUSAHA') <> 'U'
				IF LEN(xIZINUSAHA) > 0
					@ 3,4 Say fKECIL10() + SPACE(0)+ fWideON() + fTEBAL() + 'Authorized Money Changer' + fUnTEBAL() + fWideOFF() + fKECIL10() 
				ENDIF
			ENDIF		
		ELSE			
			** Nama PT
			@ 2,4 Say fKECIL10() + fHiON() + fTEBAL() + IIF(TYPE('xNAMAUSAHA')<>'U',RTRIM(xNAMAUSAHA),'') + fUnTEBAL() + fHiOFF() + fKECIL10()
			IF TYPE('xIZINUSAHA') <> 'U'	
				IF LEN(xIZINUSAHA) > 0
					@ 3,4 Say fKECIL10() + SPACE(0)+ fWideON() + fTEBAL() + 'Authorized Money Changer' + fUnTEBAL() + fWideOFF() + fKECIL10() 
				ENDIF	
			ENDIF	
		ENDIF
	ELSE
		** Nama PT
		@ 2,4 Say fKECIL10() + fHiON() + fTEBAL() + IIF(TYPE('xNAMAUSAHA')<>'U',RTRIM(xNAMAUSAHA),'') + fUnTEBAL() + fHiOFF() + fKECIL10()	
		IF TYPE('xIZINUSAHA') <> 'U'					
			IF LEN(xIZINUSAHA) > 0
				@ 3,4 Say fKECIL10() + SPACE(0)+ fWideON() + fTEBAL() + 'Authorized Money Changer' + fUnTEBAL() + fWideOFF() + fKECIL10() 			
			ENDIF	
		ENDIF
	ENDIF	
	
	** Ijin Bank Indonesia
	_IZI_BANK_INDONESIA = ''
	IF TYPE('xIZINUSAHA') <> 'U'
		_IZI_BANK_INDONESIA = xIZINUSAHA
		IF LEN(_IZI_BANK_INDONESIA) > 0
			IF TYPE('xMERKUSAHA') <> 'U'
				IF LEN(xMERKUSAHA) > 0
					@ 4,4  Say RTRIM(xNAMAUSAHA) + ', Izin Bank Indonesia No. ' + _IZI_BANK_INDONESIA
				ELSE
					@ 4,4  Say 'Izin Bank Indonesia No.' + _IZI_BANK_INDONESIA			
				ENDIF
			ELSE
				@ 4,4  Say 'Izin Bank Indonesia No.' + _IZI_BANK_INDONESIA
			ENDIF					
		ENDIF 
	ENDIF	
	@ 4,80 Say 'Nomor   : ' + _tr_number + SPACE(1) + _numberofcopies	
	
	** Alamat ke 1
	@ 5,4  Say IIF(TYPE('xALMTUSAHA1')='C',SUBSTR(ALLTRIM(xALMTUSAHA1),1,75),'')
	@ 5,80 Say 'Tanggal : ' + _tr_date
	
	** Alamat ke 2 & ke 3
	DO CASE
		CASE (LEN(IIF(TYPE('xALMTUSAHA2')='C',ALLTRIM(xALMTUSAHA2),'')) > 0)
			@ 06,04 Say IIF(TYPE('xALMTUSAHA2')='C',ALLTRIM(xALMTUSAHA2) + SPACE(2) ,'') + IIF(TYPE('xTLPNUSAHA')='C',ALLTRIM(xTLPNUSAHA),'')
		OTHERWISE
			@ 06,04 Say IIF(TYPE('xTLPNUSAHA')='C',ALLTRIM(xTLPNUSAHA),'')
	ENDCASE		
	
	***********************************************************************************************************
	*   	   1         2         3         4         5         6         7         8         9         10    
	* 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	* 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	* Nama   :                                                                    No.ID     :   
	* Alamat :                                                                    No.Telpon :         
	* 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴								
	@ 07,04 Say REPLICATE('�',nLebar)					
	@ 08,04 Say 'CIF           : ' + _customer_code + ' - ' + _customer_name
	@ 08,80 Say 'No.ID     : ' + _customer_data_number
	@ 09,04 Say 'Alamat        : ' + SUBSTR(ALLTRIM(_customer_addres),1,59)
	@ 09,80 Say 'No.Telpon : ' + _customer_phone
	@ 10,04 Say 'Sumber Dana   : ' + _sumber_dana
	@ 11,04 Say 'Tuj.Transaksi : ' + _tujuan_transaksi								


*--------------------------------------------------------------------------------------------------------
PROCEDURE _header_nota_kolom()
	***********************************************************************************************************				
	*   	   1         2         3         4         5         6         7         8         9         10    
	* 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	* 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	* No      Currency        Amount         Kurs         Subtotal     Description
	* 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	***********************************************************************************************************				
	@ 12,4  Say REPLICATE('�',nLebar)					
	@ 13,4  Say '#'
	@ 13,8  Say 'Currency'
	@ 13,24 Say 'Amount'
	@ 13,36 Say 'Exc.Rate'
	@ 13,51 Say 'Equivalent'
	@ 13,65 Say 'Description'							
	@ 14,4 Say REPLICATE('�',nLebar)

*--------------------------------------------------------------------------------------------------------
PROCEDURE _detail_nota()
	@ nRow,4  Say TRANSFORM(I,"99")
	@ nRow,8  Say SUBSTR(RTRIM(temp_detail.valas_code),1,6)
	@ nRow,19 Say TRANSFORM(nQty,"999,999,999")
	
	IF GetDecimalValue(nHarga) > 0
		DO CASE
			CASE nHarga < 100000 .AND. nHarga > 10000
		    	@nRow,35 Say TRANSFORM(nHarga)
			CASE nHarga < 10000 .AND. nHarga > 1000
		    	@nRow,36 Say TRANSFORM(nHarga)		
			CASE nHarga < 1000 .AND. nHarga > 100
		    	@nRow,37 Say TRANSFORM(nHarga)		 
			CASE nHarga < 100 .AND. nHarga > 10
				@nRow,38 Say TRANSFORM(nHarga)
			OTHERWISE
				@nRow,39 Say TRANSFORM(nHarga)				
		ENDCASE
	ELSE
	    @nRow,33 Say TRANSFORM(nHarga,"999,999,999")
	ENDIF				
	
*!*		IF GetDecimalValue((nHarga*nQty)) > 0
*!*			@nRow,43 Say TRANSFORM(ROUND(nHarga*nQty,3),"999,999,999,999.999")
*!*		ELSE
		@nRow,46 Say TRANSFORM(nHarga*nQty,"999,999,999,999")
*!*		ENDIF	
	@nRow,65 Say Proper(RTRIM(temp_detail.valas_name))

*--------------------------------------------------------------------------------------------------------
PROCEDURE _header_nota_kolom_currency()
	@ 12,04 Say REPLICATE('�',nLebar)					
	@ 13,04 Say 'Currency :'
	IF USED('temp_detail2')
		SELECT temp_detail2
		IF RECCOUNT() > 0
			@ 13,42 Say 'Currency :'
		ENDIF	
	ENDIF
	IF USED('temp_detail3')
		SELECT temp_detail3
		IF RECCOUNT() > 0
			@ 13,82 Say 'Currency :'
		ENDIF	
	ENDIF
	
*--------------------------------------------------------------------------------------------------------
PROCEDURE _detail_kolom1()
	SELECT temp_detail1
	nHarga = temp_detail1.price
	nQty = temp_detail1.qty
	IF GetDecimalValue(nHarga) > 0
*!*			IF GetDecimalValue((nHarga*nQty)) > 0
*!*				@nRow,04 Say ALLTRIM(valas_code) + SPACE(1)  + ALLTRIM(TRANSFORM(Qty,"999,999,999")) + " x " + ALLTRIM(TRANSFORM(nHarga)) + " = " + ALLTRIM(TRANSFORM(ROUND(nHarga*qty,3),"999,999,999,999.999"))
*!*			ELSE
			@nRow,04 Say ALLTRIM(valas_code) + SPACE(1)  + ALLTRIM(TRANSFORM(Qty,"999,999,999")) + " x " + ALLTRIM(TRANSFORM(nHarga)) + " = " + ALLTRIM(TRANSFORM(ROUND(nHarga*qty,3),"999,999,999,999"))
*!*			ENDIF 	
	ELSE
		@nRow,04 Say ALLTRIM(valas_code) + SPACE(1) + ALLTRIM(TRANSFORM(Qty,"999,999,999")) + " x " + ALLTRIM(TRANSFORM(nHarga,"999,999,999")) + " = " + ALLTRIM(TRANSFORM(nHarga*qty,"999,999,999,999"))
	ENDIF	

*--------------------------------------------------------------------------------------------------------
PROCEDURE _detail_kolom2()
	SELECT temp_detail2
	nHarga = temp_detail2.price
	nQty = temp_detail1.qty
	IF GetDecimalValue(nHarga) > 0
*!*			IF GetDecimalValue((nHarga*nQty)) > 0
*!*				@nRow,42 Say ALLTRIM(valas_code) + SPACE(1) + ALLTRIM(TRANSFORM(Qty,"999,999,999")) + " x " + ALLTRIM(TRANSFORM(nHarga)) + " = " + ALLTRIM(TRANSFORM(ROUND(nHarga*qty,3),"999,999,999,999.999"))
*!*			ELSE
			@nRow,42 Say ALLTRIM(valas_code) + SPACE(1) + ALLTRIM(TRANSFORM(Qty,"999,999,999")) + " x " + ALLTRIM(TRANSFORM(nHarga)) + " = " + ALLTRIM(TRANSFORM(ROUND(nHarga*qty,3),"999,999,999,999"))
*!*			ENDIF	
	ELSE
		@nRow,42 Say ALLTRIM(valas_code) + SPACE(1) + ALLTRIM(TRANSFORM(Qty,"999,999,999")) + " x " + ALLTRIM(TRANSFORM(nHarga,"999,999,999")) + " = " + ALLTRIM(TRANSFORM(nHarga*qty,"999,999,999,999"))
	ENDIF		

*--------------------------------------------------------------------------------------------------------
PROCEDURE _detail_kolom3()
	SELECT temp_detail3
	nHarga = temp_detail3.price
	nQty = temp_detail1.qty
	IF GetDecimalValue(nHarga) > 0
*!*			IF GetDecimalValue((nHarga*nQty)) > 0
*!*				@nRow,82 Say ALLTRIM(valas_code) + SPACE(1) + ALLTRIM(TRANSFORM(Qty,"999,999,999")) + " x " + ALLTRIM(TRANSFORM(nHarga)) + " = " + ALLTRIM(TRANSFORM(ROUND(nHarga*qty,3),"999,999,999,999.999"))
*!*			ELSE
			@nRow,82 Say ALLTRIM(valas_code) + SPACE(1) + ALLTRIM(TRANSFORM(Qty,"999,999,999")) + " x " + ALLTRIM(TRANSFORM(nHarga)) + " = " + ALLTRIM(TRANSFORM(ROUND(nHarga*qty,3),"999,999,999,999"))
*!*			ENDIF
	ELSE
		@nRow,82 Say ALLTRIM(valas_code) + SPACE(1) + ALLTRIM(TRANSFORM(Qty,"999,999,999")) + " x " + ALLTRIM(TRANSFORM(nHarga,"999,999,999")) + " = " + ALLTRIM(TRANSFORM(nHarga*qty,"999,999,999,999"))
	ENDIF

*--------------------------------------------------------------------------------------------------------
PROCEDURE _footer_nota()
	SELECT temp_header
	GO TOP
	_counter_name  = PROPER(RTRIM(temp_header.counter_name))
	_cashier_name  = PROPER(RTRIM(temp_header.cashier_name))
	_cash          = temp_header.cash
	_transfer      = temp_header.transfer
*!*		cTglcetak      = fGethari(DATE()) + ", " + SUBSTR(DTOS(DATE()),7,2)+'-'+SUBSTR(DTOS(DATE()),5,2)+'-'+SUBSTR(DTOS(DATE()),1,4)
*!*		cTglcetak      = cTglcetak + " / " + CDOW(DATE()) + ", "
*!*		cTglcetak      = cTglcetak + SUBSTR(DTOS(DATE()),1,4)+'-'+SUBSTR(DTOS(DATE()),5,2)+'-'+SUBSTR(DTOS(DATE()),7,2)
*!*		cTglcetak      = cTglcetak +  + SPACE(1) + TIME()
	cTglcetak = fGethari(temp_header.tr_date) + ", " + _tr_date

	
	@nRow,04 Say REPLICATE('�',nLebar)			
	nRow = nRow+1
	
	@nRow,04 Say "Attention" 
	@nRow,18 Say " : No Claim after leaving our counter."
	@nRow,75 Say "Total" 
	@nRow,85 Say ": Rp." + PADL(TRANSFORM(subtot,"999,999,999,999"),15," ")
	nRow = nRow+1			
	
	IF _cash > 0			
		@nRow,21 Say fItalicON() + "Kami tidak melayani klaim setelah" + fItalicOFF()
		@nRow,79 Say "Cash" 
		@nRow,89 Say ": Rp." + PADL(TRANSFORM(_cash,"999,999,999,999"),15," ")
		nRow = nRow+1
	ELSE
		@nRow,21 Say fItalicON() + "Kami tidak melayani klaim setelah" + fItalicOFF()
		nRow = nRow+1			
	ENDIF 

	IF _transfer > 0
		@nRow,21 Say  fItalicON() + "meninggalkan Counter"  + fItalicOFF()
		@nRow,79 Say "Transfer"
		@nRow,89 Say ": Rp." + PADL(TRANSFORM(_transfer,"999,999,999,999"),15," ")
		nRow = nRow+1			
	ELSE
		@nRow,21 Say fItalicON() + "meninggalkan Counter"  + fItalicOFF()
		nRow = nRow+1			
	ENDIF 			
	
	IF (_cash + _transfer) - subtot > 0
		@nRow,75 Say "Kembali" 
		@nRow,85 Say ": Rp." + PADL(TRANSFORM( (_cash + _transfer) - subtot ,"999,999,999"),15," ")
		nRow = nRow+1
	ENDIF 
	
	@nRow,4 Say 'PBI'	
	@nRow,18 Say ' : Merujuk PBI No 18/20/PBI/2016 dengan ini menyatakan bahwa saya tunduk pada ketentuan yang berlaku,'						
	nRow = nRow+1

	@nRow,21 Say 'bahwa pembelian valuta asing terhadap rupiah tidak melebihi batas (Threshold) USD 25,000/bln'			
	nRow = nRow+1
	
	IF .NOT. EMPTY(_description)
		@nRow,4 Say 'Keterangan'			
		@nRow,18 Say ' : ' + _description
		@nRow,80 Say 'Tgl Cetak' + ' : ' + cTglcetak
	ELSE
		@nRow,4 Say 'Tgl Cetak'			
		@nRow,18 Say ' : ' + cTglcetak
	ENDIF	
	nRow = nRow+1
	
	xCounter = "Konter,"
	xLEN3 = LEN(xCounter)
	xLEN4 = LEN(_counter_name) - xLEN3							

	xKasir = "Kasir,"				
	xLEN1 = LEN(xKasir)
	xLEN2 = LEN(_cashier_name) - xLEN1				

	@nRow,4 Say xKasir + SPACE(xLEN2+25) + xCounter + SPACE(xLEN4+25) + "Nasabah,"		
	nRow = nRow+3
	
	@nRow,4 Say _cashier_name + SPACE(25) + _counter_name + SPACE(25) + _customer_name				


