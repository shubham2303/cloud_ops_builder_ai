module Api
  module V1
    class Vas2netsController < BaseController

      skip_before_action :authenticate_headers
      
      def index
        render plain: "OK.#{params[:message_id]}"
      end
    end
  end
end