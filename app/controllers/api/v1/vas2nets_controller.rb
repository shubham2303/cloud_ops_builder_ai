module Api
  module V1
    class Vas2netsController < BaseController

      def card_verify
        render json: {status: 1, data: {}}
      end

    end
  end
end