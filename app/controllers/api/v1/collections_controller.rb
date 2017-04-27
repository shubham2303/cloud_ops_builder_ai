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
          message = "type is not valid"
          create_errors(message, 2002)
          render json: {status: 0, message: message}
          return
        elsif !AppConfig.type_enabled? type
          message = "type is not enabled"
          create_errors(message, 2003)
          render json: {status: 0, message: message}
          return
        elsif !AppConfig.subtype_exist?(type, @data['subtype'])
          message = "subtype is not valid"
          create_errors(message, 2004)
          render json: {status: 0, message: message}
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
            if @data['id'].to_s.numeric?
              individual = Individual.find_by(phone: @data['id'])||Individual.find(@data['id'])
            else
              individual = Individual.find_by!(uuid: @data['id'])
            end
            individual.amount =+ @data['amount']
            @target = "Payer Id: #{individual.uuid}"
          elsif @data['obj_type']== 'Business'
            @obj = Business.find_by(uuid: @data['id']) || Business.find(@data['id'])
            individual = @obj.individual
            individual.amount += @data['amount']
            @obj.amount += @data['amount']
            @target = "Business: '#{@obj.name}'"
          else
            if @data['id'].to_s.numeric?
              @obj = Vehicle.find(@data['id'])
            else
              @obj = Vehicle.find_by!(vehicle_number: @data['id'].upcase)
            end
            @obj.amount += @data['amount']
            @target = "Vehicle: '#{@obj.vehicle_number}'"
          end
        rescue Exception => e
          message = "#{@data['obj_type']|| "Payer"} not found"
          Rails.logger.debug "exception --------#{e.message}----------"
          create_errors(message, 2005)
          render json: {status: 0, message: message}
          return
        end
        verify_lga = Individual.check_lga_with_agent(theAgent, @data['lga'])
        obj_lga = @obj.nil? ? individual.lga : @obj.lga
        ver_obj_lga = Individual.verify_object_lga(@data['lga'], obj_lga)
        unless verify_lga && ver_obj_lga
          message = I18n.t(:lga_access_not_allowed)
          create_errors(message, 2001)
          render json: {status: 0, message: message}
          return
        end
        begin
          uuid = @data['coll_uuid']|| Collection.generate_uuid(theAgent.id)
          collection = Collection.new(category_type: @data['type'], subtype: @data['subtype'], uuid: uuid, created_at: @data['created_at'],
                                      number: @data['number'], amount: @data['amount'], period: @data['period'],
                                      lga: @data['lga'], agent: theAgent, individual: individual, collectionable: @obj)

          theAgent.amount += @data['amount']
          if offline?
            theAgent.last_coll_offline = Time.now.utc
          else
            theAgent.last_coll_online = Time.now.utc
          end

          ActiveRecord::Base.transaction do
            card = Card.verify_and_use(@data['number'], @data['amount'])
            batch_id = card.batch_id
            collection.batch_id = batch_id
            collection.save!
            theAgent.save!
            @obj.save! unless @obj.nil?
            individual.save! unless individual.nil?
          end
          phone = individual.try(:phone) || @obj.try(:phone)
          unless phone.blank?
            IndiBusiCollecSmsWorker.perform_async(phone,
                                                  I18n.t(:sms_collection_created,
                                                         name: individual.try(:name).to_s,
                                                         amount: collection.amount,
                                                         target: @target,
                                                         card_number: collection.number,
                                                         collection_id: collection.id))
          end
          render json: {status: 1, data: {collection: collection.as_json(:include=>  [:collectionable, :individual])}}
        rescue AmountExceededError, InvalidCardError => ex
          create_fraud(ex.message, @obj||individual)
          Rails.logger.debug "exception --------#{ex}----------"
          render json: {status: 0, message: ex.message }
          return
        rescue Exception => ex
          message = "Unable to record revenue collection at the moment, please try again later"
          create_errors(message, 2006)
          render json: {status: 0, message: message }
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
