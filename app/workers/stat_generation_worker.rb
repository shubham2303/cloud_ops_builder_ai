class StatGenerationWorker
  include Sidekiq::Worker
  sidekiq_options :queue => 'stat', :retry => false

  def perform(args)
    date = args['date']
    end_date = date.to_date
    Stat.to_xlsx(end_date, end_date, "daily", -60)
    if end_date.sunday?
      start_date = end_date.beginning_of_week
      Stat.to_xlsx(start_date, end_date, "weekly", -60)
    end
    # last_date = DashboardHelper.last_date_of_month? end_date
    # if last_date
    #   start_date = end_date.beginning_of_month
    #   Stat.to_xlsx(start_date, end_date, "monthly", -60)
    # end
    # month = end_date.strftime('%m').to_i
    # if (last_date) && (month %3 == 0)
    #   start_date = end_date.beginning_of_quarter
    #   Stat.to_xlsx(start_date, end_date, "quarterly", -60)
    # end
  end

  class << self
    def perform_async(args)
      args['date'] = Date.today.to_s
      super
    end
  end
end
