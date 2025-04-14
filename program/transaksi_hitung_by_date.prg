mkodevls = '' && buat ngetes per kode valas
if type('konek') = 'N'
	if konek = 1			
		text to m.lsql noshow 
			delete from st_valas_avg 
			where company_id = ?xcompanyid 
			and st_date = ?mtgl
		endtext			
		xx=sqlexec(konek,m.lsql)
		do 'program\cek_error_sql_crud.prg'
		
		do get_saldoawal		
		do get_transaksi
		
		text to m.lsql noshow
			delete from st_valas_avg where company_id = ?xcompanyid
									       and st_date = ?mtgl
									       and qty_buy + qty_sale + st_last_qty = 0
		endtext
		xx=sqlexec(konek,m.lsql)
		do 'program\cek_error_sql_crud.prg'
	
		text to m.lsql noshow
			update st_valas_avg set profit = total_sale - total_sale_average
			where company_id = ?xcompanyid 
			and st_date = ?mtgl	
			and total_sale_average > 0	
		endtext 
		xx=sqlexec(konek,m.lsql)
		do 'program\cek_error_sql_crud.prg'
		
		text to m.lsql noshow
			update st_valas_avg set created = ?datetime(), createdby = ?xiduser
			where company_id = ?xcompanyid
			and st_date = ?mtgl
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
		select id as valas_id, 
			   valas_code, 
			   valas_name 
		from m_valas 
		order by valas_id asc
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
				_tanggal    = substr(dtos(dtgl),1,4)+"-"+substr(dtos(dtgl),5,2)+"-"+substr(dtos(dtgl),7,2)
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
					and year(st_date) = ?mtahun
					and month(st_date) = ?mbulan
					and st_date < ?mtgl	
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
										  company_id,
										  st_date,
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
						   ?xcompanyid,
						   ?mtgl,
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
		select right(tr_detail.tr_number,4) as tr_number,
			   tr_detail.tr_date,
			   tr_detail.valas_id,
			   m_valas.valas_code,
			   m_valas.valas_name,			   
			   sum(tr_detail.qty) as jumlah,	                
			   tr_detail.price
		from tr_detail
		left join tr_header on tr_header.tr_id = tr_detail.tr_id and tr_header.tr_number = tr_detail.tr_number
		left join m_valas on m_valas.id = tr_detail.valas_id
		where tr_header.company_id = ?xcompanyid
		and tr_detail.company_id = ?xcompanyid
		and tr_detail.tr_date = ?mtgl
		and tr_header.status = 3
		and tr_header.tr_id = 1
		and tr_detail.status = 3
		and tr_detail.tr_id = 1		
		group by right(tr_detail.tr_number,4), tr_detail.valas_id, tr_detail.tr_date, tr_detail.price
		order by right(tr_detail.tr_number,4), tr_detail.valas_id asc 
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
				_tanggal   = tmpbeli->tr_date
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
				
				text to m.lsql noshow
					select max(id) as maxid 
		 		    from st_valas_avg 
				    where company_id = ?xcompanyid 
				    and valas_id = ?_valasid 
				    and st_date = ?mtgl
				endtext
				xx=sqlexec(konek,m.lsql,"nmax")
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
										  company_id,
										  st_date,
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
		  				   ?xcompanyid,
						   ?_tanggal,
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
		select right(tr_detail.tr_number,4) as tr_number,
			   tr_detail.tr_date,
			   tr_detail.valas_id,
			   m_valas.valas_code,
			   m_valas.valas_name,			   
			   sum(tr_detail.qty) as jumlah,	                
			   tr_detail.price
		from tr_detail 
		left join tr_header on tr_header.tr_id = tr_detail.tr_id and tr_header.tr_number = tr_detail.tr_number
		left join m_valas on m_valas.id = tr_detail.valas_id
		where tr_header.company_id = ?xcompanyid
		and tr_detail.company_id = ?xcompanyid 
		and tr_detail.tr_date = ?mtgl
		and tr_header.status = 3
		and tr_header.tr_id = 2
		and tr_detail.status = 3
		and tr_detail.tr_id = 2		
		group by right(tr_detail.tr_number,4), tr_detail.valas_id, tr_detail.tr_date, tr_detail.price
		order by right(tr_detail.tr_number,4), tr_detail.valas_id asc 
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
					select id 
					from st_valas_avg 
					where company_id = ?xcompanyid 
					and valas_id = ?_valasid 		
					and st_date = ?mtgl 
					and sale_number = ?_tr_number 
					and qty_sale = ?_jumlah 
					and price_sale = ?_harga			
				endtext	
				xx=sqlexec(konek,m.lsql,"tjual")	
				if xx <= 0 then
				   do 'program\cek_error_sql.prg'	
				endif					
				if reccount('tjual') <= 0		
					text to m.lsql noshow
						select max(id) as maxid 
						from st_valas_avg 
						where company_id = ?xcompanyid
						and valas_id = ?_valasid
						and st_date = ?mtgl
					endtext
					xx=sqlexec(konek,m.lsql,"nmax")		
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
								              company_id,
											  st_date,
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
						       ?xcompanyid,
							   ?mtgl ,
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
		select st_valas_avg.id,
			   st_valas_avg.valas_id,
			   m_valas.valas_code,
			   m_valas.valas_name,
			   st_valas_avg.st_date
			   from st_valas_avg 
			   left join m_valas on st_valas_avg.valas_id = m_valas.id
			   where company_id = ?xcompanyid
			   and st_valas_avg.st_date = ?mtgl
			   order by st_valas_avg.id, st_valas_avg.buy_number, st_valas_avg.valas_id asc
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
							  (st_last_qty * st_last_price) as st_last_total
						from st_valas_avg 
						where company_id = ?xcompanyid
						and valas_id = ?_valasid
						and st_date = (
										select max(st_date) 
										from st_valas_avg 
										where company_id = ?xcompanyid
										and st_date < ?mtgl 
										and valas_id = ?_valasid 										
									   )
						and id = (
									select max(id)
									from st_valas_avg
									where company_id = ?xcompanyid
									and valas_id = ?_valasid
									and st_date = (
													select max(st_date) 
													from st_valas_avg 
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
							select st_last_qty 
							from st_valas_avg 
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
						set a.st_last_price = round((b.st_last_total + a.total_buy) / (b.st_last_qty + a.qty_buy),2),
							a.st_last_total = round((b.st_last_total + a.total_buy) / (b.st_last_qty + a.qty_buy),2) * a.st_last_qty,
							a.total_sale_average = round((b.st_last_total + a.total_buy) / (b.st_last_qty + a.qty_buy),2) * a.qty_sale
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

	