if type('konek') = 'N'
	if konek = 1		
		text to m.lsql noshow
			select id, 
				year(created) as tahun, 
				month(created) as bulan,
				day(created) as days,
				customer_code as customer_code_old
			from m_customer 
			where company_id=?xcompanyid 
			order by id asc
		endtext				
		xx=sqlexec(konek,m.lsql,"tmp1")
		if xx <= 0 then 
			do 'program\cek_error_sql.prg'	
		endif
		*----------------------------------------------------------------------
		if used('tmp1')
			select tmp1
			if reccount() > 0				
				text to m.lsql noshow
					alter table m_customer add column customer_code_old varchar(12) after customer_code
				endtext
				xx=sqlexec(konek,m.lsql)
				if xx <= 0 then 
					do 'program\cek_error_sql.prg'	
				endif
				if xx > 0
					text to m.lsql noshow
						alter table m_customer modify customer_code varchar(12)
					endtext
					xx=sqlexec(konek,m.lsql)	
					if xx <= 0 then 
						do 'program\cek_error_sql.prg'	
					endif
					if xx > 0
						text to m.lsql noshow
							update m_customer set customer_code_old = customer_code
							where company_id=?xcompanyid
						endtext
						xx=sqlexec(konek,m.lsql)	
						if xx <= 0 then 
							do 'program\cek_error_sql.prg'	
						endif
						if xx > 0
							text to m.lsql noshow
								update m_customer set customer_code = null 
								where company_id=?xcompanyid
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
									wait window nowait 'reccord : ' + alltrim(str(nrek)) + '/' + alltrim(str(reccount()))

									nid = val(tmp1->id)
									ntahun = tmp1->tahun
									nbulan = tmp1->bulan
									ndays  = tmp1->days
									mtahun = right('00'+alltrim((tmp1->tahun)),2)
									mbulan = right('00'+alltrim((tmp1->bulan)),2)
									mdays = right('00'+alltrim((tmp1->days)),2)
									cab = right('00'+alltrim(str(xcompanyid)),2)									
									
									*----------------------------------------------------------------------
									text to m.lsql noshow
										select max(right(customer_code,4)) as kode 
										from m_customer 
										where company_id=?xcompanyid 
										and year(created) = ?ntahun 
										and month(created) = ?nbulan
										and day(created) = ?ndays
										LIMIT 1
									endtext	
									xx=sqlexec(konek,m.lsql,"tb_kode")
									if xx <= 0 then 
										do 'program\cek_error_sql.prg'	
									endif
									if xx > 0
										select tb_kode
										do 'program\update_field.prg'												
										nop='0001'
										GO TOP
										if reccount() > 0											
											go top
											nolama=val(right(tb_kode.kode,4))
											no=nolama+1
											do case
												case no<10 
													nop='000'+alltrim(str(no))
												case no<100
													nop='00'+alltrim(str(no))
												case no<1000
													nop='0'+alltrim(str(no))
												otherwise
													nop=alltrim(str(no))
											endcase
										endif	
																				
										*----------------------------------------------------------------------						
										xkode = mtahun + mbulan + mdays + cab + nop
										*----------------------------------------------------------------------
										mcustomer_code_old = tmp1->customer_code_old
										nfile = fullpath('foto\'+alltrim(mcustomer_code_old)+'.jpeg')
										nfileto = fullpath('logs\'+alltrim(xkode)+'.jpeg')																		
										if file(nfile)
											copy file &nfile to &nfileto
										endif 		
										if file(nfileto)
											delete file &nfile											
										ENDIF
										text to m.lsql noshow
											update m_customer set customer_code=?xkode 
											where id=?nid 
											and company_id=?xcompanyid
										endtext
										xx=sqlexec(konek,m.lsql)	
										if xx <= 0 then 
											do 'program\cek_error_sql.prg'	
										endif
									endif																													
									
									select tmp1
									skip 
								enddo
							endif
							use in tb_kode
						endif					
					endif					
				endif
			endif
			use in tmp1
		endif	
	endif
endif