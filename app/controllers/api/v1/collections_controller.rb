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
        elsif !AppConfig.type_enabled? type
          render json: {status: 0, message: "type is not enabled"}
          return
        elsif !AppConfig.subtype_exist?(type, @data['subtype'])
          render json: {status: 0, message: "subtype is not valid"}
          return
        else
          # nothing to do
        end
        begin
          Card.verify_and_use(@data['number'], @data['amount'])
          batch_detail = BatchDetail.find_by!(n: @data['number'])
          batch = batch_detail.batch
        rescue Exception => msg
          render json: {status: 0, message: msg}
          return
        end
        if @data['uuid'].upcase[0] == 'I'
          individual = Individual.find_by!(uuid: @data['uuid'].upcase)
        else
          @business = Business.find_by!(uuid: @data['uuid'].upcase)
          individual = @business.individual
        end
        collection = Collection.create!(category_type: @data['type'], subtype: @data['subtype'],
                                        number: @data['number'], amount: @data['amount'], period: @data['period'],
                                        batch: batch, agent: theAgent, individual: individual, business: @business)
        render json: {status: 1, data: {individual: individual.as_json(:only=>  [:name, :uuid]), amount: collection.amount }}

      end
    end
  end
end
