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

  path '/api/v1/employees/{id}' do
    delete 'Deletes an employee' do
      tags 'Employees'
      parameter name: :id, in: :path, type: :string

      response '204', 'employee deleted' do
        let(:id) { employee.id }
        run_test!
      end

      response '404', 'employee not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/employees/{id}/assign_manager' do
    post 'Assigns a manager to an employee' do
      tags 'Organograms'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :manager_params, in: :body, schema: {
        type: :object,
        properties: {
          manager_id: { type: :integer, example: 1 }
        },
        required: ['manager_id']
      }

      response '200', 'manager assigned' do
        let(:id) { employee.id }
        let(:manager_params) { { manager_id: manager.id } }
        run_test!
      end

      response '422', 'invalid assignment (e.g., creates loop)' do
        let(:id) { manager.id }
        let(:manager_params) { { manager_id: employee.id } }
        run_test!
      end
    end
  end

  path '/api/v1/employees/{id}/peers' do
    get 'Retrieves employee peers' do
      tags 'Organograms'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'peers found' do
        before { create(:employee, company: company, manager: manager) }
        let(:id) { employee.id }
        run_test!
      end
    end
  end

  path '/api/v1/employees/{id}/subordinates' do
    get "Retrieves employee's direct subordinates" do
      tags 'Organograms'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'subordinates found' do
        before { create_list(:employee, 2, company: company, manager: employee) }
        let(:id) { employee.id }
        run_test!
      end
    end
  end
end