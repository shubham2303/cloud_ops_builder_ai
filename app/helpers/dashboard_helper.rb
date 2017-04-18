module DashboardHelper

  def coll(arr)
    hsh = {}
    arr.each do |a|
      hsh[a.delete('lga')] = a
    end
    hsh
  end
end