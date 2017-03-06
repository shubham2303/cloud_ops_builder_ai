class IndiBusiCollecSmsWorker
  include Sidekiq::Worker
  include ApplicationHelper

  def perform(number, message)
    response = Message.send_sms(number, message)
    Rails.logger.debug "response from sms provider --------#{response}----------"
  end
end