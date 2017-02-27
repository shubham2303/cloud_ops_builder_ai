class Individual < ApplicationRecord

  has_many :businesses
  has_many :collections
  before_create :update_pid

  def update_pid
    self.pid = ShortUUID.unique
  end
end