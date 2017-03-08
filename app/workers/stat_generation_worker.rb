class StatGenerationWorker
  include Sidekiq::Worker

  def perform(start_date, end_date, admin_user_id)
  	admin_user = AdminUser.find(admin_user_id)
  	Stat.to_xlsx(start_date, end_date, admin_user)
  end
end