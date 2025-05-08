if type('konek') = 'N'
	if konek = 1
		text to m.lsql noshow
			select id 
			from m_customer 
			where company_id=?xcompanyid
			and customer_code IS NULL
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
				if xx > 0
					select tmp1
					go top 
					nrek = 0
					do while .not. eof()				
						
						nrek = nrek + 1
						wait window nowait 'reccord : ' + alltrim(str(nrek)) + '/' + alltrim(str(reccount()))

						nid = val(tmp1->id)						
						*----------------------------------------------------------------------
						text to m.lsql noshow
							select max(right(customer_code,5)) as kode 
							from m_customer 
							where company_id=?xcompanyid 
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
								nolama=val(tb_kode.kode)
								nop=nolama+1
							endif																		
							xkode = 'KP' + RIGHT('0000'+alltrim(str(nop)),5)
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
			endif
			use in tmp1
		endif	
	endif
endif