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
          elsif @data['obj_type']== 'Business'
            @obj = Business.find(@data['id'])
            individual = @obj.individual
            individual.amount += @data['amount']
            @obj.amount += @data['amount']
            @str = "business id"
          else
            @obj = Vehicle.find(@data['id'])
            individual = @obj.individual
            individual.amount += @data['amount']
            @str = "vehicle id"
          end
        rescue
          render json: {status: 0, message: "uuid is not valid"}
          return
        end
        verify_lga = Individual.verify_lga_with_agent_and_param(theAgent, @data['lga'], individual.lga)
        unless verify_lga || (!@obj.nil? && (@obj.lga == @data['lga']))
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
            @obj.save! if (@obj.instance_of? Business) && !@obj.nil?
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

      def index
        begin
          if params[:uuid]
            individual = Individual.find_by!(uuid: params[:uuid].upcase)
            collections = individual.collections.where(agent: theAgent).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
          elsif params[:phone_number]
            number = Individual.get_accurate_number(params[:phone_number])
            individual = Individual.find_by!(phone: number)
            collections = individual.collections.where(agent: theAgent).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
          elsif params[:vehicle_number]
            vehicle = Vehicle.find_by!(vehicle_number: params[:vehicle_number])
            collections = vehicle.collections.where(agent: theAgent).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
          else
            collections = theAgent.collections.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
          end
        rescue
          render json: {status: 0, message: "No Result Found" }
          return
        end
        if params[:date]
          final_coll = collections.where('"created_at" >= ?', params[:date])
        else
          final_coll = collections
        end
        render json: {status: 1, data: {collections: final_coll.includes(:individual, :collectionable).as_json(:include=>  [:collectionable, :individual])}}
      end
    end
  end
end
