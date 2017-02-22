module Api
  module V1
    class BaseController < ApplicationController
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
        render json: {success: 0, error_code: 1001, data: nil, message: exception.message}
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
        app_config = JSON.parse(ENV["APP_CONFIG"])

        @theApp = AppString.new request.headers['HTTP_ANDRIOD_VER'], request.headers['HTTP_CONFIG_VER']

        unless @theApp.is_valid_version?
          render json: {success: 0, error_code: 1004, data: nil, message: I18n.t(:outdated_version)}
          return
        end

        unless @agent.token.token == request.headers["HTTP_TOKEN"]
          render json: {success: 0, error_code: 1002, data: nil, message: I18n.t(:outdated_token)}
          return
        end

        unless @theApp.is_valid_config?
          render json: {success: 0, error_code: 1003, data: nil, message: I18n.t(:outdated_config)}
          return
        end  

      end
    end
  end
end
