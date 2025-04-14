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
			TR_HEADER.STATUS,
			TR_HEADER.CUSTOMER_ID AS CUSTOMER_ID,			
			M_CUSTOMER.CUSTOMER_CODE AS CUSTOMER_CODE,
			M_CUSTOMER.CUSTOMER_NAME AS CUSTOMER_NAME,
			M_CUSTOMER.CUSTOMER_ADDRES AS CUSTOMER_ADDRES,
			M_CUSTOMER.CUSTOMER_HANDPHONE AS CUSTOMER_HANDPHONE,
			M_CUSTOMER.CUSTOMER_DATA_NUMBER AS CUSTOMER_DATA_NUMBER,
			M_CUSTOMER_WORK.WORK_NAME,
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
	WHERE TR_HEADER.TR_ID = ?MJNSID AND RTRIM(TR_HEADER.TR_NUMBER) = ?RTRIM(CNOTA) AND TR_HEADER.company_id = ?xCOMPANYID
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
			_title                  = IIF(temp_header.tr_id = 1 , 'BUY',IIF(temp_header.tr_id = 2, 'SELL', '')) 
			_tr_number              = ALLTRIM(temp_header.tr_number)
			_tr_date                = SUBSTR(DTOS(temp_header.tr_date),7,2)+'-'+SUBSTR(DTOS(temp_header.tr_date),5,2)+'-'+SUBSTR(DTOS(temp_header.tr_date),1,4)	
			_tr_status              = IIF(TYPE('temp_header->status') = 'C',VAL(temp_header->status),temp_header->status)
			_customer_code          = RIGHT(ALLTRIM(temp_header.customer_code),8)
			_customer_name          = RTRIM(temp_header.customer_name)
			_customer_addres        = RTRIM(temp_header.customer_addres)
			_customer_data_number   = IIF(ISNULL(temp_header.customer_data_number) OR EMPTY(temp_header.customer_data_number),'-',RTRIM(temp_header.customer_data_number)) 
			_customer_phone         = IIF(ISNULL(temp_header.customer_handphone) OR EMPTY(temp_header.customer_handphone),RTRIM(temp_header.customer_phone),RTRIM(temp_header.customer_handphone)) 
			_customer_work          = PROPER(RTRIM(temp_header.work_name))
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
				AND company_id = ?xCOMPANYID
			ENDTEXT 
			xx=SQLEXEC(konek,m.lsql)
			DO 'program\cek_error_sql_crud.prg'
			
			** update jlh_cetak tambah 1 
			TEXT TO m.lsql NOSHOW
				UPDATE tr_header SET numberofcopies = numberofcopies + 1
				WHERE RTRIM(tr_number)=?_tr_number
				AND tr_id = ?_tr_id
				AND company_id = ?xCOMPANYID
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
				WHERE TR_DETAIL.TR_ID = ?MJNSID
				AND RTRIM(TR_DETAIL.TR_NUMBER) = ?RTRIM(CNOTA)
				AND TR_DETAIL.company_id = ?xCOMPANYID
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
							nLebar = 55
							nPage = 0
							DO WHILE !EOF()
								IF _nbaris = 1 .OR. _nbaris = 5 .OR. _nbaris = 9 .OR. _nbaris = 13 .OR. _nbaris = 17;
								   .OR. _nbaris = 21 .OR. _nbaris = 25 .OR. _nbaris = 29 .OR. _nbaris = 33 .OR. _nbaris = 37;
								   .OR. _nbaris = 41 .OR. _nbaris = 45 .OR. _nbaris = 49 .OR. _nbaris = 53 .OR. _nbaris = 57								    
									DO _header_nota_title
									DO _header_nota_kolom
									nRow = 17
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
				USE IN temp_detail 
			ENDIF			
		ENDIF
		USE IN temp_header		
	ENDIF 	
ENDIF

