class Individual < ApplicationRecord

  has_many :businesses
  has_many :collections

  before_create :update_uuid
  before_save :update_phone
  validates :name, :phone, presence: true
  validates_numericality_of :phone

  def update_uuid
    self.uuid = ShortUUID.create("I")
  end

  def update_phone
    if self.phone.length <=11
      self.phone= "234#{phone.last(10)}"
    end
  end
end