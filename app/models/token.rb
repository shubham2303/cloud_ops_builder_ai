class Token < ApplicationRecord

  belongs_to :agent
  before_save :update_other_fields

  def update_other_fields
    self.token =  ShortUUID.unique
    self.expiry =  Time.now + 1.hour
  end
end