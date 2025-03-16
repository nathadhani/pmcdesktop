SELECT * FROM m_customer
WHERE NOT EXISTS
(
	SELECT customer_id FROM tr_header WHERE tr_header.customer_id_old = m_customer.id_old
)

/*
DELETE FROM m_customer
WHERE NOT EXISTS
(
	SELECT customer_id FROM tr_header WHERE tr_header.customer_id_old = m_customer.id_old
)
*/