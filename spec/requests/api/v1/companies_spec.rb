require 'rails_helper'

RSpec.describe "Api::V1::Companies", type: :request do
  describe "GET /api/v1/companies" do
    it "returns a successful response with all companies" do
      create_list(:company, 2)
      
      get "/api/v1/companies"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(2)
    end
  end

  describe "GET /api/v1/companies/:id" do
    context "when the company does not exist" do
      it "returns a not found status" do
        get "/api/v1/companies/99999"

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to include("Couldn't find Company with 'id'=99999")
      end
    end
  end
  describe "POST /api/v1/companies" do
    context "with valid parameters" do
      let(:valid_params) { { company: attributes_for(:company) } }
      
      it "creates a new company and returns a successful response" do
        expect {
          post "/api/v1/companies", params: valid_params
        }.to change(Company, :count).by(1)

        expect(response).to have_http_status(:created)
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