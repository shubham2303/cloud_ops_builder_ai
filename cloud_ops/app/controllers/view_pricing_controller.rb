class ViewPricingController < ApplicationController

  def index
    response = Operations::GetPricing.new(params).run
    data = response.map { |req| PricingSerializer.new(req)}
    render json: {data: data}
  end
end
