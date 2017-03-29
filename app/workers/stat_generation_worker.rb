class StatGenerationWorker
  include Sidekiq::Worker

  def perform(start_date, end_date, admin_user_id, time_format)
  	admin_user = AdminUser.find(admin_user_id)
  	Stat.to_xlsx(start_date, end_date, admin_user, time_format.to_i)
  end
end