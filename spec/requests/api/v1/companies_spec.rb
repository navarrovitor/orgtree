require 'rails_helper'

RSpec.describe "Api::V1::Companies", type: :request do
  describe "GET /api/v1/companies" do
    it "returns a successful response with all companies" do
      # Setup
      company_one = Company.create!(name: "ABCorp")
      company_two = Company.create!(name: "GHInc")

      # Requisição
      get "/api/v1/companies"

      # Asserções (Expectations)
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(2)
      expect(json_response.first['name']).to eq(company_one.name)
      expect(json_response.last['name']).to eq(company_two.name)
    end
  end

  describe "POST /api/v1/companies" do
    context "with valid parameters" do
      let(:valid_params) { { company: { name: "ABCorp" } } }

      it "creates a new company and returns a successful response" do
        # Verifica se o número de empresas no banco aumenta em 1
        expect {
          post "/api/v1/companies", params: valid_params
        }.to change(Company, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq("ABCorp")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { company: { name: "" } } }

      it "does not create a new company and returns an error" do
        expect {
          post "/api/v1/companies", params: invalid_params
        }.not_to change(Company, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to include("can't be blank")
      end
    end
  end
end