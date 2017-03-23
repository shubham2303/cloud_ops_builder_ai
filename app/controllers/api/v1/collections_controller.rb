module Api
  module V1
    class CollectionsController < BaseController
      before_action :check_headers
      before_action :get_data_using_decryption, except: :index

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
            @target = "Payer Id: #{individual.uuid}"
          elsif @data['obj_type']== 'Individual'
            individual = Individual.find(@data['id'])
            individual.amount =+ @data['amount']
            @target = "Payer Id: #{individual.uuid}"
          elsif @data['obj_type']== 'Business'
            @obj = Business.find(@data['id'])
            individual = @obj.individual
            individual.amount += @data['amount']
            @obj.amount += @data['amount']
            @target = "Business: '#{@obj.name}'"
          else
            @obj = Vehicle.find(@data['id'])
            individual = @obj.individual
            individual.amount += @data['amount']
            @obj.amount += @data['amount']
            @target = "Vehicle: '#{@obj.vehicle_number}'"
          end
        rescue
          render json: {status: 0, message: "uuid is not valid"}
          return
        end
        verify_lga = Individual.check_lga_with_agent(theAgent, @data['lga'])
        obj_lga = @obj.nil? ? individual.lga: @obj.lga
        ver_obj_lga = Individual.verify_object_lga(@data['lga'], obj_lga)
        unless verify_lga && ver_obj_lga
          render json: {status: 0, message: I18n.t(:lga_access_not_allowed)}
          return
        end
        begin
          collection = Collection.new(category_type: @data['type'], subtype: @data['subtype'],
                                      number: @data['number'], amount: @data['amount'], period: @data['period'],
                                      lga: @data['lga'], agent: theAgent, individual: individual, collectionable: @obj)

          ActiveRecord::Base.transaction do
            card = Card.verify_and_use(@data['number'], @data['amount'])
            batch_id = card.batch_id
            collection.batch_id = batch_id
            collection.save!
            @obj.save! unless @obj.nil?
            individual.save!
          end
          IndiBusiCollecSmsWorker.perform_async(individual.phone,
                                                I18n.t(:sms_collection_created,
                                                       name: individual.name,
                                                       amount: collection.amount,
                                                       target: @target,
                                                       card_number: collection.number,
                                                       collection_id: collection.id))
          render json: {status: 1, data: {collection: collection.as_json(:include=>  [:collectionable, :individual])}}
        rescue AmountExceededError, InvalidCardError => ex
          Rails.logger.debug "exception --------#{ex}----------"
          render json: {status: 0, message: ex.message }
          return
        rescue
          render json: {status: 0, message: "Unable to record revenue collection at the moment, please try again later" }
        end
      end

      # GET /api/v1/collections/?page=4&date=Fri, 17 Mar 2017
      def index
        begin
          collections = Collection.get_collections(params, theAgent)
        rescue
          render json: {status: 0, message: "No Result Found" }
          return
        end
        if params[:date]
          collections = collections.where('Date(created_at) <= ?', params[:date])
        end
        render json: {status: 1, data: {collections: collections.includes(:individual, :collectionable).as_json(:include=>  [:collectionable, :individual])}}
      end
    end
  end
end
