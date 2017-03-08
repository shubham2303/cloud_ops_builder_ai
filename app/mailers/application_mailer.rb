class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def send_stat(file)
  	@username = 'Sweety Mehta' #current_admin_user.name
    attachments['report.xlsx'] = file
    mail to: 'smehta128@gmail.com', subject: "report"
  end

end
