module Api
  module V1
    class BusinessesController < BaseController
      before_action :check_headers

      # POST   /api/v1/individuals/:pid/businesses
      #              OR
      # POST   /api/v1/individuals/businesses
      #
      #{"id": 1,
      # "business":
      #     {
      #         "address": "9999999999",
      #         "category": "Abia",
      #         "lga": "Egor",
      #         "year": "2017",
      #         "turnover": 2000
      #     },
      #     "individual":
      #     {
      #         "phone": "9999999979",
      #         "name": "Abia",
      #         "address": "Egor"
      #     }
      # }
      #---
      def create
        if params[:pid]
          individual = Individual.find_by(pid: params[:pid])
        else
          individual = Individual.find(params.require(:id))
        end
        if params[:individual]
          individual.update!(individual_params)
        end
        business = individual.businesses.create!(business_params)
        render json: {success: 1,business: business}
      end

      private

      def individual_params
        params.require(:individual).permit(:phone, :name, :address)
      end

      def business_params
        params.require(:business).permit(:address, :category, :turnover, :year, :lga)
      end
    end
  end
end
