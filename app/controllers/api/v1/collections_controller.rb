module Api
  module V1
    class CollectionsController < BaseController
      before_action :check_headers

      def test_decryption
        render json: {status: 1, data: @data}
      end

      def create
        if AppConfig.check_type_subtype_valid?(params[:type], params[:subtype])
          collection = Collection.create!(data)
        else
        end
      collection = Collection.create!(data)
      render json: {status: 1, data: {collection: collection}}
      end

      private

      def collection_params
        params.require(:collection).permit(:type, :subtype, :number, :amount, :agent_id, :individual_id, :business_id)
      end
    end
  end
end
