log_ = FULLPATH('logs')
IF !DIRECTORY(log_)
	MD (log_)
ENDIF 

** Backup file .sql
** ------------------------------------------------------------
lBuka = .F.
DO CASE
	CASE FILE('E:\xampp\mysql\bin\MySQLDump.exe')
		Buka  = 'E:\xampp\mysql\bin\'
		lBuka = .T.		
	CASE FILE('E:\apps\db\mysql\bin\MySQLDump.exe')
		Buka  = 'E:\apps\db\mysql\bin\'
		lBuka = .T.
	CASE FILE('E:\server\mysql\bin\MySQLDump.exe')
		Buka  = 'E:\server\mysql\bin\'
		lBuka = .T.			
ENDCASE
IF lBuka = .T.
	**-- User password akses database
	cUser  = 'root'
	cPas   = 'vunrtmry007'
	cDb    = 'money_changer'
	
	**-- paramater nama file
	SET CENTURY ON
	SET DATE DMY 	
	destBACKUP = 'logs\'
	strNM = STRTRAN(STRTRAN(STRTRAN(TTOC(DATETIME()), ':', ''), '/',''), ' ', '_') + '_' + STRTRAN(SYS(2015),'_','')
	rarNM = (destBACKUP) + strNM + '.log'
	flNM   = strNM + '.sql'
	cFilename = (destBACKUP) + (flNM)	             
	
	**-- Backup all tabel ke dalam satu file .sql
	mExecute   = Buka + "mysqldump -u&cUser -p&cPas &cDb > &cFilename"
	EXECSCRIPT('! ' + mExecute)	
	
	**-- add file to arcive rar.exe
	IF FILE(cFilename)
*!*			IF ADIR(arArrayName, cFilename) = 1
*!*			    myFileBytes= arArrayName(2) && or more clearly arArrayName[1,2]
*!*			ENDIF
*!*			IF myFileBytes > 0		
			WAIT WINDOW 'backup data......' NOWAIT			
			mPass = 'jurukunci66'
			*fRAR  = "Rar.exe A -Y -RR -S -EP -CFG -M5 -DF -P&mPass "+rarNM+" "+cFilename+""
			fRAR  = "Rar.exe A -Y -RR -S -EP -CFG -M5 -DF -P&mPass &rarNM &cFilename"
			EXECSCRIPT('! ' + fRAR)
*!*			ENDIF 
	ENDIF	
ENDIF 	

** Backup masing2 table ke file .sql
** ------------------------------------------------------------
*!*		tbl1  = 'finance_account'
*!*		tbl2  = 'finance_detail'
*!*		tbl3  = 'finance_header'
*!*		tbl4  = 'kurs_daily'
*!*		tbl5  = 'm_company'
*!*		tbl6  = 'm_country'
*!*		tbl7  = 'm_customer'
*!*		tbl8  = 'm_customer_action'
*!*		tbl9  = 'm_customer_category'
*!*		tbl10 = 'm_customer_data'
*!*		tbl11 = 'm_customer_profesi'
*!*		tbl12 = 'm_customer_type'
*!*		tbl13 = 'm_customer_work'
*!*		tbl14 = 'm_level'
*!*		tbl15 = 'm_status'
*!*		tbl16 = 'm_transaction'
*!*		tbl17 = 'm_user'
*!*		tbl18 = 'm_valas'
*!*		tbl19 = 'tr_detail'
*!*		tbl20 = 'tr_header'
*!*		tbl21 = 'tr_transfer'
*!*		FOR i = 1 TO 21
*!*			xi = alltrim(str(i))			
*!*			sqlFile = (destBACKUP)+ tbl&xi + '_' + SUBSTR(SYS(2015),2,9) + '.sql'
*!*			mExecute = Buka+"mysqldump -u&cUser -p&cPas &cDb &tbl&xi > &sqlFile"
*!*			EXECSCRIPT('! ' + mExecute)			
*!*			IF FILE(sqlFile)		
*!*				myFileBytes=IIF(ADIR(myDir,(sqlFile))=1,myDir(1,2),0)
*!*				IF myFileBytes > 0	
*!*				    WAIT WINDOW 'tunggu sedang proses data ......' NOWAIT
*!*					mPass = 'jurukunci66'
*!*					fRAR  = "Rar.exe A -Y -RR -S -EP -CFG -M5 -DF -P&mPass" + SPACE(1) + rarNM + SPACE(1) + sqlFile
*!*					EXECSCRIPT('! ' + fRAR)
*!*				ENDIF 	
*!*			ENDIF				
*!*		ENDFOR


** Backup file .csv
** ------------------------------------------------------------
*!*	flNM1  = 'finance_account'
*!*	flNM2  = 'finance_detail'
*!*	flNM3  = 'finance_header'
*!*	flNM4  = 'kurs_daily'
*!*	flNM5  = 'm_company'
*!*	flNM6  = 'm_country'
*!*	flNM7  = 'm_customer'
*!*	flNM8  = 'm_customer_action'
*!*	flNM9  = 'm_customer_category'
*!*	flNM10 = 'm_customer_data'
*!*	flNM11 = 'm_customer_profesi'
*!*	flNM12 = 'm_customer_type'
*!*	flNM13 = 'm_customer_work'
*!*	flNM14 = 'm_level'
*!*	flNM15 = 'm_status'
*!*	flNM16 = 'm_transaction'
*!*	flNM17 = 'm_user'
*!*	flNM18 = 'm_valas'
*!*	flNM19 = 'tr_detail'
*!*	flNM20 = 'tr_header'
*!*	flNM21 = 'tr_transfer'

*!*	FOR i = 1 TO 21
*!*		xi = alltrim(str(i))
	
*!*		_table = "SELECT * FROM " + flNM&xi
*!*		_to    = (destBACKUP) + flNM&xi + '_' + SUBSTR(SYS(2015),2,9)
*!*		=SQLEXEC(KONEK,_table,'Tmp')
*!*		IF USED('Tmp')
*!*			SELECT Tmp
*!*			IF RECCOUNT() > 0
*!*				COPY TO &_to TYPE CSV 
*!*				cFilename&xi = _to + '.csv'
*!*				IF FILE(cFilename&xi)		
*!*					myFileBytes=IIF(ADIR(myDir,(cFilename&xi))=1,myDir(1,2),0)
*!*					IF myFileBytes > 0	
*!*					    WAIT WINDOW 'tunggu sedang proses data ......' NOWAIT
*!*						mPass = 'jurukunci66'
*!*						fRAR  = "Rar.exe A -Y -RR -S -EP -CFG -M5 -DF -P&mPass" + SPACE(1) + rarNM + SPACE(1) + cFilename&xi
*!*						EXECSCRIPT('! ' + fRAR)
*!*					ENDIF 	
*!*				ENDIF				
*!*			ENDIF
*!*			USE IN Tmp
*!*		ENDIF  
*!*	ENDFOR

*!*	LOCAL ltMessageTimeOut
*!*	m.ltMessageTimeOut = DATETIME() + 5
*!*	DO WHILE DATETIME() < m.ltMessageTimeOut
*!*	    WAIT WINDOW 'tunggu sedang proses data ...... ' NOCLEAR TIMEOUT 5
*!*		WAIT CLEAR
*!*	ENDDO
