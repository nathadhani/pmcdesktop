IF xx <= 0
	DO 'program\cek_error_sql.prg'
	=SQLROLLBACK(konek)
ELSE
   xx=SQLCOMMIT(konek)
   IF xx <= 0
	   DO 'program\cek_error_sql.prg'
   	   =SQLROLLBACK(konek)
   ENDIF					
ENDIF	    