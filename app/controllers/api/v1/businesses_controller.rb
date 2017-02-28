module Api
  module V1
    class BusinessesController < BaseController
      before_action :check_headers

      # POST   /api/v1/individuals/:uuid/businesses
      #
      # {
      # "business":
      #     {
      #         "address": "9999999999",
      #         "category": "Abia",
      #         "lga": "Egor",
      #         "year": "2017",
      #         "turnover": 2000
      #     }
      # }
      #---
      def create
        individual = Individual.find_by!(uuid: uuid_param)
        individual.businesses.create!(business_params)
        render json: {status: 1,data: {uuid: individual.uuid}}
      end

      private

      def uuid_param
        params[:uuid]
      end  

      def business_params
        params.require(:business).permit(:address, :category, :turnover, :year, :lga)
      end
    end
  end
end
