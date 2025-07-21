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
end