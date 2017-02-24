module Api
  module V1
    class BusinessesController < BaseController
      before_action :check_headers

      # POST   /api/v1/individuals/:pid/businesses
      #              OR
      # POST   /api/v1/businesses
      #
      #{
      # "pid": 1, // individual id
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
        individual = Individual.find_by(pid: pid_param)

        if params[:individual]
          individual.update!(individual_params)
        end
        business = individual.businesses.create!(business_params)
        render json: {status: 1,business: business}
      end

      private

      def pid_param
        params[:pid] || params.require(:id)
      end  

      def individual_params
        params.require(:individual).permit(:phone, :name, :address)
      end

      def business_params
        params.require(:business).permit(:address, :category, :turnover, :year, :lga)
      end
    end
  end
end
