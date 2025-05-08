GO TOP
gnFieldcount = AFIELDS(gaMyArray)  && Create array.
FOR nCount = 1 TO gnFieldcount 
	lnFieldname = gaMyArray(nCount,1) && Display field name.
	DO CASE 
   		CASE gaMyArray(nCount,2) = 'C' && Display field type.
   			REPLACE ALL &lnFieldname WITH '' FOR ALLTRIM(&lnFieldname) = '.NULL.'
   			REPLACE ALL &lnFieldname WITH '' FOR ISNULL(&lnFieldname) 
   			REPLACE ALL &lnFieldname WITH ALLTRIM(&lnFieldname)
   		CASE gaMyArray(nCount,2) = 'N' && Display field type.
   			REPLACE ALL &lnFieldname WITH 0 FOR ISNULL(&lnFieldname) 
   		CASE gaMyArray(nCount,2) = 'T' && Display field type.
   			REPLACE ALL &lnFieldname WITH CTOT("0000-00-00T00:00:00") FOR ISNULL(&lnFieldname) 
   		CASE gaMyArray(nCount,2) = 'D' && Display field type.
   			REPLACE ALL &lnFieldname WITH CTOT(" / / ") FOR ISNULL(&lnFieldname)
		CASE gaMyArray(nCount,2) = 'I' && Display field type.
	   		REPLACE ALL &lnFieldname WITH 0 FOR ISNULL(&lnFieldname)
		CASE gaMyArray(nCount,2) = 'M' && Display field type.
   			REPLACE ALL &lnFieldname WITH '' FOR ISNULL(&lnFieldname) 
   	ENDCASE 
ENDFOR
GO TOP
