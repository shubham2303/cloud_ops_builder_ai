class Batch < ApplicationRecord

  has_many :batch_details
  has_many :cards

  def self.generate(arr)
    raise Exception.new 'Illegal arguments' unless arr.is_a? Array

    total = 0
    arr.each do |hsh|
      count = hsh[:count].to_i
      denomination = hsh[:amount].to_i
      raise Exception.new 'Illegal arguments' unless count > 0 && denomination > 0
      total += count * denomination
    end
    ActiveRecord::Base.transaction do
      batch = Batch.create! net_worth: total, details: arr
      arr.each do |hsh|
        count = hsh[:count].to_i
        denomination = hsh[:amount].to_i
        (1..count).each do |i|
          n = Luhn.generate
          x = Digester.hash_luhn_number! n
          y = Digester.generate_secret
          z = Digester.hash_number_with_secret! n, y
          BatchDetail.create! batch_id: batch.id, n: n, amount: denomination
          Card.create! batch_id: batch.id, x: x, y: y, z: z, amount: denomination
        end
      end
    end
  end

end
