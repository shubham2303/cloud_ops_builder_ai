module Api
  module V1
    class BaseController < ApplicationController
      include ApplicationHelper

      rescue_from ActiveRecord::RecordNotFound, :with => :ar_obj_not_found
      rescue_from ActionController::ParameterMissing, :with => :ar_required_params
      rescue_from ActiveRecord::RecordInvalid, :with => :ar_validation_failed
      rescue_from ActiveRecord::RecordNotUnique, :with=> :ar_not_unique

      ################### start exception handlers ##################

      def ar_required_params(exception)
        render json: {success: 0, error_code: 400, data: nil, message: exception.message}
      end

      def ar_obj_not_found(exception)
        # render json: {success: 0, error_code: 404, data: nil, message: exception.message}
        render json: {success: 0, error_code: 1004, data: nil, message: exception.message}
      end

      def ar_validation_failed(exception)
        render json: {success: 0, error_code: 422, data: nil, message: exception.message}
      end

      def ar_not_unique(exception)
        render json: {success: 0, error_code: 422, data: nil, message: exception.message}
      end
      ################### END exception handlers ##################

      def check_headers
        @agent = Agent.find( request.headers["HTTP_UID"] )

        unless @agent.token.token == request.headers["HTTP_TOKEN"]
          render json: {success: 0, error_code: 1002, data: nil, message: I18n.t(:outdated_token)}
          return
        end
        check_common_headers

      end


      def check_common_headers
        unless AppConfig.android_version_valid?(request.headers['HTTP_ANDRIOD_VER'])
          render json: {success: 0, error_code: 1003, data: nil, message: I18n.t(:outdated_version)}
          return
        end

        unless AppConfig.config_version_valid?(request.headers['HTTP_CONFIG_VER'])
          render json: {success: 0, error_code: 1001, data: {config: AppConfig.json}, message: I18n.t(:outdated_config)}
          return
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

        end
      end
    end
  end
end
