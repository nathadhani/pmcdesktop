#include 'include\PRINT.CH'
IF USED('Tmp1')
	SELECT Tmp1
	IF RECCOUNT() > 0			
		DO 'program\fungsi.prg'
		Cprinter=GETPRINTER()
		IF !EMPTY(Cprinter)		
			lCetak =  .F.		
			Tmp = temp_+SYS(2015)+'.prn'
			SET PRINTER TO NAME(cprinter)
			SET DEVICE TO FILE(Tmp)	
			SET CONSOLE OFF					
			DO _cetak_rate_dayli			
		ENDIF 	
	ENDIF
ENDIF 	

*--------------------------------------------------------------------------------------------------------
PROCEDURE _cetak_rate_dayli()
	IF .NOT. lCetak 
		@ 0,0 Say CHR(27) + 'C' + CHR(33) + CHR(27) + "x" + CHR(0) && Buat kembali ke posisi 33 baris dan Draft Mode
		lCetak = .T.
	ELSE 
		@ 0,0 Say CHR(27) + 'C' + CHR(66) + CHR(27) + "x" + CHR(0) && Buat kembali ke posisi 66 baris dan Draft Mode
	ENDIF 							
	_pjggaris = 130
	SELECT Tmp1			
	GO TOP 			
	_nbaris = 1
	DO WHILE !EOF()
		IF _nbaris = 1 
			DO _header_rekap_title
			DO _header_rekap_title_kolom
			nRow = 7
		ENDIF 
		_nbaris = _nbaris + 1			
		DO _detail_rekap_kiri	
		
		SELECT Tmp2		
		GO TOP 			
		LOCATE FOR urut = Tmp1->urut
		IF FOUND()
			DO _detail_rekap_kanan
		ENDIF 
		
		nRow = nRow + 1		
		SELECT Tmp1
		SKIP
	ENDDO
	DO _footer_rekap
	SET DEVICE TO SCREEN
	xx = FILETOSTR(Tmp) 
	???xx+CHR(13) && fungsi cetak ke printer
	EJECT && pindah baris di setiap akhir halaman 
	SET PRINTER TO	
	SET CONSOLE ON		

*--------------------------------------------------------------------------------------------------------
PROCEDURE _header_rekap_title()
	@ 01,04 Say fKECIL10() + IIF(TYPE('xNAMAUSAHA')='C',RTRIM(xNAMAUSAHA),'') + fKECIL10()
	@ 02,04 Say fKECIL10() + IIF(TYPE('xALMTUSAHA1')='C',RTRIM(xALMTUSAHA1),'') + fKECIL10()		
	@ 03,04 Say fKECIL10() + 'KURS VALUTA ASING' + fKECIL10() 	
	@ 03,82 Say fKECIL10() + 'Rate Tanggal : ' + CTgl + fKECIL10() 	

*--------------------------------------------------------------------------------------------------------
PROCEDURE _header_rekap_title_kolom()
	@ 4,4  Say REPLICATE('Ä',_pjggaris)					
	@ 5,4  Say '#'
	@ 5,7  Say 'Valas'	
	@ 5,17 Say 'Harga Beli'		
	@ 5,34 Say 'Per'
	@ 5,41 Say 'Harga Jual'
	@ 5,56 Say 'Per'	
	
	@ 5,62 Say '#'
	@ 5,65 Say 'Valas'
	@ 5,75 Say 'Harga Beli'					
	@ 5,91 Say 'Per'							
	@ 5,99 Say 'Harga Jual'
	@ 5,115 Say 'Per'
	@ 6,4 Say REPLICATE('Ä',_pjggaris)

*--------------------------------------------------------------------------------------------------------
PROCEDURE _detail_rekap_kiri()
	_no         = Tmp1->no
	_valascode  = RTRIM(Tmp1->valas_code)
	_beli1      = Tmp1->rate_buy
	_per1       = Tmp1->difference_buy
	_jual1      = Tmp1->rate_sale
	_per2       = Tmp1->difference_sale

	@ nRow,04 Say TRANSFORM(_no,"99")
	@ nRow,07 Say _valascode
	@ nRow,13 Say _beli1	   											   											
	@ nRow,30 Say TRANSFORM(_per1,"999,999")
	@ nRow,37 Say _jual1		
	@ nRow,52 Say TRANSFORM(_per2,"999,999")				

*--------------------------------------------------------------------------------------------------------
PROCEDURE _detail_rekap_kanan()
	_no         = Tmp2->no
	_valascode  = RTRIM(Tmp2->valas_code)
	_beli1      = Tmp2->rate_buy
	_per1       = Tmp2->difference_buy
	_jual1      = Tmp2->rate_sale
	_per2       = Tmp2->difference_sale
	
	@ nRow,62  Say TRANSFORM(_no,"99")
	@ nRow,65  Say _valascode
	@ nRow,71 Say _beli1	   											   											
	@ nRow,87 Say TRANSFORM(_per1,"999,999")
	@ nRow,95 Say _jual1		
	@ nRow,111 Say TRANSFORM(_per2,"999,999")					
	
	
*--------------------------------------------------------------------------------------------------------	
PROCEDURE _footer_rekap()
	@ nRow,4  Say REPLICATE('Ä',_pjggaris)	
	nRow = nRow + 1			
	mNamaHari = PROPER(fGethari(DATE()))	
	mNamabulan = PROPER(fGetbulan(MONTH(DATE())))		
	@ nRow,4  Say 'Diinput Oleh : ' + _AUTHOR + SPACE(4) + ' Dicetak Tanggal : '+ mNamaHari + ',' + SPACE(1) + SUBSTR(DTOS(DATE()),7,2) + SPACE(1) + ;									 
									  mNamabulan + SPACE(1) + SUBSTR(DTOS(DATE()),1,4) + SPACE(1) + TIME() 

