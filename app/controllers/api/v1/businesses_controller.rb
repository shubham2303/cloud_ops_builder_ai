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
      # ---
      def create
        individual = Individual.find_by!(uuid: uuid_param)
        verify_lga = Individual.verify_lga_with_agent_and_param(theAgent, business_params[:lga], individual.lga)
        unless verify_lga
          render json: {status: 0, message: "could not match lga"}
          return
        end
        try = 0
        begin
          business = individual.businesses.create!(business_params)
        rescue Exception=> e
          Rails.logger.debug "exception --------#{e}----------"
          if (e.message.include? ("index_businesses_on_uuid")) && (try< 5)
            try+=1
            retry
          else
            raise e
          end
        end
        IndiBusiCollecSmsWorker.perform_async(individual.phone,"Hello #{individual.first_name}, your business '#{business.name}' has been successfully registered with EIRS Connect")
        render json: {status: 1, data: {individual: individual, business: business}}
      end

      private

      def uuid_param
        params[:uuid]
      end  

      def business_params
        params.require(:business).permit(:name, :address, :turnover, :year, :lga)
      end
    end
  end
end
