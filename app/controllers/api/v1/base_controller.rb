module Api
  module V1
    class BaseController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, :with => :ar_obj_not_found
      rescue_from ActionController::ParameterMissing, :with => :ar_required_params
      rescue_from ActiveRecord::RecordInvalid, :with => :ar_validation_failed
      rescue_from ActiveRecord::RecordNotUnique, :with=> :ar_not_unique

      ################### start exception handlers ##################

      def mongo_required_params(exception)
        render json: {success: 0, error_code: 400, data: nil, message: exception.message}
      end

      def ar_obj_not_found(exception)
        render json: {success: 0, error_code: 404, data: nil, message: exception.message}
      end

      def ar_validation_failed(exception)
        render json: {success: 0, error_code: 422, data: nil, message: exception.message}
      end

      def ar_not_unique(exception)
        render json: {success: 0, error_code: 422, data: nil, message: exception.message}
      end
      ################### END exception handlers ##################

      def check_headers
        @agent = Agent.find(request.headers["uid"] )
        app_config = JSON.parse(ENV["APP_CONFIG"])
        unless @agent.token.token == request.headers["token"] || app_config['config_version'] == request.headers["config_version"] || app_config['android_version'] == request.headers["android_version"]
          render json: {success: 0}
          return
        end
      end
    end
  end
end
