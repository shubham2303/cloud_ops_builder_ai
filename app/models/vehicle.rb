class Vehicle < ApplicationRecord

  belongs_to :individual, optional: true
  has_many :collections, :as => :collectionable

  validates_inclusion_of :lga, :in => JSON.parse(ENV["APP_CONFIG"])['lga'], :allow_nil => true
  validates :vehicle_number, :lga, presence: true

  before_save :upcase_vehicle_number
  before_validation :update_phone, unless: 'phone.nil?'
  validates_numericality_of :phone

  scope :today_created, ->{ where("Date(created_at) = ?", Date.today) }
  scope :this_month_created, ->{ where("Date(created_at) >= ? AND Date(created_at) <= ?",Date.today.at_beginning_of_month, Date.today) }
  scope :this_year_created, ->{ where("Date(created_at) >= ? AND Date(created_at) <= ?",Date.today.at_beginning_of_year, Date.today) }

  def upcase_vehicle_number
    self.vehicle_number = vehicle_number.upcase
  end

  def update_phone
    if self.phone.length <= 11
      self.phone= ("234#{phone.last(10)}")
    end
  end

end