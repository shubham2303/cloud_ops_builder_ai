module Api
  module V1
    class CollectionsController < BaseController
      before_action :check_headers, :get_data_using_decryption

      def test_decryption
        render json: {success: 1, data: @data}
      end

      def create

      end
    end
  end
end
