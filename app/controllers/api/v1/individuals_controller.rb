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
          message = I18n.t(:lga_access_not_allowed)
          create_errors(message, 2001)
          render json: {status: 0, message: message}
          return
        end
        try = 0
        begin
          unless individual_params[:uuid]
            payer_id = Individual.generate_payer_id_v2(theAgent.id)
            individual = Individual.create!(individual_params.merge(uuid: payer_id))
          else
            individual = Individual.create!(individual_params)
          end
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
           payer_id: individual.uuid.downcase))
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
        individual = Individual.find_by(phone: individual_params[:phone])
        unless individual.nil?
          render json: {status: 0, message: I18n.t(:individual_found_error, target: 'business')}
          return
        end
        verify_lga = Individual.verify_lga_with_agent_and_param(theAgent, business_params[:lga], individual_params[:lga])
        unless verify_lga
          render json: {status: 0, message: I18n.t(:lga_access_not_allowed)}
          return
        end
        begin
          ActiveRecord::Base.transaction do
            if individual_params[:uuid]
              @individual = Individual.create!(individual_params)
            else
              payer_id = Individual.generate_payer_id_v2(theAgent.id)
              @individual = Individual.create!(individual_params.merge(uuid: payer_id))
            end
            if business_params[:uuid]
              @business = @individual.businesses.create!(business_params)
            else
              @business = @individual.businesses.create!(business_params.merge(uuid: SecureRandom.uuid))
            end
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
        IndiBusiCollecSmsWorker.perform_async(@individual.phone,
          I18n.t(:sms_individual_registered,
           name: @individual.first_name,
           payer_id: @individual.uuid.downcase))

        IndiBusiCollecSmsWorker.perform_async(@individual.phone,
          I18n.t(:sms_object_registered,
           name: @individual.first_name,
           obj_type: 'business',
           obj_id: @business.name))
        render json: {status: 1, data: {individual: @individual, business: @business}}
      end

      # GET /api/v2/individuals?q=SDSDS for vehicle association null for individual
      # GET /api/v1/individuals?q=SDSDS for otherwise
      def get_individuals
        is_v1 = request.path.include?('/v1/')

        if params[:q].to_s.numeric?
          number = Individual.get_accurate_number(params[:q])
          individual = Individual.find_by(phone: number)
          @matched = "none"
        else
          individual = Individual.find_by(uuid: params[:q].upcase)
          @matched = "payer_id"
        end
        @hsh = if is_v1
                 { individual: individual.as_json(:include => [:businesses, :vehicles]) }
               else
                 { individual: individual.as_json(:include => [:businesses]) }
               end

        if individual.nil?
          begin
            vehicle = Vehicle.find_by!(vehicle_number: params[:q].upcase)
            @matched = "vehicle_number"
          rescue
            render json: {status: 0, message: "No matches found"}
            return
          end

          if is_v1
            individual = vehicle.individual
            if individual.nil?
              render json: {status: 0, message: "No matches found"}
              return
            end

            @hsh = { individual: individual.as_json(:include => [:businesses, :vehicles]) }
          else
            @hsh = { vehicle: vehicle }
          end
        end
        render json: {status: 1, data: {matched: @matched}.merge(@hsh)}
      end



      private

      def individual_params
        params.require(:individual).permit(:phone, :first_name, :last_name, :address, :lga, :uuid, :created_at)
      end

      def business_params
        params.require(:business).permit(:name, :address, :turnover, :year, :lga, :uuid)
      end
    end
  end
end
