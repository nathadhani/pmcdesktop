mkodevls = '' && buat ngetes per kode valas
if type('konek') = 'N'
	if konek = 1
		set date dmy
		ntgl1 = ctod('01/'+right('00'+alltrim(str(mbulan)),2)+'/'+alltrim(str(mtahun))) && tanggal satu di bulan yang input		
		
		text to m.lsql noshow
			delete from st_valas_avg 
			where company_id = ?xcompanyid
			and year(st_date) = ?mtahun 
			and month(st_date) = ?mbulan
		endtext
		xx=sqlexec(konek,m.lsql)
		do 'program\cek_error_sql_crud.prg'
		
		do get_saldoawal
		=paramtgl('get_transaksi')
		
		text to m.lsql noshow
			update st_valas_avg set profit = total_sale  - total_sale_average
			where company_id = ?xcompanyid
			and year(st_date) = ?mtahun	
			and month(st_date) = ?mbulan
			and total_sale_average > 0
		endtext 
		xx=sqlexec(konek,m.lsql)
		do 'program\cek_error_sql_crud.prg'

		text to m.lsql noshow
			delete from st_valas_avg 
			where company_id = ?xcompanyid
			and qty_buy + qty_sale + st_last_qty = 0
		endtext
		xx=sqlexec(konek,m.lsql)
		do 'program\cek_error_sql_crud.prg'

		text to m.lsql noshow
			update st_valas_avg 
			set created = ?datetime(), 
			createdby = ?xiduser 
			where company_id = ?xcompanyid 
			and year(st_date) = ?mtahun 
			and month(st_date) = ?mbulan
		endtext
		xx=sqlexec(konek,m.lsql)
		do 'program\cek_error_sql_crud.prg'
		wait clear 
	endif 	
endif

