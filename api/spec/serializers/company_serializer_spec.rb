require 'rails_helper'

describe CompanySerializer, type: :serializer do
  let(:company) { create(:company) }
  let!(:employees) { create_list(:employee, 2, company: company) }

  let(:serializer) { described_class.new(company) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  let(:json) { JSON.parse(serialization.to_json) }

  it 'includes the correct company attributes' do
    expect(json['id']).to eq(company.id)
    expect(json['name']).to eq(company.name)
  end

  it 'includes a list of associated employees' do
    expect(json['employees']).to be_an_instance_of(Array)
    expect(json['employees'].size).to eq(2)
    expect(json['employees'].first['id']).to eq(employees.first.id)
  end
end