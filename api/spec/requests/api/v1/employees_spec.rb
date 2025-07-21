require 'swagger_helper'

RSpec.describe "Api::V1::Employees", type: :request do

  path '/api/v1/employees/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Employee ID'

    delete 'Deletes an employee' do
      tags 'Employees'

      response '204', 'employee deleted' do
        let(:employee) { create(:employee) }
        let(:id) { employee.id }

        run_test! do
          expect(Employee.find_by(id: employee.id)).to be_nil
        end
      end

      response '404', 'employee not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/employees/{id}/assign_manager' do
    parameter name: :id, in: :path, type: :string, description: 'Employee ID'

    post 'Assigns a manager to an employee' do
      tags 'Org Chart'
      consumes 'application/json'
      parameter name: :manager_params, in: :body, schema: {
        type: :object,
        properties: { manager_id: { type: :integer, example: 1 } },
        required: ['manager_id']
      }

      response '200', 'manager assigned' do
        let(:company) { create(:company) }
        let(:employee) { create(:employee, company: company) }
        let(:manager) { create(:employee, company: company) }
        let(:id) { employee.id }
        let(:manager_params) { { manager_id: manager.id } }

        run_test! do |response|
          expect(employee.reload.manager).to eq(manager)
          data = JSON.parse(response.body)
          expect(data['manager']['id']).to eq(manager.id)
        end
      end

      response '422', 'invalid assignment (e.g., creates loop)' do
        let(:company) { create(:company) }
        let(:manager) { create(:employee, company: company) }
        let(:employee) { create(:employee, company: company, manager: manager) }
        let(:id) { manager.id }
        let(:manager_params) { { manager_id: employee.id } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to include("Manager creates a organization hierarchy loop")
        end
      end
    end
  end

  path '/api/v1/employees/{id}/peers' do
    parameter name: :id, in: :path, type: :string, description: 'Employee ID'

    get 'Retrieves employee peers' do
      tags 'Org Chart'
      produces 'application/json'

      response '200', 'peers found' do
        let(:company) { create(:company) }
        let(:manager) { create(:employee, company: company) }
        let(:employee1) { create(:employee, company: company, manager: manager) }
        let!(:employee2) { create(:employee, company: company, manager: manager) }
        let(:id) { employee1.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.size).to eq(1)
          expect(data.first['id']).to eq(employee2.id)
        end
      end
    end
  end

  path '/api/v1/employees/{id}/subordinates' do
    parameter name: :id, in: :path, type: :string, description: 'Employee ID'

    get "Retrieves employee's direct subordinates" do
      tags 'Org Chart'
      produces 'application/json'

      response '200', 'subordinates found' do
        let(:manager) { create(:employee) }
        let!(:subordinates) { create_list(:employee, 2, company: manager.company, manager: manager) }
        let(:id) { manager.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.size).to eq(2)
          expect(data.map{ |e| e['id'] }).to match_array(subordinates.map(&:id))
        end
      end
    end
  end
end