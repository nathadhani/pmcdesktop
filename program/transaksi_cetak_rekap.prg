#include 'include\PRINT.CH'
IF USED('TmpCetak')
	SELECT TmpCetak
	IF RECCOUNT() > 0			
		DO 'program\fungsi.prg'
		Cprinter=GETPRINTER()
		IF !EMPTY(Cprinter)		
			lCetak =  .F.		
			Tmp = temp_+SYS(2015)+'.prn'
			SET PRINTER TO NAME(cprinter)
			SET DEVICE TO FILE(Tmp)	
			SET CONSOLE OFF					
			DO _cetak_rekap_harian			
		ENDIF 	
	ENDIF
	USE IN TmpCetak
ENDIF 	

*--------------------------------------------------------------------------------------------------------
PROCEDURE _cetak_rekap_harian()
	IF .NOT. lCetak 
		@ 0,0 Say CHR(27) + 'C' + CHR(33) + CHR(27) + "x" + CHR(0) && Buat kembali ke posisi 33 baris dan Draft Mode
		lCetak = .T.
	ELSE 
		@ 0,0 Say CHR(27) + 'C' + CHR(66) + CHR(27) + "x" + CHR(0) && Buat kembali ke posisi 66 baris dan Draft Mode
	ENDIF 							
	_pjggaris = 111
	SELECT TmpCetak			
	GO TOP 			
	_nbaris = 1
	_total_stkawal = 0
	_total_beli = 0
	_total_jual = 0
	_total_stkakhir = 0
	DO WHILE !EOF()
		IF _nbaris = 1 .OR. _nbaris = 19 .OR. _nbaris = 37
			DO _header_rekap_title
			DO _header_rekap_title_kolom
			nRow = 8
		ENDIF 
		_nbaris = _nbaris + 1			
		
		_no          = TmpCetak->no
		_valascode   = RTRIM(TmpCetak->valas_code)
		_stokawal    = TmpCetak->st_first_qty
		_stokawalrp  = TmpCetak->st_first_total
		_beli        = TmpCetak->qty_buy
		_belirp      = TmpCetak->total_buy
		_jual        = TmpCetak->qty_sale
		_jualrp      = TmpCetak->total_sale
		_stokakhir   = TmpCetak->st_last_qty
		_stokakhirrp = TmpCetak->st_last_total
		
		_total_stkawal = _total_stkawal + _stokawalrp
		_total_beli = _total_beli + _belirp
		_total_jual = _total_jual + _jualrp
		_total_stkakhir = _total_stkakhir + _stokakhirrp

		DO _detail_rekap		
	
		nRow = nRow + 1		
		SELECT TmpCetak
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
	@ 03,04 Say fKECIL10() + 'Rekap Transaksi Per ' + cetak_title_rekap_transaksi + fKECIL10()

*--------------------------------------------------------------------------------------------------------
PROCEDURE _header_rekap_title_kolom()
	*         1         2         3         4         5         6         7         8         9         10        11        12        13            
	*0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
    *           Stok Awal                   Beli                        Jual                        Stok Akhir
    *   No Curr Qty         Rupiah          Qty         Rupiah          Qty         Rupiah          Qty         Rupiah
	*   01 MYR  999,999,999 999,999,999,999 999,999,999 999,999,999,999 999,999,999 999,999,999,999 999,999,999 999,999,999,999
 	*----------------------------------------------------------------------------------------------------------------------------------
	@ 04,04  Say REPLICATE('-',_pjggaris)
		
	@ 05,12 Say 'Stok Awal'	
	@ 05,40 Say 'Beli'		
	@ 05,68 Say 'Jual'		
	@ 05,96 Say 'Stok Akhir'		

	@ 06,04 Say 'No'
	@ 06,07 Say 'Curr'

	** Stok Awal
	@ 06,12 Say 'Qty' 
	@ 06,24 Say 'Rupiah'	
	
	** Beli
	@ 06,40 Say 'Qty'
	@ 06,52 Say 'Rupiah'
	
	** Jual
	@ 06,68 Say 'Qty'
	@ 06,80 Say 'Rupiah'
	
	** Stok Akhir
	@ 06,96 Say 'Qty'
	@ 06,108 Say 'Rupiah'
	
	@ 07,04 Say REPLICATE('-',_pjggaris)

*--------------------------------------------------------------------------------------------------------
PROCEDURE _detail_rekap()
	@ nRow,04 Say TRANSFORM(_no,"99")
	@ nRow,07 Say _valascode
	
	@ nRow,12 Say TRANSFORM(_stokawal,"999,999,999")									   											
	@ nRow,24 Say TRANSFORM(_stokawalrp,"999,999,999,999")

	@ nRow,40 Say TRANSFORM(_beli,"999,999,999")									   											
	@ nRow,52 Say TRANSFORM(_belirp,"999,999,999,999")
	
	@ nRow,68 Say TRANSFORM(_jual,"999,999,999")									   											
	@ nRow,80 Say TRANSFORM(_jualrp,"999,999,999,999")
	
	@ nRow,96 Say TRANSFORM(_stokakhir,"999,999,999") 											   											
	@ nRow,108 Say TRANSFORM(_stokakhirrp,"999,999,999,999")
	
*--------------------------------------------------------------------------------------------------------	
PROCEDURE _footer_rekap()
	@ nRow,04  Say REPLICATE('-',_pjggaris)	
	nRow = nRow + 1			
	@ nRow,04 Say 'Stok Awal Rp.  ' + TRANSFORM(_total_stkawal,"999,999,999,999")
	@ nRow,40 Say 'Beli Rp. ' + TRANSFORM(_total_beli,"999,999,999,999")
	@ nRow,80 Say 'Per. ' + DTOC(DATE()) + SPACE(1) + TIME()
	nRow = nRow + 1			
	@ nRow,04 Say 'Stok Akhir Rp. ' + TRANSFORM(_total_stkakhir,"999,999,999,999")
	@ nRow,40 Say 'Jual Rp. ' + TRANSFORM(_total_jual,"999,999,999,999")
	@ nRow,80 Say 'Mengetahui, '	
