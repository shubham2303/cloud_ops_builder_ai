module Api
  module V1
    class Vas2netsController < BaseController

      def vas2net
        render json: {status: 1 }
      end
    end
  end
end
