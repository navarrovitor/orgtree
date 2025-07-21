require 'rails_helper'

RSpec.describe "Api::V1::Employees", type: :request do
  let(:company) { create(:company) }
  let(:ceo) { create(:employee, company: company) }
  let(:tech_lead) { create(:employee, company: company, manager: ceo) }

  describe "POST /api/v1/employees/:id/assign_manager" do
    it "assigns a valid manager to an employee" do
      post "/api/v1/employees/#{tech_lead.id}/assign_manager", params: { manager_id: ceo.id }

      expect(response).to have_http_status(:ok)
      expect(tech_lead.reload.manager).to eq(ceo)
    end

    it "returns an error when trying to create a organization hierarchy loop" do
      post "/api/v1/employees/#{ceo.id}/assign_manager", params: { manager_id: tech_lead.id }

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to include("Manager creates a organization hierarchy loop")
    end
  end

  describe "GET /api/v1/employees/:id/peers" do
    let!(:dev_one) { create(:employee, company: company, manager: tech_lead) }
    let!(:dev_two) { create(:employee, company: company, manager: tech_lead) }

    it "returns the employee's peers (excluding self)" do
      get "/api/v1/employees/#{dev_one.id}/peers"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(1)
      expect(json_response.first['id']).to eq(dev_two.id)
    end
  end
end