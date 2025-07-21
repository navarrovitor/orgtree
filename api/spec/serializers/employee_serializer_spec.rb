require 'rails_helper'

describe EmployeeSerializer, type: :serializer do
  let(:company) { create(:company) }
  let(:manager) { create(:employee, company: company) }
  let(:employee) { create(:employee, company: company, manager: manager) }
  let!(:subordinate) { create(:employee, company: company, manager: employee) }
  
  let(:serializer) { described_class.new(employee) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  let(:json) { JSON.parse(serialization.to_json) }

  it 'includes the correct employee attributes' do
    expect(json['id']).to eq(employee.id)
    expect(json['name']).to eq(employee.name)
    expect(json['email']).to eq(employee.email)
    expect(json['picture']).to eq(employee.picture)
  end

  it 'includes the manager with the simplified format' do
    expect(json['manager']['id']).to eq(manager.id)
    expect(json['manager'].keys).to contain_exactly('id', 'name', 'email')
  end

  it 'includes subordinates with the simplified format' do
    expect(json['subordinates'].size).to eq(1)
    expect(json['subordinates'].first['id']).to eq(subordinate.id)
    expect(json['subordinates'].first.keys).to contain_exactly('id', 'name', 'email')
  end
end