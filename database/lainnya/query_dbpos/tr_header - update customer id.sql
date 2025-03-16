update tr_header, m_customer set tr_header.customer_id = m_customer.id
where tr_header.customer_id_old = m_customer.id_old
and tr_header.company_id = m_customer.company_id