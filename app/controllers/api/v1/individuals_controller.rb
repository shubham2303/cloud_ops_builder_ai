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
        individual = Individual.new(individual_params)
        if individual.save
          render json: {success: 1, individual: individual}
        else
          render json: {success: 0}
        end  
      end

      private

      def individual_params
        params.require(:individual).permit(:phone, :name, :address)
      end
    end
  end
end