lBuka = .F.
IF FILE('C:\xampp\mysql\bin\MySQLDump.exe')
	Buka  = 'C:\xampp\mysql\bin\' 
	lBuka = .T.
ELSE
	IF FILE('D:\xampp\mysql\bin\MySQLDump.exe')
		Buka  = 'D:\xampp\mysql\bin\'
		lBuka = .T.
	ELSE	
		IF FILE('E:\xampp\mysql\bin\MySQLDump.exe')
			Buka  = 'E:\xampp\mysql\bin\'
			lBuka = .T.		
		ENDIF 	
	ENDIF
ENDIF	
IF lBuka = .T.
	cUser  = 'root'
	cPas   = 'vunrtmry007'
	cDb    = 'money_changer'
	cFolder = 'logs\'	
	flNM   = 'restore.sql'
	cMyFile = (cFolder)+(flNM)	             
	IF FILE(cMyFile)	
		myFileBytes=IIF(ADIR(myDir,(cMyFile))=1,myDir(1,2),0)
		IF myFileBytes > 0		
			mExecute = Buka+"mysql -u&cUser -p&cPas &cDb < &cMyFile"
			EXECSCRIPT('! ' + mExecute)
		ENDIF		
	ENDIF	
ENDIF 	


