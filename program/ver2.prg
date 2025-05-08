IF .NOT. AppMutex()
	CLOSE ALL
	QUIT
	CLEAR EVENTS
ELSE
	PUBLIC versi01 AS Character
	versi01 = 'T' && new version
	
	PUBLIC ltglexp
	ltglexp = VAL(DTOS(DATE()))
	
	PUBLIC cKey AS Character
	cKey = '041D-2969' && Acer
	*cKey = '30D7-5545' && DMA		
	*cKey = 'E048-F9C8' && PERMATA VALAS UTAMA 17-03-2025
	*cKey = '6AFB-64FD' && INDOCEV CITRALAND 17-03-2025
	*cKey = '066F-95A1' && INDOCEV CILEGON 17-03-2025	
	*cKey = '909F-46BB' && INDOCEV SOETA T2 17-03-2025
	*cKey = '84CD-6381' && INDOCEV SOETA T3 17-03-2025
	*cKey = 'C002-28B8' && INDOCEV MEDAN 17-03-2025	
	*cKey = 'A46F-E4DC' && INDOCEV SURABAYA ATAS 17-03-2025
	*cKey = '6CAE-F2CD' && INDOCEV SURABAYA BAWAH 17-03-2025
	*cKey = 'EC12-BCD3' && INDOCEV SOLO 17-03-2025
	*cKey = 'F6F6-288E' && INDOCEV JOGJA 17-03-2025
	** ----------------------------------------------------------------------------------
	
	IF ReadSerialDiskDrive('C:\') <> cKey
		=StrToFile('apps error','temp\error.key',1)
		CLOSE ALL
		ON SHUTDOWN
		QUIT
		CLEAR EVENTS
	ELSE
		lexp = .T.
		IF VAL(DTOS(DATE())) > ltglexp
			=StrToFile('apps error','temp\error.exp',1)
			lexp = .F.
			CLOSE ALL
			ON SHUTDOWN
			QUIT
			CLEAR EVENTS
		ENDIF
		IF lexp = .T.
			WITH _SCREEN
				.VISIBLE=.F.
				.WINDOWSTATE=1
				.MINBUTTON=.F.
				.MAXBUTTON=.F.
				.CLOSABLE=.F.
				.CAPTION = 'Application'
			ENDWITH
			CLOSE ALL
			SET NEAR OFF
			SET TALK OFF
			SET STAT OFF
			SET SAFETY OFF
			SET DELETED ON 
			SET ESCAPE OFF
			SET SYSMENU OFF
			SET AUTOSAVE ON
			SET CPDIALOG OFF
			SET STATUS BAR ON
			PUSH MENU _MSYSMENU
			SET REPROCESS TO AUTOMATIC
			SET EXCLUSIVE OFF
			SET DELETED ON
			SET CENTURY ON 
			SET DATE DMY			
					
			Public fPath
			fPath = SYS(5)+SYS(2003)

			SET PATH TO (fPath)  ADDITIVE
			SET PATH TO ./CLASS,./FORM,./ICON,./REPORT,./PROGRAM,./TEXT

			RELEASE ALL
			ON ERROR DO pError WITH ERROR(),MESSAGE(),PROGRAM(),LINENO(),PROGRAM(1),LINENO(1)
			DO 'program\public_variabel.prg'
			DO 'program\fungsi.prg'
			DO 'program\conn.prg'
			IF TYPE('konek') = 'N'
				IF konek = 1
					DO FORM 'Form\frm_login.scx'
					READ EVENTS
					CLEAR EVENTS
					ON SHUTDOWN
					QUIT
				ELSE
					CLOSE ALL
					CLEAR EVENTS
					ON SHUTDOWN
					QUIT				
				ENDIF
			ELSE
				CLOSE ALL
				CLEAR EVENTS
				ON SHUTDOWN
				QUIT
			ENDIF			
		ENDIF
	ENDIF		 	
ENDIF
IF _VFP.Startmode = 4 && EXE or APP
	CLOSE ALL
	CLEAR ALL
	ON SHUTDOWN
	QUIT
ENDIF

PROCEDURE pError(xError,xMessage,xProgram,xLineno,xProgram1,xLineno1)
	IF TYPE('xProgram') = "C" AND TYPE('xLineNo') = "N"
	   IF xError=1705
	      lERROR = .T.
	      RETURN
	   ELSE
	      IF xERROR=2091 AND AT('.DBF',UPPER(xMESSAGE))>0
	         _POS1 = AT(' ',xMESSAGE,1)
	         _POS2 = AT(' ',xMESSAGE,2)         
	         _FileDBF_ = SUBSTR(xMESSAGE,_POS1+1,_POS2-_POS1-1)
	         _FileDBF_ = STRTRAN(_FileDBF_,"'","")
	         RETURN
	      ENDIF   
	   ENDIF
	   LOCAL Fl_Err,xString
	   *SET STEP ON 	   
   
	   SET CENTURY ON
	   SET DATE DMY
	   Fl_Err = 'error.err'
	   xString = "(" + LTRIM(STR(xError)) + ");" + xMessage + ";" + xProgram+ ";(" + LTRIM(STR(xLineno))+");" + ;
	             xProgram1 + ";(" + LTRIM(STR(xLineno1)) + ");" + TTOC(DATETIME()) + CHR(13) + CHR(10)
	   =StrToFile(xString,Fl_Err,1)
	ENDIF
	RETURN

FUNCTION AppMutex 
	DECLARE INTEGER CreateMutex IN WIN32API INTEGER, INTEGER, STRING @ 
	DECLARE INTEGER CloseHandle IN WIN32API INTEGER 
	DECLARE INTEGER GetLastError IN WIN32API 
	DECLARE INTEGER SetProp IN WIN32API INTEGER, STRING @, INTEGER 
	DECLARE INTEGER GetProp IN WIN32API INTEGER, STRING @ 
	DECLARE INTEGER RemoveProp IN WIN32API INTEGER, STRING @ 
	DECLARE INTEGER IsIconic IN WIN32API INTEGER 
	DECLARE INTEGER SetForegroundWindow IN WIN32API INTEGER 
	DECLARE INTEGER GetWindow IN WIN32API INTEGER, INTEGER 
	DECLARE INTEGER ShowWindow IN WIN32API INTEGER, INTEGER 
	DECLARE INTEGER GetDesktopWindow IN WIN32API 
	DECLARE LONG FindWindow IN WIN32API LONG, STRING 
	#DEFINE SW_RESTORE 9 
	#DEFINE ERROR_ALREADY_EXISTS 183 
	#DEFINE GW_HWNDNEXT 2 
	#DEFINE GW_CHILD 5 
	LOCAL llRetVal, lcExeFlag, lnExeHwnd, lnHwnd 
	lcExeFlag = STRTRAN(_screen.caption, " ", "") + CHR(0) 
	lnExeHwnd = CreateMutex(0, 1, @lcExeFlag) 
	IF GetLastError() = ERROR_ALREADY_EXISTS 
		lnHwnd = GetWindow(GetDesktopWindow(), GW_CHILD) 
		DO WHILE lnHwnd > 0 
			IF GetProp(lnHwnd, @lcExeFlag) = 1 
				IF IsIconic(lnHwnd) > 0 
					ShowWindow(lnHwnd, SW_RESTORE) 
				ENDIF 
				SetForegroundWindow(lnHwnd) 
				EXIT 
			ENDIF 
			lnHwnd = GetWindow(lnHwnd, GW_HWNDNEXT) 
		ENDDO 
		CloseHandle(lnExeHwnd) 
		llRetVal = .F. 
	ELSE 
		SetProp(FindWindow(0, _screen.caption), @lcExeFlag, 1) 
		llRetVal = .T. 
	ENDIF 
	RETURN llRetVal 
ENDFUNC 

FUNCTION ReadSerialDiskDrive()
	LPARAMETERS lDRIVE
	LOCAL lpRootPathName, ;
		 lpVolumeNameBuffer, ;
		 nVolumeNameSize, ;
		 lpVolumeSerialNumber, ;
		 lpMaximumComponentLength, ;
		 lpFileSystemFlags, ;
		 lpFileSystemNameBuffer, ;
		 nFileSystemNameSize

	lpRootPathName = lDRIVE && LTRIM(SYS(5))+"\"  && Drive and directory path (e.g.  C:\)
	lpVolumeNameBuffer = SPACE(256) && lpVolumeName return buffer
	nVolumeNameSize = 256 && Size of/lpVolumeNameBuffer
	lpVolumeSerialNumber = 0 && lpVolumeSerialNumber buffer
	lpMaximumComponentLength = 256
	lpFileSystemFlags = 0
	lpFileSystemNameBuffer = SPACE(256)
	nFileSystemNameSize = 256
	  
	DECLARE INTEGER GetVolumeInformation IN Win32API AS GetVolInfo ;
	 STRING @lpRootPathName, ;
	 STRING @lpVolumeNameBuffer, ;
	 INTEGER nVolumeNameSize, ;
	 INTEGER @lpVolumeSerialNumber, ;
	 INTEGER @lpMaximumComponentLength, ;
	 INTEGER @lpFileSystemFlags, ;
	 STRING @lpFileSystemNameBuffer, ;
	 INTEGER nFileSystemNameSize
		
	RetVal=GetVolInfo(@lpRootPathName, @lpVolumeNameBuffer, ;
					  nVolumeNameSize, @lpVolumeSerialNumber, ;
					  @lpMaximumComponentLength, @lpFileSystemFlags, ;
					  @lpFileSystemNameBuffer, nFileSystemNameSize)

	cSerial = TRANSFORM(lpVolumeSerialNumber,'@0x')  && convert it to hex XXXX-XXXX
	RETURN (SUBSTR(cSerial,3,4)+'-'+subSTR(cSerial,7,4)) && conver to string
	**Return lpVolumeSerialNumber (numeric) && conver to numeric