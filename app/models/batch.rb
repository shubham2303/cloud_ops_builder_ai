
class Batch < ApplicationRecord

  has_many :batch_details, dependent: :delete_all
  has_many :cards, dependent: :delete_all

  after_rollback :delete_batch

  def self.generate(arr, async = true)
    raise Exception.new 'Illegal arguments' unless arr.is_a? Array

    total = 0
    total_count = 0
    arr.each do |hsh|
      count = hsh[:count].to_i
      total_count += count
      denomination = hsh[:amount].to_i
      raise Exception.new 'Illegal arguments' unless count > 0 && denomination > 0
      total += count * denomination
    end
    batch = Batch.create! net_worth: total, details: arr, count: total_count
    if async
      Thread.new do
        begin
          ActiveRecord::Base.transaction do
            batch.touch
            generate_internal(arr, batch)
            $redis.del(batch.id)
          end
        rescue Exception=> e
          Rails.logger.debug "exception --------#{e}----------"
        end
      end
    else
      generate_internal(arr, batch)
    end
  end

  private

  def self.generate_internal(arr, batch)
    batch_id = batch.id
     arr.each do |hsh|
        count = hsh[:count].to_i
        denomination = hsh[:amount].to_i
        (1..count).each do |i|
          n = Luhn.generate
          x = Digester.hash_luhn_number! n
          y = Digester.generate_secret
          z = Digester.hash_number_with_secret! n, y
          BatchDetail.create! batch_id: batch_id, n: n, amount: denomination
          Card.create! batch_id: batch_id, x: x, y: y, z: z, amount: denomination
          $redis.set(batch_id, i)
        end
      end
  end

  def delete_batch
    if self.batch_details.count == 0
      self.delete
    end
  end

end
