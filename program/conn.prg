PUBLIC konek
konek = 0
hname = '127.0.0.1'
codbc_mySQL = '{MySQL ODBC 8.0 Unicode Driver}'
*codbc_mySQL = '{MySQL ODBC 5.3 Unicode Driver}'
db 	  = 'dbpos'
cpass = 'vunrtmry007'
cuser = 'root'
dsn	  = "DRIVER=&codbc_mySQL;" + ;
		"PORT=3306;" +;
		"DATABASE=&db;" +;
		"SERVER=&hname;" +;					
		"Uid=&cuser;" +;
	    "PWD=&cpass;"	 
	    
=SQLSETPROP(0,"DispLogin",3)
STORE SQLSTRINGCONNECT(dsn) TO konek
IF konek <= 0 THEN
   DO 'program\cek_error_sql.prg'
   CLOSE ALL
   QUIT
   CLEAR EVENTS                                
ENDIF
IF konek = 1
	PUBLIC temp_
	temp_ = FULLPATH('temp')
	IF !DIRECTORY(temp_)
		MD (temp_)
	ENDIF
	temp_ = FULLPATH('temp\')		
ENDIF