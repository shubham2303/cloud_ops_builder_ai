module Api
  module V1
    class BusinessesController < BaseController
      before_action :check_headers

      # POST   /api/v1/individuals/:individual_id/businesses
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
      #
      # --- OR ---
      #
      # POST   /api/v1/businesses
      #
      # {
      # "business":
      #     {
      #         "address": "9999999999",
      #         "category": "Abia",
      #         "lga": "Egor",
      #         "year": "2017",
      #         "turnover": 2000
      #     },
      #   "individual_id": "id | payer_id | 234-phone"
      # }
      # ---
      def create
        verify_lga = Individual.check_lga_with_agent(theAgent, business_params[:lga])
        unless verify_lga
          message = I18n.t(:lga_access_not_allowed)
          create_errors(message, 2001)
          render json: {status: 0, message: message}
          return
        end
        individual = get_individual
        if business_params[:uuid]
          business = individual.businesses.create!(business_params)
        else
          business = individual.businesses.create!(business_params.merge(uuid: SecureRandom.uuid))
        end
        IndiBusiCollecSmsWorker.perform_async(individual.phone,
                                              I18n.t(:sms_object_registered,
                                                     name: individual.first_name,
                                                     obj_type: 'business',
                                                     obj_id: business.name))
        render json: {status: 1, data: {individual: individual, business: business}}
      end

      private

      def get_individual
        id = params.require(:individual_id)
        if id.to_s.numeric?
          begin
            return Individual.find_by!(phone: id)
          rescue
            return Individual.find(id)
          end
        else
          return Individual.find_by!(uuid: id)
        end
      end

      def business_params
        params.require(:business).permit(:name, :address, :turnover, :year, :lga, :uuid, :created_at)
      end
    end
  end
end