** data saldo awal
** ------------------------------------------------------------------------------------------------------------------------------------------ 
procedure get_saldoawal()
	text to m.lsql noshow
		select id as valas_id, valas_code, valas_name from m_valas order by valas_id asc
	endtext 
	xx=sqlexec(konek,m.lsql,'tmpawal')
	if xx <= 0 then
	   do 'program\cek_error_sql.prg'	
	endif	
	if used('tmpawal')
		if reccount('tmpawal') > 0		
			select tmpawal
			go top 
			nrek = 0
			_recount = reccount()
			do while .not. eof()
				_id 		= 1			
				_tanggal    = substr(dtos(ntgl1),1,4)+"-"+substr(dtos(ntgl1),5,2)+"-"+substr(dtos(ntgl1),7,2)
				_valasid    = tmpawal->valas_id
				_valascode  = substr(alltrim(tmpawal->valas_code),1,len(alltrim(tmpawal->valas_code)))
				_valasname  = alltrim(tmpawal->valas_name)
				
				nrek = nrek + 1
				wait window nowait 'stok awal : ' + _valascode + ' | tanggal : ' + _tanggal + ' | reccord :' +	alltrim(str(nrek)) + ' / ' + alltrim(str(_recount))

				select tmpawal
				if .not. empty(mkodevls)
					if len(mkodevls) > 3
						if .not. _valascode $ mkodevls
							skip 
							loop
						endif	
					else
						if .not. _valascode == mkodevls
							skip 
							loop
						endif							
					endif
				endif													   
				
				_saldo_awal_qty   = 0
				_saldo_awal_harga = 0
				_saldo_awal_total = 0
				text to m.lsql noshow
					select max(st_date) as maxdate 
					from st_valas_avg 
					where company_id = ?xcompanyid 
					and valas_id = ?_valasid 
					and year(st_date) = ?mtahun0 
					and month(st_date) = ?mbulan0 
					limit 1
				endtext
				xx=sqlexec(konek,m.lsql,'tmptglmax')
				if used('tmptglmax')
					select tmptglmax
					if reccount() > 0
						do 'program\update_field.prg'	
						go top
						nmaxtgl = tmptglmax->maxdate
						text to m.lsql noshow
							select max(id) as maxid 
							from st_valas_avg 
							where company_id = ?xcompanyid 
							and valas_id = ?_valasid
							and st_date = ?nmaxtgl
							limit 1
						endtext
						xx=sqlexec(konek,m.lsql,'tmpmaxid')
						if used('tmpmaxid')
							select tmptglmax
							if reccount() > 0
								do 'program\update_field.prg'
								go top
								nmaxid = tmpmaxid->maxid
								text to m.lsql noshow
									select 
										valas_id,
										st_last_qty,
										st_last_price,
										st_last_total												
									from st_valas_avg
									where company_id = ?xcompanyid
									and valas_id = ?_valasid 
									and st_date = ?nmaxtgl
									and id = ?nmaxid 
								endtext
								xx=sqlexec(konek,m.lsql,'tmpsawal')
								if xx <= 0 then
								do 'program\cek_error_sql.prg'	
								endif	
								if used('tmpsawal')
									if reccount('tmpsawal') > 0
										_saldo_awal_qty   = tmpsawal->st_last_qty
										_saldo_awal_harga = tmpsawal->st_last_price
										_saldo_awal_total = tmpsawal->st_last_total
									endif 
									use in tmpsawal
								endif
							endif	
						    use in tmpmaxid
						endif						
					endif
					use in tmptglmax
				endif				 
				
				select tmpawal				
				if _saldo_awal_qty = 0
					skip 
					loop
				endif	
						
				text to m.lsql noshow
					insert into st_valas_avg(id,
										  st_date,
										  company_id,
										  valas_id,
										  buy_number,	
										  qty_buy,
										  price_buy,
										  total_buy,
										  sale_number,
										  qty_sale,
										  price_sale,
										  total_sale,										  
										  total_sale_average,
										  profit,										  
										  st_last_qty,
										  st_last_price,
										  st_last_total)
					values(?_id,
						   ?_tanggal,
						   ?xcompanyid,
						   ?_valasid,
						   '',
						   0,
						   0,
						   0,
						   '',
						   0,
						   0,
						   0,
						   0,
						   0,
						   ?_saldo_awal_qty,
						   ?_saldo_awal_harga,
						   ?_saldo_awal_total)
				endtext
				xx=sqlexec(konek,m.lsql)	
				do 'program\cek_error_sql_crud.prg'
				
				if tmpawal.valas_id = _valasid 
					skip
				else 
					select tmpawal
					skip 										
				endif															
			enddo			
		endif
		use in tmpawal
	endif
	
