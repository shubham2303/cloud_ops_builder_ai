module Api
  module V1
    class CollectionsController < BaseController
      before_action :check_headers, :get_data_using_decryption

      def test_decryption
        render json: {status: 1, data: @data}
      end

      def create
        type= AppConfig.type_exist?(@data['type'])
        if type.nil?
          render json: {status: 0, message: "type is not valid"}
          return
        elsif !AppConfig.subtype_exist?(type, @data['subtype'])
          render json: {status: 0, message: "subtype is not valid"}
          return
        else
        end
        begin
          card = Card.verify_and_use(@data['number'], @data['amount'])
          # batch = card.batch
        rescue Exception => msg
          render json: {status: 0, message: msg}
          return
        end
        if @data['uuid'][0] == 'I'
          individual = Individual.find_by!(uuid: @data['uuid'])
        else
          business = Business.find_by!(uuid: @data['uuid'])
        end
        byebug
        collection = Collection.create!(type: @data['type'], subtype: @data['subtype'], number: @data[:number], amount: @data['amount'])
        render json: {status: 1, data: {collection: collection}}

      end

      private

      def collection_params
        params.require(:collection).permit(:type, :subtype, :number, :amount, :agent_id, :individual_id, :business_id)
      end
    end
  end
end
