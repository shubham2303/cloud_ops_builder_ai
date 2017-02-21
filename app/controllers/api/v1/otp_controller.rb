module Api
  module V1
    class OtpController < ApplicationController

      def generate_otp
        otp =  Otp.make
        $redis.set(params[:number], Otp.make)
        $redis.expire(params[:number], 20)
        render json: {success: 1, otp: otp}
      end

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
        render json: {success: 1}
      end
    end
  end
end
