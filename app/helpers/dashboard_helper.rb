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

  def self.time_conversion timestamp
    t1, t2 = timestamp.split('.')
    t3 = if t2.length < 6
           (t2 + '0'* (6-t2.length)).to_f
         else
           t2.insert(6, '.').to_f
         end
    Time.at(t1.to_i, t3)
  end
end