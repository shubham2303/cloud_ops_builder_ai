module Api
  module V1
    class IndividualsController < BaseController
      before_action :check_headers

      # POST /api/v1/individuals
      # {
      #   "individual":
      #     {
      #      "name": "Abia",
      #      "phone": "64564565445",
      #      "address": "wefefefef"
      #     }
      # }
      def create
        individual = Individual.create!(individual_params)
        render json: {status: 1, data: {uuid: individual.uuid}}
      end

      # create business for an existing or new individual
      # POST /api/v1/individuals/business
      # {
      #     "business":
      #         {
      #             "address": "9999999999",
      #             "name": "Abia",
      #             "lga": "Egor",
      #             "year": "2017"
      #         },
      #     "individual":
      #         {
      #             "name": "Abia",
      #             "phone": "9990170194"
      #         }
      # }
      def business
        individual = Individual.find_or_initialize_by(phone: individual_params[:phone])
        individual.update!(individual_params)
        individual.businesses.create!(business_params)
        render json: {status: 1, data: {uuid: individual.uuid}}
      end

      private

      def individual_params
        params.require(:individual).permit(:phone, :name, :address)
      end

      def business_params
        params.require(:business).permit(:name, :address, :turnover, :year, :lga)
      end
    end
  end
end