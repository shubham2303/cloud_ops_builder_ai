module Api
  module V1
    class BaseController < ApplicationController
      include ApplicationHelper

      before_action :authenticate_headers

      attr_reader :theAgent, :theToken

      rescue_from ActiveRecord::RecordNotFound, :with => :ar_obj_not_found
      rescue_from ActionController::ParameterMissing, :with => :ar_required_params
      rescue_from ActiveRecord::RecordInvalid, :with => :ar_validation_failed
      rescue_from ActiveRecord::RecordNotUnique, :with=> :ar_not_unique
      rescue_from ::AccessBlocked, :with => :blocked_access_detected
      rescue_from ::VersionBlocked, :with => :blocked_version_detected
      rescue_from ::ConfigBlocked, :with => :blocked_config_detected
      rescue_from TokenExpired, :with => :token_expiration_detected
      rescue_from AgentNotFound, :with => :agent_not_found

      ################### start exception handlers ##################
      def create_errors(message, code)
        if request.headers["HTTP_UPSYNC"] == "1"
          UpsyncError.create(agent_id: theAgent.id, message: message, error: {params: params}, code: code)
        end
      end

      def create_fraud(message, obj)
        if request.headers["HTTP_UPSYNC"] == "1"
          Fraud.create(agent_id: theAgent.id, message: message, error: {params: params}, object: obj)
        end
      end

      def ar_required_params(exception)
        create_errors(exception.message, 400)
        Rails.logger.debug "exception --------#{exception.message}----------"
        render json: {status: 400, data: nil, message: exception.message}
      end

      def ar_obj_not_found(exception)
        Rails.logger.debug "exception --------#{exception.message}----------"
        if Agent.to_s == exception.try(:model)
          message = I18n.t(:agent_not_found)
          create_errors(message, 404)
          render json: {status: 404, data: nil, message: message}
        else
          create_errors(exception.message, 404)
          render json: {status: 404, data: nil, message: exception.message}
        end
      end

      def ar_validation_failed(exception)
        create_errors(exception.message, 422)
        Rails.logger.debug "exception --------#{exception.message}----------"
        render json: {status: 422, data: nil, message: exception.message}
      end
      def ar_not_unique(exception)
        create_errors(exception.message, 422)
        Rails.logger.debug "exception --------#{exception.message}----------"
        render json: {status: 422, data: nil, message: "#{controller_name.singularize} already exist"};
      end

      def blocked_access_detected(exception)
        Rails.logger.debug "exception --------#{exception.message}----------"
        theToken.update_columns(expiry: Time.now)
        render json: {status: 1004, data: nil, message: exception.message}
      end

      def blocked_version_detected(exception)
        Rails.logger.debug "exception --------#{exception.message}----------"
        render json: {status: 1003, data: nil, message: exception.message}
      end  

      def blocked_config_detected(exception)
        Rails.logger.debug "exception --------#{exception.message}----------"
        render json: {status: 1001, data: {config: AppConfig.json}, message: exception.message}
      end  

      def token_expiration_detected(exception)
        Rails.logger.debug "exception --------#{exception.message}----------"
        theToken.save
        render json: {status: 1002, data: {token: theToken.token}, message: exception.message}
      end

      def agent_not_found(exception)
        Rails.logger.debug "exception --------#{exception.message}----------"
        render json: {status: 1004, data: nil, message: exception.message}
      end
      ################### END exception handlers ##################

      def theAgent
        unless @theAgent
          return nil unless request.headers["HTTP_UID"]
          begin
          @theAgent = Agent.find( request.headers["HTTP_UID"] )
          rescue
            raise AgentNotFound.new
          end


        end
        @theAgent

      end  

      def theToken
        theAgent.token
      end  

      def authenticate_headers
        unless AppConfig.android_version_valid?(request.headers['HTTP_ANDROID_VER'])
          raise VersionBlocked.new
        end 

        unless AppConfig.config_version_valid?(request.headers['HTTP_CONFIG_VER'])
          raise ConfigBlocked.new
        end  
      end  

      def check_headers
        token = theAgent.token.token
        Rails.logger.debug "token received --------#{request.headers["HTTP_TOKEN"]}----------"
        Rails.logger.debug "actual token --------#{token}----------"
        if token != request.headers["HTTP_TOKEN"]
          raise AccessBlocked.new
        elsif theAgent.token.expired?
          raise TokenExpired.new
        end
      end

      def get_data_using_decryption
        begin
          static_rsa = StaticRSAHelper.new
          decrypted_secret_key = static_rsa.decrypt(params.require(:secret))
          # des = TripleDESHelper.new(decrypted_secret_key)
          # decrypted_data = des.decrypt(params.require(:data))
          # @data = JSON.parse(decrypted_data)
          decrypted_data =AESCrypt.decrypt(params.require(:data), decrypted_secret_key)
          @data = JSON.parse(decrypted_data)
          Rails.logger.debug "decrypted data --------#{@data}----------"
          @data
        rescue
          raise AccessBlocked.new
        end
      end
    end
  end
end
