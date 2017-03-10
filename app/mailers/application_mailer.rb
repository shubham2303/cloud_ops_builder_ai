class ApplicationMailer < ActionMailer::Base
  default from: 'do-not-reply@esirconnect.ng'
  layout 'mailer'

  def send_stat(file, admin_user)
  	@username = 'Admin' #current_admin_user.name
    attachments['report.xlsx'] = file
    mail to: admin_user.email, subject: "report"
  end

end
