class Individual < ApplicationRecord

  has_many :businesses
  has_many :collections

  before_create :update_uuid

  validates :name, :phone, presence: true

  def update_uuid
    self.uuid = "123"
  end
end