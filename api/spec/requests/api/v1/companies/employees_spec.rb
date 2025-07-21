require 'swagger_helper'

RSpec.describe 'Api::V1::Companies::Employees', type: :request do
  let(:company) { create(:company) }

  path '/api/v1/companies/{company_id}/employees' do
    parameter name: :company_id, in: :path, type: :string, description: 'Company ID'

    get 'Lists employees for a company' do
      tags 'Employees'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number for pagination'

      response '200', 'successful' do
        let(:company_id) { company.id }
        before { create_list(:employee, 15, company: company) }

        run_test! do |response|
          json_response = JSON.parse(response.body)
          expect(json_response.keys).to contain_exactly('data', 'pagy')
          expect(json_response['data'].size).to eq(10)
        end
      end
    end

    post 'Creates an employee for a company' do
      tags 'Employees'
      consumes 'application/json'
      parameter name: :employee_params, in: :body, schema: {
        type: :object,
        properties: {
          employee: {
            type: :object,
            properties: {
              name: { type: :string, example: 'John Doe' },
              email: { type: :string, example: 'john.doe@companyname.com' },
              picture: { type: :string, example: 'http://example.com/pic.jpg' }
            },
            required: %w[name email]
          }
        },
        required: ['employee']
      }

      response '201', 'employee created' do
        let(:company_id) { company.id }
        let(:employee_params) { { employee: { name: 'Jane Doe', email: "jane.doe@#{company.name.downcase}.com" } } }
        
        run_test! do |response|
          expect(company.employees.count).to eq(1)
          expect(company.employees.first.name).to eq('Jane Doe')
        end
      end

      response '422', 'invalid request (e.g., wrong domain)' do
        let(:company_id) { company.id }
        let(:employee_params) { { employee: { name: 'Pedro', email: 'pedro@gmail.com' } } }

        run_test! do |response|
          json_response = JSON.parse(response.body)
          expect(json_response['email'].first).to include("domain must match the company's domain")
        end
      end
    end
  end
end