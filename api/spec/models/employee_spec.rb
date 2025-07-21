require 'rails_helper'

RSpec.describe Employee, type: :model do
  let(:company) { Company.create!(name: 'ABCorp') }

  it 'is valid with name, email and company' do
    employee = Employee.new(name: 'João', email: 'joao@abcorp.com', company: company)
    expect(employee).to be_valid
  end

  it 'is invalid if email domain does not match company' do
    employee = Employee.new(name: 'João', email: 'joao@gmail.com', company: company)
    expect(employee).not_to be_valid
    expect(employee.errors[:email]).to include("domain must match the company's domain (abcorp.com)")
  end

  it 'is invalid if manager is from a different company' do
    other_company = Company.create!(name: 'GHInc')
    manager = Employee.create!(name: 'Maria', email: 'maria@ghinc.com', company: other_company)
    employee = Employee.new(name: 'João', email: 'joao@abcorp.com', company: company, manager: manager)

    expect(employee).not_to be_valid
    expect(employee.errors[:manager]).to include("must be in the same company")
  end

  it 'is invalid if creates a management loop' do
    ceo = Employee.create!(name: 'Alice', email: 'alice@abcorp.com', company: company)
    tech_lead = Employee.create!(name: 'Bárbara', email: 'barbara@abcorp.com', company: company, manager: ceo)
    dev = Employee.create!(name: 'Carol', email: 'carol@abcorp.com', company: company, manager: tech_lead)

    # Tentativa de loop: ceo agora reporta a dev
    ceo.manager = dev
    expect(ceo).not_to be_valid
    expect(ceo.errors[:manager_id]).to include("creates a organization hierarchy loop")
  end
end
