update m_customer
SET m_customer.created = null,
m_customer.updated = null,
m_customer.updatedby = null

UPDATE m_customer, ztrh
SET m_customer.created = ztrh.created,
m_customer.updated = null,
m_customer.updatedby = null
WHERE ztrh.customer_id_old = m_customer.id_old
