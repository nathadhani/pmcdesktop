if type('konek') = 'N'
	if konek = 1
		** Modify cba_th
		**-----------------------------------------------------------------------------
		text to m.lsql noshow
			select 
				company_id,
				cba_id,
				cba_pos_id,
				year(cba_tr_date) as tahun,
				month(cba_tr_date) as bulan,
				day(cba_tr_date) as days
			from cba_th
			where company_id=?xcompanyid 
			group by company_id, cba_id, cba_pos_id, year(cba_tr_date), month(cba_tr_date), day(cba_tr_date)
			order by company_id, cba_id, cba_pos_id, year(cba_tr_date), month(cba_tr_date), day(cba_tr_date) asc
		endtext			
		xx=sqlexec(konek,m.lsql,"tmp1")
		if xx <= 0 then 
			do 'program\cek_error_sql.prg'	
		endif
		if used('tmp1')
			select tmp1
			if reccount() > 0
				text to m.lsql noshow
					alter table cba_th modify cba_tr_number varchar(16)
				endtext
				xx=sqlexec(konek,m.lsql)
				if xx <= 0 then 
					do 'program\cek_error_sql.prg'	
				endif
				if xx > 0
					text to m.lsql noshow
						alter table cba_th add column cba_tr_number_old varchar(16) after cba_tr_number
					endtext
					xx=sqlexec(konek,m.lsql)	
					if xx <= 0 then 
						do 'program\cek_error_sql.prg'	
					endif				
					if xx > 0
						text to m.lsql noshow						
							update cba_th set cba_tr_number_old = cba_tr_number
						endtext
						xx=sqlexec(konek,m.lsql)
						if xx <= 0 then 
							do 'program\cek_error_sql.prg'	
						endif
						if xx > 0
							select tmp1
							go top
							nrek = 0
							do while .not. eof()	
								nrek = nrek + 1
								wait window nowait 'reccord : ' + alltrim(str(nrek))+'/'+alltrim(str(reccount()))
								mcba_id = tmp1->cba_id
								mcba_pos_id = tmp1->cba_pos_id			
								mtahun = tmp1->tahun
								mbulan = tmp1->bulan
								mdays  = tmp1->days					
								text to m.lsql noshow
									select id from cba_th 
									where company_id=?xcompanyid
									and cba_id=?mcba_id
									and cba_pos_id=?mcba_pos_id
									and year(cba_tr_date)=?mtahun 
									and month(cba_tr_date)=?mbulan
									and day(cba_tr_date)=?mdays
									order by id asc
								endtext
								xx=sqlexec(konek,m.lsql,"tmp2")	
								if xx <= 0 then 
									do 'program\cek_error_sql.prg'	
								endif				
								if used('tmp2')
									select tmp2
									go top 
									no = 0
									do while .not. eof()		
										nid = val(tmp2->id)							
										*----------------------------------------------------------------------		
										no=no+1
										do case						 
											case no < 10
										 		nop = '000'+alltrim(str(no))						 
											case no < 100
												nop = '00'+alltrim(str(no))
											case no < 1000
											 	nop = '0'+alltrim(str(no))
											case no < 10000
											 	nop = alltrim(str(no))
										endcase
										*----------------------------------------------------------------------
										xtahun = substr(alltrim(str(mtahun)),3,2)
										xbulan = right('00'+alltrim(str(mbulan)),2)
										xdays  = right('00'+alltrim(str(mdays)),2)
										xcab = right('00'+alltrim(str(xcompanyid)),2)
										xcba_id = right('00'+alltrim(str(mcba_id)),2)
										xcba_pos_id = right('00'+alltrim(str(mcba_pos_id)),2)
										xkode = xtahun + xbulan + xdays + xcab + xcba_id + xcba_pos_id +(nop)
										xx=sqlexec(konek,"update cba_th set cba_tr_number=?xkode where id=?nid")	
										if xx <= 0 then 
											do 'program\cek_error_sql.prg'	
										endif
										*----------------------------------------------------------------------
										select tmp2
										skip 
									enddo
									use in tmp2
								endif					
								select tmp1
								skip
							enddo
						endif
					endif
				endif		
			endif
			use in tmp1		
		endif
		** End Modify cba_th
		**-----------------------------------------------------------------------------
		
		** Modify cba_td
		**-----------------------------------------------------------------------------		
		text to m.lsql noshow
			select cba_tr_number, cba_tr_number from cba_th
			where company_id=?xcompanyid 
			and cba_tr_number is not null 
			and cba_tr_number_old is not null 
			group by cba_tr_number, cba_tr_number_old
			order by cba_tr_number, cba_tr_number_old asc
		endtext				
		xx=sqlexec(konek,m.lsql,"tmp1")
		if xx <= 0 then 
			do 'program\cek_error_sql.prg'	
		endif
		if used('tmp1')
			select tmp1
			if reccount() > 0
				text to m.lsql noshow
					alter table cba_td modify cba_tr_number varchar(16)
				endtext
				xx=sqlexec(konek,m.lsql)
				if xx <= 0 then 
					do 'program\cek_error_sql.prg'	
				endif
				if xx > 0			
					text to m.lsql noshow
						alter table cba_td add column cba_tr_number_old varchar(16) after cba_tr_number
					endtext
					xx=sqlexec(konek,m.lsql)
					if xx <= 0 then
						do 'program\cek_error_sql.prg'	
					endif	
					*----------------------------------------------------------------------
					if xx > 0
						text to m.lsql noshow						
							update cba_td set cba_tr_number_old = cba_tr_number
						endtext
						xx=sqlexec(konek,m.lsql)
						if xx <= 0 then 
							do 'program\cek_error_sql.prg'	
						endif
						if xx > 0
							text to m.lsql noshow						
								update cba_td, cba_th set cba_td.cba_tr_number = cba_th.cba_tr_number
								where cba_td.company_id = cba_th.company_id 
								and cba_td.cba_id = cba_th.cba_id 
								and cba_td.cba_pos_id = cba_th.cba_pos_id 
								and cba_td.cba_tr_number_old = cba_th.cba_tr_number_old								
							endtext
							xx=sqlexec(konek,m.lsql)
							if xx <= 0 then 
								do 'program\cek_error_sql.prg'	
							endif
							if xx > 0
								text to m.lsql noshow
									alter table cba_td drop column cba_tr_number_old
								endtext
								xx=sqlexec(konek,m.lsql)
								if xx <= 0 then 
									do 'program\cek_error_sql.prg'	
								endif
								if xx > 0
									text to m.lsql noshow
										alter table cba_th drop column cba_tr_number_old
									endtext
									xx=sqlexec(konek,m.lsql)
									if xx <= 0 then 
										do 'program\cek_error_sql.prg'	
									endif
								endif
							endif
						endif
					endif
				endif			
			endif
		endif
		** End Modify tr_detail
		**-----------------------------------------------------------------------------	
	endif
endif