public xcompanyid
xcompanyid = 0

*--------------------------------------------------------------------------------------
** variable user
public xuserdeveloper
xuserdeveloper = 'dh@n!22'

public xusername, xpasuser
xusername = ''
xpasuser  = ''

public xiduser, xnmuser, xlevel, xusergroup
xiduser = 0
xnmuser = ''
xlevel = 0
xusergroup = 0

public xidkonter, xnmkonter 
xidkonter = 0
xnmkonter = ''	

public xidkasir, xnmkasir
xidkasir = 0
xnmkasir = ''

public xinsert, xupdate, xdelete, xcancel
xinsert = ''
xupdate = ''
xdelete = ''
xcancel = ''
** end variable user
*--------------------------------------------------------------------------------------

*--------------------------------------------------------------------------------------
** variable transaction buy / sell
public lkonter
lkonter = .f.

public lclosing
lclosing = .f.		

public cetak_title_rekap_transaksi as character
cetak_title_rekap_transaksi = ''	
	
public mjnsid as number
mjnsid = 0
	
public getuserid, getlevelid as number
getuserid = 0
getlevelid = 0

public getvalasid as number
getvalasid = 0
 
public getnegaraid as number
getnegaraid = 0

public getcustid,;
	   getcustrelasi_id,;
	   getworkid as number
getcustid = 0
getcustrelasi_id = 0
getworkid = 0

public getstatusid
getstatusid = 0

public mkata, mhandphone, mkodevls, getnoid, getkode, getaction as character				
mkata      = ''
mhandphone = ''			
mkodevls   = ''	
getnoid    = ''
getkode    = ''
getaction  = ''	

public ldata_pelanggan, ljualbeli, ldata_valas 
ldata_pelanggan = .f.
ljualbeli = .f.
ldata_valas = .f.

public _namanegara, _namapekerjaan, _namapelanggan as character
_namanegara     = ''
_namapekerjaan  = ''
_namapelanggan  = ''	
** end variable transaction buy / sell
*--------------------------------------------------------------------------------------

*--------------------------------------------------------------------------------------
** variable transaction kas / bank
public getcb_id as number
getcb_id = 0

public getcb_pos_id as number
getcb_pos_id = 0

** end variable transaction kas / bank
*--------------------------------------------------------------------------------------
	
public mtahun, mbulan, mtahun0, mbulan0, mhari as number 
mtahun = year(date())
mbulan = month(date())
mhari  = day(date())
if mbulan = 1
	mtahun0 = mtahun - 1
	mbulan0 = 12
else
	mtahun0 = mtahun 
	mbulan0 = mbulan - 1	
endif 		

public warna1, warna2, warna3, warna4	
*warna1 = rgb(52,73,94)
*warna2 = rgb(143,193,62)
warna1 = rgb(143,193,62)
warna2 = rgb(52,73,94)
	
public warna_tombol, warna_tombol_simpan
warna_tombol = rgb(139,157,195)
warna_tombol_simpan = rgb(139,157,195)

public warna_grid_highlightbackcolor, warna_grid_highlightforecolor
warna_grid_highlightbackcolor = rgb(255,255,0)
warna_grid_highlightforecolor = rgb(0,0,0)

public lmenuof as logical
