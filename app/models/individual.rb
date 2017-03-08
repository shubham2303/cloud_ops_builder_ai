class Individual < ApplicationRecord

  has_many :businesses
  has_many :collections

  before_create :update_uuid

  validates :name, :phone, presence: true
  validates_numericality_of :phone

  scope :today_created, ->{ where("Date(created_at) = ?", Date.today) }
  scope :this_month_created, ->{ where("Date(created_at) >= ? AND Date(created_at) <= ?",Date.today.at_beginning_of_month, Date.today) }
  scope :this_year_created, ->{ where("Date(created_at) >= ? AND Date(created_at) <= ?",Date.today.at_beginning_of_year, Date.today) }

  def update_uuid
    self.uuid = ShortUUID.create("I")
  end

end