require "csv"

class BatchDetail < ApplicationRecord

  attr_reader :number

  belongs_to :batch

  validates :n, uniqueness: true

  def number
    @number ||= Card.beautify_number(n)
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
      csv << ["Card Number", "Denomination"]
      the_batch.batch_details.each do |bd|
        csv << [bd.number, bd.amount]
      end
    end
  end

end
