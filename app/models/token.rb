class Token < ApplicationRecord

  belongs_to :agent
  before_save :update_other_fields

  def update_other_fields
    self.assign_attributes(expiry:  Time.now.utc + 1.year, token: SecureRandom.uuid)
  end

  def expired?
  	expiry <= Time.now.utc
  end	
end
