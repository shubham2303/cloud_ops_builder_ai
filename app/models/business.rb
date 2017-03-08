class Business < ApplicationRecord

  belongs_to :individual
  has_many :collections

  validates_inclusion_of :lga, :in => JSON.parse(ENV["APP_CONFIG"])['lga'], :allow_nil => true
  validates :name, :address, :lga, :year, presence: true

  before_create :update_uuid

  scope :today_created, ->{ where("Date(created_at) = ?", Date.today) }
  scope :this_month_created, ->{ where("Date(created_at) >= ? AND Date(created_at) <= ?",Date.today.at_beginning_of_month, Date.today) }
  scope :this_year_created, ->{ where("Date(created_at) >= ? AND Date(created_at) <= ?",Date.today.at_beginning_of_year, Date.today) }

  def update_uuid
    self.uuid = ShortUUID.create("B")
  end

end