module Api
  module V1
    class AgentsController < BaseController
      before_action :check_headers

      def update_me
        ActiveRecord::Base.transaction do
          if params[:device_id]
            @agent.token.update!(device_id: params[:device_id])
          end
          @agent.update!(agent_params)
        end
        render json: {success: 1}
      end

      private

      def agent_params
        params.require(:agent).permit(:phone, :name, :address, :birthplace, :state, :lga)
      end

    end
  end
end