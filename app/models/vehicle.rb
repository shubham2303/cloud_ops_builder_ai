class Vehicle < ApplicationRecord

  belongs_to :individual
  has_many :collections, :as => :collectionable

  validates_inclusion_of :lga, :in => JSON.parse(ENV["APP_CONFIG"])['lga'], :allow_nil => true
  validates :vehicle_number, :lga, :individual, presence: true

  before_save :upcase_vehicle_number

  def upcase_vehicle_number
    self.vehicle_number = vehicle_number.upcase
  end
end