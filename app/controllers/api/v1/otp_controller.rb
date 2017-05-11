module Api
  module V1
    class OtpController < BaseController
      # before_action :check_common_headers
      # GET  /api/v1/otp/generate_otp?number=9990170198
      # ---
      def generate_otp
        if params[:number]
          Agent.find_by!(phone: params[:number]) if Rails.env.production?
          otp =  Otp.make
          $redis.set(params[:number], otp)
          $redis.expire(params[:number], 600)
          if Rails.env.production?
            response = Message.send_sms(params[:number], "OTP for EIRS Connect Agent login is #{otp}")
            if response.include? "OK" || ApplicationHelper::AppConfig.master_otp_enabled?
              render json: { status: 1, data: {otp: ''} }
            else
              Rails.logger.debug "response from sms provider --------#{response}----------"
              render json: { status: 0, message: I18n.t(:unable_to_send_otp) }
            end
          else
            render json: { status: 1, data: {otp: otp} }
          end
        else
          render json: { status: 0, message: I18n.t(:invalid_phone_param) }
        end  
      end

      # POST /api/v1/otp/verify
      # {
      #  "number": "9990170198",
      #  "otp": "1111",
      #  "device_id": "123"
      # }
      # ---
      def verify
        otp = $redis.get(phone_params)
        unless ApplicationHelper::AppConfig.master_otp_bypass?(params.require(:otp))
          if otp.nil? || otp != params.require(:otp)
            render json: { status: 0, message: I18n.t(:otp_expired)}
            return
          end
        end
        ActiveRecord::Base.transaction do
          begin
            agent = Agent.find_by!(phone: phone_params)
          rescue Exception => e
            Rails.logger.debug "exception --------#{e}----------"
            unless Rails.env.production?
              agent = Agent.create!(phone: phone_params,lga: 'Egor')
            else
              raise AgentNotFound.new I18n.t(:agent_X_not_found, phone: phone_params)
            end
          end
          agent.token.delete unless agent.token.nil?
          token = Token.find_by(device_id: params.require(:device_id))
          token.delete unless token.nil?
          agent.create_token(device_id: params.require(:device_id))
          render json: { status: 1, data: {agent: agent.as_json.merge(revenue_beat: agent.revenue_beat), token: agent.token.token} }
        end
      end


      private

      def phone_params
        params.require(:number)
      end  
    end
  end
end
