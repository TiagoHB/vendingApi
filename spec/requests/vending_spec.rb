require 'rails_helper'

RSpec.describe "api/v1/vendings", type: :request do

  before do
    @useller = User.new(email:'seller@store.com', password:'111111',role:"seller")
    @useller.save
    
    @prod = Product.new(productName: "phone", cost: 5, amountAvailable: 10, seller: @useller )
    @prod.save

    @user = User.new(username:'buyerUser', password:'111111',role:"buyer")
    @user.save
  end

  describe "POST /deposit" do
    it "returns http success" do
      post "/api/v1/deposit", params: { coin_value: 10 }, as: :json
      expect(response).to have_http_status(401)

      @headers = get_headers(@user.username)
      post "/api/v1/deposit", params: { coin_value: 10 }, headers: @headers, as: :json
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /api/v1/buy" do
    it "returns http success" do
      
      post "/api/v1/buy", params: { productId: @prod.id, amount: 1 }
      expect(response).to have_http_status(401)
      
      @headers = get_headers(@user.username)
      post "/api/v1/deposit", params: { coin_value: 10 }, headers: @headers, as: :json
      post "/api/v1/buy", params: { productId: @prod.id, amount: 1 }, headers: @headers, as: :json
      expect(response).to have_http_status(:success)

      # TODO: Test change calculation
      # post "/api/v1/deposit", params: { coin_value: 10 }, headers: @headers, as: :json
      # post "/api/v1/buy", params: { productId: @prod.id, amount: 1 }, headers: @headers, as: :json
      # expect(response.body).to eq({ "totalSpent": 5, "product": "phone", "change": { "100": 0, "50": 0, "20": 0, "10": 0, "5": 1 } })
    end
  end

  describe "POST /api/v1/reset" do
    it "returns http success" do
      post "/api/v1/reset"
      expect(response).to have_http_status(401)
      
      @headers = get_headers(@user.username)
      post "/api/v1/reset", headers: @headers
      expect(response).to have_http_status(:success)
    end
  end

end
