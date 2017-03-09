module Api
  module V1
    class AgentsController < BaseController
      before_action :check_headers

      # PUT  /api/v1/agents/me
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
            theToken.update!(device_id: params[:device_id])
          end
          theAgent.update!(agent_params)
        end
        render json: {status: 1, data: {agent: theAgent, token: theToken.token}}
      end

      private

      def agent_params
        params.require(:agent).permit(:phone, :first_name, :last_name, :address, :birthplace, :state, :dob)
      end

    end
  end
end