module Api
  module V1
    class OfflineController < BaseController
      before_action :check_headers

      def down_sync
        if params[:timestamp]
         vehicles = Vehicle.where("updated_at >= ?", params[:timestamp])
         businesses = Business.where("updated_at >= ?", params[:timestamp])
         individuals = Individual.where("updated_at >= ?", params[:timestamp])
         batch_details = BatchDetail.where("updated_at >= ?", params[:timestamp])
        else
          vehicles = Vehicle.all
          businesses = Business.all
          individuals = Individual.all
          batch_details = BatchDetail.all
        end
        render json: {status: 1, vehicles: vehicles.as_json(only: [:id, :vehicle_number, :lga]),
                      businesses: businesses.as_json(only: [:id, :uuid, :name, :lga]),
                      individuals: individuals.as_json(only: [:id, :uuid, :first_name, :last_name, :lga, :phone]),
                      cards: batch_details.as_json(only: [:n, :amount]), timestamp: Time.now.utc }
      end

    end
  end

end
