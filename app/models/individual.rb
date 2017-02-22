class Individual < ApplicationRecord

  has_many :businesses
  before_create :update_pid

  def update_pid
    self.pid = ShortUUID.unique
  end
end