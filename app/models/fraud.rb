class Fraud < ApplicationRecord

  belongs_to :object, polymorphic: true
  belongs_to :agent
end
