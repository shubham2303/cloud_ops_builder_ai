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

      ################### start exception handlers ##################

      def ar_required_params(exception)
        render json: {status: 400, data: nil, message: exception.message}
      end

      def ar_obj_not_found(exception)
        render json: {status: 1004, data: nil, message: exception.message}
      end

      def ar_validation_failed(exception)
        render json: {status: 422, data: nil, message: exception.message}
      end

      def ar_not_unique(exception)
        render json: {status: 422, data: nil, message: exception.message}
      end

      def blocked_access_detected(exception)
        theToken.update_columns(expiry: Time.now)
        render json: {status: 1004, data: nil, message: exception.message}
      end

      def blocked_version_detected(exception)
        render json: {status: 1003, data: nil, message: exception.message}
      end  

      def blocked_config_detected(exception)
        render json: {status: 1001, data: {config: AppConfig.json}, message: exception.message}
      end  

      def token_expiration_detected(exception)
        theToken.save
        render json: {status: 1002, data: {token: theToken.token}, message: exception.message}
      end  
      ################### END exception handlers ##################

      def theAgent
        unless @theAgent
          return nil unless request.headers["HTTP_UID"]
          @theAgent = Agent.find( request.headers["HTTP_UID"] )
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
        if theAgent.token.token != request.headers["HTTP_TOKEN"]
          raise AccessBlocked.new
        elsif theAgent.token.expired?
          raise TokenExpired.new
        end
      end

      def get_data_using_decryption
        begin
          static_rsa = StaticRSAHelper.new
          decrypted_secret_key = static_rsa.decrypt(params.require(:secret))
          des = TripleDESHelper.new(decrypted_secret_key)
          decrypted_data = des.decrypt(params.require(:data))
          @data = JSON.parse(decrypted_data)
        rescue
          theToken.update_columns(expiry: Time.now) unless theAgent.nil?
          raise TokenExpired.new
        end
      end
    end
  end
end
