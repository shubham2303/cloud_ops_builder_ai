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
          $redis.expire(params[:number], 60)
          if Rails.env.production?
            response = Message.send_sms(params[:number], "OTP for EIRS Connect Agent login is #{otp}")
            if response.include? "OK"
              render json: { status: 1, data: {otp: otp} }
            else
              Rails.logger.debug "response from sms provider --------#{response}----------"
              render json: { status: 0, message: "cannot send otp" }
            end
          else
            render json: { status: 1, data: {otp: otp} }
          end
        else
          render json: { status: 0, message: "number parameter is missing" }
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
        if otp.nil? || otp != params.require(:otp)
          render json: { status: 0, message: 'Otp expired or wrong otp, try again'}
          return
        end
        ActiveRecord::Base.transaction do
          begin
            agent = Agent.find_by!(phone: phone_params)
          rescue Exception => e
            unless Rails.env.production?
              agent = Agent.create!(phone: phone_params,lga: 'Egor')
            else
              raise AgentNotFound.new "Agent with phone number #{phone_params} does not exist"
            end
          end
          agent.token.delete unless agent.token.nil?
          token = Token.find_by(device_id: params.require(:device_id))
          token.delete unless token.nil?
          agent.create_token(device_id: params.require(:device_id))
          render json: { status: 1, data: {agent: agent, token: agent.token.token} }
        end
      end


      private

      def phone_params
        params.require(:number)
      end  
    end
  end
end
