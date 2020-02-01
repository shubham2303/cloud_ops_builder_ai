require 'rails_helper'

RSpec.describe ViewPricingController do
  describe "GET pricing " do
    it "assigns terms" do
      term = [
          {"description" => "$6.0E-7  per Request for Lambda-Edge-Request in EU (Paris)",
           "beginRange" => "0",
           "endRange" => "Inf",
           "unit" => "Request",
           "pricePerUnit" => "0.0000006000",
           "effectiveDate" => "2019-12-01T00:00:00Z"}]
      get :index
      data = JSON.parse(response.body)
      expect(data["data"][0]).to eq(term[0])
    end

  end
end