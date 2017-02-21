module Api
  module V1
    class BusinessesController < BaseController
      before_action :check_headers

      def create
        if params[:pid]
          individual = Individual.find_by(pid: params[:pid])
        else
          individual = Individual.find(params.require(:id))
        end
        business = individual.businesses.create!(business_params)
        render json: {success: 1,business: business}
      end
      private

      def business_params
        params.require(:business).permit(:address, :category, :turnover, :year, :lga)
      end
    end
  end
end
