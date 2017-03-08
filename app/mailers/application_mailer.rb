class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def send_stat(file, admin_user)
  	@username = 'Admin' #current_admin_user.name
    attachments['report.xlsx'] = file
    mail to: admin_user.email, subject: "report"
  end

end
