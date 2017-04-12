module Api
  module V1
    class OfflineController < BaseController
      http_basic_authenticate_with name: "Kamille Watsica", password: "J8O4Js5fQp", only: :dump
      before_action :check_headers , except: :dump


      def down_sync
        get_offline_data
      end

      def dump
        get_offline_data
      end

      def get_offline_data
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
                      businesses: businesses.as_json(only: [:id, :uuid, :name, :lga, :individual_id]),
                      individuals: individuals.as_json(only: [:id, :uuid, :first_name, :last_name, :lga, :phone]),
                      cards: batch_details.as_json(only: [:n, :amount]), timestamp: Time.now.utc }
      end

    end
  end

end
