Bagian = "000"
Kata   = ""
BlnK   = "0000000000"
HRG2   = STR((MAUKATA*-1),11)
R      = at("-",HRG2)
IF R>1
   Hrg = SUBSTR(BlnK,1,(R-1))+SUBSTR(HRG2,(R+1),(11-R))
ELSE
   Hrg = SUBSTR(HRG2,2,10)
ENDIF
LBR     = len(Hrg)
PUTARAN = int(LBR/3)
LOP1    = PUTARAN*3
SISA    = LBR-LOP1
PUTARAN = PUTARAN+1
IF SISA#0
   IF SISA=1
      Bagian = "00"+SUBSTR(Hrg,1,1)
   ENDIF
   IF SISA=2
      Bagian = "0"+SUBSTR(Hrg,1,2)
   ENDIF
ENDIF
CEK = 0
DO WHILE .t.
   HBS = 0
   IF VAL(Bagian)#0
      Bagian1 = SUBSTR(Bagian,1,1)
      IF Bagian1#"0"
         IF Bagian1#"1"
            LEB  = SUBSTR(LEBAR,&Bagian1,1)
            AWAL = STR((&Bagian1*9-8),2)
            KATA = KATA+SUBSTR(BIL,&AWAL,&LEB)
            KATA = KATA+"Ratus "
         ELSE
            KATA = KATA+"Seratus "
         ENDIF
      ENDIF
      Bagian1 = SUBSTR(Bagian,2,1)
      IF Bagian1#"0"
         IF Bagian1#"1"
            LEB  = SUBSTR(LEBAR,&Bagian1,1)
            AWAL = STR((&Bagian1*9-8),2)
            KATA = KATA+SUBSTR(BIL,&AWAL,&LEB)
            KATA = KATA+"Puluh "
         ELSE
            Bagian1 = SUBSTR(Bagian,3,1)
            IF Bagian1="0"
               KATA = KATA+"Sepuluh "
            ELSE
               IF Bagian1="1"
                  KATA = KATA+"Sebelas "
               ELSE
                  LEB  = SUBSTR(LEBAR,&Bagian1,1)
                  AWAL = STR((&Bagian1*9-8),2)
                  KATA = KATA+SUBSTR(BIL,&AWAL,&LEB)
                  KATA = KATA+"Belas "
               ENDIF
            ENDIF
            HBS = 3
         ENDIF
      ENDIF
      IF HBS=0
         Bagian1 = SUBSTR(Bagian,3,1)
         IF VAL(Bagian1)#0
            IF VAL(Bagian)=1 .AND. PUTARAN=2
               KATA = KATA+"Se"
            ELSE
               LEB  = SUBSTR(LEBAR,&Bagian1,1)
               AWAL = STR((&Bagian1*9-8),2)
               KATA = KATA+SUBSTR(BIL,&AWAL,&LEB)
            ENDIF
         ENDIF
      ELSE
         HBS = 0
      ENDIF
      IF PUTARAN=4
         KATA = KATA+"Milyar "
      ELSE
         IF PUTARAN=3
            KATA = KATA+"Juta "
         ELSE
            IF PUTARAN=2
               KATA = KATA+"Ribu "
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   PUTARAN = PUTARAN-1
   IF PUTARAN<=0
      EXIT
   ELSE
      IF PUTARAN#1
         IF PUTARAN#2
            Bagian = SUBSTR(Hrg,2,3)
         ELSE
            Bagian = SUBSTR(Hrg,5,3)
         ENDIF
      ELSE
         Bagian = SUBSTR(Hrg,8,3)
      ENDIF
   ENDIF
ENDDO
