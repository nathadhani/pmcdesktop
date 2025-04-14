*LOCAL ARRAY laError[1]
*=MESSAGEBOX(laError[1,2],16,"Error " + TRANSFORM(laError[5]),5000)     

=AERROR(laError)
=MESSAGEBOX(laerror[2],16,"Error " + TRANSFORM(laError[5]),5000)

SET CENTURY ON
SET DATE DMY
Fl_Err = 'errorsql.err'
xString = CHR(13) + CHR(10) +;
		  'error code : ' + TRANSFORM(laError[5]) + CHR(13) + CHR(10) +;
		  'error message : ' + laerror[2] + CHR(13) + CHR(10) +;
		  'time smap : ' + TTOC(DATETIME())		  
=StrToFile(xString,Fl_Err,1)
