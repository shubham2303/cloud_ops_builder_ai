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

      def check_headers
        @agent = Agent.find(request.headers["uid"] )
        app_config = JSON.parse(ENV["APP_CONFIG"])
        unless @agent.token.token == request.headers["token"] || app_config['config_version'] == request.headers["config_version"] || app_config['android_version'] == request.headers["android_version"]
          render json: {success: 0}
          return
        end
      end
    end
  end
end