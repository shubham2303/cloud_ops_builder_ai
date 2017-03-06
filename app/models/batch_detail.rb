require "csv"

class BatchDetail < ApplicationRecord

  attr_reader :number

  belongs_to :batch, counter_cache: :batch_details_count

  validates :n, uniqueness: true

  def number
    @number ||= Card.beautify_number(n)
  end

  def fix_length
    return if self.number.length == 16

    card = Card.verify_and_get(self.number)
    ActiveRecord::Base.transaction do
      n = '%015i' % number.to_i
      x = Digester.hash_luhn_number! n
      y = Digester.generate_secret
      z = Digester.hash_number_with_secret! n, y
      self.update! n: n
      card.update! x: x, y: y, z: z
    end
  end

  def self.csv(batch)
    the_batch = if batch.is_a? Batch
                 batch
                else
                 Batch.find batch
                end
    # filename = Rails.root + 'tmp' + "#{the_batch.id}_#{the_batch.created_at.to_formatted_s(:number)}.csv"
    # CSV.open(filename, "wb") do |csv|
    CSV.generate do |csv|  
      csv << ["Sr No", "Card Number", "Denomination"]
      the_batch.batch_details.each do |bd|
        csv << [bd.id, bd.number, bd.amount]
      end
    end
  end

end
