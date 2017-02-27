class Token < ApplicationRecord

  belongs_to :agent
  before_save :update_other_fields

  def update_other_fields
    self.assign_attributes(expiry:  Time.now.utc + 1.hour, token: ShortUUID.unique)
  end

  def expired?
  	expiry <= Time.now
  end	
end