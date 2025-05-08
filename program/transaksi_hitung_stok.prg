if type('konek') = 'N'
	if konek = 1					
		wait window nowait 'stok akhir : ' + alltrim(str(mtahun))	+ ' - ' + right('00'+alltrim(str(mbulan)),2)
		** stok awal bulan berjalan
		*************************************************************************
		xx=sqlexec(konek,'delete from st_valas where company_id = ?xCOMPANYID and st_year = ?mTahun and st_month = ?mbulan')
		do 'program\cek_error_sql_crud.prg'
		xx=SQLEXEC(konek,"SELECT IFNULL(MAX(id), 0) AS id FROM st_valas LIMIT 1","nmaxid")
		do 'program\cek_error_sql_crud.prg'
		_nextid = IIF(TYPE('nmaxid->id') <> 'U',IIF(TYPE('nmaxid->id') = 'C',VAL(nmaxid->id),nmaxid->id),0)
		text to m.lsql noshow
			set @rownr=?_nextid;
		endtext
		xx=sqlexec(konek,m.lsql)
		text to m.lsql noshow
			insert into st_valas(id,company_id,valas_id,st_year,st_month,qty_first,created,createdby)
			select @rownr:=@rownr+1 as id,
				   ?xCOMPANYID as company_id,
				   valas_id,
				   ?mTahun,
				   ?mbulan,
				   qty_last as qty_first,
				   ?datetime(),
				   ?xiduser
			from v_st3
			where company_id = ?xCOMPANYID
			and st_year = ?mTahun0
			and st_month = ?mbulan0
			and qty_last <> 0
			order by valas_id,st_year,st_month asc
		endtext
		xx=sqlexec(konek,m.lsql)
		do 'program\cek_error_sql_crud.prg'
		
		** transaksi beli/buy
		*************************************************************************		
		xx=SQLEXEC(konek,"SELECT IFNULL(MAX(id), 0) AS id FROM st_valas LIMIT 1","nmaxid")
		do 'program\cek_error_sql_crud.prg'
		_nextid = IIF(TYPE('nmaxid->id') <> 'U',IIF(TYPE('nmaxid->id') = 'C',VAL(nmaxid->id),nmaxid->id),0)
		text to m.lsql noshow
			set @rownr=?_nextid;
		endtext
		xx=sqlexec(konek,m.lsql)
		text to m.lsql noshow
			insert into st_valas(id,company_id,valas_id,st_year,st_month,qty_first,created,createdby)
			select @rownr:=@rownr+1 as id,
				   ?xCOMPANYID as company_id,
				   valas_id,
				   ?mTahun as st_year,
				   ?mbulan as st_month,
				   0 as qty_first,
				   ?datetime(),
				   ?xiduser
			from tr_detail
			left join tr_header
			on tr_detail.tr_id = tr_header.tr_id
			and tr_detail.tr_number = tr_header.tr_number
			where tr_header.company_id = ?xCOMPANYID 
			and tr_detail.company_id = ?xCOMPANYID
			and year(tr_header.tr_date) = ?mTahun
			and month(tr_header.tr_date) = ?mbulan
			and tr_header.tr_id = 1
			and tr_detail.tr_id = 1
			and tr_header.status = 3
			and tr_detail.status = 3
			and not exists(
				select valas_id from st_valas where company_id = ?xCOMPANYID and st_year = ?mTahun and st_month = ?mbulan and valas_id = tr_detail.valas_id
			)
			group by valas_id,st_year,st_month
			order by valas_id,st_year,st_month asc
		endtext
		xx=sqlexec(konek,m.lsql)
		do 'program\cek_error_sql_crud.prg'

		** stok awal bulan berikutnya
		*************************************************************************
		do case 
			case mbulan = 12
				mTahun0 = mTahun 
				mbulan0 = 12	
			case mbulan = 1
				mTahun0 = mTahun 
				mbulan0 = 1
			otherwise 
				mTahun0 = mTahun 
				mbulan0 = mbulan - 1			
		endcase 
		xx=sqlexec(konek,'delete from st_valas where company_id = ?xCOMPANYID and st_year = ?mTahun1 and st_month = ?mbulan1')
		do 'program\cek_error_sql_crud.prg'
		xx=SQLEXEC(konek,"SELECT IFNULL(MAX(id), 0) AS id FROM st_valas LIMIT 1","nmaxid")
		do 'program\cek_error_sql_crud.prg'
		_nextid = IIF(TYPE('nmaxid->id') <> 'U',IIF(TYPE('nmaxid->id') = 'C',VAL(nmaxid->id),nmaxid->id),0)
		text to m.lsql noshow
			set @rownr=?_nextid;
		endtext
		xx=sqlexec(konek,m.lsql)
		text to m.lsql noshow
			insert into st_valas(id,company_id,valas_id,st_year,st_month,qty_first,created,createdby)
			select @rownr:=@rownr+1 as id,
				   ?xCOMPANYID as company_id,
				   valas_id,
				   ?mTahun1 as st_year,
				   ?mbulan1 as st_month,
				   0 as qty_first,
				   ?datetime(),
				   ?xiduser
			from tr_detail
			left join tr_header
			on tr_detail.tr_id = tr_header.tr_id
			and tr_detail.tr_number = tr_header.tr_number
			where tr_header.company_id = ?xCOMPANYID
			and tr_detail.company_id = ?xCOMPANYID
			and year(tr_header.tr_date) = ?mTahun1
			and month(tr_header.tr_date) = ?mbulan1
			and tr_header.status = 3
			and tr_detail.status = 3
			and not exists(
				select valas_id from st_valas where company_id = ?xCOMPANYID and st_year = ?mTahun1 and st_month = ?mbulan1 and valas_id = tr_detail.valas_id
			)
			group by valas_id,st_year,st_month
			order by valas_id,st_year,st_month asc
		endtext
		xx=sqlexec(konek,m.lsql)
		do 'program\cek_error_sql_crud.prg'		
		*************************************************************************
		xx=SQLEXEC(konek,"SELECT IFNULL(MAX(id), 0) AS id FROM st_valas LIMIT 1","nmaxid")
		do 'program\cek_error_sql_crud.prg'
		_nextid = IIF(TYPE('nmaxid->id') <> 'U',IIF(TYPE('nmaxid->id') = 'C',VAL(nmaxid->id),nmaxid->id),0)
		text to m.lsql noshow
			set @rownr=?_nextid;
		endtext
		xx=sqlexec(konek,m.lsql)
		text to m.lsql noshow
			insert into st_valas(id,company_id,valas_id,st_year,st_month,qty_first,created,createdby)
			select @rownr:=@rownr+1 as id,
				   ?xCOMPANYID as company_id,
				   valas_id,
				   ?mTahun1 as st_year,
				   ?mbulan1 as st_month,
				   qty_last as qty_first,
				   ?datetime(),
				   ?xiduser
			from v_st3
			where company_id = ?xCOMPANYID
			and st_year = ?mTahun
			and st_month = ?mBulan
			and qty_last <> 0	
			order by valas_id,st_year,st_month asc
		endtext
		xx=sqlexec(konek,m.lsql)
		do 'program\cek_error_sql_crud.prg'
		wait clear 
	endif
endif
											