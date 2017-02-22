module Api
  module V1
    class OtpController < BaseController

      # GET  /api/v1/otp/generate_otp?number=9990170198
      # ---
      def generate_otp
        if params[:number]
          otp =  Otp.make
          $redis.set(params[:number], Otp.make)
          $redis.expire(params[:number], 20)
          render json: {success: 1, otp: otp}
        else
          render json: {success: 0, message: "number parameter is missing"}
        end  
      end

      # POST /api/v1/otp/verify
      
      # {"number": "9990170198",
      #  "otp": "1111",
      #  "device_id": "123"
      # }
      # ---
      def verify
        otp = $redis.get(params.require(:number))
        if otp.nil? || otp != params.require(:otp)
          render json: {success: 0}
          return
        end
        ActiveRecord::Base.transaction do
          agent = Agent.find_or_create_by!(phone: params.require(:number))
          if agent.token.nil?
            agent.create_token(device_id: params.require(:device_id))
          end
        end
        render json: {success: 1, agent: agent}
      end
    end
  end
end
