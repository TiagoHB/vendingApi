require 'rails_helper'

RSpec.describe "api/v1/vendings", type: :request do
  describe "GET /deposit" do
    it "returns http success" do
      get "/vending/deposit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /buy" do
    it "returns http success" do
      get "/vending/buy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /reset" do
    it "returns http success" do
      get "/vending/reset"
      expect(response).to have_http_status(:success)
    end
  end

end
