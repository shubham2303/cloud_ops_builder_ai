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
          if @data['uuid']
            individual = Individual.find_by!(uuid: @data['uuid'])
            individual.amount =+ @data['amount']
            @str = "payer id"
          elsif @data['obj_type']== 'Individual'
            individual = Individual.find(@data['id'])
            individual.amount =+ @data['amount']
            @str = "payer id"
          else
            @business = Business.find(@data['id'])
            individual = @business.individual
            individual.amount += @data['amount']
            @business.amount += @data['amount']
            @str = "business id"
          end
        rescue
          render json: {status: 0, message: "uuid is not valid"}
          return
        end
        verify_lga = Individual.verify_lga_with_agent_and_param(theAgent, @data['lga'], individual.lga)
        unless verify_lga || (!@business.nil? && (@business.lga == @data['lga']))
          render json: {status: 0, message: I18n.t(:lga_access_not_allowed)}
          return
        end
        begin
          collection = Collection.new(category_type: @data['type'], subtype: @data['subtype'],
                                      number: @data['number'], amount: @data['amount'], period: @data['period'],
                                      lga: @data['lga'], agent: theAgent, individual: individual, collectionable: @business)

          ActiveRecord::Base.transaction do
            card = Card.verify_and_use(@data['number'], @data['amount'])
            batch_id = card.batch_id
            collection.batch_id = batch_id
            collection.save!
            @business.save! unless @business.nil?
            individual.save!
          end
          IndiBusiCollecSmsWorker.perform_async(individual.phone, "Hello #{individual.name}, a collection of #{collection.amount} has been registered against your #{@str} #{individual.uuid} using the card #{collection.number}. Collection id is #{collection.id}")
          render json: {status: 1, data: {collection: collection.as_json(:include=>  [:collectionable, :individual])}}
        rescue AmountExceededError, InvalidCardError => ex
          Rails.logger.debug "exception --------#{ex}----------"
          render json: {status: 0, message: ex.message }
          return
        rescue
          render json: {status: 0, message: "Unable to record revenue collection at the moment, please try again later" }
        end
      end
    end
  end
end