*--------------------------------------------------------------------------------------------------------
PROCEDURE _header_nota_title()	
	nPage = nPage + 1
	** Buy/Sell
	IF _tr_status = 4
		@ 01,04 Say fKECIL10() + 'Page ' + ALLTRIM(STR(nPage)) + SPACE(27) + fBESAR12()+ fWideON() + fTEBAL() + fUnderON() + _title + fUnderOFF() + fUnTEBAL() + fWideOFF() + fUnBESAR12()+ fKECIL10() + ' (batal)'
	ELSE
		@ 01,04 Say fKECIL10() + 'Page ' + ALLTRIM(STR(nPage)) + SPACE(34) + fBESAR12()+ fWideON() + fTEBAL() + fUnderON() + _title + fUnderOFF() + fUnTEBAL() + fWideOFF() + fUnBESAR12()+ fKECIL10()
	ENDIF

	** Nama PT	
	@ 02,04 Say fKECIL10() + fTEBAL() + IIF(TYPE('xNAMAUSAHA')<>'U',RTRIM(xNAMAUSAHA),'') + fUnTEBAL() + fKECIL10()
		
	** Ijin Bank Indonesia
	IF TYPE('xIZINUSAHA') <> 'U'
		IF LEN(xIZINUSAHA) > 0
			@ 03,04 Say 'Authorized Money Changer ' + ALLTRIM(xIZINUSAHA)
		ENDIF
	ENDIF	
		
	** Alamat ke 1
	@ 04,04 Say IIF(TYPE('xALMTUSAHA1')='C',SUBSTR(ALLTRIM(xALMTUSAHA1),1,55),'')
	
	** Alamat ke 2
	@ 05,04 Say IIF(TYPE('xALMTUSAHA2')='C',SUBSTR(ALLTRIM(xALMTUSAHA2),1,55),'')
	
	** Phone
	@ 06,04 Say 'Phone. ' + IIF(TYPE('xTLPNUSAHA')='C',ALLTRIM(xTLPNUSAHA),'')
	
	** Nomor & Tanggal Nota
	@ 07,04 Say 'Date ' + _tr_date + SPACE(1) + 'No. ' + _tr_number + SPACE(1) + _numberofcopies
	
	***********************************************************************************************************
	*   	   1         2         3         4         5         6         7         8         9         10    
	* 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	* 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	* Nama   :                                                                    No.ID     :   
	* Alamat :                                                                    No.Telpon :         
	* 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴								
	@ 08,04 Say REPLICATE('�',nLebar)					
	@ 09,04 Say 'CIF     : ' + _customer_code + SPACE(2) + 'ID No. : ' + _customer_data_number
	@ 10,04 Say 'Name    : ' + SUBSTR(ALLTRIM(_customer_name),1,40)
	@ 11,04 Say 'Address : ' + SUBSTR(ALLTRIM(_customer_addres),1,45)
	@ 12,04 Say 'Phone   : ' + _customer_phone + SPACE(2) + 'Job : ' + _customer_work
	@ 13,04 Say 'Source  : ' + SUBSTR(ALLTRIM(_sumber_dana),1,45)
	@ 14,04 Say 'Purpose : ' + SUBSTR(ALLTRIM(_tujuan_transaksi),1,45)

*--------------------------------------------------------------------------------------------------------
PROCEDURE _header_nota_kolom()
	***********************************************************************************************************				
	*   	   1         2         3         4         5         6         7         8         9         10    
	* 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	* 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	* No      Currency        Amount         Kurs         Subtotal     Description
	* 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	***********************************************************************************************************				
	@ 15,04 Say REPLICATE('�',nLebar)					
	@ 16,04 Say 'No'
	@ 16,08 Say 'Curr'
	@ 16,18 Say 'Amount'
	@ 16,28 Say 'Exc.Rate'
	@ 16,41 Say 'Equivalent'

*--------------------------------------------------------------------------------------------------------
PROCEDURE _detail_nota()
	@ nRow,04 Say RIGHT('00'+ALLTRIM(STR(I)),2)
	@ nRow,08 Say SUBSTR(RTRIM(temp_detail.valas_code),1,6)
	@ nRow,13 Say TRANSFORM(nQty,"999,999,999")
	IF GetDecimalValue(nHarga) > 0
		DO CASE
			CASE nHarga < 100000 .AND. nHarga > 10000
		    	@nRow,27 Say TRANSFORM(nHarga)
			CASE nHarga < 10000 .AND. nHarga > 1000
		    	@nRow,28 Say TRANSFORM(nHarga)		
			CASE nHarga < 1000 .AND. nHarga > 100
		    	@nRow,29 Say TRANSFORM(nHarga)		 
			CASE nHarga < 100 .AND. nHarga > 10
				@nRow,30 Say TRANSFORM(nHarga)
			OTHERWISE
				@nRow,31 Say TRANSFORM(nHarga)				
		ENDCASE
	ELSE
	    @nRow,25 Say TRANSFORM(nHarga,"999,999,999")
	ENDIF	
*!*		IF GetDecimalValue((nHarga*nQty)) > 0
*!*			@nRow,43 Say TRANSFORM(ROUND(nHarga*nQty,3),"999,999,999,999.999")
*!*		ELSE
		@nRow,36 Say TRANSFORM(nHarga*nQty,"999,999,999,999")
*!*		ENDIF

*--------------------------------------------------------------------------------------------------------
PROCEDURE _footer_nota()
	SELECT temp_header
	GO TOP
	_cash = temp_header.cash
	_transfer = temp_header.transfer
	
	@nRow,04 Say REPLICATE('�',nLebar)			
	nRow = nRow+1		
	
	@nRow,04 Say "Total " + "Rp." + PADL(TRANSFORM(subtot,"999,999,999,999"),15," ")
	IF _transfer > 0
		@nRow,29 Say "Transfer " + "Rp." + PADL(TRANSFORM(_transfer,"999,999,999,999"),15," ")
	ENDIF
	nRow = nRow+1		
	
	IF _cash > 0
		@nRow,04 Say "Cash  " + "Rp."  + PADL(TRANSFORM(_cash,"999,999,999,999"),15," ")
		IF ((_cash + _transfer) - subtot) > 0
			@nRow,29 Say "Return   " + "Rp." + PADL(TRANSFORM( (_cash + _transfer) - subtot ,"999,999,999"),15," ")
		ENDIF
		nRow = nRow+1
	ENDIF
	
	@nRow,04 Say "Attention : No Claim after leaving our counter."
	nRow = nRow+1
	@nRow,04 Say 'Saya menyatakan bahwa transaksi ini belum melebihi threshold'
	nRow = nRow+1
	@nRow,04 Say 'USD 25.000 dalam bulan ini dan akan menyertakan Underlying'
	nRow = nRow+1
	@nRow,04 Say 'yang sebenarnya jika melebihi'
	
	nRow = nRow+1
	@nRow,4 Say "Counter," + SPACE(8) + "Cashier," + SPACE(8) + "Customer,"
