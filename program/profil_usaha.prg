lparameters ncompany_id
text to m.lsql noshow
	select * from m_company where id = ?ncompany_id limit 1
endtext
xx=sqlexec(konek,m.lsql,'tb_company')
if xx <= 0
	do 'program\cek_error_sql.prg'
endif		
if used('tb_company')
	select tb_company
	if reccount() > 0
		do 'program\update_field.prg'
		select tb_company
		go top
		public xnamausaha,;
			   xalmtusaha1,;
			   xalmtusaha2,;			   
			   xtlpnusaha,;
			   xkotausaha,;
			   xkodeposusaha,;
			   xemailusaha,;
			   xizinusaha
		xnamausaha     = alltrim(tb_company->company_name)
		xalmtusaha1    = alltrim(tb_company->company_address1)
		xalmtusaha2    = alltrim(tb_company->company_address2)		
		xtlpnusaha     = alltrim(tb_company->company_phone)
		xkotausaha     = alltrim(tb_company->company_city)
		xkodeposusaha  = alltrim(tb_company->company_postcode)
		xemailusaha    = alltrim(tb_company->company_email)
		xizinusaha     = alltrim(substr(tb_company->legal_gbi,1,50))
	endif
endif