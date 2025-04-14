DO 'program\path.prg'

Function fGethari()
	Parameter chari
		Do case
		     case dow(chari) = 1
		          nmhari_    = "Minggu"
		     case dow(chari) = 2
		          nmhari_    = "Senin"
		     case dow(chari) = 3
		          nmhari_    = "Selasa"
		     case dow(chari) = 4
		          nmhari_    = "Rabu"
		     case dow(chari) = 5
		          nmhari_    = "Kamis"
		     case dow(chari) = 6
		          nmhari_    = "Jum'at"
		     case dow(chari) = 7
		          nmhari_    = "Sabtu"
		     otherwise
		          nmhari_    = ""
		Endcase
	Return nmhari_

Function fGetbulan()
	Parameter bulan
		Do case
			case bulan    = 1
			     nmbulan_ = "Jan"
			case bulan    = 2
			     nmbulan_ = "Peb"
			case bulan    = 3
			     nmbulan_ = "Mar"
			case bulan    = 4
			     nmbulan_ = "Apr"
			case bulan    = 5
			     nmbulan_ = "Mei"
			case bulan    = 6
			     nmbulan_ = "Juni"
			case bulan    = 7
			     nmbulan_ = "Juli"
			case bulan    = 8
			     nmbulan_ = "Agust"
			case bulan    = 9
			     nmbulan_ = "Sept"
			case bulan    = 10
			     nmbulan_ = "Okt"
			case bulan    = 11
			     nmbulan_ = "Nop"
			case bulan    = 12
			     nmbulan_ = "Des"
			otherwise
				 nmbulan_ = ""
		Endcase	
	Return nmbulan_
	
Function fGetbulan2()
	Parameter bulan
		Do case
			case bulan    = 1
			     nmbulan_ = "Januari"
			case bulan    = 2
			     nmbulan_ = "Pebruari"
			case bulan    = 3
			     nmbulan_ = "Maret"
			case bulan    = 4
			     nmbulan_ = "April"
			case bulan    = 5
			     nmbulan_ = "Mei"
			case bulan    = 6
			     nmbulan_ = "Juni"
			case bulan    = 7
			     nmbulan_ = "Juli"
			case bulan    = 8
			     nmbulan_ = "Agustus"
			case bulan    = 9
			     nmbulan_ = "September"
			case bulan    = 10
			     nmbulan_ = "Oktober"
			case bulan    = 11
			     nmbulan_ = "Nopember"
			case bulan    = 12
			     nmbulan_ = "Desember"
			otherwise
				 nmbulan_ = ""
		Endcase	
	Return nmbulan_	

Function fTEBAL()
	Return( CHR(27)+CHR(71) )

Function fUnTEBAL()
	Return( CHR(27)+CHR(72) )

Function fNORMAL10()
	Return( CHR(27)+CHR(80)+CHR(18) )

Function fNORMAL12()
	Return( CHR(27)+CHR(77)+CHR(18) )

Function fCONDEN10()
	Return( CHR(27)+CHR(80)+CHR(15) )
	
Function fCONDEN12()
	Return( CHR(27)+CHR(77)+CHR(15) )

Function fKECIL10()
	Return( CHR(27)+CHR(80)+CHR(15) )

Function fKECIL12()
	Return( CHR(27)+CHR(77)+CHR(15) )

Function fBESAR12()
	Return( CHR(27)+CHR(77)+CHR(18)+CHR(14) )

Function fUnBESAR12()
	Return( fNORMAL12() )

Function fBESAR10()
	Return( CHR(27)+CHR(80)+CHR(18)+CHR(14) )

Function fUnBESAR10()
	Return( fNORMAL10() )

Function fHiON()
	Return( CHR(27)+"w"+CHR(1) )

Function fHiOFF()
	Return( CHR(27)+"w"+CHR(0) )
	
Function fWideON()
	Return( CHR(27)+"W"+CHR(1) )
	
Function fWideOFF()
	Return( CHR(27)+"W"+CHR(0) )

Function fItalicON()
	Return( CHR(27)+"4" )

Function fItalicOFF()
	Return( CHR(27)+"5" )

Function fUnderON()
	Return( CHR(27)+"-"+CHR(1) )

Function fUnderOFF()
	Return( CHR(27)+"-"+CHR(0) )

Function DBF2Excel()
  Parameters tcCursorName, toSheet, tcTargetRange  
	  tcCursorName  = Iif(Empty(m.tcCursorName),Alias(),m.tcCursorName)
	  tcTargetRange = Iif(Empty(m.tcTargetRange),'A1',m.tcTargetRange)	  
  Local loConn As AdoDB.Connection, loRS As AdoDB.Recordset,;
	  lcTempRs, lcTemp, oExcel
	  lcTemp   = Forcepath(Sys(2015)+'.dbf',Sys(2023))
	  lcTempRs = Forcepath(Sys(2015)+'.rst',Sys(2023))	  
	  Select (m.tcCursorName)
	  Copy To (m.lcTemp)
	  loConn = Createobject("Adodb.connection")
	  loConn.ConnectionString = "Provider=VFPOLEDB;Data Source="+Sys(2023)
	  loConn.Open()
	  loRS = loConn.Execute("select * from "+m.lcTemp)
	  loRS.Save(m.lcTempRs)
	  loRS.Close
	  loConn.Close
	  Erase (m.lcTemp)
	  loRS.Open(m.lcTempRs)
  With toSheet
    .QueryTables.Add( loRS, .Range(m.tcTargetRange)).Refresh()
  Endwith 
  loRS.Close
  Erase (m.lcTempRs)

FUNCTION MsgBox()
	Parameter pesan
	msg = Messagebox(pesan,64,'message',5000)
	RETURN msg

Function GetDecimalValue()
	Parameter nVal
	mval = nVal - INT(nVal)
	gDecValue = INT(val(SUBSTR(TRANSFORM(mval),AT('.',TRANSFORM(mval),1)+1)))
	RETURN gDecValue
