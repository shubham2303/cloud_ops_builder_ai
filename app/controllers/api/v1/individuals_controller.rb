module Api
  module V1
    class IndividualsController < BaseController
      before_action :check_headers

      # POST /api/v1/individuals
      # {
      #   "individual":
      #     {
      #      "name": "Abia",
      #      "phone": "64564565445",
      #      "address": "wefefefef"
      #     }
      # }
      def create
        try = 0
        begin
          individual = Individual.create!(individual_params)
          IndiBusiCollecSmsWorker.perform_async(individual.phone, "Hello #{individual.name}, you have been successfully registered with EIRS Connect. Your payer id is #{individual.uuid}")
        rescue Exception=> e
          if (e.message.include?("index_individuals_on_uuid")) && (try< 5)
            try+=1
            retry
          else
            super
          end
        end
        render json: {status: 1, data: {individual: individual}}
      end


      # create business for an existing or new individual
      # POST /api/v1/individuals/business
      # {
      #     "business":
      #         {
      #             "address": "9999999999",
      #             "name": "Abia",
      #             "lga": "Egor",
      #             "year": "2017"
      #         },
      #     "individual":
      #         {
      #             "name": "Abia",
      #             "phone": "9990170194"
      #         }
      # }
      def business
        try = 0
        individual = Individual.find_or_initialize_by(phone: individual_params[:phone])
        checknew_record= individual.new_record?
        begin
          ActiveRecord::Base.transaction do
            individual.update!(individual_params)
            @business = individual.businesses.create!(business_params)
          end
        rescue Exception=> e
          if (e.message.include?(("index_individuals_on_uuid")||("index_businesses_on_uuid"))) && (try < 5)
            try+=1
            retry
          else
            super
          end
        end
        if checknew_record
          IndiBusiCollecSmsWorker.perform_async(individual.phone, "Hello #{individual.name}, you have been successfully registered with EIRS Connect. Your payer id is #{individual.uuid}")
        end
        IndiBusiCollecSmsWorker.perform_async(individual.phone,"Hello #{individual.name}, your business '#{@business.name}' has been successfully registered with EIRS Connect. Your business's id is #{@business.uuid}")
        render json: {status: 1, data: {individual: individual, business: @business}}
      end

      private

      def individual_params
        params.require(:individual).permit(:phone, :name, :address)
      end

      def business_params
        params.require(:business).permit(:name, :address, :turnover, :year, :lga)
      end
    end
  end
end