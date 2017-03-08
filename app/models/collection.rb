class Collection < ApplicationRecord

  belongs_to :batch
  belongs_to :agent
  belongs_to :business
  belongs_to :individual

  validates :category_type, :subtype, :number, :amount, presence: true

  scope :today_created, ->{ where("Date(created_at) = ?", Date.today) }
  scope :this_month_created, ->{ where("Date(created_at) >= ? AND Date(created_at) <= ?",Date.today.at_beginning_of_month, Date.today) }
  scope :this_year_created, ->{ where("Date(created_at) >= ? AND Date(created_at) <= ?",Date.today.at_beginning_of_year, Date.today) }
end