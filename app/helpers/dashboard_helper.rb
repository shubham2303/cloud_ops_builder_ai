module DashboardHelper

  def coll(arr)
    hsh = {}
    arr.each do |a|
      hsh[a.delete('lga')] = a
    end
    hsh
  end

  def self.last_date_of_month? date
    date.month != date.next_day.month
  end
end