** data pembelian & penjualan
** ------------------------------------------------------------------------------------------------------------------------------------------ 
procedure get_transaksi()
	** transakasi pembelian
	** ---------------------------------------------------------------------------		
	text to m.lsql noshow
		select right(tr_number,4) as tr_number,
			   tr_date,
			   valas_id,
			   (select valas_code from m_valas where m_valas.id = tr_detail.valas_id limit 1) as valas_code,
			   (select valas_name from m_valas where m_valas.id = tr_detail.valas_id limit 1) as valas_name,	
			   sum(qty) as jumlah,	                
			   price
		from tr_detail 
		where company_id = ?xcompanyid 
		and tr_date = ?mtgl
		and status = 3
		and tr_id = 1		
		group by right(tr_number,4), valas_id, tr_date, price
		order by right(tr_number,4), valas_id asc 
	endtext 
	xx=sqlexec(konek,m.lsql,'tmpbeli')
	if xx <= 0 then
	   do 'program\cek_error_sql.prg'	
	endif	
	if used('tmpbeli')
		select tmpbeli
		if reccount() > 0		
			select tmpbeli
			go top 
			nrek = 0
			_recount = reccount()
			do while .not. eof()	
				_id        = 0			
				_tanggal    = substr(dtos(tmpbeli->tr_date),1,4)+"-"+substr(dtos(tmpbeli->tr_date),5,2)+"-"+substr(dtos(tmpbeli->tr_date),7,2)
				_valasid   = tmpbeli->valas_id
				_valascode = substr(alltrim(tmpbeli->valas_code),1,len(alltrim(tmpbeli->valas_code)))
				_valasname = alltrim(tmpbeli->valas_name)
				_tr_number = tmpbeli->tr_number		
				_jumlah    = tmpbeli->jumlah
				_harga     = tmpbeli->price
				_subtotal  = _jumlah * _harga
				
				nrek = nrek + 1
				wait window nowait 'transaksi beli : ' + _valascode + ' | tanggal : ' + mtgl + ' | reccord :' +	alltrim(str(nrek)) + ' / ' + alltrim(str(_recount))
				
				if .not. empty(mkodevls)
					if len(mkodevls) > 3
						if .not. upper(alltrim(_valascode)) $ upper(alltrim(mkodevls))
							skip 
							loop
						endif	
					else
						if .not. upper(alltrim(_valascode)) = upper(alltrim(mkodevls))
							skip 
							loop
						endif							
					endif
				endif
				
				xx=sqlexec(konek,"select max(id) as maxid from st_valas_avg where company_id = ?xcompanyid and valas_id = ?_valasid and st_date = ?mtgl","nmax")			
				if xx <= 0 then
				   do 'program\cek_error_sql.prg'	
				endif					
				if used('nmax')	
					if isnull(nmax->maxid)
						_id = 1
					else
						_id = nmax->maxid + 1  
					endif
				endif																
								
				text to m.lsql noshow
					insert into st_valas_avg(id,
										  st_date,
										  company_id,
										  valas_id,
										  buy_number,
										  qty_buy,
										  price_buy,
										  total_buy,
										  sale_number,
										  qty_sale,
										  price_sale,
										  total_sale,										  
										  total_sale_average,
										  profit,
										  st_last_qty,
										  st_last_price,
										  st_last_total)
					values(?_id,
						   ?_tanggal,
						   ?xcompanyid,
						   ?_valasid,
					       ?_tr_number,
						   ?_jumlah,
						   ?_harga,
						   ?_subtotal,
						   '',
						   0,
						   0,
						   0,
						   0,
						   0,
						   0,
						   0,
						   0)
				endtext
				xx=sqlexec(konek,m.lsql)	
				do 'program\cek_error_sql_crud.prg'
				
				select tmpbeli
				skip 
			enddo 
		endif 
		use in tmpbeli
	endif

	** tranasksi penjualan
	** ---------------------------------------------------------------------------		
	text to m.lsql noshow
		select right(tr_number,4) as tr_number,
			   tr_date,
			   valas_id,
			   (select valas_code from m_valas where m_valas.id = tr_detail.valas_id limit 1) as valas_code,
			   (select valas_name from m_valas where m_valas.id = tr_detail.valas_id limit 1) as valas_name,			   
			   sum(qty) as jumlah,	                
			   price
		from tr_detail 
		where company_id = ?xcompanyid
		and tr_date = ?mtgl
		and status = 3
		and tr_id = 2
		group by right(tr_number,4), valas_id, tr_date, price
		order by right(tr_number,4), valas_id asc
	endtext 
	xx=sqlexec(konek,m.lsql,'tmpjual')	
	if xx <= 0 then
	   do 'program\cek_error_sql.prg'	
	endif		
	if used('tmpjual')
		select tmpjual
		if reccount() > 0
			select tmpjual 	
			go top 
			nrek = 0
			_recount = reccount()
			do while .not. eof()	
				_valasid   = tmpjual->valas_id
				_valascode = substr(alltrim(tmpjual->valas_code),1,len(alltrim(tmpjual->valas_code)))
				_valasname = alltrim(tmpjual->valas_name)
				_tr_number = tmpjual->tr_number		
				_jumlah    = tmpjual->jumlah
				_harga     = tmpjual->price
				_subtotal  = _jumlah * _harga	

				nrek = nrek + 1
				wait window nowait 'transaksi jual : ' + _valascode + ' | tanggal : ' + mtgl + ' | reccord :' +	alltrim(str(nrek)) + ' / ' + alltrim(str(_recount))

				if .not. empty(mkodevls)
					if len(mkodevls) > 3
						if .not. upper(alltrim(_valascode)) $ upper(alltrim(mkodevls))
							skip 
							loop
						endif	
					else
						if .not. upper(alltrim(_valascode)) = upper(alltrim(mkodevls))
							skip 
							loop
						endif							
					endif
				endif
				
				** tambah penjualan
				text to m.lsql noshow
					select id from st_valas_avg 
					where company_id = ?xcompanyid
					and valas_id  = ?_valasid 											
					and st_date     = ?mtgl 
					and sale_number = ?_tr_number
					and qty_sale    = ?_jumlah 
					and price_sale  = ?_harga					
				endtext	
				xx=sqlexec(konek,m.lsql,"tjual")	
				if xx <= 0 then
				   do 'program\cek_error_sql.prg'	
				endif					
				if reccount('tjual') <= 0		
					xx=sqlexec(konek,"select max(id) as maxid from st_valas_avg where company_id = ?xcompanyid and valas_id = ?_valasid and st_date = ?mtgl","nmax")		
					if xx <= 0 then
					   do 'program\cek_error_sql.prg'	
					endif						
					if used('nmax')	
						if isnull(nmax->maxid)
							_xid = 1
						else
							_xid = nmax->maxid + 1  
						endif
					endif															
					text to m.lsql noshow
						insert into st_valas_avg(id,
									  st_date,
									  company_id,
									  valas_id,
									  buy_number,
									  qty_buy,
									  price_buy,
									  total_buy,
									  sale_number,
									  qty_sale,
									  price_sale,
									  total_sale,
									  st_last_qty,
									  st_last_price,
									  st_last_total,
									  total_sale_average,
									  profit)
						values(?_xid,
							   ?mtgl ,
							   ?xcompanyid,
							   ?_valasid,
							   '',
							   0,
							   0,
							   0,
							   ?_tr_number,
							   ?_jumlah,
							   ?_harga,
							   ?_subtotal,
							   0,
							   0,
							   0,
							   0,
							   0)
					endtext
					xx=sqlexec(konek,m.lsql)	
					do 'program\cek_error_sql_crud.prg'
				endif
				use in tjual
				
				select tmpjual
				skip 
			enddo
		endif
		use in tmpjual
	endif			
	
	** saldo akhir stok & harga rata2
	** ------------------------------------------------------------------------------------------------------------------------------------------ 	
	text to m.lsql noshow
	   select id,
	   buy_number,
	   valas_id,
	   st_date,
	   (select valas_code from m_valas where m_valas.id = st_valas_avg.valas_id and st_valas_avg.company_id = ?xcompanyid limit 1) as valas_code,
	   (select valas_name from m_valas where m_valas.id = st_valas_avg.valas_id and st_valas_avg.company_id = ?xcompanyid limit 1) as valas_name
	   from st_valas_avg 
	   where company_id = ?xcompanyid
	   and st_date = ?mtgl	   
	   order by id, buy_number, valas_id asc
	endtext
	xx=sqlexec(konek,m.lsql,"tmpsaldo")		
	if xx <= 0 then
	   do 'program\cek_error_sql.prg'	
	endif	
	if used('tmpsaldo')
		if reccount('tmpsaldo') > 0
			select tmpsaldo
			go top 
			nrek = 0
			_recount = reccount()
			do while .not. eof()						
				_id           = tmpsaldo->id
				_id_last 	  = _id - 1
				_valasid      = tmpsaldo->valas_id
				_valascode    = substr(alltrim(tmpsaldo->valas_code),1,len(alltrim(tmpsaldo->valas_code)))
				_valasname    = alltrim(tmpsaldo->valas_name)
				
				nrek = nrek + 1
				wait window nowait 'stok akhir : ' + _valascode + ' | tanggal : ' + mtgl + ' | reccord :' +	alltrim(str(nrek)) + ' / ' + alltrim(str(_recount))
				
				if .not. empty(mkodevls)
					if len(mkodevls) > 3
						if .not. upper(alltrim(_valascode)) $ upper(alltrim(mkodevls))
							skip 
							loop
						endif	
					else
						if .not. upper(alltrim(_valascode)) = upper(alltrim(mkodevls))
							skip 
							loop
						endif							
					endif
				endif
								   
				if _id = 1
					** update jlh saldo akhir
					** ---------------------------------------------------------------------------------------------------------------------------		
					text to m.lsql noshow
						select st_last_qty from st_valas_avg
						  where st_valas_avg.company_id = ?xcompanyid
						  and st_valas_avg.valas_id = ?_valasid
						  and st_valas_avg.st_date = (
									  					select max(st_date) from st_valas_avg xx
														where xx.company_id = ?xcompanyid
														and xx.valas_id = ?_valasid 
														and xx.st_date < ?mtgl 														
													 )
						  and st_valas_avg.id = (
									  				select max(id) from st_valas_avg yy
													where yy.company_id = ?xcompanyid
													and yy.valas_id = ?_valasid 
													and yy.st_date = (
													  				 	select max(st_date) from st_valas_avg zz
														 		     	where zz.company_id = ?xcompanyid
														 		     	and zz.valas_id = ?_valasid
														 		     	and zz.st_date < ?mtgl  														 		     	
														 		     )										
												)						  
					endtext 
					xx=sqlexec(konek,m.lsql,'lastsaldo')
					if xx <= 0 then
					   do 'program\cek_error_sql.prg'	
					endif						
					if used('lastsaldo')
						if .not. isnull(lastsaldo->st_last_qty)							
							_saldo = lastsaldo->st_last_qty							
						endif
						use in lastsaldo
						text to m.lsql noshow
							update st_valas_avg set st_last_qty = (?_saldo + qty_buy) - qty_sale
							where company_id = ?xcompanyid
							and valas_id = ?_valasid
							and st_date = ?mtgl
							and id = ?_id							
						endtext 
						xx=sqlexec(konek,m.lsql)
						do 'program\cek_error_sql_crud.prg'	
					endif					
					
					** update harga rata - rata 
					** ---------------------------------------------------------------------------------------------------------------------------
					text to m.lsql noshow
						select st_last_qty, 
							   st_last_price, 
							  (st_last_qty * st_last_price)  as st_last_total 
						from st_valas_avg 
						where company_id = ?xcompanyid
						and valas_id = ?_valasid
						and st_date = (
						  					select max(st_date) from st_valas_avg 
										    where company_id = ?xcompanyid
										    and st_date < ?mtgl 
										    and valas_id = ?_valasid 										    
									  )
						and id = (
									select max(id) from st_valas_avg 
									where company_id = ?xcompanyid 
									and valas_id = ?_valasid
									and st_date = (
													select max(st_date) from st_valas_avg 
												    where company_id = ?xcompanyid
												    and st_date < ?mtgl  
												    and valas_id = ?_valasid 												    
												  )										  
								)						
					endtext
					xx=sqlexec(konek,m.lsql,'lastsaldo')
					if xx <= 0 then
					   do 'program\cek_error_sql.prg'	
					endif						
					_st_last_qty   = 0
					_st_last_price = 0
					_st_last_total = 0
					if used('lastsaldo')
						if .not. isnull(lastsaldo->st_last_qty)							
							_st_last_qty = lastsaldo->st_last_qty					
						endif
						if .not. isnull(lastsaldo->st_last_price)							
							_st_last_price = lastsaldo->st_last_price					
						endif
						if .not. isnull(lastsaldo->st_last_total)							
							_st_last_total = lastsaldo->st_last_total					
						endif
						use in lastsaldo
					endif	
					text to m.lsql noshow
						update st_valas_avg set st_last_price = round((?_st_last_total + total_buy) / (?_st_last_qty + qty_buy),2),
											    st_last_total = round((?_st_last_total + total_buy) / (?_st_last_qty + qty_buy),2) * st_last_qty,
												total_sale_average = round((?_st_last_total + total_buy) / (?_st_last_qty + qty_buy),2) * qty_sale
						where company_id = ?xcompanyid
						and valas_id = ?_valasid
						and st_date = ?mtgl
						and id = ?_id						
					endtext
					xx=sqlexec(konek,m.lsql)
					do 'program\cek_error_sql_crud.prg'

					text to m.lsql noshow
						update st_valas_avg set st_last_price = 0, st_last_total = 0
						where company_id = ?xcompanyid
						and valas_id = ?_valasid
						and st_date = ?mtgl
						and id = ?_id
						and st_last_qty = 0						
					endtext
					xx=sqlexec(konek,m.lsql)	
					do 'program\cek_error_sql_crud.prg'
				else				
					** update jlh saldo akhir
					** ---------------------------------------------------------------------------------------------------------------------------		
					text to m.lsql noshow
						update st_valas_avg as a,  
						(
							select st_last_qty from st_valas_avg
						 	where company_id = ?xcompanyid 
						 	and valas_id = ?_valasid
						 	and st_date = ?mtgl
						 	and id = ?_id_last
						 ) as b													  
						set a.st_last_qty = ((b.st_last_qty + a.qty_buy) - a.qty_sale)
						where a.company_id = ?xcompanyid
						and a.valas_id = ?_valasid
						and a.st_date = ?mtgl
						and a.id = ?_id						
					endtext 
					xx=sqlexec(konek,m.lsql)	
					do 'program\cek_error_sql_crud.prg'
					
					** update harga rata - rata 
					** ---------------------------------------------------------------------------------------------------------------------------
					text to m.lsql noshow
						update st_valas_avg as a,  
						(
							select st_last_qty, 
							    st_last_price, 
							   (st_last_qty * st_last_price) as st_last_total 
							from st_valas_avg
						 	where company_id = ?xcompanyid
						 	and valas_id = ?_valasid
						 	and st_date = ?mtgl
						 	and id = ?_id_last
						 ) as b													  
						set a.st_last_price      = round((b.st_last_total + total_buy) / (b.st_last_qty + qty_buy),2),
							a.st_last_total      = round((b.st_last_total + total_buy) / (b.st_last_qty + qty_buy),2) * a.st_last_qty,
							a.total_sale_average = round((b.st_last_total + total_buy) / (b.st_last_qty + qty_buy),2) * a.qty_sale
						where a.company_id = ?xcompanyid
						and a.valas_id = ?_valasid
						and a.st_date = ?mtgl
						and a.id = ?_id						
					endtext
					xx=sqlexec(konek,m.lsql)
					do 'program\cek_error_sql_crud.prg'		

					text to m.lsql noshow
						update st_valas_avg set st_last_price = 0, st_last_total = 0
						where company_id = ?xcompanyid
						and valas_id = ?_valasid
						and st_date = ?mtgl
						and id = ?_id
						and st_last_qty = 0						
					endtext
					xx=sqlexec(konek,m.lsql)
					do 'program\cek_error_sql_crud.prg'
				endif
				
				select tmpsaldo
				skip
			enddo
		endif
	endif

procedure paramtgl(_ket_)
	public tgl_, mtgl_last, mtgl, mtgl_next
	if .not. empty(_ket_)
		if mbulan = month(date()) and mtahun = year(date())
			ntgl2 = date() + 1 && tanggal hari ini
		else
			ntgl2 = gomonth(ntgl1,1)-day(ntgl1) && tanggal akhir bulan
		endif
		max_  = (ntgl2) - (ntgl1) + 1
		for loop = 1 to max_
			tgl_      = (ntgl1) + (loop-1)
			mtgl_last = substr(dtos(tgl_ - 1),1,4)  + "-" + substr(dtos(tgl_ - 1),5,2)  + "-" + substr(dtos(tgl_ - 1),7,2)
			mtgl      = substr(dtos(tgl_),1,4)      + "-" + substr(dtos(tgl_),5,2)      + "-" + substr(dtos(tgl_),7,2)		
			mtgl_next = substr(dtos(tgl_ + 1 ),1,4) + "-" + substr(dtos(tgl_ + 1 ),5,2) + "-" + substr(dtos(tgl_ + 1),7,2)
			do &_ket_
		next
	endif