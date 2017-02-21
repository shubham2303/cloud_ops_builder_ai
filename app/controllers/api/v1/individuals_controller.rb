module Api
  module V1
    class IndividualsController < BaseController
      before_action :check_headers

      def create
        individual = Individual.create!(individual_params)
        render json: {success: 1, individual: individual}
      end

      private

      def individual_params
        params.require(:individual).permit(:phone, :name, :address)
      end
    end
  end
end