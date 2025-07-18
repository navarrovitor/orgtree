company = Company.create!(name: 'ABCorp')
ceo = company.employees.create!(name: 'Marcos', email: 'marcos@abcorp.com')
tech_lead = company.employees.create!(name: 'Pedro', email: 'pedro@abcorp.com', manager: ceo)
dev = company.employees.create!(name: 'Paulo', email: 'paulo@abcorp.com', manager: tech_lead)
