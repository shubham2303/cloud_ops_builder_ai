class Individual < ApplicationRecord

  has_many :businesses
  has_many :collections

  before_create :update_uuid

  validates :name, :phone, presence: true
  validates_numericality_of :phone

  def update_uuid
    self.uuid = ShortUUID.create("I")
  end
end