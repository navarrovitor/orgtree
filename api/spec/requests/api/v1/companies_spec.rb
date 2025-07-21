require 'swagger_helper'

RSpec.describe "Api::V1::Companies", type: :request do
  path '/api/v1/companies' do
    get 'Lists all companies' do
      tags 'Companies'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number for pagination'

      response '200', 'successful' do
        # Setup: Create more companies than the page size to test pagination
        before { create_list(:company, 12) }
        
        run_test! do |response|
          json_response = JSON.parse(response.body)

          # Assertion: Check for the paginated structure
          expect(json_response.keys).to contain_exactly('data', 'pagy')
          expect(json_response['data'].size).to eq(10)
          expect(json_response['pagy']['count']).to eq(12)
        end
      end
    end

    post 'Creates a company' do
      tags 'Companies'
      consumes 'application/json'
      parameter name: :company_params, in: :body, schema: {
        type: :object,
        properties: {
          company: {
            type: :object,
            properties: {
              name: { type: :string, example: 'NewCo' }
            },
            required: ['name']
          }
        },
        required: ['company']
      }

      response '201', 'company created' do
        let(:company_params) { { company: { name: 'Test Company' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('Test Company')
        end
      end

      response '422', 'invalid request (e.g., blank name)' do
        let(:company_params) { { company: { name: '' } } }
        run_test!
      end
    end
  end

  path '/api/v1/companies/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Company ID'

    get 'Retrieves a company' do
      tags 'Companies'
      produces 'application/json'

      response '200', 'company found' do
        let(:id) { create(:company, name: 'Specific Company').id }
        
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('Specific Company')
        end
      end

      response '404', 'company not found' do
        let(:id) { 'invalid-id' }
        run_test!
      end
    end
  end
end