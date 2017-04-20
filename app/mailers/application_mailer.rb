class ApplicationMailer < ActionMailer::Base
  default from: 'do-not-reply@esirconnect.ng'
  layout 'mailer'

  def send_stat(file, period = nil, stat_for)
    subject = "ESIR Connect Report"
    subject += " :: #{period}" unless period.nil?
  	@username = 'Admin' #current_admin_user.name
    attachments["#{stat_for}"+".xlsx"] = file
    emails = ENV['EMAILS'].split(" ").map(&:to_s)
    mail to: emails, subject: subject
  end

end
