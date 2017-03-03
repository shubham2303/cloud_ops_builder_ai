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
          render json: { status: 1, data: {otp: otp} }
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
          agent = if Rails.env.production?
                    Agent.find_by!(phone: phone_params)
                  else
                    Agent.find_or_create_by!(phone: phone_params)
                  end
          agent.token.delete unless agent.token.nil?
          token = Token.find_by(device_id: params.require(:device_id))
          token.delete unless token.nil?
          agent.create_token(expiry: Time.now.utc + 1.hour, token: ShortUUID.unique, device_id: params.require(:device_id))
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
