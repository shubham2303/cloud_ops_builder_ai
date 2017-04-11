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
        verify_lga = Individual.check_lga_with_agent(theAgent, business_params[:lga])
        unless verify_lga
          render json: {status: 0, message: I18n.t(:lga_access_not_allowed)}
          return
        end
        try = 0
        begin
          unless business_params[:uuid]
            business = individual.businesses.create!(business_params.merge(uuid: ShortUUID.unique))
          else
            business = individual.businesses.create!(business_params)
          end
        rescue Exception=> e
          Rails.logger.debug "exception --------#{e}----------"
          if (e.message.include? ("index_businesses_on_uuid")) && (try< 5)
            try+=1
            retry
          else
            raise e
          end
        end
        IndiBusiCollecSmsWorker.perform_async(individual.phone,
                                              I18n.t(:sms_object_registered,
                                                     name: individual.first_name,
                                                     obj_type: 'business',
                                                     obj_id: business.name))
        render json: {status: 1, data: {individual: individual, business: business}}
      end

      private

      def uuid_param
        params[:uuid]
      end  

      def business_params
        params.require(:business).permit(:name, :address, :turnover, :year, :lga, :uuid)
      end
    end
  end
end
