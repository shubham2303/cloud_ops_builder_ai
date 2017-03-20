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
        verify_lga = Individual.verify_lga_with_agent_and_param(theAgent, vehicle_params[:lga], individual.lga)
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
        individual = Individual.find_or_initialize_by(phone: individual_params[:phone])
        checknew_record= individual.new_record?
        verify_lga = Individual.verify_lga_with_agent_and_param(theAgent, vehicle_params[:lga], individual_params[:lga])
        unless verify_lga
          render json: {status: 0, message: I18n.t(:lga_access_not_allowed)}
          return
        end
        ActiveRecord::Base.transaction do
          individual.update!(individual_params)
          @vehicle = individual.vehicles.create!(vehicle_params)
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
                                                     obj_type: 'vehicle',
                                                     obj_id: @vehicle.vehicle_number))
        render json: {status: 1, data: {individual: individual, vehicle: @vehicle}}
      end

      private

      def uuid_param
        params[:uuid]
      end

      def individual_params
        params.require(:individual).permit(:phone, :first_name, :last_name, :address, :lga)
      end

      def vehicle_params
        params.require(:vehicle).permit(:vehicle_number, :lga)
      end
    end
  end
end
