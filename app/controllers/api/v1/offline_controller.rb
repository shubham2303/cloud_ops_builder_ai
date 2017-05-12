module Api
  module V1
    class OfflineController < BaseController
      http_basic_authenticate_with name: "Kamille Watsica", password: "J8O4Js5fQp", only: :dump
      before_action :authenticate_headers, except: :dump
      before_action :check_headers_without_expiry , except: :dump


      def down_sync
        get_offline_data
      end

      def dump
        get_offline_data
      end

      def get_offline_data
        if params[:timestamp]
          timestamp = Time.parse(params[:timestamp]).utc
        else
          timestamp = Time.parse(ENV['ADMIN_CREATION_TIME']).utc
        end
        time = ENV['TIME'].to_i
        if ((Time.now.utc - timestamp)/3600) > time
          end_timestamp = timestamp + time.hours
        else
          end_timestamp = Time.now.utc
        end
        vehicles = Vehicle.where("updated_at >= ? AND updated_at < ?", timestamp, end_timestamp)
        businesses = Business.where("updated_at >= ? AND updated_at < ?", timestamp, end_timestamp)
        individuals = Individual.where("updated_at >= ? AND updated_at < ?", timestamp, end_timestamp)
        # batch_details = BatchDetail.where("updated_at >= ? AND updated_at < ?", timestamp, end_timestamp)
        vehicles_count = Vehicle.where("updated_at >= ?",end_timestamp).limit(1)
        businesses_count = Business.where("updated_at >= ?", end_timestamp).limit(1)
        individuals_count = Individual.where("updated_at >= ?", end_timestamp).limit(1)
        # batch_details_count = BatchDetail.where("updated_at >= ?", end_timestamp).limit(1)
        if vehicles_count.empty? && businesses_count.empty? && individuals_count.empty?
          try = 0
        else
          try = 1
        end
        theAgent.update last_downsync: Time.now.utc
        render json: {status: 1, vehicles: vehicles.as_json(only: [:id, :vehicle_number, :lga]),
                      businesses: businesses.as_json(only: [:id, :uuid, :name, :lga, :individual_id]),
                      individuals: individuals.as_json(only: [:id, :uuid, :first_name, :last_name, :lga, :phone]),
                      cards: [], timestamp: end_timestamp, try: try}
      end

      def cards
        agent_id = theAgent.id
        agent_table = AgentTable.find_by(agent_id: agent_id)
        if agent_table.nil?
          params[:id] = 0
          AgentTable.create!(agent_id: agent_id, migration_version: 1, migration_target: "card")
        end
        batch_details = BatchDetail.where("id > ?", params[:id] || ENV['FALLBACK_CARD_ID'] || 0).where('created_at = updated_at').order(id: :ASC).limit(ENV['CARD_LIMIT'])
        last_card = batch_details.last
        if last_card.nil?
          last_card_id = nil
        else
          last_card_id = last_card.id
        end
        out = BatchDetail.detail_json(batch_details)
        theAgent.update last_downsync: Time.now.utc
        render json: {status: 1, cards: out, id: last_card_id}
      end

      def card_down_sync
        timestamp = params[:timestamp]|| Time.parse(ENV['ADMIN_CREATION_TIME']).to_f.to_s
        time = DashboardHelper.time_conversion(timestamp)

        batch_details = BatchDetail.where("(updated_at > ?) or (updated_at = ? AND id > ?)",time, time, params[:card_id]||0)
                            .where('created_at != updated_at').order(updated_at: :ASC, id: :ASC).limit(ENV['CARD_LIMIT'])
        last_card = batch_details.last

        unless last_card.nil?
          @last_card_id = last_card.id
          @last_card_timestamp = last_card.updated_at.to_f.to_s
          if @last_card_id == params[:card_id].to_i && last_card.remaining_amount == params[:amount].to_i
            @last_card_id = nil
            @last_card_timestamp = nil
          end
        end
        out = BatchDetail.detail_json(batch_details)
        theAgent.update last_downsync: Time.now.utc
        render json: {status: 1, cards: out, card_id: @last_card_id, timestamp: @last_card_timestamp}
      end

    end
  end

end
