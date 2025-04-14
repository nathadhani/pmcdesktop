if type('konek') = 'N'
	if konek = 1
		** Modify tr_header
		**-----------------------------------------------------------------------------
		text to m.lsql noshow
			select 
				tr_id,
				year(tr_date) as tahun, 
				month(tr_date) as bulan,
				day(tr_date) as days
			from tr_header
			where company_id=?xcompanyid 
			group by tr_id, year(tr_date), month(tr_date), day(tr_date)
			order by tr_id, year(tr_date), month(tr_date), day(tr_date) asc
		endtext				
		xx=sqlexec(konek,m.lsql,"tmp1")
		if xx <= 0 then 
			do 'program\cek_error_sql.prg'	
		endif
		if used('tmp1')
			select tmp1
			if reccount() > 0
				text to m.lsql noshow
					alter table tr_header modify tr_number varchar(14)
				endtext
				xx=sqlexec(konek,m.lsql)
				if xx <= 0 then 
					do 'program\cek_error_sql.prg'	
				endif
				if xx > 0
					text to m.lsql noshow
						alter table tr_header add column tr_number_old varchar(14) after tr_number
					endtext
					xx=sqlexec(konek,m.lsql)
					if xx <= 0 then 
						do 'program\cek_error_sql.prg'	
					endif				
					*----------------------------------------------------------------------
					if xx > 0
						text to m.lsql noshow						
							update tr_header set tr_number_old = tr_number
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
								mjnsid = tmp1->tr_id			
								mtahun = tmp1->tahun
								mbulan = tmp1->bulan
								mdays  = tmp1->days					
								text to m.lsql noshow
									select id from tr_header 
									where company_id=?xcompanyid
									and tr_id=?mjnsid 
									and year(tr_date)=?mtahun 
									and month(tr_date)=?mbulan
									and day(tr_date)=?mdays
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
										xjnsid = right('00'+alltrim(str(mjnsid)),2)
										xkode = xtahun+xbulan+xdays+xcab+xjnsid+(nop)
										xx=sqlexec(konek,"update tr_header set tr_number=?xkode where id=?nid")
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
		** End Modify tr_header
		**-----------------------------------------------------------------------------
		
		** Modify tr_detail
		**-----------------------------------------------------------------------------
		text to m.lsql noshow
			select tr_number, tr_number_old from tr_header 
			where company_id=?xcompanyid 
			and tr_number is not null 
			and tr_number_old is not null 
			group by tr_number, tr_number_old
			order by tr_number, tr_number_old asc
		endtext				
		xx=sqlexec(konek,m.lsql,"tmp1")
		if xx <= 0 then 
			do 'program\cek_error_sql.prg'	
		endif
		if used('tmp1')
			select tmp1
			if reccount() > 0
				text to m.lsql noshow
					ALTER table tr_detail MODIFY tr_number VARCHAR(14)
				endtext
				xx=sqlexec(konek,m.lsql)
				if xx <= 0 then 
					do 'program\cek_error_sql.prg'	
				endif
				if xx > 0			
					text to m.lsql noshow
						ALTER TABLE tr_detail ADD COLUMN tr_number_old VARCHAR(14) AFTER tr_number
					endtext
					xx=sqlexec(konek,m.lsql)	
					if xx <= 0 then 
						do 'program\cek_error_sql.prg'	
					endif
					*----------------------------------------------------------------------
					if xx > 0
						text to m.lsql noshow						
							UPDATE tr_detail SET tr_number_old = tr_number
						endtext
						xx=sqlexec(konek,m.lsql)
						if xx <= 0 then 
							do 'program\cek_error_sql.prg'	
						endif
						if xx > 0
							text to m.lsql noshow						
								update tr_detail, tr_header set tr_detail.tr_number = tr_header.tr_number 
								where tr_detail.company_id = tr_header.company_id 
								and tr_detail.tr_id = tr_header.tr_id 
								and tr_detail.tr_number_old = tr_header.tr_number_old								
							endtext
							xx=sqlexec(konek,m.lsql)
							if xx <= 0 then 
								do 'program\cek_error_sql.prg'	
							endif
							if xx > 0
								text to m.lsql noshow
									ALTER TABLE tr_detail DROP COLUMN tr_number_old
								endtext
								xx=sqlexec(konek,m.lsql)
								if xx <= 0 then 
									do 'program\cek_error_sql.prg'	
								endif
								if xx > 0
									text to m.lsql noshow
										ALTER TABLE tr_header DROP COLUMN tr_number_old
									endtext
									xx=sqlexec(konek,m.lsql)
									if xx <= 0 then 
										do 'program\cek_error_sql.prg'	
									endif
									if xx > 0
										** Insert tr_bayar
										**-----------------------------------------------------------------------------
										text to m.lsql noshow
											truncate table tr_bayar										
										endtext
										xx=sqlexec(konek,m.lsql)
										if xx <= 0 then 
											do 'program\cek_error_sql.prg'	
										endif
										if xx > 0
											text to m.lsql noshow
												SET @rownr=0;
											endtext
											xx=sqlexec(konek,m.lsql)
											if xx <= 0 then 
												do 'program\cek_error_sql.prg'	
											endif
											if xx > 0
												text to m.lsql noshow
													insert into tr_bayar(	
																	     id,
																	     company_id,
																	     tr_id,
																	     tr_number,
																	     tr_date,
																	     payment_type,
																	     amount,
																	     description,
																	     status,
																	     created,
																	     updated,
																	     createdby,
																	     updatedby)
													select	
														@rownr:=@rownr+1 AS id,
														company_id,
														tr_id,
														tr_number,
														tr_date,
														1 AS payment_type,
														SUM(subtotal) as amount,
														'Pembayaran Tunai' AS description,
														3 AS status,
														created,
														updated,
														createdby,
														updatedby
													FROM tr_detail
													GROUP BY tr_id,tr_number
												endtext
												xx=sqlexec(konek,m.lsql)
												if xx <= 0 then 
													do 'program\cek_error_sql.prg'	
												endif
											endif
										endif										
										** End Modify tr_bayar
										**-----------------------------------------------------------------------------									
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