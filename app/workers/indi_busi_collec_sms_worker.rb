class IndiBusiCollecSmsWorker
  include Sidekiq::Worker
  include ApplicationHelper
  sidekiq_options :queue => 'sms'

  def perform(number, message)
    if number.blank?
      Rails.logger.error "Attempting to send SMS to blank number"
      return
    end

    if message.blank?
      Rails.logger.error "Attempting to send a blank SMS"
      return
    end

    response = Message.send_sms(number, message)
    Rails.logger.debug "response from sms provider --------#{response}----------"
  end
end
