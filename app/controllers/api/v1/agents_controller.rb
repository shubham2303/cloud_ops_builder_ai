module Api
  module V1
    class AgentsController < BaseController
      before_action :check_headers

      # PUT  /api/v1/agents/:uid
      #
      #  {
      #   "agent": {
      #   "state": "Abia",
      #   "phone": "9908907897",
      #   "address": "fwferrr",
      #   "device_id": "1211",
      #   "birthplace": "sdfdff",
      #   "lga": "fwefrf",
      #   "dob": "23-03-1992"
      #  }
      # }
      def update_me
        ActiveRecord::Base.transaction do
          if params[:device_id]
            theAgent.token.update!(device_id: params[:device_id])
          end
          @agent.update!(agent_params)
        end
        render json: {status: 1, data: {agent: theAgent.token.token}}
      end

      private

      def agent_params
        params.require(:agent).permit(:phone, :name, :address, :birthplace, :state, :lga, :dob)
      end

    end
  end
end