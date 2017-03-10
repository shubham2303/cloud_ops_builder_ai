class ApplicationMailer < ActionMailer::Base
  default from: 'do-not-reply@esirconnect.ng'
  layout 'mailer'

  def send_stat(file, admin_user, period = nil)
    subject = "ESIR Connect Report"
    subject += " :: #{period}" unless period.nil?
  	@username = 'Admin' #current_admin_user.name
    attachments['report.xlsx'] = file
    mail to: admin_user.email, subject: subject
  end

end
