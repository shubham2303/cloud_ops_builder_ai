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
        try = 0
        begin
          business = individual.businesses.create!(business_params)
        rescue Exception=> e
          if (e.message.include? ("index_businesses_on_uuid")) && (try< 5)
            try+=1
            retry
          else
            super
          end
        end
        IndiBusiCollecSmsWorker.perform_async(individual.phone,"Hello #{name}, your business '#{business name}' has been successfully registered with EIRS Connect. Your business's id is #{business.uuid}")
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
