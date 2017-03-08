class StatGenerationWorker
  include Sidekiq::Worker

  def perform(start_date, end_date)
  	Stat.to_xlsx(start_date, end_date)
  end
end