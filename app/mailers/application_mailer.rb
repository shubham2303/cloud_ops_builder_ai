class ApplicationMailer < ActionMailer::Base
  default from: 'do-not-reply@esirconnect.ng'
  layout 'mailer'

  def send_stat(file, period, stat_for)
    subject = "ESIR Connect #{stat_for.downcase} report :: #{period}"
  	@username = 'Admin' #current_admin_user.name
    attachments["esirconnect.#{stat_for}.#{period}"+".xlsx"] = file
    emails = ENV['EMAILS'].split(" ").map(&:to_s)
    mail to: emails, subject: subject
  end

end
