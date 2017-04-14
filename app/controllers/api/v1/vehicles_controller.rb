module Api
  module V1
    class VehiclesController < BaseController
      before_action :check_headers

      # POST   /api/v1/individuals/:uuid/vehicles
      #
      # {
      # "vehicle":
      #     {
      #         "lga": "Egor",
      #         "vehicle_number": "DL2034"
      #     }
      # }
      # ---
      def create
        individual = Individual.find_by!(uuid: uuid_param)
        verify_lga = Individual.check_lga_with_agent(theAgent, vehicle_params[:lga])
        unless verify_lga
          render json: {status: 0, message: I18n.t(:lga_access_not_allowed)}
          return
        end
        vehicle = individual.vehicles.create!(vehicle_params)
        IndiBusiCollecSmsWorker.perform_async(individual.phone,
                                              I18n.t(:sms_object_registered,
                                                     name: individual.first_name,
                                                     obj_type: 'vehicle',
                                                     obj_id: vehicle.vehicle_number))
        render json: {status: 1, data: {individual: individual, vehicle: vehicle}}
      end

      # POST   /api/v1/vehicles
      #
      # {
      # "vehicle":
      #     {
      #         "lga": "Egor",
      #         "vehicle_number": "DL2034",
      #         "phone": "64564565445"
      #     }
      # }
      # ---  
      def create_alone
        verify_lga = Individual.check_lga_with_agent(theAgent, vehicle_params[:lga])
        unless verify_lga
          message = I18n.t(:lga_access_not_allowed)
          create_errors(message, 2001)
          render json: {status: 0, message: message}
          return
        end
        vehicle = Vehicle.create!(vehicle_params)
        unless vehicle.phone.blank?
          IndiBusiCollecSmsWorker.perform_async(vehicle.phone,
                                                I18n.t(:sms_object_registered,
                                                       name: '',
                                                       obj_type: 'vehicle',
                                                       obj_id: vehicle.vehicle_number))
        end
        vehicle_hsh = vehicle.as_json
        vehicle_hsh.delete("individual_id")
        render json: {status: 1, data: {vehicle: vehicle_hsh} }

      end  

      # create vehicle for an existing or new individual
      # POST /api/v1/individuals/vehicle
      # {
      #     "vehicle":
      #         {
      #             "vehicle_number": "Dl4323",
      #             "lga": "Egor"
      #         },
      #     "individual":
      #         {
      #             "name": "Abia",
      #             "phone": "9990170194"
      #         }
      # }
      def vehicle
        individual = Individual.find_by(phone: individual_params[:phone])
        unless individual.nil?
          message = I18n.t(:individual_found_error, target: 'vehicle')
          create_errors(message, 2001)
          render json: {status: 0, message: message}
          return
        end
        verify_lga = Individual.verify_lga_with_agent_and_param(theAgent, business_params[:lga], vehicle_params[:lga])
        unless verify_lga
          render json: {status: 0, message: I18n.t(:lga_access_not_allowed)}
          return
        end
        ActiveRecord::Base.transaction do
          unless individual_params[:uuid]
            payer_id = Individual.generate_payer_id(individual_params[:first_name],individual_params[:last_name], theAgent.id)
            @individual = Individual.create!(individual_params.merge(uuid: payer_id))
          else
            @individual = Individual.create!(individual_params)
          end
          @vehicle = @individual.vehicles.create!(vehicle_params)
        end
          IndiBusiCollecSmsWorker.perform_async(@individual.phone,
                                                I18n.t(:sms_individual_registered,
                                                       name: @individual.first_name,
                                                       payer_id: @individual.uuid.downcase))
        IndiBusiCollecSmsWorker.perform_async(@individual.phone,
                                              I18n.t(:sms_object_registered,
                                                     name: @individual.first_name,
                                                     obj_type: 'vehicle',
                                                     obj_id: @vehicle.vehicle_number))
        render json: {status: 1, data: {individual: individual, vehicle: @vehicle}}
      end

      private

      def uuid_param
        params[:uuid]
      end

      def individual_params
        params.require(:individual).permit(:phone, :first_name, :last_name, :address, :lga, :uuid, :created_at)
      end

      def vehicle_params
        params.require(:vehicle).permit(:vehicle_number, :lga, :phone, :created_at)
      end
    end
  end
end
