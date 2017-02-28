class Individual < ApplicationRecord

  has_many :businesses
  has_many :collections
  before_create :update_pid

  validates :name, :phone, presence: true

  def update_pid
    self.uuid = 'I-'+ShortUUID.unique
  end
end