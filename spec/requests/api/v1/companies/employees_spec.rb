require 'rails_helper'

RSpec.describe "Api::V1::Companies::Employees", type: :request do
  describe "POST /api/v1/companies/:company_id/employees" do
    let(:company) { create(:company) }
    
    it "creates a new employee for the correct company" do
      employee_params = {
        employee: {
          name: "João",
          email: "joao@#{company.name.downcase}.com"
        }
      }

      post "/api/v1/companies/#{company.id}/employees", params: employee_params

      expect(response).to have_http_status(:created)
      expect(company.employees.count).to eq(1)
      expect(company.employees.first.name).to eq("João")
    end

    it "returns an error if email domain is invalid" do
      employee_params = { employee: { name: "Pedro", email: "pedro@gmail.com" } }

      post "/api/v1/companies/#{company.id}/employees", params: employee_params

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response['email']).to include("domain must match the company's domain (#{company.name.downcase}.com)")
    end
  end

  path '/api/v1/companies/{company_id}/employees' do
    get 'Lists employees for a company' do
      tags 'Employees'
      produces 'application/json'
      parameter name: :company_id, in: :path, type: :string

      response '200', 'successful' do
        let(:company_id) { company.id }
        before { create_list(:employee, 3, company: company) }
        run_test!
      end
    end

    post 'Creates an employee for a company' do
      tags 'Employees'
      consumes 'application/json'
      parameter name: :company_id, in: :path, type: :string
      parameter name: :employee_params, in: :body, schema: {
        type: :object,
        properties: {
          employee: {
            type: :object,
            properties: {
              name: { type: :string, example: 'John Doe' },
              email: { type: :string, example: "john.doe@company1.com" },
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
        run_test!
      end

      response '422', 'invalid request' do
        let(:company_id) { company.id }
        let(:employee_params) { { employee: { name: 'Jane Doe', email: 'invalid-email@othercorp.com' } } }
        run_test!
      end
    end
  end
end