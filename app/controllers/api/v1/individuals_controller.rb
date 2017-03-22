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
        verify_lga = Individual.check_lga_with_agent(theAgent,individual_params[:lga])
        unless verify_lga
          render json: {status: 0, message: I18n.t(:lga_access_not_allowed)}
          return
        end
        try = 0
        begin
          individual = Individual.create!(individual_params)
        rescue Exception=> e
          Rails.logger.debug "exception --------#{e}----------"
          if (e.message.include?("index_individuals_on_uuid")) && (try< 5)
            try+=1
            retry
          else
            raise e 
          end
        end
        IndiBusiCollecSmsWorker.perform_async(individual.phone,
                                              I18n.t(:sms_individual_registered,
                                                     name: individual.first_name,
                                                     payer_id: individual.uuid))
        render json: {status: 1, data: {individual: individual}}
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
        try = 0
        individual = Individual.find_or_initialize_by(phone: individual_params[:phone])
        checknew_record= individual.new_record?
        verify_lga = Individual.verify_lga_with_agent_and_param(theAgent, business_params[:lga], individual_params[:lga])
        unless verify_lga
          render json: {status: 0, message: I18n.t(:lga_access_not_allowed)}
          return
        end
        begin
          ActiveRecord::Base.transaction do
            individual.update!(individual_params) if checknew_record
            @business = individual.businesses.create!(business_params)
          end
        rescue Exception=> e
          Rails.logger.debug "exception --------#{e}----------"
          if (e.message.include?(("index_individuals_on_uuid")||("index_businesses_on_uuid"))) && (try < 5)
            try+=1
            retry
          else
            raise e 
          end
        end
        if checknew_record
          IndiBusiCollecSmsWorker.perform_async(individual.phone,
                                                I18n.t(:sms_individual_registered,
                                                       name: individual.first_name,
                                                       payer_id: individual.uuid))
        end
        IndiBusiCollecSmsWorker.perform_async(individual.phone,
                                              I18n.t(:sms_object_registered,
                                                     name: individual.first_name,
                                                     obj_type: 'business',
                                                     obj_id: @business.name))
        render json: {status: 1, data: {individual: individual, business: @business}}
      end

      def get_individuals
        if params[:q].to_i == 0
          individual = Individual.find_by(uuid: params[:q].upcase)
          @matched = "payer_id"
        else
          number = Individual.get_accurate_number(params[:q])
          individual = Individual.find_by(phone: number)
          @matched = "none"
        end
        if individual.nil?
          begin
            vehicle = Vehicle.find_by!(vehicle_number: params[:q].upcase)
            individual = vehicle.individual
            @matched = "vehicle_number"
          rescue
            render json: {status: 0, message: "Couldn't find Individual"}
            return
          end
        end
        render json: {status: 1, data: {matched: @matched, individual: individual.as_json(:include=> [:businesses, :vehicles])}}
      end



      private

      def individual_params
        params.require(:individual).permit(:phone, :first_name, :last_name, :address, :lga)
      end

      def business_params
        params.require(:business).permit(:name, :address, :turnover, :year, :lga)
      end
    end
  end
end
